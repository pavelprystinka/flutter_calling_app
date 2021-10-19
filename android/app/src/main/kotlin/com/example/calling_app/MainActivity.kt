package com.example.calling_app

import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.ui.CallComposite
import com.azure.android.communication.ui.CallCompositeBuilder
import com.azure.android.communication.ui.GroupCallOptions
import com.azure.android.communication.ui.TeamsMeetingOptions
import com.github.kittinunf.fuel.httpGet
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.UUID

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.microsoft.com/calling"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "startCallingExperience") {
                val userName: String = call.argument("userName")!!
                val authToken: String = call.argument("authToken")!!
                val callType: String = call.argument("callType")!!
                val groupCallId = call.argument<String?>("groupCallId")
                val meetingLink = call.argument<String?>("meetingLink")

                startCalling(authToken, userName, callType, groupCallId, meetingLink)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startCalling(token: String, userName: String, callType: String, groupCallId: String?, meetingLink: String?) {
        val communicationCallingComposite: CallComposite = CallCompositeBuilder().build()
        val communicationTokenCredential = CommunicationTokenCredential(token)

        if (callType == "group_call") {
            val groupCallParameters = GroupCallOptions(
                    this,
                    communicationTokenCredential,
                    userName,
                    UUID.fromString(groupCallId)
            )
            communicationCallingComposite.launch(groupCallParameters)
        }
        else {
            val teamsMeetingParameters = TeamsMeetingOptions(
                    this,
                    communicationTokenCredential,
                    userName,
                    meetingLink!!
            )
            communicationCallingComposite.launch(teamsMeetingParameters)
        }
    }
}
