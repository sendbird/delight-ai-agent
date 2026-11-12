package com.sendbird.sdk.aiagent.sample.push

import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat
import com.sendbird.sdk.aiagent.sample.R
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

/**
 * Takes this device's token off the signed-in user before they leave, and clears the notifications
 * they got here. Returns whether to go on leaving: always, unless unregistering failed and
 * [confirmOnFailure] asked and the user chose to stay.
 */
suspend fun AppCompatActivity.unregisterPushToken(aiAgentId: String, confirmOnFailure: Boolean): Boolean {
    val leave = SamplePushHandler.unregisterCurrentToken(aiAgentId) || !confirmOnFailure || confirmLeaveAnyway()
    if (leave) NotificationManagerCompat.from(this).cancelAll()
    return leave
}

private suspend fun AppCompatActivity.confirmLeaveAnyway(): Boolean = suspendCancellableCoroutine { continuation ->
    val dialog = AlertDialog.Builder(this)
        .setMessage(R.string.sample_text_push_unregister_failed)
        .setPositiveButton(R.string.sample_text_logout_anyway) { _, _ -> continuation.resume(true) }
        .setNegativeButton(R.string.sample_text_cancel) { _, _ -> continuation.resume(false) }
        .setOnCancelListener { continuation.resume(false) }
        .show()
    continuation.invokeOnCancellation { dialog.dismiss() }
}
