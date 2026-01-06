[![iOS](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![Version](https://img.shields.io/badge/0.9.5-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### Customizing Link Tap Action in Message

- You can override the default action when a link inside a message is tapped by subclassing `SBAConversationViewController` and handling the `.didTapMessageLink` event.

**Step 1: Subclass `SBAConversationViewController`**

```swift
import SendbirdAIAgentMessenger

final class CustomConversationController: SBAConversationViewController {
    override func conversationModule(
        _ listComponent: SBAConversationModule.List,
        event: SBAConversationModule.List.DelegateEvent
    ) {
        switch event {
        case .didTapMessageLink(let message, let url):
            // You can handle the URL here (e.g., open in Safari, route internally, etc.)
            debugPrint("handle link url: \(url.absoluteString)")
        default:
            super.conversationModule(listComponent, event: event)
        }
    }
}
```

**Step 2: Register the Custom Controller**

- Assign your custom class to `SBAViewControllerSet.ConversationViewController` before presenting the messenger.

```swift
SBAViewControllerSet.ConversationViewController = CustomConversationController.self
```
