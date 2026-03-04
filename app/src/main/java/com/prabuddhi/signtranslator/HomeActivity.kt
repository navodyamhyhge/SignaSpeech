package com.prabuddhi.signtranslator

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class HomeActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        val btnSign = findViewById<Button>(R.id.btnSign)
        val btnWord = findViewById<Button>(R.id.btnWord)

        btnSign.setOnClickListener {
            startActivity(Intent(this, SignDetectionActivity::class.java))
        }

        btnWord.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
        }
    }
}