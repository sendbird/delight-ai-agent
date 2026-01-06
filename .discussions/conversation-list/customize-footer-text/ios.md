[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### How to Customize the Footer Text

You can customize the footer button text by subclassing `SBAConversationListBottomView` and overriding `setupStyles()`.

**Step 1: Create a Custom Bottom View**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationListBottomView: SBAConversationListBottomView {
    override func setupStyles() {
        super.setupStyles()

        // Set custom button text
        self.button?.setTitle("Start New Chat", for: .normal)
    }
}
```

**Step 2: Register the Custom View**

```swift
SBAModuleSet.ConversationListModule.BottomView = CustomConversationListBottomView.self
```

**Notes:**
- You can also customize the button font: `button?.titleLabel?.font`
- Or button text color: `button?.setTitleColor(color, for: .normal)`
