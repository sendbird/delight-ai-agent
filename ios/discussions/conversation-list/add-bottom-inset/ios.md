[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Add Bottom Inset to the ListView

You can add bottom spacing to the table view by subclassing `SBAConversationListModule.List` and setting `contentInset` in `setupViews()`.

**Step 1: Create a Custom List Component**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationListModule {
    class List: SBAConversationListModule.List {
        override func setupViews() {
            super.setupViews()

            // Add bottom inset
            self.tableView?.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 50,  // 50pt bottom spacing
                right: 0
            )
        }
    }
}
```

**Step 2: Register the Custom Component**

```swift
SBAModuleSet.ConversationListModule.ListComponent = CustomConversationListModule.List.self
```

**Notes:**
- Useful when you have fixed content (banner, ads) at the bottom
- Prevents the last item from being hidden behind bottom UI elements
- You can adjust all four edges (top, left, bottom, right)
