[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to customize the time label color in the conversation message

You can customize the stateView of the conversation message by subclassing `SBAMessageStateView` and overriding the `setupStyles()` method.

**Step 1: Create a Custom Class**

Create a subclass of `SBAMessageStateView` and override the `setupStyles()` method:

```swift
import SendbirdAIAgentMessenger

class CustomMessageStateView: SBAMessageStateView {
    override func setupStyles() {
        super.setupStyles()

        let customColor = UIColor(hex: "#7A50F2")
        self.timeLabel?.textColor = customColor
    }
}
```

**Step 2: Register the Custom class**

Before presenting the conversation view, register your custom class:

```swift
SBAModuleSet.ConversationModule.List.Cell.StateView = CustomMessageStateView.self
```

**Helper: UIColor Hex Extension**

`UIColor(hex:)` used in the example above is not provided by the SDK. Add this extension to your app to enable hex color initialization:

```swift
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
```
