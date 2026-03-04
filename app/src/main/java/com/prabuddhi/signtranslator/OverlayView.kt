package com.prabuddhi.signtranslator

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View

class OverlayView(context: Context, attrs: AttributeSet) : View(context, attrs) {

    private val boxPaint = Paint()

    init {
        boxPaint.color = Color.GREEN
        boxPaint.strokeWidth = 8f
        boxPaint.style = Paint.Style.STROKE
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        val left = width * 0.2f
        val top = height * 0.2f
        val right = width * 0.8f
        val bottom = height * 0.8f

        canvas.drawRect(left, top, right, bottom, boxPaint)
    }
}