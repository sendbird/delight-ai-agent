# AIAgentStarterKit

A simplified starter kit for integrating **Delight AI Agent SDK** into your iOS application. This starter kit provides an easy-to-use wrapper around the Delight AI Agent SDK, handling initialization, session management, connection, and UI presentation with minimal configuration.

## Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [File Structure](#-file-structure)
- [Core Functionality](#-core-functionality)
- [Optional Features](#-optional-features)
- [Extended SDK Integration](#-extended-sdk-integration)
- [Configuration](#-configuration)

---

## Features

### Core Features
- **Easy SDK Initialization**: Simple one-line initialization with minimal configuration
- **Session Management**: Support for both manual and anonymous authentication modes
- **Automatic Token Refresh**: Built-in session delegate for seamless token management
- **Connection Management**: Reliable connect/disconnect handling
- **UI Presentation**: Full-screen conversation view and floating launcher button

### Optional Features
- **Theme Management**: Light and dark mode support
- **Context Objects**: Pass custom metadata (language, country, custom data) to AI conversations
- **Push Notifications**: Complete push notification handling, deep linking, and validation
- **Customization**: Advanced customization builders for global, module, and context-level theming

### Extended SDK Support
- **SendbirdUIKit Integration**: Optional UIKit SDK co-existence
- **SendBirdDesk Integration**: Optional Desk SDK co-existence
- **Lifecycle Orchestration**: Automatic initialization order management

---

## Quick Start

### 1. Configure Settings

Update `SampleConfiguration.swift` with your credentials:

```swift
struct SampleConfiguration {
    static var appId = "YOUR_APP_ID"
    static var aiAgentId = "YOUR_AI_AGENT_ID"
    static var sessionInfoType: SessionInfoType = .manual  // or .anonymous

    // For manual session mode:
    static var userId = "your_user_id"
    static var sessionToken = "your_session_token"
}
```

### 2. Initialize → Session → Connect → Present

```swift
import UIKit
import SendbirdChatSDK

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Step 1: Initialize
        SendbirdLogger.setLevel(SampleConfiguration.logLevel)

        AIAgentStarterKit.initialize(
            applicationId: SampleConfiguration.appId
        ) { error in
            guard error == nil else { return }

            // Step 2: Set Session
            AIAgentStarterKit.updateSessionInfo(
                userId: SampleConfiguration.userId,
                sessionToken: SampleConfiguration.sessionToken,
                sessionHandler: AIAgentStarterKit.shared
            )

            // Step 3: Connect
            AIAgentStarterKit.connect { error in
                guard error == nil else { return }
                print("Ready to use!")
            }
        }

        return true
    }
}

class ViewController: UIViewController {
    @IBAction func showChatTapped(_ sender: Any) {
        // Step 4: Present
        AIAgentStarterKit.present(parent: self)
    }
}
```

---

## File Structure

```
AIAgentStarterKit/
│
├── Core/                                    [Required - 4 files]
│   ├── AIAgentStarterKit.swift                # Main: Initialize → Session → Connect → Present
│   ├── AIAgentStarterKit+Configuration.swift  # Settings: Singleton, Status, Callbacks
│   ├── AIAgentStarterKit+SessionDelegate.swift # Session delegate implementation
│   └── AIAgentStarterKit+Concurrency.swift    # Async/await wrappers
│
├── Features/                                [Optional - 3 files]
│   ├── AIAgentStarterKit+Theme.swift          # Light/dark mode toggle
│   ├── AIAgentStarterKit+ContextObjects.swift # Language, country, metadata
│   └── AIAgentStarterKit+Push.swift           # Push notifications & deep linking
│
├── Customization/                           [Advanced - 1 file]
│   └── AIAgentStarterKit+Customize.swift      # Global/module/context builders
│
├── ExtendedSDK/                             [Conditional - 5 files]
│   ├── ExtendedSDKBridge.swift                # Base bridge abstraction
│   ├── ExtendedSDKBridge+Common.swift         # Lifecycle orchestration
│   ├── ExtendedSDKBridge+UIKit.swift          # SendbirdUIKit integration
│   ├── ExtendedSDKBridge+DeskSDK.swift        # SendBirdDesk integration
│   └── AsyncHelpers.swift                     # Async utilities
│
├── Development/                             [Dev Only - 1 file]
│   └── MockServer.swift                       # Token refresh simulation
│
├── SampleConfiguration.swift                   # Central configuration
└── README.md                                   # This file
```

### Quick Navigation Guide

| Need to... | Go to... |
|------------|----------|
| **Understand core flow** | `Core/AIAgentStarterKit.swift` |
| **Configure app settings** | `SampleConfiguration.swift` |
| **Add theme toggle** | `Features/AIAgentStarterKit+Theme.swift` |
| **Handle push notifications** | `Features/AIAgentStarterKit+Push.swift` |
| **Pass custom metadata** | `Features/AIAgentStarterKit+ContextObjects.swift` |
| **Customize UI deeply** | `Customization/AIAgentStarterKit+Customize.swift` |
| **Integrate UIKit/Desk** | `ExtendedSDK/` folder |

---

## Core Functionality

### Core/AIAgentStarterKit.swift

**The main file containing the essential 4-step flow:**

#### 1. Initialize
```swift
SendbirdLogger.setLevel(.error)  // .none, .error, .warning, .info, .debug, .verbose

AIAgentStarterKit.initialize(
    applicationId: "YOUR_APP_ID"
) { error in
    if let error = error {
        print("Initialization failed: \(error)")
    }
}
```

#### 2. Session Management
```swift
// Manual session (with user ID and token)
AIAgentStarterKit.updateSessionInfo(
    userId: "user123",
    sessionToken: "token_from_your_backend",
    sessionHandler: AIAgentStarterKit.shared
)

// Or anonymous session (auto-generated)
AIAgentStarterKit.updateAnonymousSessionInfo()
```

#### 3. Connection
```swift
AIAgentStarterKit.connect { error in
    if error == nil {
        print("Connected successfully!")
    }
}

// Disconnect when needed
AIAgentStarterKit.disconnect { error in
    print("Disconnected")
}
```

#### 4. Presentation
```swift
// Full-screen conversation
AIAgentStarterKit.present(parent: viewController)

// Or attach floating launcher button
AIAgentStarterKit.attachLauncher(view: nil)  // nil = attach to window

// Detach launcher when done
AIAgentStarterKit.detachLauncher()
```

### Core/AIAgentStarterKit+Configuration.swift

**Manages SDK state and configuration:**

- **Singleton**: `AIAgentStarterKit.shared`
- **SessionData**: Stores `appId`, `userId`, `sessionToken`, `sessionHandler`
- **Status Enum**: `.uninitialized` → `.initialized` → `.readyToUse`
- **Callbacks**: `onReadyToUse` closure
- **Launcher Options**: `defaultLauncherOptions` for customization

```swift
// Example: Wait for ready state
AIAgentStarterKit.shared.onReadyToUse = {
    print("SDK is ready!")
    AIAgentStarterKit.present(parent: viewController)
}
```

### Core/AIAgentStarterKit+SessionDelegate.swift

**Handles session events and token refresh:**

Implements `SessionDelegate` protocol:
- `sessionTokenDidRequire()` - Refreshes expired tokens
- `sessionWasClosed()` - Called when session closes
- `sessionWasRefreshed()` - Called after successful refresh
- `sessionDidHaveError()` - Handles session errors

**Important**: The built-in implementation uses `MockServer` for demonstration. Replace with your actual backend API in production.

### Core/AIAgentStarterKit+Concurrency.swift

**Provides async/await wrappers for modern Swift:**

```swift
// Async/await versions of core methods
Task {
    do {
        try await AIAgentStarterKit.initialize(applicationId: appId)
        try await AIAgentStarterKit.connect()
        print("Ready!")
    } catch {
        print("Error: \(error)")
    }
}
```

---

## Optional Features

### Features/AIAgentStarterKit+Theme.swift

**Theme management for light/dark mode:**

```swift
// Toggle theme
let newScheme = AIAgentStarterKit.toggleColorScheme()

// Apply specific theme
AIAgentStarterKit.applyColorScheme(.dark)

// Get current theme
let current = AIAgentStarterKit.getCurrentColorScheme()  // .light or .dark
```

### Features/AIAgentStarterKit+ContextObjects.swift

**Pass custom metadata to AI conversations:**

```swift
// Set context objects
AIAgentStarterKit.updateContextObjects(
    language: "ko",           // Language code (IETF BCP 47)
    countryCode: "KR",        // Country code (ISO 3166)
    context: [
        "userTier": "premium",
        "region": "asia",
        "customKey": "customValue"
    ]
)

// Clear all context
AIAgentStarterKit.clearContextObjects()
```

**Use cases:**
- Personalized AI responses based on user language
- Region-specific content
- User tier for premium features
- Custom business logic data

### Features/AIAgentStarterKit+Push.swift

**Complete push notification support:**

#### Register Push Token
```swift
// In AppDelegate
func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
    AIAgentStarterKit.registerPush(deviceToken: deviceToken)
}
```

#### Handle Push Notification
```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo = response.notification.request.content.userInfo

    // Validate Sendbird push
    guard AIAgentStarterKit.isValidSendbirdPush(userInfo: userInfo) else {
        completionHandler()
        return
    }

    // Mark as clicked
    AIAgentStarterKit.markPushNotificationAsClicked(userInfo: userInfo)

    // Present conversation from notification
    AIAgentStarterKit.presentFromNotification(
        userInfo: userInfo,
        topViewController: nil  // Auto-detect top VC
    )

    completionHandler()
}
```

#### Unregister Push
```swift
// When user logs out
AIAgentStarterKit.unregisterPush()
```

---

## Advanced Customization

### Customization/AIAgentStarterKit+Customize.swift

**Deep customization with builders:**

```swift
// Apply custom configurations
AIAgentStarterKit.applyCustomizations()

// Available builders:
// - globalConfigCustomizationBuilder: Global theming across entire SDK
// - moduleSetCustomizationBuilder: Module-level customization (header, list, input, etc.)
// - contextObjectsBuilder: Context-specific customization
```

**When to use:**
- Custom color schemes beyond light/dark
- Module-specific UI changes
- Advanced theming requirements

---

## Extended SDK Integration

### When to Use

Only needed if you're using:
- **SendbirdUIKit**: For UIKit chat components
- **SendBirdDesk**: For customer support ticketing

### How It Works

The `ExtendedSDK/` folder manages initialization order:

```
Initialization Order:
1. SendbirdUIKit  (if available)
2. SendBirdDesk   (if available)
3. AI Agent SDK   (always)
```

### ExtendedSDK/ExtendedSDKBridge.swift

Base abstraction and protocol definitions for extended SDK integration.

### ExtendedSDK/ExtendedSDKBridge+Common.swift

**Orchestrates lifecycle for all extended SDKs:**

```swift
// Automatically called from AIAgentStarterKit.initialize()
try await ExtendedSDKBridge.initializeIfNeeded(...)

// Automatically called from AIAgentStarterKit.updateSessionInfo()
try await ExtendedSDKBridge.updateSessionInfoIfNeeded()

// Automatically called from AIAgentStarterKit.connect()
try await ExtendedSDKBridge.connectIfNeeded()

// Automatically called from AIAgentStarterKit.disconnect()
try await ExtendedSDKBridge.disconnectIfNeeded()
```

### ExtendedSDK/ExtendedSDKBridge+UIKit.swift

SendbirdUIKit integration (conditional compilation).

### ExtendedSDK/ExtendedSDKBridge+DeskSDK.swift

SendBirdDesk integration (conditional compilation).

### ExtendedSDK/AsyncHelpers.swift

Utility functions to convert callback-based APIs to async/await.

---

## Development Tools

### Development/MockServer.swift

**Development Only - Remove for Production**

Simulates backend API for token refresh during development:

```swift
MockServer.refreshSessionToken(for: userId) { result in
    switch result {
    case .success(let token):
        print("New token: \(token)")
    case .failure(let error):
        print("Failed: \(error)")
    }
}
```

**Production Replacement:**
Replace `MockServer` calls in `Core/AIAgentStarterKit+SessionDelegate.swift` with your actual backend API.

---

## Configuration

### SampleConfiguration.swift

**Central configuration file:**

```swift
struct SampleConfiguration {
    // MARK: - Application Configuration
    static var appId = "YOUR_APP_ID"          // From Sendbird Dashboard
    static var aiAgentId = "YOUR_AI_AGENT_ID" // From Sendbird Dashboard

    // MARK: - Session Configuration
    static var sessionInfoType: SessionInfoType = .manual  // or .anonymous
    static var userId = "client_user"
    static var sessionToken = "your_session_token"

    // MARK: - Logging
    static var logLevel: SendbirdLogger.Level = .error

    // MARK: - Server (Optional)
    static var productionServer: String? = nil  // Uses default if nil

    // MARK: - Extended SDK Detection (Automatic)
    static var extendedSDKs: [ExtendedSDKType] {
        // Auto-detects SendbirdUIKit and SendBirdDesk
    }

    static var hasUIKit: Bool { ... }    // True if UIKit linked
    static var hasDeskSDK: Bool { ... }  // True if DeskSDK linked
}
```

### Launcher Customization

```swift
AIAgentStarterKit.defaultLauncherOptions = SBALauncherOptions(
    parentView: nil,  // nil = attach to window
    entryPoint: .conversation,  // or .conversationList
    layout: .init(
        position: .trailingBottom,  // .leadingTop, .trailingTop, .leadingBottom, .trailingBottom
        margin: .init(all: 16),     // Margin from edges
        useSafeArea: true           // Respect safe area
    ),
    displayStyle: .overlay()  // or .fullscreen()
)
```
