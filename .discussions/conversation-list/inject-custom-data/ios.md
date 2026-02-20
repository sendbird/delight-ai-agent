[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Inject and Render Custom Data in the Conversation List

This guide shows how to inject custom data (like a banner channel) into the conversation list by overriding the ViewController's DataSource method. This approach avoids interfering with the SDK's internal ViewModel logic.

**Step 1: Create a Custom ViewController with Banner Channel**

Create a `GroupChannel` instance using `GroupChannel.make()` and inject it via DataSource override.

```swift
import SendbirdAIAgentMessenger
import SendbirdChatSDK

class CustomConversationListViewController: SBALauncherConversationListViewController {

    // Create banner channel on demand
    lazy var bannerChannel: GroupChannel? = {
        GroupChannel.make([
            "channel_url": "mock_channel_\(UUID().uuidString)",
            "created_at": Int64(Date().timeIntervalSince1970),
            "name": "Test Channel",
            "data": "banner"  // Identifier for banner type
        ])
    }()

    /// Override DataSource to inject banner
    override func conversationListModule(
        _ listComponent: SBAConversationListModule.List,
        requestsDataFor event: SBAConversationListModule.List.DataSourceEvent
    ) -> Any? {
        switch event {
        case .conversationList:
            // Get regular channels from SDK
            let channels = super.conversationListModule(listComponent, requestsDataFor: event) as? [GroupChannel] ?? []

            // Inject banner at top if exists
            if let banner = bannerChannel {
                return [banner] + channels
            }
            return channels

        case .conversationForIndex(let index):
            // Get regular channels from SDK
            var channels = super.conversationListModule(listComponent, requestsDataFor: .conversationList) as? [GroupChannel] ?? []

            // Inject banner at top if exists
            if let banner = bannerChannel {
                channels = [banner] + channels
            }

            if channels.count > index {
                return channels[index]
            } else {
                return nil
            }

        default:
            return super.conversationListModule(listComponent, requestsDataFor: event)
        }
    }
}
```

**Step 2: Create a Custom Banner Cell**

Create a custom cell that renders the banner content.

**⚠️ Important:** Use `lazy var` for custom UI components in cells to ensure proper initialization timing.

```swift
import SendbirdAIAgentMessenger
import UIKit

class CustomBannerCell: SBABaseConversationCell {

    // Use lazy var for custom views
    lazy var bannerLabel = UILabel()

    func layoutBody() -> UIView {
        SBALinearLayout.hStack(alignment: .center) {
            self.bannerLabel
        }
    }

    override func setupViews() {
        super.setupViews()
    }

    override func configure(with configuration: SBABaseConversationCellParams) {
        super.configure(with: configuration)

        // Setup body layout
        self.setupBodyContents(layoutBody())

        // Configure banner label
        self.bannerLabel.font = .systemFont(ofSize: 16, weight: .bold)
        self.bannerLabel.textColor = .systemPurple
        self.bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bannerLabel.text = "📢 Banner: \(configuration.channel.name)"
        self.bannerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
```

**Step 3: Register Custom Cell and Identify Banner Channels**

Register the custom cell type and implement cell type selection logic.

```swift
import SendbirdAIAgentMessenger
import SendbirdChatSDK

class CustomConversationList: SBAConversationListModule.List {

    override func setupViews() {
        super.setupViews()

        // Register custom banner cell type
        self.register(customDataCellType: CustomBannerCell.self)
    }

    override func generateCellIdentifier(by channel: GroupChannel) -> String? {
        // Check if this is a banner channel by data property
        if channel.data == "banner" {
            return CustomBannerCell.sba_className
        }

        // Default: Use standard conversation cell
        return super.generateCellIdentifier(by: channel)
    }
}
```

**Step 4: Register Components**

Register the custom ViewController and List component in your AppDelegate.

```swift
import SendbirdAIAgentMessenger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SBAViewControllerSet.LauncherConversationListViewController = CustomConversationListViewController.self
        SBAModuleSet.ConversationListModule.ListComponent = CustomConversationList.self
        return true
    }
}
```

**Key Points:**

1. **lazy var Required for UI Components**: Always use `lazy var` for custom UI components (UILabel, UIButton, etc.) in custom views and cells in the current SDK version
2. **DataSource Override**: Override `conversationListModule(_:requestsDataFor:)` in ViewController to inject custom data
3. **Handle Multiple Events**: Handle both `.conversationList` and `.conversationForIndex` events
4. **Channel Identification**: Use `channel.data` property to identify banner channels
5. **setupBodyContents()**: Use this method to set custom cell layout in `configure()`

**Notes:**
- This pattern doesn't affect SDK's internal ViewModel logic
- The banner channel is created using `GroupChannel.make()` with mock data
- Custom cells inherit from `SBABaseConversationCell` for basic cell functionality
- Use `SBALinearLayout` for arranging cell contents
- **Important**: UI components like UILabel, UIImageView, UIButton, etc. must be declared with `lazy var` in custom cells and views
