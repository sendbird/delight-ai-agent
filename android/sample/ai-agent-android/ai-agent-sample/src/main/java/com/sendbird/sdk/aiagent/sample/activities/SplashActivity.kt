package com.sendbird.sdk.aiagent.sample.activities

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.sendbird.sdk.aiagent.common.utils.Logger
import com.sendbird.sdk.aiagent.messenger.ui.activity.MessengerActivity
import com.sendbird.sdk.aiagent.messenger.ui.widget.WaitingDialog
import com.sendbird.sdk.aiagent.sample.AgentApplication
import com.sendbird.sdk.aiagent.sample.consts.InitState
import com.sendbird.sdk.aiagent.sample.databinding.SampleLayoutSplashBinding
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils
import kotlinx.coroutines.launch

@SuppressLint("CustomSplashScreen")
class SplashActivity : BaseSampleActivity() {
    override val binding by lazy { SampleLayoutSplashBinding.inflate(layoutInflater) }
    private var initializationCompleted = false
    private var permissionGranted = false

    private val notificationPermissionLauncher: ActivityResultLauncher<String> =
        registerForActivityResult(ActivityResultContracts.RequestPermission()) { isGranted ->
            Logger.d(">> Push notification permission result: $isGranted")
            permissionGranted = true
            if (initializationCompleted) {
                proceedToNextStep()
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        // Request push notification permission for Android 13+
        requestNotificationPermissionIfNeeded()

        lifecycleScope.launch {
            AgentApplication.initState.collect {
                Logger.i(">> collected, initState: $it")
                when (it) {
                    InitState.NONE -> {}
                    InitState.MIGRATING -> WaitingDialog.show(this@SplashActivity)
                    InitState.FAILED, InitState.SUCCEED -> {
                        WaitingDialog.dismiss()
                        initializationCompleted = true
                        if (permissionGranted) {
                            proceedToNextStep()
                        }
                    }
                }
            }
        }
    }

    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (!hasPermissions(this, Manifest.permission.POST_NOTIFICATIONS)) {
                Logger.d(">> Requesting push notification permission")
                notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            } else {
                Logger.d(">> Push notification permission already granted")
                permissionGranted = true
            }
        } else {
            Logger.d(">> Push notification permission not required for this Android version")
            permissionGranted = true
        }
    }

    private fun proceedToNextStep() {
        Logger.d(">> Proceeding to next step")
        val appInfo = PreferenceUtils.sampleAppInfo
        val notifiedChannelUrl = intent.getStringExtra(KEY_CHANNEL_URL)
        when {
            appInfo == null -> startActivity(Intent(this, SelectAppInfoActivity::class.java))
            // Home goes underneath, so backing out of the notified conversation lands where a normal start would.
            notifiedChannelUrl != null -> startActivities(
                arrayOf(
                    ViewMainActivity.newIntent(this, aiAgentId = appInfo.aiAgentId),
                    MessengerActivity.newIntentForConversation(this, appInfo.aiAgentId, conversationChannelUrl = notifiedChannelUrl),
                )
            )
            else -> startActivity(ViewMainActivity.newIntent(this, aiAgentId = appInfo.aiAgentId))
        }
        finish()
    }

    private fun hasPermissions(context: Context, vararg permissions: String): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            for (permission in permissions) {
                if (ContextCompat.checkSelfPermission(
                        context,
                        permission
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    return false
                }
            }
        }
        return true
    }

    companion object {
        private const val KEY_CHANNEL_URL = "KEY_CHANNEL_URL"

        /**
         * The intent a push notification opens: a fresh task through the splash, so the SDK is
         * initialized and the session set before [channelUrl]'s conversation opens, whether or not
         * the process was still alive. A null [channelUrl] starts the app as the launcher does.
         */
        internal fun newIntentForConversation(context: Context, channelUrl: String?): Intent {
            return Intent(context, SplashActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                channelUrl?.let { putExtra(KEY_CHANNEL_URL, it) }
            }
        }
    }
}
