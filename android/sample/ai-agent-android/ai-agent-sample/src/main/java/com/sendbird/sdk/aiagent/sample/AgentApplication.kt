package com.sendbird.sdk.aiagent.sample

import android.app.Application
import android.content.res.Configuration
import com.sendbird.android.exception.SendbirdException
import com.sendbird.sdk.aiagent.common.utils.LoggerLevel
import com.sendbird.sdk.aiagent.messenger.AIAgentMessenger
import com.sendbird.sdk.aiagent.messenger.consts.MessengerThemeMode
import com.sendbird.sdk.aiagent.messenger.interfaces.MessengerInitResultHandler
import com.sendbird.sdk.aiagent.messenger.model.MessengerInitParams
import com.sendbird.sdk.aiagent.messenger.model.SessionInfo
import com.sendbird.sdk.aiagent.sample.consts.InitState
import com.sendbird.sdk.aiagent.sample.model.SampleAppInfo
import com.sendbird.sdk.aiagent.sample.model.us3
import com.sendbird.sdk.aiagent.sample.utils.AbstractSessionHandler
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils
import com.sendbird.sdk.aiagent.sample.utils.apiHost
import com.sendbird.sdk.aiagent.sample.utils.getCurrentTheme
import com.sendbird.sdk.aiagent.sample.utils.wsHost
import kotlinx.coroutines.flow.MutableStateFlow

class AgentApplication : Application(), MessengerInitResultHandler {
    override fun onCreate() {
        super.onCreate()
        initHandler = this

        PreferenceUtils.init(applicationContext)
        val appInfo: SampleAppInfo = PreferenceUtils.sampleAppInfo ?: us3
        AIAgentMessenger.initialize(MessengerInitParams(
            context = applicationContext,
            appId = appInfo.appId,
            theme = applicationContext.getCurrentTheme(),
            initResultHandler = this,
            apiHost = appInfo.region.apiHost(),
            wsHost = appInfo.region.wsHost(),
            loggerLevel = LoggerLevel.VERBOSE
        ))
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)

        if (newConfig.uiMode and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES) {
            AIAgentMessenger.setThemeMode(MessengerThemeMode.Dark)
        } else if (newConfig.uiMode and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_NO) {
            AIAgentMessenger.setThemeMode(MessengerThemeMode.Light)
        }
    }

    override fun onInitSuccess() {
        val sessionInfo = PreferenceUtils.manualUserInfo?.let {
            SessionInfo.ManualSessionInfo(it.userId, it.authToken, AbstractSessionHandler())
        } ?: run {
            SessionInfo.AnonymousSessionInfo()
        }
        AIAgentMessenger.updateSessionInfo(sessionInfo)
        initState.value = InitState.SUCCEED
    }

    override fun onInitFailure(e: SendbirdException) {
        initState.value = InitState.FAILED
    }

    override fun onMigrationStarted() {
        initState.value = InitState.MIGRATING
    }

    companion object {
        internal val initState = MutableStateFlow(InitState.NONE)
        internal var initHandler: MessengerInitResultHandler? = null
    }
}
