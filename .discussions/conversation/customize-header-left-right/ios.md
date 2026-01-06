[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### How to Customize the Left/Right Areas in the Conversation HeaderView

- Description

This guide shows how to set up and apply layouts for the left and right areas of the Conversation HeaderView.

You can customize the header layout of the conversation screen by subclassing `SBAConversationModule.Header` and overriding the `layoutLeftItems()` and `layoutRightItems()` methods. This allows you to rearrange, add, or remove items in the header's left and right areas.

When composing layouts, use `SBALinearLayout` to arrange views. This utility provides convenient methods for creating horizontal and vertical stack layouts to organize your UI elements.

**Step 1: Create a Custom Header Class**

Create a subclass of `SBAConversationModule.Header` and override the layout methods:

```swift
import SendbirdAIAgentMessenger

class CustomConversationHeader: SBAConversationModule.Header {
    override func layoutLeftItems() -> UIView? {
        // Use SBALinearLayout to arrange views in the left area
        SBALinearLayout.hStack {
            self.closeButton
        }
    }

    override func layoutRightItems() -> UIView? {
        // Return nil to remove all items from the right area
        // Or use SBALinearLayout to arrange desired buttons
        nil
    }
}
```

**Step 2: Register the Custom Header**

Before presenting the conversation view, register your custom header class:

```swift
SBAModuleSet.ConversationModule.HeaderComponent = CustomConversationHeader.self
```

**Example Configurations:**

Show only menu button on the left, handoff button on the right:
```swift
override func layoutLeftItems() -> UIView? {
    SBALinearLayout.hStack {
        self.menuButton
    }
}

override func layoutRightItems() -> UIView? {
    SBALinearLayout.hStack {
        self.closeButton
    }
}
```

Multiple buttons on the right side:
```swift
override func layoutRightItems() -> UIView? {
    SBALinearLayout.hStack {
        self.handoffButton
        self.menuButton
    }
}
```

**Available Default Buttons:**
- `closeButton` - Closes the conversation view
- `menuButton` - Opens the menu options
- `handoffButton` - Handles agent handoff functionality

**Notes:**
- Use `SBALinearLayout` to arrange views when composing your layouts
- `SBALinearLayout.hStack` creates a horizontal stack for arranging multiple buttons side by side
- Returning `nil` from either layout method will completely remove items from that area
- Changes to the module set are global and will affect all conversation screens in your app
