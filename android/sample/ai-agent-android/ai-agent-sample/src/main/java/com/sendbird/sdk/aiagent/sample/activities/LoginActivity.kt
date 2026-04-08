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
import com.sendbird.sdk.aiagent.sample.model.userNo1
import com.sendbird.sdk.aiagent.sample.model.userNo2
import com.sendbird.sdk.aiagent.sample.model.userNo3
import com.sendbird.sdk.aiagent.sample.model.userNo4
import com.sendbird.sdk.aiagent.sample.model.userNo5
import com.sendbird.sdk.aiagent.sample.model.userNo6
import com.sendbird.sdk.aiagent.sample.model.userUs3
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
                lifecycleScope.launch {
                    val userId = etUserId.text.toString()
                    val authToken = etAuthToken.text.toString()
                    val context = this@LoginActivity
                    runCatching {
                        authenticate(userId, authToken)
                    }.onFailure {
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
                // Handle error
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
            Region.NO1 -> userNo1
            Region.NO2 -> userNo2
            Region.NO3 -> userNo3
            Region.NO4 -> userNo4
            Region.NO5 -> userNo5
            Region.NO6 -> userNo6
        }
    }
}
