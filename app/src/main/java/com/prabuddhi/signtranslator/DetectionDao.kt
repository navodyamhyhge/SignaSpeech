package com.prabuddhi.signtranslator

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface DetectionDao {

    @Insert
    suspend fun insertRecord(history: DetectionHistory)

    @Query("SELECT * FROM detection_history WHERE userId = :userId")
    suspend fun getUserHistory(userId: String): List<DetectionHistory>

    @Query("DELETE FROM detection_history WHERE detectionId = :id")
    suspend fun deleteRecord(id: Int)

    @Query("DELETE FROM detection_history")
    suspend fun clearAll()
}