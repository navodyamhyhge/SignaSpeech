package com.prabuddhi.signtranslator

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.room.Room
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SignDetectionActivity : AppCompatActivity() {

    private lateinit var previewView: PreviewView
    private lateinit var resultText: TextView
    private lateinit var buttonHistory: Button
    private lateinit var buttonLogout: Button

    private lateinit var db: AppDatabase
    private lateinit var dao: DetectionDao

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_detection)

        // Initialize UI
        previewView = findViewById(R.id.previewView)
        resultText = findViewById(R.id.textResult)
        buttonHistory = findViewById(R.id.buttonHistory)
        buttonLogout = findViewById(R.id.buttonLogout)

        // Initialize Room database
        db = Room.databaseBuilder(
            applicationContext,
            AppDatabase::class.java,
            "sign_database"
        ).build()

        dao = db.detectionDao()

        // Start camera
        startCamera()

        // History button
        buttonHistory.setOnClickListener {

            val currentUserId = FirebaseAuth.getInstance().currentUser?.uid
                ?: return@setOnClickListener

            val intent = Intent(this, DetectionHistory::class.java)
            intent.putExtra("USER_ID", currentUserId)
            startActivity(intent)
        }

        // Logout button
        buttonLogout.setOnClickListener {

            FirebaseAuth.getInstance().signOut()

            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }

        // Temporary detection simulation (replace later with AI model)
        simulateDetection()
    }

    // CameraX setup
    private fun startCamera() {

        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({

            val cameraProvider = cameraProviderFuture.get()

            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            cameraProvider.unbindAll()

            cameraProvider.bindToLifecycle(
                this,
                cameraSelector,
                preview
            )

        }, ContextCompat.getMainExecutor(this))
    }

    // Temporary detection result
    private fun simulateDetection() {

        val detectedLabel = "Hello"
        val detectedConfidence = 0.92f

        resultText.text =
            "Detected Gesture: $detectedLabel\nConfidence: ${detectedConfidence * 100}%"

        saveDetectionToDatabase(detectedLabel, detectedConfidence)
    }

    // Save detection to Room database
    private fun saveDetectionToDatabase(label: String, confidence: Float) {

        val currentUserId = FirebaseAuth.getInstance().currentUser?.uid ?: return

        val history = DetectionHistory(
            label = label,
            confidence = confidence,
            timestamp = System.currentTimeMillis(),
            userId = currentUserId
        )

        lifecycleScope.launch(Dispatchers.IO) {
            dao.insertRecord(history)
        }
    }
}
