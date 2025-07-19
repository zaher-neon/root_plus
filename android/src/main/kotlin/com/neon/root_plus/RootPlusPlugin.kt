package com.neon.root_plus

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.DataOutputStream
import java.io.InputStreamReader

class RootPlusPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.neon.root_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "requestRootAccess" -> {
        val hasRoot = requestRootAccess()
        result.success(hasRoot)
      }
      "executeRootCommand" -> {
        val command = call.argument<String>("command")
        if (command != null) {
          executeRootCommand(command, result)
        } else {
          result.error("INVALID_ARGUMENT", "Command argument is missing", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun requestRootAccess(): Boolean {
    return try {
      val process = Runtime.getRuntime().exec("su")
      val outputStream = DataOutputStream(process.outputStream)
      outputStream.writeBytes("exit\n")
      outputStream.flush()
      process.waitFor()
      process.exitValue() == 0
    } catch (e: Exception) {
      false
    }
  }

  private fun executeRootCommand(command: String, result: Result) {
    try {
      val process = Runtime.getRuntime().exec("su")
      val outputStream = DataOutputStream(process.outputStream)
      val inputStream = BufferedReader(InputStreamReader(process.inputStream))
      val errorStream = BufferedReader(InputStreamReader(process.errorStream))

      // Write the command
      outputStream.writeBytes("$command\n")
      outputStream.writeBytes("exit\n")
      outputStream.flush()

      // Read output
      val output = StringBuilder()
      var line: String?
      while (inputStream.readLine().also { line = it } != null) {
        output.append(line).append("\n")
      }

      // Read errors
      val error = StringBuilder()
      while (errorStream.readLine().also { line = it } != null) {
        error.append(line).append("\n")
      }

      process.waitFor()

      if (error.isNotEmpty()) {
        result.error("COMMAND_FAILED", error.toString(), output.toString())
      } else {
        result.success(output.toString())
      }
    } catch (e: Exception) {
      result.error("EXECUTION_FAILED", e.message, null)
    }
  }
}