package com.prabuddhi.signtranslator

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.*

class HistoryAdapter(private val historyList: List<DetectionHistory>) :
    RecyclerView.Adapter<HistoryAdapter.HistoryViewHolder>() {

    class HistoryViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val label: TextView = itemView.findViewById(R.id.textLabel)
        val confidence: TextView = itemView.findViewById(R.id.textConfidence)
        val timestamp: TextView = itemView.findViewById(R.id.textTimestamp)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HistoryViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_history, parent, false)
        return HistoryViewHolder(view)
    }

    override fun onBindViewHolder(holder: HistoryViewHolder, position: Int) {
        val item = historyList[position]

        holder.label.text = "Gesture: ${item.label}"
        holder.confidence.text = "Confidence: ${item.confidence}"

        val dateFormat = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault())
        holder.timestamp.text = "Time: ${dateFormat.format(Date(item.timestamp))}"
    }

    override fun getItemCount(): Int = historyList.size
}