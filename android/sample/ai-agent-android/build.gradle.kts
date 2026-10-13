// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.google.services) apply false
    alias(libs.plugins.paparazzi) apply false
}

// Builds against an unreleased chat-android: `-PsendbirdChatVersion=<version>` resolves every request
// for sendbird-chat and sendbird-chat-ktx — declared in the catalog or arriving transitively — to
// that version, and `-PsendbirdAuthVersion` / `-PsendbirdCommonVersion` do the same for
// sendbird-auth and sendbird-common, the chat-android modules sendbird-chat is built on. A CI run
// given a chat-android revision publishes all four to mavenLocal first (see
// .github/actions/build-chat-android and use-chat-android). Forcing, rather than overriding the
// catalog alone, keeps a released version from quietly winning conflict resolution — the catalog
// declares sendbird-auth directly, and Gradle ranks `<version>-<sha>` below `<version>`. Without the
// properties nothing changes.
val localChatSdkVersions: Map<String, String> =
    mapOf(
        "sendbird-chat" to "sendbirdChatVersion",
        "sendbird-chat-ktx" to "sendbirdChatVersion",
        "sendbird-auth" to "sendbirdAuthVersion",
        "sendbird-common" to "sendbirdCommonVersion",
    ).mapNotNull { (artifact, property) ->
        providers.gradleProperty(property).orNull?.takeIf { it.isNotBlank() }?.let { artifact to it }
    }.toMap()
if (localChatSdkVersions.isNotEmpty()) {
    logger.lifecycle(
        "Resolving to local chat-android builds: " +
            localChatSdkVersions.entries.joinToString { (artifact, version) -> "$artifact $version" },
    )
    subprojects {
        configurations.configureEach {
            resolutionStrategy.eachDependency {
                val localVersion = localChatSdkVersions[requested.name]
                if (requested.group == "com.sendbird.sdk" && localVersion != null) {
                    useVersion(localVersion)
                    because("a sendbird*Version property selects a locally published chat-android build")
                }
            }
        }
    }
}
