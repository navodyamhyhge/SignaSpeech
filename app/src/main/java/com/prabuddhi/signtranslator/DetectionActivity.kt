package com.prabuddhi.signtranslator

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.ImageFormat
import android.graphics.Rect
import android.graphics.YuvImage
import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.camera.core.*
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.io.ByteArrayOutputStream
import java.util.Locale
import java.util.concurrent.Executors

class DetectionActivity : AppCompatActivity() {

    private lateinit var previewView: PreviewView
    private lateinit var textResult: TextView
    private lateinit var modelHelper: ModelHelper
    private lateinit var tts: TextToSpeech

    private val cameraExecutor = Executors.newSingleThreadExecutor()

    private var lastSpoken = ""
    private var lastDetectionTime = 0L

    private val labels = arrayOf(
        "Hello",
        "Thank You",
        "Yes",
        "No",
        "Please",
        "Good Luck",
        "Thumbs Up",
        "I Love You"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_detection)

        previewView = findViewById(R.id.previewView)
        textResult = findViewById(R.id.textResult)

        modelHelper = ModelHelper(this)

        tts = TextToSpeech(this) { status ->
            if (status == TextToSpeech.SUCCESS) {
                tts.language = Locale.US
            }
        }

        if (allPermissionsGranted()) {
            startCamera()
        } else {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.CAMERA),
                101
            )
        }
    }

    private fun startCamera() {

        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({

            val cameraProvider = cameraProviderFuture.get()

            val preview = Preview.Builder().build()
            preview.setSurfaceProvider(previewView.surfaceProvider)

            val imageAnalyzer = ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()

            imageAnalyzer.setAnalyzer(cameraExecutor) { imageProxy ->

                val currentTime = System.currentTimeMillis()

                if (currentTime - lastDetectionTime > 700) {

                    val bitmap = imageProxyToBitmap(imageProxy)

                    runModelOnFrame(bitmap)

                    lastDetectionTime = currentTime
                }

                imageProxy.close()
            }

            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            cameraProvider.unbindAll()

            cameraProvider.bindToLifecycle(
                this,
                cameraSelector,
                preview,
                imageAnalyzer
            )

        }, ContextCompat.getMainExecutor(this))
    }

    private fun runModelOnFrame(bitmap: Bitmap) {

        val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 224, 224, true)

        val input = Array(1) { Array(224) { Array(224) { FloatArray(3) } } }

        for (y in 0 until 224) {
            for (x in 0 until 224) {

                val pixel = resizedBitmap.getPixel(x, y)

                input[0][y][x][0] = (pixel shr 16 and 0xFF) / 255.0f
                input[0][y][x][1] = (pixel shr 8 and 0xFF) / 255.0f
                input[0][y][x][2] = (pixel and 0xFF) / 255.0f
            }
        }

        val output = Array(1) { FloatArray(8) }

        modelHelper.runModel(input, output)

        val scores = output[0]

        var maxIndex = 0
        var maxScore = scores[0]

        for (i in scores.indices) {
            if (scores[i] > maxScore) {
                maxScore = scores[i]
                maxIndex = i
            }
        }

        val confidence = maxScore * 100

        val detectedSign = labels[maxIndex] + " (" + String.format("%.1f", confidence) + "%)"

        runOnUiThread {

            textResult.text = detectedSign

            if (labels[maxIndex] != lastSpoken) {
                lastSpoken = labels[maxIndex]
                tts.speak(labels[maxIndex], TextToSpeech.QUEUE_FLUSH, null, null)
            }
        }
    }

    private fun imageProxyToBitmap(image: ImageProxy): Bitmap {

        val yBuffer = image.planes[0].buffer
        val uBuffer = image.planes[1].buffer
        val vBuffer = image.planes[2].buffer

        val ySize = yBuffer.remaining()
        val uSize = uBuffer.remaining()
        val vSize = vBuffer.remaining()

        val nv21 = ByteArray(ySize + uSize + vSize)

        yBuffer.get(nv21, 0, ySize)
        vBuffer.get(nv21, ySize, vSize)
        uBuffer.get(nv21, ySize + vSize, uSize)

        val yuvImage = YuvImage(
            nv21,
            ImageFormat.NV21,
            image.width,
            image.height,
            null
        )

        val out = ByteArrayOutputStream()

        yuvImage.compressToJpeg(
            Rect(0, 0, image.width, image.height),
            100,
            out
        )

        val imageBytes = out.toByteArray()

        return android.graphics.BitmapFactory.decodeByteArray(
            imageBytes,
            0,
            imageBytes.size
        )
    }

    private fun allPermissionsGranted(): Boolean {

        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.CAMERA
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onDestroy() {
        super.onDestroy()

        if (::tts.isInitialized) {
            tts.stop()
            tts.shutdown()
        }

        cameraExecutor.shutdown()
    }
}