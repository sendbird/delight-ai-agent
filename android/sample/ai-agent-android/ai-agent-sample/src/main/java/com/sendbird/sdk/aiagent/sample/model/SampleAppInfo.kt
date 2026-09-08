package com.sendbird.sdk.aiagent.sample.model

import com.sendbird.sdk.aiagent.sample.consts.KeySet
import com.sendbird.sdk.aiagent.sample.consts.Region
import org.json.JSONObject

internal data class SampleAppInfo(
    val region: Region,
    val appId: String,
    val aiAgentId: String
) {
    fun toJson(): JSONObject {
        return JSONObject().apply {
            put(KeySet.region, region.name)
            put(KeySet.appId, appId)
            put(KeySet.aiAgentId, aiAgentId)
        }
    }

    companion object {
        fun fromJsonOrNull(jsonString: String): SampleAppInfo? {
            val json = runCatching { JSONObject(jsonString) }.getOrNull() ?: return null
            val region = Region.fromNameOrNull(json.optString(KeySet.region)) ?: return null
            if (!json.has(KeySet.appId) || !json.has(KeySet.aiAgentId)) return null
            return SampleAppInfo(
                region = region,
                appId = json.getString(KeySet.appId),
                aiAgentId = json.getString(KeySet.aiAgentId)
            )
        }
    }
}

// region public app info
internal val us3 = SampleAppInfo(
    region = Region.PRODUCTION,
    appId = "10306808-B7F3-436F-9F5C-29F431B47B73",
    aiAgentId = "e4c57465-4773-432e-9740-f0284a951494"
)
// endregion

internal val preprod = SampleAppInfo(
    region = Region.PREPROD,
    appId = "",
    aiAgentId = ""
)

internal val a11y = SampleAppInfo(
    region = Region.A11Y,
    appId = "",
    aiAgentId = ""
)

internal val coA = SampleAppInfo(
    region = Region.CO_A,
    appId = "",
    aiAgentId = ""
)

internal val coB = SampleAppInfo(
    region = Region.CO_B,
    appId = "",
    aiAgentId = ""
)

internal val coC = SampleAppInfo(
    region = Region.CO_C,
    appId = "",
    aiAgentId = ""
)

internal val coD = SampleAppInfo(
    region = Region.CO_D,
    appId = "",
    aiAgentId = ""
)

internal val coE = SampleAppInfo(
    region = Region.CO_E,
    appId = "",
    aiAgentId = ""
)
