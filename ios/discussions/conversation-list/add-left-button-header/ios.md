[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Add a Left Button to the Conversation List Header

You can add a custom button to the left side of the header by subclassing `SBAConversationListModule.Header` and overriding `layoutLeftItems()`. To handle button taps in the ViewController, use the delegate event system.

**Step 1: Create a Custom Header with Left Button**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationListHeader: SBAConversationListModule.Header {
    // Create left menu button
    lazy var leftMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("☰", for: .normal)
        button.addTarget(self, action: #selector(onMenuButtonTapped), for: .touchUpInside)
        return button
    }()

    // Override to add button to left area
    override func layoutLeftItems() -> UIView? {
        return SBALinearLayout.hStack(spacing: 8, alignment: .center) {
            self.leftMenuButton
        }
    }

    // Send custom event to ViewController
    @objc func onMenuButtonTapped() {
        self.delegate(with: .custom(name: "custom_close_action", data: nil))
    }
}
```

**Step 2: Create a ViewController to Handle the Event**

```swift
class CustomConversationListViewController: SBAConversationListViewController {
    override func conversationListModule(
        _ headerComponent: SBAConversationListModule.Header,
        didReceiveEvent event: SBAConversationListModule.Header.DelegateEvent
    ) {
        switch event {
        case .custom(let name, let data):
            if name == "custom_close_action" {
                // Handle the button tap
                print("Menu button tapped")
            }
        default:
            super.conversationListModule(headerComponent, didReceiveEvent: event)
        }
    }
}
```

**Step 3: Register Both Custom Components**

```swift
// In AppDelegate or before presenting the UI
SBAModuleSet.ConversationListModule.HeaderComponent = CustomConversationListHeader.self
SBAViewControllerSet.ConversationListViewController = CustomConversationListViewController.self
```

**Notes:**
- Use `layoutLeftItems()` for left-side buttons, `layoutRightItems()` for right-side buttons
- Custom events can pass data: `.custom(name: "event_name", data: yourData)`
- Always call `super.conversationListModule(...)` for unhandled events
