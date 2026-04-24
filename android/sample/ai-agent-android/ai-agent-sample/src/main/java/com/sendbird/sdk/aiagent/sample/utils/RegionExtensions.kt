package com.sendbird.sdk.aiagent.sample.utils

import android.content.Context
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.consts.Region

fun Region.apiHost(): String? {
    return when (this) {
        Region.NO1 -> "https://api-no1.sendbirdtest.com"
        Region.NO2 -> "https://api-no2.sendbirdtest.com"
        Region.NO3 -> "https://api-no3.sendbirdtest.com"
        Region.NO4 -> "https://api-no4.sendbirdtest.com"
        Region.NO5 -> "https://api-no5.sendbirdtest.com"
        Region.NO6 -> "https://api-no6.sendbirdtest.com"
        Region.A11Y -> "https://api-no2.sendbirdtest.com"
        else -> null
    }
}

fun Region.wsHost(): String? {
    return when (this) {
        Region.NO1 -> "wss://ws-no1.sendbirdtest.com"
        Region.NO2 -> "wss://ws-no2.sendbirdtest.com"
        Region.NO3 -> "wss://ws-no3.sendbirdtest.com"
        Region.NO4 -> "wss://ws-no4.sendbirdtest.com"
        Region.NO5 -> "wss://ws-no5.sendbirdtest.com"
        Region.NO6 -> "wss://ws-no6.sendbirdtest.com"
        Region.A11Y -> "wss://ws-no2.sendbirdtest.com"
        else -> null
    }
}

fun String.toRegion(context: Context): Region {
    context.let {
        return when (this) {
            context.getString(R.string.sample_region_production) -> Region.PRODUCTION
            context.getString(R.string.sample_region_no1) -> Region.NO1
            context.getString(R.string.sample_region_no2) -> Region.NO2
            context.getString(R.string.sample_region_no3) -> Region.NO3
            context.getString(R.string.sample_region_no4) -> Region.NO4
            context.getString(R.string.sample_region_no5) -> Region.NO5
            context.getString(R.string.sample_region_no6) -> Region.NO6
            context.getString(R.string.sample_region_a11y) -> Region.A11Y
            else -> Region.PRODUCTION
        }
    }
}
