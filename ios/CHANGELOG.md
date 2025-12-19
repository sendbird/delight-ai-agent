# Changelog

## v1.4.3 (Dec 19, 2025) with Chat SDK v4.35.0

### Changes
- Updated dependency SDK versions to the latest stable releases
- SendbirdChatSDK: v4.35.0
- SendbirdMessageTemplate: v3.33.0

### New Features
- **User Input Blocking System**: Implemented server-driven user input disabling
## v1.4.2 (Dec 03, 2025) with Chat SDK v4.34.1

### Improvements
  - Streaming Animation Performance Optimization
  - Prevented Streaming State Synchronization
  - **Renamed conversation action button label texts**
    - Standardized action button text to "Start a conversation" across conversation list footer and closed conversation view

## v1.4.1 (Nov 19, 2025) with Chat SDK v4.34.1

### Bugfixes
  - Fixed issue where the action sheet text color was not visible
  - Fix thread timing issue in detachLauncher
## v1.4.0 (Nov 18, 2025) with Chat SDK v4.34.0

### Improvements
  - Implemented file attachment rules system to support server-side control of uploadable file types
  - Improved the performance and structure of the starter kit
  - Changed SBALogType to hierarchical levels and simplified log level mapping across the SDK
## v1.3.1 (Nov 14, 2025) with ChatSDK v4.34.0

### Improvements
- Updated dependency SDK versions to latest stable releases
  - SendbirdChatSDK: v4.34.0

## v1.3.0 (Nov 05, 2025) with ChatSDK v4.33.0

### Features
- **Conversation Closure API**
  - Added public `closeConversation()` method in `SBAConversationViewModel` for programmatic conversation closure
- **Message Feedback (:+1: / :-1: + Comments)**
  - Added user feedback capability for AI-generated messages with good/bad rating and optional comments (up to 100 characters)
  - Supports editing and deleting feedback in active conversations
  - Read-only feedback display for closed conversations
  - Includes 11 language localizations and RTL support

### Improvements
  - **Support Resolution feedback as optional**
    - Support for optional CRE (Customer Resolution Evaluation) in CSAT submissions
    - Users can now submit with only score selection when CRE is configured as optional  

### Bug Fixes
- Fixed intermittent issue where theme updates would fail to apply
- Fixed an issue where the input view becomes active during Agent response

## v1.2.0 (Oct 30, 2025) with ChatSDK v4.32.0

### Features
- **Failed Message Localization**
  - Added public `SBALocalization.Conversation.List.FailedMessage` class with `retry` and `delete` properties for custom localization support

### Changes
- Updated dependency SDK versions to latest stable releases
  - SendbirdChatSDK: v4.32.0
  - SendbirdUIMessageTemplate: v3.32.3

## v1.1.1 (Oct 24, 2025) with ChatSDK v4.31.1

### Changed

- Updated dependency SDK versions to latest stable releases
  - SendbirdChatSDK: v4.31.1
  - SendbirdPackages: v0.10.8 

### Bugfix

- Fix AIAgent.GroupChannelListQuery to exclude non-filtered regular channels.

## v1.1.0 (Oct 02, 2025) with ChatSDK v4.30.0

### Interfaces
- Enhanced `SBAMessageCSATData`: Added new public properties for custom CSAT configuration
  - title, csatQuestion, csatSubmitLabel, csatSubmittedLabel
  - csatScores: [ScoreData], cre: CREData?, followUp: [FollowUpData]?

### Features
- Custom CSAT support: Dashboard-driven CSAT UI customization with follow-up questions

## v1.0.0 (Sep 25, 2025) with ChatSDK v4.30.0

## **Delight AI Agent iOS SDK - GA Release Changelog**

### Highlights

- **AI Agent Chat**: Engage in natural, context-aware conversations with an AI agent, including real-time messaging and conversation list functionality.
- **Messenger Launcher Widget**: Easily add a floating launcher button to your app's interface for quick access to AI chat.
- **Full-Screen Messenger**: Launch full-screen chat conversations with the AI agent through dedicated screens.
- **Rich Message Templates**: Support for various interactive message formats through structured templates including buttons, cards, lists, and more.
- **Easy Integration**: Initialize and launch the AI agent messenger with just a few lines of code.
- **Markdown & Code Syntax Highlighting**: Comprehensive markdown text rendering with syntax highlighting for code blocks.
- **Multi-language Support**: Built-in support for 11 languages with the ability to extend to additional languages through custom localization.
- **Complete Theme System**: Provides a foundational theme system including light/dark mode, with ongoing expansion to add richer customization options.
- **Modular Architecture**: Flexible module system allowing complete customization of UI components.

---

### Requirements
The minimum requirements for AI Agent for iOS are:

- iOS 14.0 or higher
- Swift 5.10 or higher
- Xcode 16.3 or higher
- SendbirdChatSDK 4.30.0 or higher
- SendbirdUIMessageTemplate 3.32.2 or higher

### Installation
The SDK can be installed through various package managers.

**Swift Package Manager (SPM)**
```swift
dependencies: [
    .package(url: "https://github.com/sendbird/delight-ai-agent-messenger-ios.git", from: "1.0.0")
]
```

**CocoaPods**
```ruby
source 'https://github.com/sendbird/sendbird-ios-distribution.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'

target 'YourApp' do
  use_frameworks!

  pod 'SendbirdAIAgentMessenger', '~> 1.0.0'
end

# Required for XCFramework download scripts
post_install do |installer|
  project = installer.aggregate_targets[0].user_project
  project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
  end
  project.save
end
```

---

### Features

**Delight AI Agent Messenger SDK has been officially released!**
This SDK enables you to seamlessly integrate an enterprise-grade AI-powered chat agent into your iOS applications.

#### 1. Messenger Launcher Widget
The SDK provides MessengerLauncher functionality that can be easily attached to your application's root view programmatically.

To add the MessengerLauncher to your screen, simply call the `attachLauncher()` function specifying the AI agent ID:

```swift
AIAgentMessenger.attachLauncher(aiAgentId: "your_ai_agent_id")
```

- Configure the Launcher's behavior and appearance through `SBALauncherOptions`:
  - **`entryPoint`**: Specify which screen to open from the launcher
    - `conversation`: Navigate directly to conversation screen (default)
    - `conversationList`: Navigate to conversation list screen

  - **`layout.position`**: Determine which corner of the screen the launcher appears in
    - `leadingTop`: Top left
    - `trailingTop`: Top right
    - `leadingBottom`: Bottom left
    - `trailingBottom`: Bottom right (default)

  - **`layout.margin`**: Set margins around the launcher button
  - **`layout.useSafeArea`**: Configure safe area usage

  - **`displayStyle`**: Set messenger display mode
    - `fullscreen`: Display in full-screen mode
    - `overlay`: Display as overlay (default)

  - **`context`**: Key-value dictionary for passing conversation context information

> Attach the launcher to your activity or view to create a floating entry point for AI chat.

---

#### 2. Full-Screen Messenger
You can open full-screen conversations.

```swift
// Present conversation screen
AIAgentMessenger.presentConversation(aiAgentId: "your_ai_agent_id")

// Or present conversation list screen
AIAgentMessenger.presentConversationList(aiAgentId: "your_ai_agent_id")
```

---

#### 3. Rich Message Templates
Support for various interactive elements through structured message templates including buttons, cards, lists, and more.

---

#### 4. Easy Integration
Initialize and launch the AI agent messenger with just a few lines of code.

```swift
// Create new conversation
AIAgentMessenger.createConversation(aiAgentId: "your_ai_agent_id") { result in
    switch result {
    case .success(let channelURL):
        // Conversation creation successful
    case .failure(let error):
        // Conversation creation failed
    }
}
```

---

#### 5. Markdown & Code Syntax Highlighting
Provides advanced text rendering capabilities including markdown text rendering and code block syntax highlighting.

---

#### 6. Multi-language Support
Supports global application development through a multi-language support system.

- **Built-in 11 Language Support**: Korean, English, Japanese, German, Spanish, Italian, French, Dutch, Portuguese, Turkish, Hindi
- **Extensible Localization**: Custom localization system for additional language support
- **Dynamic Language Switching**: Real-time language changes within the app
- **Language-specific Optimization**: Automatic font and layout adjustments for each language
- **Developer-friendly**: Easy extension following standard iOS localization patterns

---

#### 7. Complete Theme System
Provides a foundational theme system including light/dark mode. Future updates will add richer customization options.

```swift
// Update color scheme
AIAgentMessenger.update(colorScheme: .dark)

// Font customization
SBAFontSet.fontFamily = "YourCustomFont"
```

- **Basic Theme Support**: Automatic light/dark mode switching
- **Font Customization**: Custom font family support through SBAFontSet
- **Ongoing Expansion**: Gradual addition of brand-specific color and style options

---

#### 8. Modular Architecture
Flexible module system allows complete customization of UI components.

- **MVVM Pattern**: Clean separation of concerns
- **Event-driven Communication**: Delegate, DataSource, HandleEvent patterns
- **Module Replacement**: Easy UI customization through simple module replacement
- **@LayoutSlot Pattern**: Declarative UI composition

---

#### 9. Session Management and Authentication
The SDK supports flexible user authentication through two session types.

**Authenticated Users (Manual Session)**
```swift
// Create session info for authenticated users
let sessionInfo = AIAgentMessenger.SessionInfo.manual(
    userId: "user123",
    sessionToken: "your_session_token",
    sessionDelegate: self // Implement SessionDelegate protocol
)

// Update session information
AIAgentMessenger.updateSessionInfo(with: sessionInfo)

// Authenticate with AI agent
AIAgentMessenger.authenticate(aiAgentId: "your_ai_agent_id") { result in
    switch result {
    case .success(let activeChannelURL):
        // Authentication successful
    case .failure(let error):
        // Authentication failed
    }
}
```

**Anonymous Users (Anonymous Session)**
```swift
// Create session info for anonymous users (app attribute settings required)
let anonymousSessionInfo = AIAgentMessenger.SessionInfo.anonymous()

// Update session information
AIAgentMessenger.updateSessionInfo(with: anonymousSessionInfo)

// Authenticate with AI agent (same method)
AIAgentMessenger.authenticate(aiAgentId: "your_ai_agent_id") { result in
    // Handle authentication
}
```

> **Note**: To use Anonymous Session, app attribute settings must be enabled in the Sendbird dashboard.

---

### Architecture

#### Modular Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Event-driven Communication**: Delegate, DataSource, HandleEvent patterns
- **Module System**: Flexible customization through `SBAModuleSet`
- **@LayoutSlot Pattern**: Declarative UI composition

#### Key Components
- **AIAgentMessenger**: Main public API
- **SBAModuleSet**: Customizable module system
- **SBATheme**: Comprehensive theme management

---

### Known Issues

- Limited support for some SwiftUI features on iOS 14.0

---

### Support

- **Sample Apps**: [iOS AIAgent basic sample](https://github.com/sendbird/delight-ai-agent/tree/main/ios/sample)
- **Technical Support**: [Sendbird Support](https://sendbird.com/support)

---

*This release is the first GA (Generally Available) version of the Delight AI Agent iOS SDK. It is safe for use in production environments.*

## v0.10.9 (Sep 03, 2025) with ChatSDK v4.29.2

### Public API Changes
- **`SBAViewModelSet.ConversationViewModel` is now public** - Allows external customization of conversation view models
- **`SBAConversationViewModel` class and its delegate methods are now public** - Enables subclassing and custom implementations
- **`SBAConversationViewController.viewModel` and `channel` properties are now public** - Provides public access to conversation state

### Features
- **Added `reset()` functionality to conversation components** - Enables starting new conversations without navigation controller

### Improvements  
- **Enhanced conversation initialization** - Refactored `SBAConversationViewModel` to use builder pattern for initialization parameters
- **Improved "Start New Conversation" flow** - Fixed behavior when using ViewControllerSet without navigation controller

### Bug Fixes
- **Fixed conversation reset when starting new conversation** - Properly resets header, list, and input components
- **Fixed navigation handling for non-navigation controller scenarios** - Gracefully handles cases without `AIAgentNavigationController`

## v0.10.8 (Sep 01, 2025) with ChatSDK v4.29.2

### Improvements

- Added `InitParamsBuilder` for `SBAConversationViewController`

```swift
SBAViewControllerSet.ConversationViewController.init(
  aiAgentId: "YOUR_AI_AGENT_ID",
  paramsBuilder: { params in
    params.language = "ko"
    params.countryCode = "KR"
    params.context = [:]
  }
)
```

## v0.10.7 (Aug 31, 2025) with ChatSDK v4.29.2

### Features
- **Conversation Module Customization**
  - Made `SBAConversationModule.List.Cell` public with customizable subviews:
    - `UserNameView`
    - `StateView`
    - `DateView`
  - Added public access to message cell types:
    - `AdminMessageCell`
    - `UserMessageCell`
    - `FileMessageCell`
    - `TypingIndicatorMessageCell`
    - `UnknownMessageCell`

- **Header Configuration**
  - Added `ContentAlignment` enum in `SBAConfig.Conversation.Header` for content alignment control
    - Supports `.leading`, `.center`, `.trailing` alignment options
  - Added `contentAlignment` property (default: `.leading`)

### Improvements
- Common
  - Improved memory management with proper cleanup in deinit methods
  - Enhanced null safety with optional handling

### Bug Fixes
- **View Lifecycle**
  - Fixed potential crash in `SBAFileViewController` when dismissing
  - Added safety checks for view controller state before animations
  - Fixed infinite recursion in `setupStyles()` 

- **Layout Issues**
  - Fixed constraint activation timing issues
  - Fixed markdown view layout with proper max width handling

## v0.10.6 (Aug 25, 2025) with ChatSDK v4.29.2

### Features
- **Conversation Header Customization**
  - Made `SBAConversationModule.Header.TitleView` public for custom title view implementation

### Improvements
- Improved Japanese translation quality with more natural expressions
- Date separators now respect user's system locale settings

### Bug Fixes
- Fixed theme not applying

### Performance
- Fixed infinite `setupStyles()` recursion issue
- Optimized streaming event handling to prevent duplicates
- Improved table view reload performance with debouncing

## v0.10.5 (Aug 22, 2025) with ChatSDK v4.29.2

### Changed
- Exposed public properties in SBAConversationModule.Header:
  - `menuButton`, `closeButton`, and `handoffButton`

## v0.10.4 (Aug 18, 2025) with ChatSDK v4.29.2

### Improvements
- Profile Image Hidden Options in Conversation
  - Added `SBAConfig.Conversation.Header.shouldShowProfile` 
    - Controls profile image visibility in conversation header
  - Added `SBAConfig.Conversation.List.shouldShowSenderProfile`
    - Controls sender profile image visibility in message list 

## v0.10.3 (Aug 18, 2025) with ChatSDK v4.29.2

### Improvements
- Profile Image Hidden Options in Conversation
  - Added `SBAConfig.Conversation.Header.shouldShowProfile` 
    - Controls profile image visibility in conversation header
  - Added `SBAConfig.Conversation.List.shouldShowSenderProfile`
    - Controls sender profile image visibility in message list 

## v0.10.2 (Aug 14, 2025) with ChatSDK v4.29.2


### Improvements
- Supports minimum version to iOS 14 

## v0.10.1 (Aug 12, 2025) with ChatSDK v4.29.2

### Improvements
- iOS minor version issue supports

## v0.9.15 (Aug 08, 2025)

### Improvements
- Fixed image ratio handling.

## v0.10.0 (Aug 08, 2025)

### Features
- **New Authentication Flow**: Streamlined authentication with automatic connection
  ```swift
  AIAgentMessenger.authenticate(aiAgentId: "agent123") { result in
      // Returns activeChannelURL on success
  }
  ```
  - Added `authenticate(aiAgentId:paramsBuilder:completionHandler:)` method
  - Added `AuthenticateParamsBuilder` for configuration
  - Added `AuthenticateResultHandler` returning `activeChannelURL` on success

- **Conversation Creation**: New API for creating conversations programmatically
  ```swift
  AIAgentMessenger.createConversation(aiAgentId: "agent123") { result in
      // Returns channelURL of created conversation
  }
  ```
  - Added `createConversation(aiAgentId:paramsBuilder:completionHandler:)` method
  - Added `ConversationCreateParamsBuilder`
  - Added `ChannelURLResponseHandler` for conversation creation results

- **Enhanced Builder Pattern Support**: All major APIs now support builder pattern
  - `baseInitialize(appId:paramsBuilder:completionHandler:)` with `InitializeParamsBuilder`
  - `attachLauncher(aiAgentId:channelURL:paramsBuilder:)` with `LauncherSettingsParamsBuilder`
  - `presentConversation(aiAgentId:channelURL:paramsBuilder:)` with `ConversationSettingsParamsBuilder`
  - `presentConversationList(aiAgentId:paramsBuilder:)` with `ConversationSettingsParamsBuilder`

- **Session Factory Methods**: Simplified session creation
  ```swift
  // For authenticated users
  let session = AIAgentMessenger.SessionInfo.manual(
      userId: "user123",
      sessionToken: "token",
      sessionDelegate: delegate
  )
  
  // For anonymous users
  let session = AIAgentMessenger.SessionInfo.anonymous()
  ```

- **Enhanced Template Support**: Extended message template configuration
  - Added `Cascade` template configuration in `SBAConfig.Conversation.Template.InternalVariables`
  - New cascade spacing and padding properties: `spacing`, `paddingRight`, `paddingLeft`

### Improvements
- **Color Scheme Updates**: New method for updating color scheme
  - `update(colorScheme:)` method for dynamic color scheme changes

- **Session Delegate Enhancements**: Improved session token management
  - `SessionDelegate` protocol now properly handles token updates
  - Automatic session token refresh through delegate callbacks
  - Optional methods in `SessionDelegate` with default implementations

- **Error Handling**: New error types for better error classification
  - `SBAErrorType.authenticateFailed` for authentication failures
  - `SBAErrorType.invalidAuthentication` for invalid authentication state
  - `SBAErrorType.invalidAgentInfo` for invalid agent information

- **Push Notification**: All completion handlers now execute on service queue
  - `registerPushToken(deviceToken:unique:completionHandler:)`
  - `unregisterPushToken(completionHandler:)`
  - `unregisterAllPushToken(completionHandler:)`

### Bug Fixes
- **Localization**: Fixed duplicate locale updates
  - `SBALocalization.updateLocale(_:)` now checks for duplicate updates before applying

### Performance & Stability
- **UI Performance**: Fixed infinite recursion issues
- **Memory Management**: Better resource cleanup
- **Template Configuration**: Extended template system
- **Type Safety**: Improved type definitions

### BREAKING CHANGES
- **Session Management**: Complete overhaul of session management system
  - `UserSessionInfo` class has been replaced with new `SessionInfo` hierarchy
  - `ManualSessionInfo` for authenticated users with custom user data
  - `AnonymousSessionInfo` for anonymous users (requires app attribute settings enabled)
  - `updateSessionInfo(with:)` now accepts `SessionInfo` instead of `UserSessionInfo`
  - Session info must be reset after calling `deauthenticate()` or when authentication expires

- **Initialization Parameters**: `InitializeParams` constructor removed
  - Properties are now mutable: `logLevel`, `startHandler`, `migrationHandler`, `apiHost`, `wsHost`
  - Use builder pattern instead of constructor parameters

---

**Migration Guide for v0.10.0:**

1. **Update Session Management**:
   ```swift
   // OLD (v0.9.x)
   let sessionInfo = AIAgentMessenger.UserSessionInfo(
       userId: "user123",
       sessionToken: "token",
       sessionDelegate: delegate
   )
   
   // NEW (v0.10.0)
   let sessionInfo = AIAgentMessenger.SessionInfo.manual(
       userId: "user123",
       sessionToken: "token", 
       sessionDelegate: delegate
   )
   ```

2. **Update Initialization**:
   ```swift
   // OLD (v0.9.x)
   let params = AIAgentMessenger.InitializeParams(
       logLevel: .info,
       apiHost: "custom.host"
   )
   
   // NEW (v0.10.0)
   AIAgentMessenger.baseInitialize(appId: "app123") { params in
       params.logLevel = .info
       params.apiHost = "custom.host"
   }
   ```

3. **Use New Authentication API**:
   ```swift
   // NEW in v0.10.0
   AIAgentMessenger.authenticate(aiAgentId: "agent123") { result in
       switch result {
       case .success(let activeChannelURL):
           print("Authenticated with channel: \(activeChannelURL)")
       case .failure(let error):
           print("Authentication failed: \(error)")
       }
   }
   ```

4. **Update Builder Pattern Usage**:
   ```swift
   // NEW builder pattern support
   AIAgentMessenger.attachLauncher(aiAgentId: "agent123") { params in
       params.options.position = .bottomRight
       params.parent = viewController
   }
   ```

## v0.9.14 (Aug 07, 2025)

### Improvements

- Fixed an issue where the file attachment view was not appearing.

## v0.9.14 (Aug 07, 2025)

### Improvements

- Improved functionality to handle Desk CSAT
  - Added `desk` type in `SBAMessageCSATData.DataType`

## v0.9.13 (Jul 24, 2025)

### Improvements

- Improved functionality to handle Desk CSAT
  - Added `desk` type in `SBAMessageCSATData.DataType`

## v0.9.12 (Jul 18, 2025)

### Improvements

- Improved handling of anonymous users

## v0.9.11 (Jul 14, 2025)

### Features
- Updated file upload button visibility to ensure it's visible after handed off to human agents

## v0.9.10 (Jul 01, 2025)

### Fixed
- Updated minimum required version of the dependency SDK

## v0.9.9 (Jun 30, 2025)

### Fixed
- Updated swift-tools-version to 6.1

## v0.9.8 (Jun 30, 2025)

### Fixed
- Updated swift-tools-version to 6.1

## v0.9.7 (Jun 30, 2025)

### Fixed
- Improved framework binary compatibility across different Swift versions

## v0.9.6 (Jun 27, 2025)

### BREAKING CHANGES
- **Minimum Requirements**: Xcode 16.3+ (Swift 6.1+) now required

#### What Changed
- Updated to Swift 6.1 to resolve Apple's Swift compiler compatibility issues between versions 6.0 and 6.1
- Addresses module interface incompatibility introduced in Swift 6.1

#### Why This Change?
Apple's Swift 6.1 compiler cannot load modules built with Swift 6.0, even with `BUILD_LIBRARY_FOR_DISTRIBUTION` enabled. This affects users on macOS Sequoia (which requires Xcode 16+) and those using newer Xcode versions.

#### If You See This Error:
```
Failed to build module 'SendbirdAIAgentCore'; 
this SDK is not supported by the compiler
```
**Fix**: Update to Xcode 16.3+, then clean and rebuild your project.

## v0.9.5 (Jun 25, 2025)

### Improvements

- Fixed proper handling of markAsRead
- Updated to use cached active channel

### New interfaces

- Add `SBAMessageCSATData` struct and `DataType` enum
- Add `SBAMessageTemplate`, `SBAMessageTemplate.Action`, and `ActionType` enum
- Add `didTapMessageLink()` event in Conversation ListComponent
  - Enables custom handling of link actions in markdown view

## v0.9.4 (Jun 13, 2025)

### Improvements
- Applied hidden state to poweredByMessage using appAttribute

## v0.9.2 (May 29, 2025)
### Improvements
#### Customization supports
- Added `isConversationClosedViewEnabled` property to `SBAConfig` to toggle disabling conversation closed view
- Made `ConversationViewController` type in `SBAViewControllerSet`
- Changed access levels for some interfaces to support customizations
- Refactored and opened layout methods for subclassing in `SBAConversationListModule.Header`

## v0.9.2 (May 28, 2025)
### Improvements
- Supports Objective-C compatibility

## v0.9.1 (May 27, 2025)
### Improvements
- Added `@objc` annotations to avoid naming conflict
- Debug print statements inside the UIView extension for layout slot validation were commented out.

## v0.9.0 (May 26, 2025)
### Improvements
- **SBAConfig**
  - Added `isMessageReceiptStateEnabled` property to the `Conversation`
- **NSObject+SBA**
  - Made `sba_className` properties public
- **SBAQueryParamsSet**
  - Introduced global query parameter builder (`public static var queryParamsBuilder`) for conversation list
- **SBAConversationListModule**
  - Clarified `ConversationCell` type, removed `CustomDataCell`
- **ConversationListFetcher**
  - Related file removed (internal structure refactored)

### Privacy Info
- Added `privacyInfo.xcprivacy` file to comply with Apple’s new privacy requirements.
- Describes data usage in the app as required for App Store submission.

## v0.0.10 (May 20, 2025)

### FIX
- Removed trailing comma from function argument list to ensure compatibility with Xcode 16.2. This syntax is only supported in Swift 6.1+ (Xcode 16.3 and later).

## v0.0.9 (May 19, 2025)

### Public Beta release
- Starting from this version, the beta (snapshot) dependency package has been replaced with the public dependency package
- Intended for early access and feedback
