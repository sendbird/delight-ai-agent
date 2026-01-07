[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize Element Positions in Message Bubbles

This guide shows how to customize the position and arrangement of sender name, sent time, and sender avatar in message bubbles by customizing the cell layout.

You can customize the layout by subclassing `SBAUserMessageCell` and overriding the `layoutMessageContentsLeft()` method.

**Default Layout:**
```
Row 1: [Profile] [Name]
Row 2:          [Message Bubble]
Row 3:          [Time]
```

**Custom Layout (This Example):**
```
Row 1: [Name] [Time]
Row 2: [Profile] [Message Bubble]
```

**Step 1: Create a Custom User Message Cell**

Create a subclass and override the `layoutMessageContentsLeft()` method to rearrange elements:

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomUserMessageCell: SBAUserMessageCell {
    // Override layoutMessageContentsLeft to customize left-side message layout
    override func layoutMessageContentsLeft(with configuration: SBABaseMessageCellParams) -> UIView {
        SBALinearLayout.vStack(alignment: .fill) {
            // Row 1: Name and Time side by side
            SBALinearLayout.hStack(alignment: .center) {
                self.userNameView?.set(
                    padding: .init(
                        left: 12,
                        bottom: messageTopSpacing
                    )
                )

                self.stateView?.set(
                    padding: .init(
                        left: 8,
                        bottom: messageTopSpacing
                    )
                )

                SBASpacer()
            }

            // Row 2: Profile and Message Bubble side by side
            // ⚠️ Use alignment: .top for profile (fixed 40x40) + message (variable height)
            SBALinearLayout.hStack(alignment: .top) {
                self.profileView?.set(
                    padding: .init(
                        left: 12
                    )
                )

                self.messageAreaView?.set(
                    padding: .init(
                        left: 8
                    )
                )
                SBASpacer()
            }

            // Template view (if exists)
            SBALinearLayout.vStack {
                self.templateView?
                    .set(
                        padding: .init(
                            top: !configuration.message.message.isEmpty ? messageTopSpacing : 0
                        )
                    )
            }
        }
    }
}
```

**Step 2: Register the Custom User Message Cell**

Register your custom cell before presenting the conversation view:

```swift
SBAModuleSet.ConversationModule.UserMessageCell = CustomUserMessageCell.self
```

**Notes:**
- `layoutMessageContentsLeft()` defines the layout for incoming (left-aligned) messages
- Use `SBALinearLayout.vStack` for vertical arrangement and `hStack` for horizontal arrangement
- Available views: `userNameView`, `stateView`, `profileView`, `messageAreaView`, `templateView`
- Use `.set(padding:)` to adjust spacing between elements
- `SBASpacer()` pushes content to the left side
- Changes apply globally to all user message cells
- For right-aligned messages, override `layoutMessageContentsRight()` instead
