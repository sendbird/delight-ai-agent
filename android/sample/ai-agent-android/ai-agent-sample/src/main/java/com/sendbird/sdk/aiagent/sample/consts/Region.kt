package com.sendbird.sdk.aiagent.sample.consts

enum class Region {
    PRODUCTION,
    PREPROD,
    A11Y,
    CO_A,
    CO_B,
    CO_C,
    CO_D,
    CO_E
    ;

    companion object {
        // Persisted as the stable enum name. Older installs may have persisted a
        // name that no longer exists (e.g. the retired NO1-NO6 test regions), so
        // callers must treat a null result as "no saved app info" rather than
        // silently defaulting to a region.
        fun fromNameOrNull(name: String): Region? {
            return runCatching { valueOf(name) }.getOrNull()
        }
    }
}
