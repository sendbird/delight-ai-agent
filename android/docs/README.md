# Android

The **Delight AI agent Messenger** allows seamless integration of chatbot features into your Android application. Follow the steps below to initialize and utilize the SDK effectively.

This guide explains:
- [Requirements](#requirements)
- [Prerequisites](#prerequisites)
- [Getting started](#getting-started)
    - [Step 1. Create a new project](#step-1-create-a-new-project)
    - [Step 2. Install AI Agent SDK](#step-2-install-ai-agent-sdk)
    - [Step 3. Initialize AI Agent SDK](#step-3-initialize-ai-agent-sdk)
- [Running your application](#running-your-application)
    - [Manage user sessions](#manage-user-sessions)
    - [Handle session expiration](#handle-session-expiration)
    - [Launch the messenger](#launch-the-messenger)
    - [Push notifications for Android](#push-notifications-for-android)
- [Advanced features](#advanced-features)
    - [Update SDK theme](#update-sdk-theme)
    - [Deauthenticate and clear session](#deauthenticate-and-clear-session)
    - [Passing context object to Agent](#passing-context-object-to-agent)

## Requirements

The minimum requirements for AI Agent for Android are the following.

- Android 5.0 (API level 21) or higher
- Java 11 or higher
- Android Gradle plugin 8.0.0 or higher
- Android ViewBinding enabled
- Sendbird Chat SDK 4.23.1 or higher
- Sendbird UIKit 3.22.1 or higher

## Prerequisites

Before you start, you'll need your **Application ID** and **AI Agent ID**.
<br><br/>
You can find it under the **Channels** > **Messenger** menu on the Delight AI dashboard.

![ai-agent-app-id-agent-id](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-messenger-basic-information.png)

---

## Getting started

Quickly install and initalize the AI Agent SDK by following the steps below.

### Step 1. Create a new project

1. In Android Studio, create a new project (**File > New > New Project...**).
2. Select **Empty Views Activity** and click **Next**.

![ai-agent-android-empty-activity](https://github.com/user-attachments/assets/d34eee4c-36e4-441b-8b72-3a7c3592bece)

3. Give your project a name. Accept all other defaults, including the language as `Kotlin` and the minimum SDK as `API 21: Android 5.0 (Lollipop)` and click **Finish**.

![ai-agent-android-new-project](https://github.com/user-attachments/assets/630ceccf-d2db-4edb-bb93-109770965a13)

### Step 2. Install AI Agent SDK

Install AI Agent SDK for Android using Gradle by following the steps below.

#### Configuring repository

Add the following to your `settings.gradle.kts` (Project Settings) file:

```kotlin
dependencyResolutionManagement {
    repositories {
        maven { setUrl("https://repo.delight.ai/public/maven") }
    }
}
```
**Note:** You should be using Gradle 8.0 or higher. You can check the `gradle-wrapper.properties` file in your project to see the version of Gradle you are using.

#### Adding dependency

Add the dependency to your `build.gradle.kts` (Module) file:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    buildFeatures {
        viewBinding = true
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    implementation("com.sendbird.sdk:ai-agent-messenger:1.+")
}
```

Then, click **'Sync Now'** in the Gradle toolbar to apply all changes.

### Step 3. Initialize AI Agent SDK

To properly integrate and initialize Delight AI agent in your Android project, [create](#how-to-create-the-application-file) and add the following code to your `Application` class file.

```kotlin
import android.app.Application
import com.sendbird.android.exception.SendbirdException
import com.sendbird.sdk.aiagent.messenger.AIAgentMessenger
import com.sendbird.sdk.aiagent.messenger.consts.MessengerThemeMode
import com.sendbird.sdk.aiagent.messenger.interfaces.MessengerInitResultHandler
import com.sendbird.sdk.aiagent.messenger.model.MessengerInitParams

internal const val APP_ID = "YOUR_APP_ID"

class AgentApplication : Application(), MessengerInitResultHandler {
    override fun onCreate() {
        super.onCreate()
        AIAgentMessenger.initialize(MessengerInitParams(
            context = applicationContext,
            appId = APP_ID,
            theme = MessengerThemeMode.Light,
            initForeground = false,
            initResultHandler = this
        ))
    }

    override fun onInitSuccess() {
        // SDK initialized successfully
        // You need to call `AIAgentMessenger.updateSessionInfo()` here if user session info already exists.
    }

    override fun onInitFailure(e: SendbirdException) {
        // Handle initialization error
    }

    override fun onMigrationStarted() {
        // Migration started
    }
}
```

To ensure that your `AgentApplication` class is used as the application class, you need to register it in the AndroidManifest.xml file.
```xml
<application
    android:name=".AgentApplication"
>
</application>
```

#### How to create the Application file

1. Open Android Studio and navigate to your project.
2. In the left side bar, locate the **app** module.
3. Right-click on the java or kotlin folder (depending on the language of your project).
4. Select **New > Kotlin File/Class**.
5. In the dialog that appears, select **Class** and name it `AgentApplication`.
6. Then, add the code above to your `AgentApplication.kt` file.

---

## Running your application

Now that you have installed and initialized the AI Agent SDK, follow the steps below to run your application.

> Note: Make sure to perform the following steps after the SDK has been successfully initialized. Once initialization is complete, set up the user session and launch the messenger.

### Manage user sessions

To use the SDK, session information is required. The SDK supports two types of user sessions depending on your authentication requirements:

#### Session Types

The SDK provides two session types: **Manual Session** for authenticated users and **Anonymous Session** for temporary users.

**1. Manual Session (ManualSessionInfo) - For Authenticated Users**

Use Manual Session when you have an existing user authentication system and want to:
- Maintain persistent conversation history across app sessions
- Associate conversations with specific user accounts
- Track user activity and provide personalized experiences

```kotlin
val manualSessionInfo = SessionInfo.ManualSessionInfo(
    userId = USER_ID,
    sessionToken = SESSION_TOKEN,
    sessionHandler = YourSessionHandler()
)
AIAgentMessenger.updateSessionInfo(manualSessionInfo)
```

> **⚠️ Important:** When using Manual Session, you **must** implement a `SessionHandler` to handle session expiration and token refresh. See the [Handle session expiration](#handle-session-expiration) section below for implementation details.

**2. Anonymous Session (AnonymousSessionInfo) - For Temporary Users**

Use Anonymous Session when you want to:
- Provide instant access without requiring user registration
- Offer guest or trial experiences
- Support users who prefer not to create accounts

The server automatically creates a temporary user identity - no authentication required.

```kotlin
val anonymousSessionInfo = SessionInfo.AnonymousSessionInfo()
AIAgentMessenger.updateSessionInfo(anonymousSessionInfo)
```

> **⚠️ Important Note for Anonymous Sessions:**
> - Anonymous users are temporary and generated by the server
> - Conversation history may **not persist** across different app sessions
> - Users cannot see their previous conversations if cached session information is removed (e.g., app reinstall) or the session expires
> - Session expiration handling is **not required** (no SessionHandler needed)

#### When to set the session information

The timing of session setup depends on your app's authentication flow:

**1. Upon initial login (Manual Session):**
When a user logs in for the first time or after logging out, set the session immediately after successful authentication.

```kotlin
fun onLoginSuccess(userId: String, sessionToken: String) {
    PreferenceUtils.saveUserInfo(userId, sessionToken)

    // Update AI Agent Messenger session
    AIAgentMessenger.updateSessionInfo(
        SessionInfo.ManualSessionInfo(
            userId = userId,
            sessionToken = sessionToken,
            sessionHandler = YourSessionHandler()
        )
    )
}
```

**2. For already logged-in users (Manual Session):**
If the user is already logged in (credentials stored), register the session immediately after SDK initialization in `onInitSuccess()`.

```kotlin
class YourApplication : Application(), MessengerInitResultHandler {
    override fun onInitSuccess() {
        // Check if user credentials exist in your app
        val userInfo = PreferenceUtils.getUserInfo()

        if (userInfo != null) {
            // User is already logged in - use Manual Session
            val sessionInfo = SessionInfo.ManualSessionInfo(
                userId = userInfo.userId,
                sessionToken = userInfo.sessionToken,
                sessionHandler = YourSessionHandler()
            )
            AIAgentMessenger.updateSessionInfo(sessionInfo)
        }
    }
}
```

**3. For guest users (Anonymous Session):**
Set up anonymous session immediately after SDK initialization or when starting a guest experience.

```kotlin
// No authentication required - set up immediately
AIAgentMessenger.updateSessionInfo(SessionInfo.AnonymousSessionInfo())
```

### Handle session expiration

**This section is only required when using Manual Session (ManualSessionInfo).**

When using `ManualSessionInfo`, session tokens can expire over time due to security policies. The SDK uses a `SessionHandler` to notify your app when the session needs attention, allowing you to refresh tokens or redirect users to login.

> **Note:** Session expiration handling is **only applicable** when using `ManualSessionInfo`. `AnonymousSessionInfo` does not require session token management or a session handler.

#### Understanding SessionHandler callbacks

The `AIAgentSessionHandler` provides two important callbacks:

**1. `onSessionClosed()`**
- The session refresh has been denied from the app.
- Client apps should guide the user to a login page to log in again.

**Action:** Redirect the user to the login screen to re-authenticate.

**2. `onSessionTokenRequired(sessionTokenRequester: SessionTokenRequester)`**
- Called when the SDK requires a new session token to refresh the session.
- Refresh the session token from your authentication server and pass it to the SDK through `sessionTokenRequester.onSuccess(NEW_TOKEN)`.
- When `sessionTokenRequester.onSuccess()` is called with the new token, the SDK internally calls `updateSessionInfo`, which automatically updates the session token, you don't need to call `updateSessionInfo` manually.
- If you do not want to refresh the session, pass on a null value through sessionTokenRequester.onSuccess(null).
- If any error occurred while refreshing the token, let the SDK know about it through sessionTokenRequester.onFail().

**Action:** Request a new token from your authentication server and provide it to the SDK.

#### Implementation example

Here's how to implement a SessionHandler based on the ai-agent-sample:

```kotlin
import com.sendbird.android.handler.SessionTokenRequester
import com.sendbird.sdk.aiagent.messenger.interfaces.AIAgentSessionHandler

class YourSessionHandler : AIAgentSessionHandler() {

    override fun onSessionClosed() {
        // The session has been completely closed
        // Redirect user to login screen
    }

    override fun onSessionTokenRequired(sessionTokenRequester: SessionTokenRequester) {
        // The session token has expired and needs to be refreshed
    }
}
```

#### Setting up the SessionHandler

Pass your SessionHandler when creating the ManualSessionInfo:

```kotlin
val sessionHandler = YourSessionHandler()

val manualSessionInfo = SessionInfo.ManualSessionInfo(
    userId = "USER_ID",
    sessionToken = "SESSION_TOKEN",
    sessionHandler = sessionHandler
)

AIAgentMessenger.updateSessionInfo(manualSessionInfo)
```

### Launch the messenger

#### Before You Start
- Was `onInitSuccess` received via MessengerInitResultHandler after invoking `AIAgentMessenger.initialize()`?
- `AIAgentMessenger.updateSessionInfo()` been called with the user session information

Once the authentication information has been successfully registered, you can launch the messenger to start a conversation with the ai agent.

There are two ways to display the messenger:

1. Using the launcher button
2. Opening the conversation channel in full-screen mode

>__Note__: Replace `YOUR_AI_AGENT_ID` with your AI agent ID which you can obtain from the Delight AI dashboard. To learn how do to so, refer to the [prerequisites](#prerequisites) section.

#### 1. Using the launcher button

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-launcher2.png" />

The SDK provides the MessengerLauncher view, which can be easily attached to your application's root view programmatically without directly adding it to XML layouts.

> Since the SDK utilizes Fragments, make sure the context you pass to the MessengerLauncher is an instance of FragmentActivity. If you're using standard Android components such as AppCompatActivity, there's no need to worry, as it already inherits from FragmentActivity.
However, if you're using a custom or legacy activity, verify that it inherits from FragmentActivity to avoid runtime issues.

To add the MessengerLauncher to your screen, simply call the `attach()` function of `MessengerLauncher`, specifying the AI agent ID and configuration parameters:

```kotlin
MessengerLauncher(context, "YOUR_AI_AGENT_ID").attach()
```

- **`entryPoint`**: Controls which screen is displayed first when the MessengerLauncher is clicked:

```kotlin
val entryPoint = MessengerEntryPoint.CONVERSATION // or MessengerEntryPoint.CONVERSATION_LIST
MessengerLauncher(this, "YOUR_AI_AGENT_ID", LauncherSettingsParams(entryPoint = entryPoint)).attach()
```

Available options:
- `MessengerEntryPoint.CONVERSATION`: Opens directly to the conversation screen (default)
- `MessengerEntryPoint.CONVERSATION_LIST`: Opens to the conversation list screen

Use `CONVERSATION` for single AI agent conversations, or `CONVERSATION_LIST` when multiple conversation channels are available.

- `LauncherLayoutParams` allows you to configure the MessengerLauncher's behavior and appearance:
    - **`launchMode`**:
        - `EXPANDED`: Opens the messenger in full-screen mode with predefined margins.
        - `ANCHORED`: Opens the messenger anchored near the launcher button, with adjustable positioning.ㄴ

    - **`margin`**: Defines the margin around the launcher button itself (does not affect the messenger window).

    - **`location`**: Determines which corner of the screen the launcher will appear in. Available options are:
        - `TOP_START`
        - `TOP_END`
        - `BOTTOM_START`
        - `BOTTOM_END`

#### 2. Opening the conversation channel in full-screen mode

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies2.png" />

You can open a full-screen conversation by starting an `Activity`.

```kotlin
startActivity(MessengerActivity.newIntentForConversation(context, "YOUR_AI_AGENT_ID"))
```

---

### Push notifications for Android

For more details, refer to the [Push notifications](https://sendbird.com/docs/chat/sdk/v4/android/push-notifications/overview-push-notifications) page on our official documentation.

#### Register for push notifications

To receive push notifications from Delight AI server, register the device token by setting up a custom `FirebaseMessagingService`.
Call the following method after login:

```kotlin
SendbirdPushHelper.registerHandler(MyFirebaseMessagingService())
```
This will register the FCM token and automatically send it to the Delight AI server.

#### Unregister for Push Notifications

To stop receiving push notifications:

```kotlin
SendbirdPushHelper.unregisterHandler()
```
This is typically used on logout or when push notifications should be disabled.

#### Handling Push Notifications

Push payloads will be delivered via FCM and include a `sendbird` field in the RemoteMessage data.

In your custom FirebaseMessagingService, override onMessageReceived() like this:
```kotlin
override fun onMessageReceived(context: Context, remoteMessage: RemoteMessage) {
    val jsonStr = remoteMessage.data["sendbird"] ?: return
    val sendbird = JSONObject(jsonStr)
    val message = sendbird.getString("message")
    val channelUrl = sendbird.getJSONObject("channel").getString("channel_url")

    // Show local notification and route user to the correct screen
}
```
You can refer to the sample MyFirebaseMessagingService implementation for building local notifications and launching a conversation screen using the channelUrl.

---

## Advanced features

The following are available advanced features.

### Update SDK theme

You can update the SDK's color scheme to match your app's theme as shown below.

```kotlin
AIAgentMessenger.setThemeMode(themeMode) // Options: MessengerThemeMode.Dark, MessengerThemeMode.Light
```

Since apps may allow users to switch themes manually or follow the device's settings, theme updates need to be explicitly called.


### Deauthenticate and clear session

When the user logs out of your app, de-authenticate the SDK to clear session data and disconnect.

```kotlin
AIAgentMessenger.deauthenticate()
```


### Passing context object to Agent

You can predefine customer-specific information such as country, language, or other custom context data to guide the AI Agent in providing faster and more accurate responses.

This allows for a more personalized and context-aware interaction experience.

> Once the contexts are set, they will be used throughout the conversation to provide personalized and context-aware responses. The configured context is set when the conversation starts.
If you need to update the context during the conversation, you can use the Platform API to modify it.

#### 1. Applying settings data through MessengerLauncher
```kotlin
MessengerLauncher(this, it, LauncherSettingsParams(
    language = "en",
    countryCode = "US",
    context = mapOf(
        "key1" to "value1",
        "key2" to "value2"
    )
)).attach()
```

#### 2. Applying settings data through full-screen conversation

```kotlin
startActivity(
    MessengerActivity.newIntentForConversation(
        context = context,
        aiAgentId = aiAgentId,
        conversationSettingsParams = ConversationSettingsParams(
            language = "en",
            countryCode = "US",
            context = mapOf(
                "key1" to "value1",
                "key2" to "value2"
            )
        )
    )
)
```
