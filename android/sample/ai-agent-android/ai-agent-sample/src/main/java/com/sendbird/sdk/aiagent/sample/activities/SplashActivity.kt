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
        val intent = if (appInfo == null) {
            Intent(this, SelectAppInfoActivity::class.java)
        } else {
            ViewMainActivity.newIntent(this, aiAgentId = appInfo.aiAgentId)
        }
        startActivity(intent)
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
}
