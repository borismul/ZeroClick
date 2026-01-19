package com.zeroclick.app

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.zeroclick/carplay"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkConnection" -> {
                    result.success(CarDetectionService.isCarConnected)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Set up callback from service to Flutter
        CarDetectionService.onCarConnectionChanged = { connected ->
            runOnUiThread {
                if (connected) {
                    println("[MainActivity] Notifying Flutter: Car connected")
                    methodChannel?.invokeMethod("onCarPlayConnected", null)
                } else {
                    println("[MainActivity] Notifying Flutter: Car disconnected")
                    methodChannel?.invokeMethod("onCarPlayDisconnected", null)
                }
            }
        }

        // Start the foreground service
        startCarDetectionService()
    }

    private fun startCarDetectionService() {
        val serviceIntent = Intent(this, CarDetectionService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
        println("[MainActivity] Started CarDetectionService")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if already connected when app starts
        if (CarDetectionService.isCarConnected) {
            methodChannel?.invokeMethod("onCarPlayConnected", null)
        }
    }
}
