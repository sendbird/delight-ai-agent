package com.sendbird.sdk.aiagent.sample.utils

import android.content.Context
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.consts.Region

fun Region.apiHost(): String? {
    return when (this) {
        Region.PREPROD -> "https://api-preprod.svc.delightstg.ai"
        Region.A11Y -> "https://api-co-b.svc.delightdev.ai"
        Region.CO_A -> "https://api-co-a.svc.delightdev.ai"
        Region.CO_B -> "https://api-co-b.svc.delightdev.ai"
        Region.CO_C -> "https://api-co-c.svc.delightdev.ai"
        Region.CO_D -> "https://api-co-d.svc.delightdev.ai"
        Region.CO_E -> "https://api-co-e.svc.delightdev.ai"
        else -> null
    }
}

fun Region.wsHost(): String? {
    return when (this) {
        Region.PREPROD -> "wss://ws-preprod.svc.delightstg.ai"
        Region.A11Y -> "wss://ws-co-b.svc.delightdev.ai"
        Region.CO_A -> "wss://ws-co-a.svc.delightdev.ai"
        Region.CO_B -> "wss://ws-co-b.svc.delightdev.ai"
        Region.CO_C -> "wss://ws-co-c.svc.delightdev.ai"
        Region.CO_D -> "wss://ws-co-d.svc.delightdev.ai"
        Region.CO_E -> "wss://ws-co-e.svc.delightdev.ai"
        else -> null
    }
}

fun String.toRegion(context: Context): Region {
    context.let {
        return when (this) {
            context.getString(R.string.sample_region_production) -> Region.PRODUCTION
            context.getString(R.string.sample_region_preprod) -> Region.PREPROD
            context.getString(R.string.sample_region_a11y) -> Region.A11Y
            context.getString(R.string.sample_region_co_a) -> Region.CO_A
            context.getString(R.string.sample_region_co_b) -> Region.CO_B
            context.getString(R.string.sample_region_co_c) -> Region.CO_C
            context.getString(R.string.sample_region_co_d) -> Region.CO_D
            context.getString(R.string.sample_region_co_e) -> Region.CO_E
            else -> Region.PRODUCTION
        }
    }
}
