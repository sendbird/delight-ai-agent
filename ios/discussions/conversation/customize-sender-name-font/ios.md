[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize the Sender Name Font Style

This guide shows how to customize the font style of sender names displayed in incoming message bubbles.

You can customize the sender name font by subclassing `SBAUserNameView` and overriding the `setupStyles()` method.

**Step 1: Create a Custom User Name View**

Create a subclass and override the `setupStyles()` method to change the font:

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomUserNameView: SBAUserNameView {
    override func setupStyles() {
        super.setupStyles()

        // Define custom font (bold, size 16)
        let customFont = UIFont.systemFont(ofSize: 16, weight: .bold)

        // Change sender name button font
        self.nameButton.titleLabel?.font = customFont

        // Optional: Also change color if needed
        // self.nameButton.setTitleColor(UIColor.systemBlue, for: .normal)
    }
}
```

**Step 2: Register the Custom User Name View**

Register your custom view before presenting the conversation view:

```swift
SBAModuleSet.ConversationModule.List.Cell.UserNameView = CustomUserNameView.self
```

**Notes:**
- The `setupStyles()` method is called when the view is configured
- `nameButton` is the button that displays the sender name
- You can customize both font and color properties
- Changes apply to all incoming message sender names
- Use UIFont system fonts or custom fonts loaded in your app
