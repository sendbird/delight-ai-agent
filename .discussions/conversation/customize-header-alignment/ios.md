[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

### Changing titleView alignment in Conversation Header

This guide explains how to change the alignment of the titleView in the **Conversation Header** in the conversation message list.

- You can set the alignment of the conversation header titleView using the `contentAlignment` property in the AIAgentMessenger.config.conversation.header.

**Example:**

```swift
AIAgentMessenger.config.conversation.header.contentAlignment = .center
```
Explanation:
- `contentAlignment` = .leading → Leading-aligns the titleView in the header (default).
- `contentAlignment` = .center → Center-aligns the titleView in the header.
- `contentAlignment` = .trailing → Trailing-aligns the titleView in the header.
