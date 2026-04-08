package com.sendbird.sdk.aiagent.sample.sendbird

import com.sendbird.android.params.AIAgentGroupChannelListQueryParams
import com.sendbird.sdk.aiagent.messenger.viewmodel.repository.DefaultConversationListRepository
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils

internal class CustomConversationListRepository(
    aiAgentId: String
) : DefaultConversationListRepository(aiAgentId) {

    override fun createGroupChannelListQueryParams(): AIAgentGroupChannelListQueryParams {
        val pinnedUrls = PreferenceUtils.pinnedChannelUrls
        if (pinnedUrls.isEmpty()) return super.createGroupChannelListQueryParams()
        return super.createGroupChannelListQueryParams().copy(
            pinnedChannelUrls = pinnedUrls
        )
    }
}
