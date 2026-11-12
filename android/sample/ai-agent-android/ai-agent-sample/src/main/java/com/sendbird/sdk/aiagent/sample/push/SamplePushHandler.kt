package com.sendbird.sdk.aiagent.sample.push

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.google.firebase.messaging.RemoteMessage
import com.sendbird.android.SendbirdChat
import com.sendbird.android.exception.SendbirdException
import com.sendbird.android.handler.PushRequestCompleteHandler
import com.sendbird.android.push.SendbirdPushHandler
import com.sendbird.android.push.SendbirdPushHelper
import com.sendbird.sdk.aiagent.common.utils.Logger
import com.sendbird.sdk.aiagent.messenger.AIAgentMessenger
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.activities.SplashActivity
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.suspendCancellableCoroutine
import org.json.JSONObject
import kotlin.coroutines.resume

/**
 * The sample's push receiver. [SendbirdPushHelper] gets the FCM token and registers it with the Chat
 * SDK for the connected user, and the Chat SDK's own messaging service hands each push here; showing a
 * notification is the app's call.
 *
 * [alwaysReceiveMessage] stays false, so the helper drops a push it has already passed on, and one
 * that arrives while the Chat SDK is connected with the app in front: that message already reached
 * the app. Whether the user saw it is not something the SDK says, and the sample does not track it.
 */
class SamplePushHandler : SendbirdPushHandler() {
    override fun onNewToken(newToken: String?) {
        super.onNewToken(newToken)
        Logger.i(">> FCM token issued")
    }

    override fun onMessageReceived(context: Context, remoteMessage: RemoteMessage) {
        // Ids only: the payload carries the message text and a session key.
        Logger.i(">> Push received: id=${remoteMessage.messageId}")
        // The AI Agent payload rides FCM data as one JSON object; anything else is not for this receiver.
        val payload = remoteMessage.data[PAYLOAD_KEY]?.let { runCatching { JSONObject(it) }.getOrNull() } ?: return
        val body = payload.optString("message").ifBlank { return }
        val title = payload.optJSONObject("sender")?.optString("name")?.ifBlank { null }
        val channelUrl = payload.optJSONObject("channel")?.optString("channel_url")?.ifBlank { null }
        // Keyed by the message, not its text: two pushes that read the same would replace each other.
        val notificationId = (payload.optString("message_id").ifBlank { null } ?: remoteMessage.messageId ?: body).hashCode()
        showNotification(context, notificationId, title, body, channelUrl)
    }

    private fun showNotification(context: Context, notificationId: Int, title: String?, body: String, channelUrl: String?) {
        if (ContextCompat.checkSelfPermission(context, android.Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) return

        val manager = NotificationManagerCompat.from(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && manager.getNotificationChannel(CHANNEL_ID) == null) {
            manager.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, context.getString(R.string.app_name), NotificationManager.IMPORTANCE_HIGH),
            )
        }
        // One request code per conversation: with a shared one, FLAG_UPDATE_CURRENT would point every
        // notification at the conversation of the last push.
        val tap = PendingIntent.getActivity(
            context,
            channelUrl.hashCode(),
            SplashActivity.newIntentForConversation(context, channelUrl),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setContentIntent(tap)
            .build()
        manager.notify(notificationId, notification)
    }

    companion object {
        // The data key the AI Agent payload arrives under: {"type","message","sender":{"name"},"channel",...}.
        private const val PAYLOAD_KEY = "sendbird"
        private const val CHANNEL_ID = "sample_push_messages"

        /**
         * Registers this device's token for the connected user. Called at start and at sign-in: the
         * helper holds the request until the Chat SDK connects, and a sign-out drops the handler.
         */
        fun register() {
            SendbirdPushHelper.registerHandler(SamplePushHandler())
        }

        /**
         * Unregisters this device's token for the connected user, and says whether it did. The
         * request needs this user's connection: a caller that signs out or switches users after a
         * false gives up the only chance to stop this user's pushes, so whether to go on is its call.
         *
         * A user restored from an earlier run but not yet connected in this one is authenticated
         * against [aiAgentId] first, since the request needs the connection.
         */
        suspend fun unregisterCurrentToken(aiAgentId: String): Boolean {
            return runCatching {
                if (SendbirdChat.currentUser == null) AIAgentMessenger.authenticate(aiAgentId)
                suspendCancellableCoroutine { continuation ->
                    // This device's token only: the user's other devices keep theirs.
                    SendbirdPushHelper.unregisterHandler(false, object : PushRequestCompleteHandler {
                        override fun onComplete(isActive: Boolean, token: String?) = continuation.resume(Result.success(Unit))
                        override fun onError(e: SendbirdException) = continuation.resume(Result.failure(e))
                    })
                }.getOrThrow()
            }
                // A cancelled caller stays cancelled: its activity may be gone, so no dialog may follow.
                .onFailure { if (it is CancellationException) throw it }
                .onSuccess { Logger.i(">> Push token unregistered") }
                .onFailure { Logger.w(">> Push token unregister failed: $it") }
                .isSuccess
        }
    }
}
