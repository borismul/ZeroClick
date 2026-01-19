package com.zeroclick.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.car.app.connection.CarConnection
import androidx.core.app.NotificationCompat
import androidx.lifecycle.Observer

class CarDetectionService : Service() {
    private var carConnection: CarConnection? = null
    private var connectionObserver: Observer<Int>? = null

    companion object {
        const val CHANNEL_ID = "car_detection_channel"
        const val NOTIFICATION_ID = 1
        var isCarConnected = false
        var onCarConnectionChanged: ((Boolean) -> Unit)? = null
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        setupCarConnectionListener()
        println("[CarService] Service created and running")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        println("[CarService] onStartCommand")
        return START_STICKY // Restart if killed
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Zero Click",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Detecteert auto verbinding"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Zero Click")
            .setContentText(if (isCarConnected) "Verbonden met auto" else "Wacht op auto verbinding...")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun updateNotification() {
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_ID, createNotification())
    }

    private fun setupCarConnectionListener() {
        // Use CarConnection API - works on Android 12+
        carConnection = CarConnection(this)

        connectionObserver = Observer { connectionState ->
            val wasConnected = isCarConnected

            isCarConnected = when (connectionState) {
                CarConnection.CONNECTION_TYPE_PROJECTION -> {
                    // Connected to Android Auto
                    println("[CarService] Connected to Android Auto (projection)")
                    true
                }
                CarConnection.CONNECTION_TYPE_NATIVE -> {
                    // Running on Android Automotive OS
                    println("[CarService] Running on Android Automotive OS")
                    true
                }
                else -> {
                    // Not connected
                    println("[CarService] Not connected to car")
                    false
                }
            }

            if (wasConnected != isCarConnected) {
                updateNotification()
                onCarConnectionChanged?.invoke(isCarConnected)
            }
        }

        // Observe on main thread using a handler
        android.os.Handler(mainLooper).post {
            carConnection?.type?.observeForever(connectionObserver!!)
        }
    }

    override fun onDestroy() {
        println("[CarService] Service destroyed")
        connectionObserver?.let { observer ->
            carConnection?.type?.removeObserver(observer)
        }
        super.onDestroy()
    }
}

// Boot receiver to start service after device reboot
class BootReceiver : android.content.BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            println("[BootReceiver] Device booted, starting CarDetectionService")
            val serviceIntent = Intent(context, CarDetectionService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}
