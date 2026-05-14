import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? _controller;
  Interpreter? _interpreter;

  bool _cameraReady = false;
  bool _isDetecting = false;

  String _result = "Point camera at a gesture...";
  double _confidence = 0.0;

  final FlutterTts _tts = FlutterTts();
  String _lastSpoken = "";
  DateTime _lastSpeakTime = DateTime.now();

  List<String> _labels = [];

  final List<String> gestures = [
    'Good Luck',
    'Hello',
    'I Love You',
    'No',
    'Please',
    'Thank You',
    'Thumbs Up',
    'Yes',
  ];

  // ✅ Lowered threshold so detections register
  static const int inputSize = 640;
  static const int numDetections = 8400;
  static const int numClasses = 8;
  static const double confidenceThreshold = 0.25;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _initTts();
    await _loadModel();
    await _initCamera();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    final now = DateTime.now();
    if (text == _lastSpoken &&
        now.difference(_lastSpeakTime).inSeconds < 3) return;
    _lastSpoken = text;
    _lastSpeakTime = now;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/model.tflite',
      );

      print("INPUT SHAPE: ${_interpreter!.getInputTensor(0).shape}");
      print("OUTPUT SHAPE: ${_interpreter!.getOutputTensor(0).shape}");
      print("INPUT TYPE: ${_interpreter!.getInputTensor(0).type}");
      print("OUTPUT TYPE: ${_interpreter!.getOutputTensor(0).type}");

      try {
        final labelData = await DefaultAssetBundle.of(context)
            .loadString('assets/model/labels.txt');
        _labels = labelData.trim().split('\n');
        print("LABELS LOADED: ${_labels.length} → $_labels");
      } catch (e) {
        _labels = List.from(gestures);
        print("Labels fallback to gestures list");
      }

      print("Model loaded successfully");
    } catch (e) {
      print("MODEL ERROR: $e");
      if (mounted) {
        setState(() => _result = "Model error: $e");
      }
    }
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _result = "Camera permission denied");
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _result = "No camera found");
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.low, // ✅ Low preset to prevent memory crash
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() => _cameraReady = true);
      await _controller!.startImageStream(_processFrame);
      print("Camera started");
    } catch (e) {
      setState(() => _result = "Camera error: $e");
    }
  }

  Future<void> _processFrame(CameraImage cameraImage) async {
    if (_isDetecting || _interpreter == null) return;
    _isDetecting = true;

    try {
      img.Image? image;

      // ✅ Handle both YUV420 (phone) and BGRA8888 (emulator)
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        image = _convertYUV420(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        image = _convertBGRA8888(cameraImage);
      } else {
        print("UNKNOWN FORMAT: ${cameraImage.format.group}");
        _isDetecting = false;
        return;
      }

      if (image == null) {
        _isDetecting = false;
        return;
      }

      // ✅ Letterbox to 640x640 preserving aspect ratio
      final letterboxed = _letterbox(image, inputSize);

      // ✅ RGB normalized input tensor
      final input = List.generate(
        1,
            (_) => List.generate(
          inputSize,
              (y) => List.generate(
            inputSize,
                (x) {
              final pixel = letterboxed.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // Output tensor [1, 12, 8400]
      final output = List.generate(
        1,
            (_) => List.generate(
          12,
              (_) => List.filled(numDetections, 0.0),
        ),
      );

      _interpreter!.run(input, output);

      final rawOutput = output[0];

      // Debug top scores — remove after confirmed working
      List<MapEntry<String, double>> allScores = [];
      for (int d = 0; d < numDetections; d++) {
        for (int c = 0; c < numClasses; c++) {
          final score = rawOutput[4 + c][d];
          if (score > 0.1) {
            allScores.add(MapEntry(gestures[c], score));
          }
        }
      }
      allScores.sort((a, b) => b.value.compareTo(a.value));
      final top5 = allScores.take(5).toList();
      print("TOP SCORES: ${top5.map((e) => '${e.key}=${e.value.toStringAsFixed(3)}').join(', ')}");

      // Parse best detection
      int bestDetectionIndex = -1;
      int bestClassIndex = 0;
      double bestScore = confidenceThreshold;

      for (int d = 0; d < numDetections; d++) {
        double maxClassScore = 0.0;
        int maxClassIndex = 0;

        for (int c = 0; c < numClasses; c++) {
          final score = rawOutput[4 + c][d];
          if (score > maxClassScore) {
            maxClassScore = score;
            maxClassIndex = c;
          }
        }

        if (maxClassScore > bestScore) {
          bestScore = maxClassScore;
          bestClassIndex = maxClassIndex;
          bestDetectionIndex = d;
        }
      }

      if (!mounted) return;

      setState(() {
        if (bestDetectionIndex >= 0) {
          _confidence = bestScore;
          _result = gestures[bestClassIndex];
          _speak(gestures[bestClassIndex]);
        } else {
          _confidence = 0.0;
          _result = "No gesture detected";
        }
      });

      // ✅ Increased delay to prevent memory crash on emulator
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print("Detection Error: $e");
    }

    _isDetecting = false;
  }

  // =========================
  // YUV420 -> RGB (phone)
  // =========================

  img.Image? _convertYUV420(CameraImage image) {
    try {
      final width = image.width;
      final height = image.height;

      final yPlane = image.planes[0];
      final uPlane = image.planes[1];
      final vPlane = image.planes[2];

      final yBytes = yPlane.bytes;
      final uBytes = uPlane.bytes;
      final vBytes = vPlane.bytes;

      final yRowStride = yPlane.bytesPerRow;
      final uvRowStride = uPlane.bytesPerRow;
      final uvPixelStride = uPlane.bytesPerPixel ?? 1;

      final rgbImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final yIndex = y * yRowStride + x;
          final uvIndex =
              (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

          if (yIndex >= yBytes.length ||
              uvIndex >= uBytes.length ||
              uvIndex >= vBytes.length) continue;

          final yVal = yBytes[yIndex];
          final uVal = uBytes[uvIndex] - 128;
          final vVal = vBytes[uvIndex] - 128;

          int r = (yVal + 1.370705 * vVal).round().clamp(0, 255);
          int g = (yVal - 0.337633 * uVal - 0.698001 * vVal)
              .round()
              .clamp(0, 255);
          int b = (yVal + 1.732446 * uVal).round().clamp(0, 255);

          rgbImage.setPixelRgb(x, y, r, g, b);
        }
      }

      return rgbImage;
    } catch (e) {
      print("YUV420 conversion error: $e");
      return null;
    }
  }

  // =========================
  // BGRA8888 -> RGB (emulator)
  // =========================

  img.Image? _convertBGRA8888(CameraImage image) {
    try {
      final plane = image.planes[0];
      final bytes = plane.bytes;
      final width = image.width;
      final height = image.height;

      final rgbImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final idx = y * plane.bytesPerRow + x * 4;
          if (idx + 3 >= bytes.length) continue;

          final b = bytes[idx];
          final g = bytes[idx + 1];
          final r = bytes[idx + 2];

          rgbImage.setPixelRgb(x, y, r, g, b);
        }
      }

      return rgbImage;
    } catch (e) {
      print("BGRA8888 conversion error: $e");
      return null;
    }
  }

  // =========================
  // LETTERBOX
  // =========================

  img.Image _letterbox(img.Image source, int targetSize) {
    final srcW = source.width;
    final srcH = source.height;
    final scale = targetSize / (srcW > srcH ? srcW : srcH);
    final newW = (srcW * scale).round();
    final newH = (srcH * scale).round();
    final resized = img.copyResize(source, width: newW, height: newH);
    final canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(0, 0, 0));
    final offsetX = (targetSize - newW) ~/ 2;
    final offsetY = (targetSize - newH) ~/ 2;
    img.compositeImage(canvas, resized, dstX: offsetX, dstY: offsetY);
    return canvas;
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    _tts.stop();
    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Gesture Detection",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _cameraReady
                ? Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraPreview(_controller!),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Confidence: ${(_confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}