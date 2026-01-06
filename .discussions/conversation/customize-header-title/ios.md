[![iOS](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-ios/releases)

#### How to Customize the HeaderView title in the Conversation

This guide shows how to change the title text of the Conversation Header TitleView.

You can customize the header title of the conversation screen by subclassing `SBAConversationTitleView` and overriding the `loadTitle()` method.

**Step 1: Create a Custom Conversation TitleView Class**

Create a subclass of `SBAConversationTitleView` and override the `loadTitle()` method:

```swift
import SendbirdAIAgentMessenger

class CustomConversationTitleView: SBAConversationTitleView {
    override func loadTitle() {
        self.titleLabel?.text = "Custom title"
    }
}
```

**Step 2: Register the Custom ConversationTitleView**

Before presenting the conversation view, register your custom header titleView class:

```swift
SBAModuleSet.ConversationModule.Header.TitleView = CustomConversationTitleView.self
```
