
package com.example.personal_ai

import android.app.ActivityManager
import android.content.Context
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "personal_ai/device_info"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getDeviceSpecs" -> {
                    try {
                        val activityManager =
                            getSystemService(Context.ACTIVITY_SERVICE)
                                as ActivityManager

                        val memoryInfo =
                            ActivityManager.MemoryInfo()

                        activityManager.getMemoryInfo(memoryInfo)

                        val statFs = StatFs(
                            Environment.getDataDirectory().absolutePath
                        )

                        val mb = 1024L * 1024L

                        val deviceSpecs = mapOf(
                            "totalRamMb" to memoryInfo.totalMem / mb,
                            "availableRamMb" to memoryInfo.availMem / mb,
                            "availableStorageMb" to
                                statFs.availableBytes / mb,
                            "dataPartitionTotalMb" to
                                statFs.totalBytes / mb
                        )

                        result.success(deviceSpecs)

                    } catch (error: Exception) {
                        result.error(
                            "DEVICE_INFO_ERROR",
                            error.message,
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
