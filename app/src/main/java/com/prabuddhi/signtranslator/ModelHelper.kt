package com.prabuddhi.signtranslator

import android.content.Context
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.FileUtil

class ModelHelper(context: Context) {

    private var interpreter: Interpreter

    init {
        val model = FileUtil.loadMappedFile(context, "best.tflite")
        interpreter = Interpreter(model)
    }

    fun runModel(input: Array<Array<Array<FloatArray>>>, output: Array<FloatArray>) {
        interpreter.run(input, output)
    }
}