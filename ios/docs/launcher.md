# Launcher

`Launcher` is a core component of Delight AI agent messenger that enables you to start and manage conversations in your client app for iOS. It can be attached to any `UIView` and provides a floating button interface. When the launcher is tapped, it automatically launches a conversation screen based on your configuration.

The launcher's appearance such as an icon, its color and size can be customized via the Delight AI dashboard as shown below.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-launcher2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

This guide explains the following features of the launcher:
- [Key features](#key-features)
    - [How to attach](#how-to-attach)
    - [Start a conversation and customize the entry point](#start-a-conversation-and-customize-the-entry-point)
    - [Set the launcher position](#set-the-launcher-position)
    - [Customize the launcher appearance](#customize-the-launcher-appearance)
- [Usage](#usage)
    - [Basic](#basic)
    - [Advanced](#advanced)
    - [Remove the launcher](#remove-the-launcher)
    - [More configuration options](#more-configuration-options)
- [API references](#api-references)

---

## Key features

The core features of the Launcher are:

* [Automatic attachment](launcher.md#how-to-attach)
* [Start a conversation and customize the entry point](launcher.md#start-a-conversation-and-customize-the-entry-point)
* [Set the launcher position](launcher.md#set-the-launcher-position)
* [Customize the launcher appearance](launcher.md#customize-the-launchers-appearance)

### How to attach

You can easily attach the launcher to any screen with simple codes as shown below:

```swift
import SendbirdAIAgentMessenger

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
)
```

### Start a conversation and customize the entry point

`SBALauncherOptions.entryPoint` allows you to customize the entry point from the launcher. The code snippet below demonstrates a `.conversation` entry point: a conversation automatically opens when the launcher is tapped.

```swift
let options = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = options
}
```

If you wish to display a conversation list first when the user taps on the launcher, set the `entryPoint` to `.conversationList`.

```swift
// Direct conversation entry.
let conversationOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = conversationOptions
}

// Conversation list entry.
let listOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversationList,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = listOptions
}
```

### Set the launcher position

Set the launcher position on a screen using `layout.init()` in `SBALauncherOptions` as shown below.

```swift
let options = SBALauncherOptions(
    parentView: nil,
    entryPoint: .default,
    layout: .init(
        position: .trailingBottom,
        margin: LauncherAreaMargin(
            leading: 16,
            trailing: 16,
            top: 16,
            bottom: 16
        ),
        useSafeArea: true
    ),
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = options
}
```

### Customize the launcher appearance

Launcher appearance, such as its icon and color, can be configured through [Delight AI dashboard](https://dashboard.delight.ai) - no code changes required. Simply go to [**Build > Channels > Messenger**](https://dashboard.delight.ai/ai-agent/%7Bapplication-id%7D/channels/messenger/?active_tab=Appearance) in the dashboard and click on the **Appearance** tab to customize your launcher.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-messenger-appearance.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

---

## Usage

This section demonstrates how to integrate the Launcher to your iOS app in different scenarios.

### Basic

First, use the following snippet with the default settings for a seamless launcher attachment. It demonstrates the minimal setup required to initialize and attach the launcher to your main screen.

```swift
import UIKit
import SendbirdAIAgentMessenger

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize and attach launcher.
        AIAgentMessenger.attachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID"
        )
    }

    deinit {
        AIAgentMessenger.detachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID"
        )
    }
}
```

### Advanced

Once the basic setup is complete, you can move onto customizing the launcher position and entry point.

The following snippet demonstrates how to customize your launcher using all the configuration options together, including its position, entry mode, language, and context metadata.

> **Note**: To see the full list of parameters, go to the [More configuration options](launcher.md#more-configuration-options) section.

```swift
import UIKit
import SendbirdAIAgentMessenger

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Custom launcher configuration.
        let options = SBALauncherOptions(
            parentView: nil,
            entryPoint: .conversationList,
            layout: .init(
                position: .leadingTop,
                margin: LauncherAreaMargin(
                    leading: 20,
                    trailing: 20,
                    top: 50,
                    bottom: 20
                ),
                useSafeArea: true
            ),
            displayStyle: .overlay(.init(
                spacing: 12,
                overlayLauncher: false
            ))
        )

        AIAgentMessenger.attachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID"
        ) { params in
            params.options = options
            params.language = "ko-KR"
            params.countryCode = "KR"
            params.context = [
                "user_id": "12345",
                "plan": "premium"
            ]
        }
    }

    deinit {
        AIAgentMessenger.detachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID"
        )
    }
}
```

### Remove the launcher

When you need to remove the launcher from the screen, use the snippet below.

```swift
// Detach launcher when view disappears or is no longer needed.
AIAgentMessenger.detachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
)
```

### More configuration options

This section describes how to configure the parameters and enums that control launcher behavior and appearance.

#### LauncherSettingsParams

The following table lists the configuration options in `LauncherSettingsParams`, which can be used when initializing the messenger launcher.

| Property      | Type                | Description                                                                                           | Default   |
| ------------- | ------------------- | ----------------------------------------------------------------------------------------------------- | --------- |
| `options`     | SBALauncherOptions | Configures the launcher layout and display options, such as its entry point, position, and display style. | .default |
| `language`    | String?           | Sets the language code in IETF BCP 47 format.                                                         | nil     |
| `countryCode` | String?         | Sets the country code in ISO 3166 format.                                                             | nil     |
| `context`     | [String: String]  | Contains additional metadata on the user for more personalized support by AI agent.                      | [:]     |

```swift
// LauncherSettingsParams is used within the builder closure.
AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = SBALauncherOptions(
        parentView: nil,
        entryPoint: .conversation,
        layout: .init(
            position: .trailingBottom,
            margin: LauncherAreaMargin(
                leading: 16,
                trailing: 16,
                top: 16,
                bottom: 16
            ),
            useSafeArea: true
        ),
        displayStyle: .default
    )
    params.language = "en-US"
    params.context = ["user_type": "premium"]
}
```

#### SBALauncherOptions

The following table lists the configuration options in `SBALauncherOptions`, which can be used when setting the visual layout and behavior of the launcher.

| Property       | Type              | Description                                                                                                     | Default          |
| -------------- | ----------------- | --------------------------------------------------------------------------------------------------------------- | ---------------- |
| `parentView`   | UIView?         | Sets the parent view to attach the launcher.                                                                    | nil            |
| `entryPoint`   | [`SBAEntryPoint`](launcher.md#sbaentrypoint) | Determines which screen to show first when the launcher is tapped. Acceptable values are `.conversation` and `.conversationList`. | .conversation  |
| `layout`       | [`Layout`](launcher.md#layout)             | Configures the layout of the launcher, such as its position and margins.                                                       | .default       |
| `displayStyle` | [`DisplayStyle`](launcher.md#displaystyle) | Sets how the conversation screen appears. Acceptable values are `.fullscreen` and `.overlay`.                                    | .overlay()     |

```swift
let options = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .init(
        position: .trailingBottom,
        margin: .default,
        useSafeArea: true
    ),
    displayStyle: .overlay()
)
```

#### SBAEntryPoint

The following table lists the configuration options in `SBAEntryPoint`, which can be used when launching the messenger.

| Value                | Description                                                       |
| -------------------- | ----------------------------------------------------------------- |
| `.conversation`      | Opens a conversation directly after a tap on the launcher.        |
| `.conversationList`  | Shows the user's conversation list first after a tap on the launcher. |

```swift
// Launch directly into conversation.
let conversationOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .default,
    displayStyle: .default
)

// Show conversation list first.
let listOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversationList,
    layout: .default,
    displayStyle: .default
)
```

#### Layout

The following table lists the configuration options in `Layout`, which can be used when setting the positioning and margins of the launcher.

| Property      | Type                                                   | Description                                 | Default           |
| ------------- | ------------------------------------------------------ | ------------------------------------------- | ----------------- |
| `position`    | [`LauncherPosition`](launcher.md#launcherposition)     | Sets the position of the launcher on a screen. | .trailingBottom |
| `margin`      | [`LauncherAreaMargin`](launcher.md#launcherareamargin) | Sets its margins from edges.        | .default        |
| `useSafeArea` | Bool                                                 | Determines whether to respect safe area insets.        | true            |

```swift
let layout = SBALauncherOptions.Layout(
    position: .trailingBottom,
    margin: LauncherAreaMargin(
        leading: 16,
        trailing: 16,
        top: 16,
        bottom: 16
    ),
    useSafeArea: true
)
```

#### LauncherPosition

The following table lists the configuration options in `LauncherPosition`, which can be used when setting where the launcher appears on the screen.

| Value             | Description              |
| ----------------- | ------------------------ |
| `.leadingTop`     | Top-left corner of screen.  |
| `.trailingTop`    | Top-right corner of screen. |
| `.leadingBottom`  | Bottom-left corner of screen. |
| `.trailingBottom` | Bottom-right corner of screen. |

```swift
// Position at bottom-right corner.
let trailingBottomOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .default,
    layout: .init(
        position: .trailingBottom,
        margin: .default,
        useSafeArea: true
    ),
    displayStyle: .default
)

// Position at top-left corner.
let leadingTopOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .default,
    layout: .init(
        position: .leadingTop,
        margin: .default,
        useSafeArea: true
    ),
    displayStyle: .default
)
```

#### DisplayStyle

The following table lists the configuration options in `DisplayStyle`, which can be used when determining how the conversation screen appears.

| Value                            | Description                                              |
| -------------------------------- | -------------------------------------------------------- |
| `.fullscreen(FullscreenStyle)`   | The conversation opens as a full screen.                 |
| `.overlay(OverlayStyle)`         | The conversation opens like an anchored box near the launcher. |

```swift
// Full screen mode.
let fullscreenOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .default,
    layout: .default,
    displayStyle: .fullscreen(.init(
        presentationStyle: .fullScreen,
        parentController: nil
    ))
)

// Overlay mode.
let overlayOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .default,
    layout: .default,
    displayStyle: .overlay(.init(
        spacing: 12,
        overlayLauncher: false
    ))
)
```

* `FullscreenStyle`

Configuration for full-screen display mode.

| Property            | Type                      | Description               | Default       |
| ------------------- | ------------------------- | ------------------------- | ------------- |
| `presentationStyle` | UIModalPresentationStyle | Modal presentation style. | .fullScreen |
| `parentController`  | UIViewController?       | Parent view controller.   | nil         |

```swift
let fullscreenStyle = SBALauncherOptions.DisplayStyle.FullscreenStyle(
    presentationStyle: .pageSheet,
    parentController: self
)
```

* `OverlayStyle`

Configuration for overlay display mode.

| Property          | Type     | Description                              | Default |
| ----------------- | -------- | ---------------------------------------- | ------- |
| `spacing`         | CGFloat| Spacing between launcher and conversation. | 12    |
| `overlayLauncher` | Bool   | Whether to overlay the launcher.         | false |

```swift
let overlayStyle = SBALauncherOptions.DisplayStyle.OverlayStyle(
    spacing: 12,
    overlayLauncher: false
)
```

#### LauncherAreaMargin

The following table lists the configuration options in `LauncherAreaMargin`, which can be used to set the spacing around the launcher.

| Property  | Type      | Description                |
| --------- | --------- | -------------------------- |
| `leading` | CGFloat | Leading margin in points.  |
| `trailing`| CGFloat | Trailing margin in points. |
| `top`     | CGFloat | Top margin in points.      |
| `bottom`  | CGFloat | Bottom margin in points.   |

```swift
// 16pt margins on all sides.
let margin = LauncherAreaMargin(
    leading: 16,
    trailing: 16,
    top: 16,
    bottom: 16
)

// Custom margins.
let customMargin = LauncherAreaMargin(
    leading: 20,
    trailing: 20,
    top: 50,
    bottom: 30
)

// Update specific margins.
let updatedMargin = margin.update(
    top: 50,
    bottom: 30
)
```

---

## API references

### AIAgentMessenger Launcher Methods

Core methods for managing the launcher in the AI Agent Messenger SDK.

#### attachLauncher

Attaches the launcher button to the screen.

```swift
static func attachLauncher(
    aiAgentId: String,
    channelURL: String? = nil,
    paramsBuilder: LauncherSettingsParamsBuilder? = nil
)
```

| Parameter     | Type                            | Description                                                                                   |
| ------------- | -------------------------------- | --------------------------------------------------------------------------------------------- |
| `aiAgentId`   | `String`                        | The unique identifier of the AI agent.                                                       |
| `channelURL`  | `String?`                       | (Optional) The channel URL to open a specific conversation. If `nil`, a new conversation will be created. |
| `paramsBuilder` | `LauncherSettingsParamsBuilder?` | (Optional) A closure used to configure launcher settings such as layout and appearance.             |

#### detachLauncher

Removes the launcher button from the screen.

```swift
static func detachLauncher(
    aiAgentId: String
)
```

| Parameter   | Type      | Description                          |
| ----------- | --------- | ------------------------------------ |
| `aiAgentId` | `String`  | The unique identifier of the AI agent. |

### LauncherSettingsParams

Configuration parameters for the launcher button. Inherits from `BaseMessengerParams`.

| Property      | Type                | Description                             | Default     |
| ------------- | ------------------- | --------------------------------------- | ----------- |
| `options`     | SBALauncherOptions | Launcher layout and display options.    | .default  |
| `language`    | String?           | Language code (IETF BCP 47).            | nil       |
| `countryCode` | String?           | Country code (ISO 3166).                | nil       |
| `context`     | [String: String]  | Additional metadata for AI agent.   | [:]       |

### SBALauncherOptions

Comprehensive configuration options for launcher appearance and behavior.

| Property       | Type          | Description                        | Default       |
| -------------- | ------------- | ---------------------------------- | ------------- |
| `parentView`   | UIView?       | Parent view to attach launcher.    | nil           |
| `entryPoint`   | SBAEntryPoint | Initial screen to show.            | .conversation |
| `layout`       | Layout        | Position and margin configuration. | .default      |
| `displayStyle` | DisplayStyle  | How conversation appears.          | .overlay()    |

### LauncherSettingsParamsBuilder

Type alias for launcher settings parameter builder closure.

```swift
typealias LauncherSettingsParamsBuilder = (LauncherSettingsParams) -> Void
```
