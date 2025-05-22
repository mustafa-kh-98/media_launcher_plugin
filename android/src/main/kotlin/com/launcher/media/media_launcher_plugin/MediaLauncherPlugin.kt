package com.launcher.media.media_launcher_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import java.io.UnsupportedEncodingException
import java.net.URLEncoder

/** MediaLauncherPlugin */
class MediaLauncherPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "media_launcher_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val meth = SocialShareMethods.fromString(call.method);
        val message: String = call.argument("message") ?: ""
        when (meth) {
            SocialShareMethods.WHATSAPP -> whenWhtsapp(result, message)

            SocialShareMethods.TELEGRAM -> whenTelegram(result, message)
            SocialShareMethods.X -> whenX(result, message)
            SocialShareMethods.SYSTEM -> whenSystem(result, message)
            SocialShareMethods.NON -> {
                result.success("${call.method} not found")
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    fun whenWhtsapp(result: Result, message: String) {
        val whatsappIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            `package` = "com.whatsapp"
            putExtra(Intent.EXTRA_TEXT, message)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            context.startActivity(whatsappIntent)
            result.success("success")
        } catch (ex: ActivityNotFoundException) {
            result.success("error: WhatsApp not installed")
        }
    }

    fun whenTelegram(result: Result, message: String) {
        val whatsappIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            `package` = "org.telegram.messenger"
            putExtra(Intent.EXTRA_TEXT, message)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            context.startActivity(whatsappIntent)
            result.success("success")
        } catch (ex: ActivityNotFoundException) {
            result.success("error: Telegram not installed")
        }
    }

    fun whenX(result: Result, message: String) {
        try {
            val urlScheme =
                "http://www.twitter.com/intent/tweet?text=" + URLEncoder.encode(message, "UTF-8")

            val xIntent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse(urlScheme)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            try {
                context.startActivity(xIntent)
                result.success("success")
            } catch (ex: ActivityNotFoundException) {
                result.success("X not installed")
            }
        } catch (e: UnsupportedEncodingException) {
            result.success("X not installed")
        }
    }

    fun whenSystem(result: Result, message: String) {
        val systemIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, message)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            context.startActivity(systemIntent)
            result.success("success")
        } catch (ex: ActivityNotFoundException) {
            result.success("error: ${ex.message}")
        }
    }
}
