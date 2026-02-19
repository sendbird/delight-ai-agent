**iOS** / [Android](https://github.com/sendbird/delight-ai-agent/blob/main/android/README.md) / [JS](https://github.com/sendbird/delight-ai-agent/blob/main/js/)

# Delight AI agent Quickstart guide (iOS)

The **Delight AI agent Messenger** allows seamless integration of chatbot features into your iOS application. Follow the steps below to initialize and utilize the SDK effectively.

This guide explains:
- [Requirements](#requirements)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
    - [Step 1. Create a new project](#step-1-create-a-new-project)
    - [Step 2. Install AI Agent SDK](#step-2-install-ai-agent-sdk)
    - [Step 3. Initialize AI Agent SDK](#step-3-initialize-ai-agent-sdk)
- [Running your application](#running-your-application)
    - [Manage user sessions](#manage-user-sessions)
    - [Handle session expiration](#handle-session-expiration)
    - [Launch the messenger](#launch-the-messenger)
- [Push Notifications](#push-notifications)
    - [Register for push notifications](#register-for-push-notifications)
    - [Unregister for push notifications](#unregister-for-push-notifications)
- [Advanced features](#advanced-features)
    - [Customize launcher mode](#customize-launcher-mode)
    - [Entry Point Advanced Configuration Guide](#entry-point-advanced-configuration-guide)
    - [Update SDK Theme](#update-sdk-theme)
    - [Deauthenticate and clear session](#deauthenticate-and-clear-session)
    - [Passing context object to Agent](#passing-context-object-to-agent)
    - [Custom Localization Multi-language Support](#custom-localization-multi-language-support)

---

## Requirements

The minimum requirements for AI Agent for iOS are the following.

- Xcode 16.3 or later
- Swift Package Manager (SPM) support

---

## Prerequisites

Before you start, you'll need your Delight AI **Application ID** and **AI Agent ID**.
<br><br/>
You can find it under the **Channels** > **Messenger** menu on the Delight AI dashboard.

![ai-agent-app-id-agent-id](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-messenger-basic-information.png)

---

## Getting Started

Quickly install and initialize the AI Agent SDK by following the steps below.

### Step 1. Create a new project

1. Open Xcode.
2. Choose **File > New > Projec**.
3. Select **iOS** as the platform and **App** as the template.

![ai-agent-swiftui-tutorial-create-project](https://github.com/user-attachments/assets/d864fcf1-ddf2-4f42-9913-447ff8ab874f)

![aiagent-ios-project-options](https://github.com/user-attachments/assets/13f7b8c9-396b-4cc1-ba49-0339db2ddfc9)

### Step 2. Install AI Agent SDK

1. In **Xcode**, select **File > Add Package Dependencies**.
2. Add **SendbirdAIAgentMessenger** into your package repository using the following URL:

   ```
   https://github.com/sendbird/delight-ai-agent-messenger-ios.git
   ```

3. Set the **Dependency Rule** to **Branch** and use the provided branch name.

### Step 3. Initialize AI Agent SDK

Initialize the SDK by providing the **appId** (generated via Dashboard) and configuration parameters:

```swift
// Import the SDK
import SendbirdAIAgentMessenger

// Initialize the SDK
AIAgentMessenger.initialize(
    appId: TestConfig.appId,
    paramsBuilder: { params in
        // Set optional parameters if needed
    }
) { result in
    switch result {
    case .success:
        // SDK initialized successfully
        completion(true, nil)
    case .failure(let error):
        // Handle initialization error
        completion(false, error)
    }
}
```

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

```swift
AIAgentMessenger.updateSessionInfo(
    with: .manual(
        userId: userId,
        sessionToken: sessionToken,
        sessionDelegate: self
    )
)
```

> **Important:** When using Manual Session, you **must** implement a `SessionDelegate` to handle session expiration and token refresh. See the [Handle session expiration](#handle-session-expiration) section below for implementation details.

**2. Anonymous Session (AnonymousSessionInfo) - For Temporary Users**

Use Anonymous Session when you want to:
- Provide instant access without requiring user registration
- Offer guest or trial experiences
- Support users who prefer not to create accounts

The server automatically creates a temporary user identity - no authentication required.

```swift
AIAgentMessenger.updateSessionInfo(with: .anonymous())
```

> **Important Note for Anonymous Sessions:**
> - Anonymous users are temporary and generated by the server
> - Conversation history may **not persist** across different app sessions
> - Users cannot see their previous conversations if cached session information is removed (e.g., app reinstall) or the session expires
> - Session expiration handling is **not required** (no SessionDelegate needed)

#### When to set the session information

The timing of session setup depends on your app's authentication flow:

**1. Upon initial login (Manual Session):**
When a user logs in for the first time or after logging out, set the session immediately after successful authentication.

```swift
func onLoginSuccess(userId: String, sessionToken: String) {
    // Save credentials using your app's secure storage system
    // Note: UserDefaults is shown here for simplicity, but in production,
    // use Keychain or other secure storage for sensitive data
    UserDefaults.standard.set(userId, forKey: "userId")
    UserDefaults.standard.set(sessionToken, forKey: "sessionToken")

    // Update AI Agent Messenger session
    AIAgentMessenger.updateSessionInfo(
        with: .manual(
            userId: userId,
            sessionToken: sessionToken,
            sessionDelegate: self
        )
    )
}
```

**2. For already logged-in users (Manual Session):**
If the user is already logged in (credentials stored), register the session immediately after SDK initialization.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AIAgentMessenger.initialize(appId: appId) { result in
            switch result {
            case .success:
                // Check if user credentials exist in your app's secure storage
                // Note: Replace UserDefaults with your app's credential management system
                if let userId = UserDefaults.standard.string(forKey: "userId"),
                   let sessionToken = UserDefaults.standard.string(forKey: "sessionToken") {
                    // User is already logged in - use Manual Session
                    AIAgentMessenger.updateSessionInfo(
                        with: .manual(
                            userId: userId,
                            sessionToken: sessionToken,
                            sessionDelegate: SessionManager.shared
                        )
                    )
                }
            case .failure(let error):
                print("Initialization failed: \(error)")
            }
        }

        return true
    }
}
```

**3. For guest users (Anonymous Session):**
Set up anonymous session immediately after SDK initialization or when starting a guest experience.

```swift
// No authentication required - set up immediately
AIAgentMessenger.initialize(appId: appId) { result in
    switch result {
    case .success:
        AIAgentMessenger.updateSessionInfo(with: .anonymous())
    case .failure(let error):
        print("Initialization failed: \(error)")
    }
}
```

### Handle session expiration

**This section is only required when using Manual Session (ManualSessionInfo).**

When using `ManualSessionInfo`, session tokens can expire over time due to security policies. The SDK uses a `SessionDelegate` to notify your app when the session needs attention, allowing you to refresh tokens or redirect users to login.

> **Note:** Session expiration handling is **only applicable** when using `ManualSessionInfo`. `AnonymousSessionInfo` does not require session token management or a session delegate.

#### Understanding SessionDelegate callbacks

The `SessionDelegate` provides three important callbacks:

**1. `sessionWasClosed()`**
- The session has been completely closed.
- Client apps should guide the user to a login page to log in again.

**Action:** Redirect the user to the login screen to re-authenticate.

**2. `sessionTokenDidRequire(successCompletion:failCompletion:)`**
- Called when the SDK requires a new session token to refresh the session.
- Refresh the session token from your authentication server and pass it to the SDK through `successCompletion(newToken)`.
- When `successCompletion` is called with the new token, the SDK internally calls `updateSessionInfo`, which automatically updates the session token - you don't need to call `updateSessionInfo` manually.
- If you do not want to refresh the session, pass a `nil` value through `successCompletion(nil)`.
- If any error occurred while refreshing the token, let the SDK know about it through `failCompletion()`.

**Action:** Request a new token from your authentication server and provide it to the SDK.

**3. `sessionDidHaveError(_ error: SBError)`** (Optional)
- Called when a session error occurs.

**Action:** Handle session-related errors appropriately.

#### Implementation example

Here's how to implement a SessionDelegate:

```swift
import SendbirdChatSDK

class SessionManager: SessionDelegate {
    static let shared = SessionManager()

    func sessionWasClosed() {
        // The session has been completely closed
        // Redirect user to login screen
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .userSessionClosed, object: nil)
        }
    }

    func sessionTokenDidRequire(
        successCompletion success: @escaping (String?) -> Void,
        failCompletion fail: @escaping () -> Void
    ) {
        // Request a new token from your authentication server
        AuthService.refreshToken { result in
            switch result {
            case .success(let newToken):
                // Provide new token - SDK automatically updates the session
                success(newToken)

            case .failure:
                // Token refresh failed - user needs to re-authenticate
                fail()

                // Redirect to login screen
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userSessionExpired, object: nil)
                }
            }
        }
    }

    func sessionDidHaveError(_ error: SBError) {
        // Handle session errors
        print("Session error: \(error.localizedDescription)")
    }
}
```

#### Setting up the SessionDelegate

Pass your SessionDelegate when creating the ManualSessionInfo:

```swift
AIAgentMessenger.updateSessionInfo(
    with: .manual(
        userId: userId,
        sessionToken: sessionToken,
        sessionDelegate: SessionManager.shared
    )
)
```

### Launch the messenger

Once the authentication information has been successfully registered, you can launch the messenger to start a conversation with the ai agent.

There are two ways to display the chat view:

1. Using the launcher button
2. Opening the conversation channel in presentation mode

#### 1. Using the launcher button

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-launcher2.png" />

Display a floating launcher button:

```swift
AIAgentMessenger.attachLauncher(
    aiAgentId: {AIAgentId}
)
```

To hide the launcher:

```swift
AIAgentMessenger.detachLauncher(aiAgentId: {AIAgentId})
```

#### 2. Opening the conversation channel in presentation mode

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies2.png" />

Present the chat view as a modal:

```swift
AIAgentMessenger.presentConversation(
    aiAgentId: {AIAgentId}
)
```

---

## Push Notifications

### Register for push notifications

[Push notifications](https://sendbird.com/docs/chat/sdk/v4/ios/push-notifications/overview-push-notifications) are a type of notification sent to your user's device when a client app is running in the background. Push notifications for the client app will contain a payload created by Delight AI and be delivered through APNs. Delight AI server will communicate with APNs whenever needed and APNs will send a push notification to the client app on iOS devices. In order to use this feature, you need to register the user's device token to Delight AI server through the AppDelegate.

> Note : APNs should be set up in advance in order to send push notifications.

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    AIAgentMessenger.registerPush(deviceToken: deviceToken) { (success) in

    }
}
```

### Unregister for push notifications

You should unregister a user's device token from Delight AI server if you don’t want to send [push notifications](https://sendbird.com/docs/chat/sdk/v4/ios/push-notifications/overview-push-notifications) to the user.

```swift
// If you want to unregister the current device only, call this method.
AIAgentMessenger.unregisterPushToken { (success) in

}

// If you want to unregister all devices of the user, call this method.
AIAgentMessenger.unregisterAllPushToken { (success) in

}
```

---

## Advanced features

The following are available advanced features.

### Customize launcher mode

You can modify the floating launcher button’s behavior and appearance as shown below.

```swift
let options = SBALauncherOptions(
    parentView: nil, // Attaches to the window if nil
    entryPoint: .conversation,
    layout: .init(
        position: .trailingBottom,
        margin: .default,
        useSafeArea: true
    ),
    displayStyle: .overlay(.init(spacing: 12))
)

AIAgentMessenger.attachLauncher(
    aiAgentId: TestConfig.aiAgentId
) { params in
    params.options = options
}
```

### Entry Point Advanced Configuration Guide

This guide covers advanced entry point configuration options for the Delight AI agent iOS SDK.

#### Entry Point Types

The SDK supports two entry point types:

```swift
public enum SBAEntryPoint {
    case conversation      // Direct to chat conversation (default)
    case conversationList  // Show conversation list first
}
```

- **`.conversation`**: Opens directly to the chat conversation interface
- **`.conversationList`**: Shows a list of existing conversations first

#### Launcher-based Entry Point Configuration

##### Basic Setup

Configure entry point through launcher options:

```swift
AIAgentMessenger.attachLauncher(
    aiAgentId: {AIAgentId}"
) { params in
    params.options = SBALauncherOptions(
        entryPoint: .conversationList, // or .conversation (default)
        layout: .default,
        displayStyle: .overlay()
    )
}
```

#### Direct ViewController Presentation

##### Present Conversation

Use `presentConversation()` when you want to show the chat interface directly:

```swift
AIAgentMessenger.presentConversation(
    aiAgentId: {AIAgentId}
) { params in
    params.parent = self
    params.presentationStyle = .fullScreen
}
```

##### Present Conversation List

Use `presentConversationList()` to show the conversation list:

```swift
AIAgentMessenger.presentConversationList(
    aiAgentId: {AIAgentId}
) { params in
    params.parent = self
    params.presentationStyle = .fullScreen
}
```

### Update SDK Theme

You can customize the SDK’s color scheme to match your app's theme as shown below.

```swift
AIAgentMessenger.update(colorScheme: .light) // Options: .dark, .light
```

Since apps may allow users to switch themes manually or follow device settings, theme updates need to be explicitly called.

### Deauthenticate and clear session

When a user logs out, de-authenticate the SDK to clear session data and disconnect.

```swift
AIAgentMessenger.deauthenticate { [weak self] in
    // Perform post-deauthentication actions
}
```

### Passing context object to Agent

You can predefine customer-specific information, such as country, language, or other custom context data, to guide the AI Agent in providing faster and more accurate responses.

This allows for a more personalized and context-aware interaction experience.

> Once the contexts are set, they will be used throughout the conversation to provide personalized and context-aware responses.

```swift
// Case: Attach launcher
AIAgentMessenger.attachLauncher(
    aiAgentId: {AIAgentId}
) { params in
    params.language = "en" // (opt)default: Locale.preferredLanguages.first
    params.countryCode = "US" // (opt)default: Locale.current.regionCode
    params.context = ["key": "value"] // (opt)
}
```

```swift
// Case:
AIAgentMessenger.presentConversation(
    aiAgentId: {AIAgentId}
) { params in
    params.language = "en" // (opt)default: Locale.preferredLanguages.first
    params.countryCode = "US" // (opt)default: Locale.current.regionCode
    params.context = ["key": "value"] // (opt)
}
```

> - `language` value should follow the **IETF BCP 47** format.
>   - For example, it might be "ko-KR" for Korean in South Korea or "en-US" for English in the United States.
>   - See also: [List of common primary language subtags](https://en.wikipedia.org/wiki/IETF_language_tag#List_of_common_primary_language_subtags)
> - `countryCode` value should follow the **ISO 3166** format.
>   - For example, it might be "KR" for South Korea or "US" for the United States.

### Custom Localization (Multi-language Support)

AIAgent supports adding and customizing multi languages. For more information, see [this detail page](MULTILANGUAGE.md).

[def]: #prerequisites
