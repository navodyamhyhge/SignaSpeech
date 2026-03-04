package com.prabuddhi.signtranslator

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "detection_history")
data class DetectionHistory(

    @PrimaryKey(autoGenerate = true)
    val detectionId: Int = 0,

    val label: String,

    val confidence: Float,

    val timestamp: Long,

    val userId: String
)