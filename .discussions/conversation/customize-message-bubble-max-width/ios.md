[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

#### How to Customize the Message Bubble Max Width

This guide shows how to customize the maximum width of message bubbles in the conversation view using the configuration API.

The SDK provides a simple configuration property to control message bubble width.

**Set the Message Bubble Max Width**

Use the `AIAgentMessenger.config` API to set the maximum width:

```swift
import SendbirdAIAgentMessenger

// Set message bubble max width
// Default: 244.0
AIAgentMessenger.config.conversation.messageCellMaxWidth = 300.0
```

**Examples:**

```swift
// Narrower bubbles
AIAgentMessenger.config.conversation.messageCellMaxWidth = 200.0

// Wider bubbles
AIAgentMessenger.config.conversation.messageCellMaxWidth = 400.0

// Default width
AIAgentMessenger.config.conversation.messageCellMaxWidth = 244.0
```

**Notes:**
- The default max width is `244.0` points
- This setting applies to both incoming and outgoing message bubbles
- Changes apply globally to all conversation screens
- Set this before presenting the conversation view
- Value is in UIKit points, not pixels
