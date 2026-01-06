[![iOS](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-ios/releases)

#### How to Insert a Custom View into the Conversation List

You can insert a custom view (like a banner) between the header and list by subclassing `SBAConversationListModule.Header` and overriding `layoutBody()`.

**Step 1: Create a Custom Header with Banner View**

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomConversationListHeader: SBAConversationListModule.Header {
    private lazy var customBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "📢 Custom Banner View"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 60)
        ])

        return view
    }()

    override func layoutBody() -> UIView {
        return SBALinearLayout.vStack {
            self.customBannerView  // Custom banner view
        }
    }
}
```

**Step 2: Register the Custom Header**

```swift
SBAModuleSet.ConversationListModule.HeaderComponent = CustomConversationListHeader.self
```

**Notes:**
- This approach replaces the default header with your custom view
- Use `SBALinearLayout.vStack` to stack multiple views vertically
- You can add multiple custom views in the layout
