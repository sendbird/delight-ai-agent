[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize the Sent Time Font Style

This guide shows how to customize the font style of sent time (timestamp) displayed in message bubbles.

You can customize the sent time font by subclassing `SBAMessageStateView` and overriding the `setupStyles()` method.

**Step 1: Create a Custom Message State View**

Create a subclass and override the `setupStyles()` method to change the font:

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomMessageStateView: SBAMessageStateView {
    override func setupStyles() {
        super.setupStyles()

        // Define custom font (monospaced, size 20, medium weight)
        let customFont = UIFont.monospacedSystemFont(ofSize: 20, weight: .medium)

        // Change time label font
        self.timeLabel?.font = customFont

        // Optional: Also change color if needed
        // self.timeLabel?.textColor = UIColor.systemOrange
    }
}
```

**Step 2: Register the Custom Message State View**

Register your custom view before presenting the conversation view:

```swift
SBAModuleSet.ConversationModule.List.Cell.StateView = CustomMessageStateView.self
```

**Notes:**
- The `setupStyles()` method is called when the view is configured
- `timeLabel` displays the sent timestamp for both incoming and outgoing messages
- You can customize both font and color properties
- Changes apply to all message timestamps
- Consider using monospaced fonts for consistent timestamp alignment
