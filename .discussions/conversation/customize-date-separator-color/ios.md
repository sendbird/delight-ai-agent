[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### How to customize the date separator label color in the conversation

You can customize the date separator label of the conversation by subclassing `SBAMessageDateView` and overriding the `setupStyles()` method.

**Step 1: Create a Custom Class**

Create a subclass of `SBAMessageDateView` and override the `setupStyles()` method:

```swift
import SendbirdAIAgentMessenger

class CustomMessageDateView: SBAMessageDateView {
    override func setupStyles() {
        super.setupStyles()

        let customColor = UIColor(hex: "#7A50F2")
        self.dateLabel?.textColor = customColor
    }
}
```

**Step 2: Register the Custom class**

Before presenting the conversation view, register your custom class:

```swift
SBAModuleSet.ConversationModule.List.Cell.DateView = CustomMessageDateView.self
```
