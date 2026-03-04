package com.prabuddhi.signtranslator

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(
    entities = [DetectionHistory::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {

    abstract fun detectionDao(): DetectionDao
}