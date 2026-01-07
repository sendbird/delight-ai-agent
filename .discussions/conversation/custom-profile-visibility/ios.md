[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

### Customizing Profile Visibility in Conversation Header and Message List

This guide explains how to customize the visibility of the profile view in the **Conversation Header** and the **Message Sender Profile** in the conversation message list.

## 1. Customizing the Profile View in the Conversation Header

- You can show or hide the conversation header profile using the `shouldShowProfile` property in the AIAgentMessenger.config.conversation.header.

**Example:**

```swift
AIAgentMessenger.config.conversation.header.shouldShowProfile = false
```
Explanation:
- `shouldShowProfile` = true → Displays the profile view in the header (default).
- `shouldShowProfile` = false → Hides the profile view in the header.

⸻
## 2. Customizing the Sender Profile in the Message List

- You can show or hide the sender's profile in the conversation message list using the `showSenderProfile` property in the AIAgentMessenger.config.conversation.list.

**Example**
```swift
AIAgentMessenger.config.conversation.list.shouldShowSenderProfile = false
```
- `shouldShowSenderProfile` = true → Displays the sender's profile image next to each message (default).
- `shouldShowSenderProfile` = false → Hides the sender's profile image in the message list.
