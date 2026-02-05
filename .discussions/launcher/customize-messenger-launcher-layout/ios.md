[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## Steps to Customize the Launcher Layout

You can customize the MessengerLauncher layout in iOS using `SBALauncherOptions`.

### Basic Configuration

```swift
import SendbirdAIAgentMessenger

let layoutOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversationList,
    layout: .init(
        position: .trailingBottom,
        margin: .init(
            leading: 16,
            trailing: 16,
            top: 16,
            bottom: 16
        ),
        useSafeArea: true
    ),
    displayStyle: .overlay()
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "your_agent_id"
) { params in
    params.options = layoutOptions
}
```

### Configuration Options

| Property       | Type                 | Description                              | Values                                                                       |
| -------------- | -------------------- | ---------------------------------------- | ---------------------------------------------------------------------------- |
| `position`     | `LauncherPosition`   | Sets the launcher button position        | `.leadingTop`, `.trailingTop`, `.leadingBottom`, `.trailingBottom` (default) |
| `margin`       | `LauncherAreaMargin` | Sets margins around the launcher         | Custom values or `.default` (16pt all sides)                                 |
| `useSafeArea`  | `Bool`               | Whether to respect safe area constraints | `true` (default), `false`                                                    |
| `entryPoint`   | `SBAEntryPoint`      | Initial screen when launcher is tapped   | `.conversation` (default), `.conversationList`                               |
| `displayStyle` | `DisplayStyle`       | How the conversation view is presented   | `.overlay()` (default), `.fullscreen()`                                      |

### Display Style Options

## Overlay Style

| Property          | Type      | Description                                    | Default | Notes                                                 |
| ----------------- | --------- | ---------------------------------------------- | ------- | ----------------------------------------------------- |
| `spacing`         | `CGFloat` | Spacing between launcher and conversation view | `12`    | Distance in points                                    |
| `overlayLauncher` | `Bool`    | Whether to overlay the launcher button         | `false` | When `true`, launcher stays visible over conversation |

## Fullscreen Style

| Property            | Type                       | Description              | Default       | Available Options                                            |
| ------------------- | -------------------------- | ------------------------ | ------------- | ------------------------------------------------------------ |
| `presentationStyle` | `UIModalPresentationStyle` | Modal presentation style | `.fullScreen` | `.fullScreen`, `.pageSheet`, `.formSheet`, `.overFullScreen` |
| `parentController`  | `UIViewController?`        | Parent view controller   | `nil`         | Controller that presents the conversation view               |

### Advanced Examples

```swift
// Overlay style with custom spacing and persistent launcher
let overlayOptions = SBALauncherOptions(
    layout: .init(
        position: .leadingTop,
        margin: .init(leading: 24, trailing: 16, top: 44, bottom: 16),
        useSafeArea: true
    ),
    displayStyle: .overlay(
        .init(
            spacing: 16,           // 16pt spacing between launcher and conversation
            overlayLauncher: true  // Keep launcher visible over conversation
        )
    )
)

// Fullscreen style with page sheet presentation
let fullscreenOptions = SBALauncherOptions(
    entryPoint: .conversation,
    displayStyle: .fullscreen(
        .init(
            presentationStyle: .pageSheet,  // Shows as a card-style modal
            parentController: self          // Present from current controller
        )
    )
)

// Usage with paramsBuilder
AIAgentMessenger.attachLauncher(
    aiAgentId: "your_agent_id"
) { params in
    params.options = overlayOptions // or fullscreenOptions
}
```
