[![iOS](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-ios/releases)

#### How to Show and Customize the Divider Between Message List and Input Field

The SDK's `SBAMessageInputView` includes a divider at the top, but it's hidden by default. You can show and customize it by subclassing `SBAMessageInputView`.

**Step 1: Create a Custom Message Input View**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomMessageInputView: SBAMessageInputView {
    override func setupViews() {
        super.setupViews()

        // Show the divider
        self.divider?.isHidden = false
    }

    override func setupStyles() {
        super.setupStyles()

        // Customize divider color
        self.divider?.backgroundColor = UIColor.systemPurple
    }

    override func setupLayouts() {
        super.setupLayouts()

        // Customize divider height (default is 1pt)
        self.divider?.sba_constraint(height: 2)
    }
}
```

**Step 2: Register the Custom Input View**

```swift
SBAModuleSet.ConversationModule.InputComponent = CustomMessageInputView.self
```

**Notes:**
- The divider already exists in `SBAMessageInputView` but is hidden by default
- Use `setupViews()` to show it, `setupStyles()` to change color, `setupLayouts()` to adjust height
- This is simpler than overriding the entire screen layout
