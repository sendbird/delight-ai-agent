package com.sendbird.sdk.aiagent.sample.consts

import com.sendbird.sdk.aiagent.sample.R

enum class Region(val value: Int) {
    PRODUCTION(R.string.sample_region_production),
    NO1(R.string.sample_region_no1),
    NO2(R.string.sample_region_no2),
    NO3(R.string.sample_region_no3),
    NO4(R.string.sample_region_no4),
    NO5(R.string.sample_region_no5),
    NO6(R.string.sample_region_no6),
    A11Y(R.string.sample_region_a11y)
    ;

    companion object {
        fun fromValue(value: Int): Region {
            return when (value) {
                R.string.sample_region_production -> PRODUCTION
                R.string.sample_region_no1 -> NO1
                R.string.sample_region_no2 -> NO2
                R.string.sample_region_no3 -> NO3
                R.string.sample_region_no4 -> NO4
                R.string.sample_region_no5 -> NO5
                R.string.sample_region_no6 -> NO6
                R.string.sample_region_a11y -> A11Y
                else -> PRODUCTION
            }
        }
    }
}
