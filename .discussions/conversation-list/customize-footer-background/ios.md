[![iOS](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-ios/releases)

#### How to Customize the Background Color of the Footer Area

You can customize the footer button's background color by subclassing `SBAConversationListBottomView` and overriding `setupStyles()`.

**Step 1: Create a Custom Bottom View**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationListBottomView: SBAConversationListBottomView {
    override func setupStyles() {
        super.setupStyles()

        // Define custom background color
        let customBackgroundColor = UIColor.systemPink.withAlphaComponent(0.1)

        // Change button background color
        self.button?.setBackgroundImage(customBackgroundColor.asImage, for: .normal)
    }
}

// UIColor to UIImage conversion utility
extension UIColor {
    var asImage: UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
```

**Step 2: Register the Custom View**

```swift
SBAModuleSet.ConversationListModule.BottomView = CustomConversationListBottomView.self
```

**Notes:**
- You can also change the button text color using `button?.setTitleColor(color, for: .normal)`
- The `asImage` extension converts UIColor to UIImage for button backgrounds
