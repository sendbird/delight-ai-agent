[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize the List Item View

You can customize the layout of conversation list items by subclassing `SBAConversationCell` and overriding `layoutBody()`.

**Step 1: Create a Custom Cell**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationCell: SBAConversationCell {
    // Override layout to rearrange elements
    // Default: [Profile] [Title/Date/Status] [Badge]
    // Custom: [Badge] [Profile] [Title/Date/Status]
    override func layoutBody(with configuration: SBABaseConversationCellParams) -> UIView {
        SBALinearLayout.zStack { container in
            // Main content layout
            container.add(SBALinearLayout.hStack(alignment: .center) {
                // Move badge to left
                self.layoutRightItems(with: configuration)
                // Profile image
                self.layoutLeftItems(with: configuration)
                // Text content
                self.layoutContents(with: configuration)
            }, offset: .init(top: 12, left: 16, bottom: 12, right: 16))

            // Divider
            container.add(
                self.divideView,
                vertical: .bottom,
                offset: .init(top: 0, left: 76, bottom: 0, right: 0)
            )
        }
    }
}
```

**Step 2: Register the Custom Cell**

```swift
SBAModuleSet.ConversationListModule.List.ConversationCell = CustomConversationCell.self
```

**Notes:**

- Use `layoutLeftItems()`, `layoutRightItems()`, `layoutContents()` to reorder elements
- `SBALinearLayout.zStack` allows layering views (e.g., divider at bottom)
- Adjust offsets and padding as needed
