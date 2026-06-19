package com.example.slipstream

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

private val CHANNEL = "slipstream/wallpaper"

override fun configureFlutterEngine(
    flutterEngine: FlutterEngine
) {

    super.configureFlutterEngine(
        flutterEngine
    )

    MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        CHANNEL
    ).setMethodCallHandler { call, result ->

        if (call.method == "setWallpaper") {

            val path =
                call.argument<String>("path")

            val target =
                call.argument<String>("target")

            if (path == null) {
                result.error(
                    "PATH_NULL",
                    "Path is null",
                    null
                )
                return@setMethodCallHandler
            }

            try {

                val bitmap =
                    BitmapFactory.decodeFile(path)

                if (bitmap == null) {
                    result.error(
                        "BITMAP_NULL",
                        "Failed to decode image",
                        null
                    )
                    return@setMethodCallHandler
                }

                val wallpaperManager =
                    WallpaperManager.getInstance(
                        applicationContext
                    )

                when (target) {

                    "Home" -> {
                        wallpaperManager.setBitmap(
                            bitmap,
                            null,
                            true,
                            WallpaperManager.FLAG_SYSTEM
                        )
                    }

                    "Lock" -> {
                        wallpaperManager.setBitmap(
                            bitmap,
                            null,
                            true,
                            WallpaperManager.FLAG_LOCK
                        )
                    }

                    else -> {
                        wallpaperManager.setBitmap(
                            bitmap
                        )
                    }
                }

                result.success(true)

            } catch (e: Exception) {

                e.printStackTrace()

                result.error(
                    "WALLPAPER_ERROR",
                    e.toString(),
                    null
                )
            }
        } else {
            result.notImplemented()
        }
    }
}
}