package com.prabuddhi.signtranslator

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore

class MainActivity : AppCompatActivity() {

    private lateinit var db: FirebaseFirestore
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize Firebase
        db = FirebaseFirestore.getInstance()
        auth = FirebaseAuth.getInstance()

        // Connect XML views
        val inputText = findViewById<EditText>(R.id.inputText)
        val outputText = findViewById<TextView>(R.id.outputText)
        val translateButton = findViewById<Button>(R.id.translateButton)

        // Translate Button Click
        translateButton.setOnClickListener {

            val userInput = inputText.text.toString().trim()

            if (userInput.isEmpty()) {
                Toast.makeText(this, "Please enter text", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            // Display translated text (Temporary)
            outputText.text = "Translated: $userInput"

            // Get current logged-in user
            val userId = auth.currentUser?.uid

            if (userId == null) {
                Toast.makeText(this, "User not logged in", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            // Prepare detection data
            val detectionData = hashMapOf(
                "userId" to userId,
                "detectedGesture" to userInput,
                "confidence" to 0.95,   // Temporary value
                "timestamp" to System.currentTimeMillis()
            )

            // Save to Firestore
            db.collection("detections")
                .add(detectionData)
                .addOnSuccessListener {
                    Toast.makeText(this, "Detection Saved!", Toast.LENGTH_SHORT).show()
                }
                .addOnFailureListener {
                    Toast.makeText(this, "Failed to save detection", Toast.LENGTH_SHORT).show()
                }
        }
    }
}