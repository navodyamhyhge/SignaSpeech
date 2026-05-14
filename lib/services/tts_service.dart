import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  bool _initialized = false;

  /// Initialize once
  Future<void> init() async {
    if (_initialized) return;

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isPlaying = true;
    });

    _tts.setCompletionHandler(() {
      _isPlaying = false;
    });

    _tts.setErrorHandler((_) {
      _isPlaying = false;
    });

    _initialized = true;
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    await init(); // ensure initialized
    await stop();
    await _tts.speak(text);
  }

  /// Stop speech
  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}