package com.sendbird.sdk.aiagent.sample.activities

import android.os.Bundle
import android.widget.Toast
import androidx.lifecycle.lifecycleScope
import com.sendbird.android.SendbirdChat
import com.sendbird.sdk.aiagent.messenger.AIAgentMessenger
import com.sendbird.sdk.aiagent.messenger.model.SessionInfo
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.consts.Region
import com.sendbird.sdk.aiagent.sample.databinding.SampleLayoutLoginBinding
import com.sendbird.sdk.aiagent.sample.model.ManualUserInfo
import com.sendbird.sdk.aiagent.sample.model.SampleAppInfo
import com.sendbird.sdk.aiagent.sample.model.us3
import com.sendbird.sdk.aiagent.sample.model.userA11y
import com.sendbird.sdk.aiagent.sample.model.userPreprod
import com.sendbird.sdk.aiagent.sample.model.userCoA
import com.sendbird.sdk.aiagent.sample.model.userCoB
import com.sendbird.sdk.aiagent.sample.model.userCoC
import com.sendbird.sdk.aiagent.sample.model.userCoD
import com.sendbird.sdk.aiagent.sample.model.userCoE
import com.sendbird.sdk.aiagent.sample.model.userUs3
import com.sendbird.sdk.aiagent.sample.push.SamplePushHandler
import com.sendbird.sdk.aiagent.sample.push.unregisterPushToken
import com.sendbird.sdk.aiagent.sample.utils.AbstractSessionHandler
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils
import com.sendbird.sdk.aiagent.sample.utils.apiHost
import com.sendbird.sdk.aiagent.sample.utils.wsHost
import kotlinx.coroutines.launch


class LoginActivity : BaseSampleActivity() {
    override val binding by lazy { SampleLayoutLoginBinding.inflate(layoutInflater) }
    private val appInfo: SampleAppInfo by lazy { PreferenceUtils.sampleAppInfo ?: us3 }
    private val manualUserInfo: ManualUserInfo by lazy { getDefaultAppInfo(appInfo.region) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        with(binding) {
            setContentView(root)
            setDefaultInformation(this@with, manualUserInfo)
            btnSignIn.setOnClickListener {
                val userId = etUserId.text.toString()
                val authToken = etAuthToken.text.toString()
                val context = this@LoginActivity
                // Whoever is signed in now (the anonymous user, at first) holds this device's token, and
                // signing someone else in does not take it off them: it goes first, or the device
                // receives both users' pushes. Unregistering takes a request or two, so a second tap
                // waits.
                btnSignIn.isEnabled = false
                lifecycleScope.launch {
                    // No confirmation: the user replaced is mostly the anonymous one, who may never have
                    // registered here, or, with an agent in Copilot mode, cannot be authenticated to
                    // unregister at all; asking would stop most first sign-ins for nothing.
                    unregisterPushToken(appInfo.aiAgentId, confirmOnFailure = false)
                    runCatching {
                        authenticate(userId, authToken)
                    }.onFailure {
                        // The previous user is still the one signed in, and unregistering took the handler down:
                        // register it again, and the helper holds it until that user connects.
                        SamplePushHandler.register()
                        binding.btnSignIn.isEnabled = true
                        Toast.makeText(context, "Error: ${it.message}", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }
    }

    private fun authenticate(userId: String, authToken: String) {
        val userInfo = PreferenceUtils.sampleAppInfo ?: us3
        val apiHost = userInfo.region.apiHost()
        val wsHost = userInfo.region.wsHost()
        SendbirdChat.connect(userId, authToken, apiHost, wsHost) { _, e ->
            if (e != null) {
                SamplePushHandler.register()
                binding.btnSignIn.isEnabled = true
                Toast.makeText(this@LoginActivity, "Error: ${e.message}", Toast.LENGTH_SHORT).show()
                return@connect
            } else {
                PreferenceUtils.manualUserInfo = ManualUserInfo(
                    userId = userId,
                    authToken = authToken
                )
                AIAgentMessenger.updateSessionInfo(SessionInfo.ManualSessionInfo(
                    userId = userId,
                    sessionToken = authToken,
                    sessionHandler = AbstractSessionHandler()
                ))
                // Unregistering took the handler down with the previous user's token.
                SamplePushHandler.register()
                finish()
            }
        }
    }

    private fun setDefaultInformation(binding: SampleLayoutLoginBinding, manualUserInfo: ManualUserInfo) {
        with(binding) {
            with(manualUserInfo) {
                etUserId.setText(userId)
                etAuthToken.setText(authToken)
            }
        }
    }

    private fun getDefaultAppInfo(region: Region): ManualUserInfo {
        return when (region) {
            Region.PRODUCTION -> userUs3
            Region.PREPROD -> userPreprod
            Region.A11Y -> userA11y
            Region.CO_A -> userCoA
            Region.CO_B -> userCoB
            Region.CO_C -> userCoC
            Region.CO_D -> userCoD
            Region.CO_E -> userCoE
        }
    }
}
