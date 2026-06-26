[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to customize the user name color in the conversation message

You can customize the user name color of the conversation message by subclassing `SBAUserNameView` and overriding the `setupStyles()` method.

**Step 1: Create a Custom Class**

Create a subclass of `SBAUserNameView` and override the `setupStyles()` method:

```swift
import SendbirdAIAgentMessenger

class CustomMessageUserNameView: SBAUserNameView{
    override func setupStyles() {
        super.setupStyles()

        let customColor = UIColor(hex: "#7A50F2")
        self.nameButton.setTitleColor(customColor, for: .normal)
    }
}
```

**Step 2: Register the Custom class**

Before presenting the conversation view, register your custom class:

```swift
SBAModuleSet.ConversationModule.List.Cell.UserNameView = CustomMessageUserNameView.self
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
