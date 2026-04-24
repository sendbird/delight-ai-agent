package com.sendbird.sdk.aiagent.sample.model

import com.sendbird.sdk.aiagent.sample.consts.KeySet
import com.sendbird.sdk.aiagent.sample.consts.Region
import org.json.JSONObject

internal data class SampleAppInfo(
    val region: Region,
    val appId: String,
    val aiAgentId: String
) {
    constructor(json: JSONObject): this(
        region = Region.fromValue(json.getInt(KeySet.region)),
        appId = json.getString(KeySet.appId),
        aiAgentId = json.getString(KeySet.aiAgentId)
    )

    constructor(jsonString: String): this(JSONObject(jsonString))

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put(KeySet.region, region.value)
            put(KeySet.appId, appId)
            put(KeySet.aiAgentId, aiAgentId)
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

internal val no1 = SampleAppInfo(
    region = Region.NO1,
    appId = "",
    aiAgentId = ""
)

internal val no2 = SampleAppInfo(
    region = Region.NO2,
    appId = "",
    aiAgentId = ""
)

internal val a11y = SampleAppInfo(
    region = Region.A11Y,
    appId = "",
    aiAgentId = ""
)

internal val no3 = SampleAppInfo(
    region = Region.NO3,
    appId = "",
    aiAgentId = ""
)

internal val no4 = SampleAppInfo(
    region = Region.NO4,
    appId = "",
    aiAgentId = ""
)

internal val no5 = SampleAppInfo(
    region = Region.NO5,
    appId = "",
    aiAgentId = ""
)

internal val no6 = SampleAppInfo(
    region = Region.NO6,
    appId = "",
    aiAgentId = ""
)
