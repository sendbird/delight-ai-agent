[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### How to customize the user name color in the conversation message

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
