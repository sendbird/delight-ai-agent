[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize the Typing Indicator Dot Color

This guide shows how to customize the typing indicator appearance by changing the dot color displayed when the AI agent or user is typing.

You can customize the typing indicator by subclassing `SBATypingIndicatorMessageCell` and overriding the `layoutContents(with:)` method.

**Step 1: Create a Custom Typing Indicator Cell**

Create a subclass and override the `layoutContents()` method to replace the default typing indicator with a custom label:

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomTypingIndicatorMessageCell: SBATypingIndicatorMessageCell {
    private lazy var customTypingLabel: UILabel = {
        let label = UILabel()
        label.text = "✍️ Typing..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#7A50F2")
        label.backgroundColor = UIColor(hex: "#7A50F2").withAlphaComponent(0.1)
        label.layer.cornerRadius = 17
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return label
    }()

    override func layoutContents(with configuration: SBABaseMessageCellParams) -> UIView {
        SBALinearLayout.vStack(alignment: .left) {
            SBALinearLayout.hStack(alignment: .center) {
                self.profileView?.set(padding: .init(left: 12, bottom: messageTopSpacing))
                self.userNameView?.set(padding: .init(left: 8, bottom: messageTopSpacing))
                SBASpacer()
            }
            SBALinearLayout.hStack {
                self.bubbleLayoutSlot
                    .set(view: self.customTypingLabel)
                    .set(margin: .init(left: 38))
                SBASpacer()
            }
        }
    }
}

// MARK: - UIColor Extension (Hex Support)
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
```

**Step 2: Register the Custom Typing Indicator Cell**

Register your custom cell before presenting the conversation view:

```swift
SBAModuleSet.ConversationModule.List.TypingIndicatorMessageCell = CustomTypingIndicatorMessageCell.self
```

**Notes:**
- The `layoutContents(with:)` method is called when the cell's layout is configured
- Override `layoutContents(with:)` to replace the default typing bubble with a custom view
- The typing indicator appears at the bottom of the conversation when someone is typing
