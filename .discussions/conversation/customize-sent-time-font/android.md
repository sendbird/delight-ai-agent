[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Customizing the Font Style or Color

This guide explains how to customize the appearance and layout of message bubbles in the Delight AI Agent Android SDK, including sent time styling.

## Overview

The AI Agent SDK provides message containers that handle by message alignments:

- **OtherMessageContainer**: Messages from other members (left-aligned)
- **MyMessageContainer**: Messages from current user (right-aligned)

Each container provides overridable methods to customize individual UI components.

## Message Container Types

**Step 1: OtherMessageContainer (Left-aligned)**
Used for messages from other participants in the conversation.

**Available customization methods:**
- `drawSentAt(textView: TextView, message: BaseMessage, messageUIParams: MessageUIParams)`

**Step 2: MyMessageContainer (Right-aligned)**
Used for messages sent by the current user.

**Available customization methods:**
- `drawSentAt(textView: TextView, message: BaseMessage, messageUIParams: MessageUIParams)`
ConversationMessageListUIParams)`

**Available customization methods:**
- `initialize(contentView: View, eventListeners: MessageEventListeners, messageListUIParams: ConversationMessageListUIParams, messageType: MessageType)`
- `draw(channel: GroupChannel, message: BaseMessage, messageUIParams: MessageUIParams, messageListUIParams: ConversationMessageListUIParams)`

## Implementation Guide

**Step 1: Create Custom Message Container**

Create a custom container class that extends the appropriate base container:

```kotlin
class CustomOtherMessageContainer(context: Context) : OtherMessageContainer(context) {
    private val appContext = context

    override fun drawSentAt(textView: TextView, message: BaseMessage, messageUIParams: MessageUIParams) {
        super.drawSentAt(textView, message, messageUIParams)

        // Customize sent time appearance
        textView.setTextColor(Color.BLUE)
        textView.textSize = 12f
    }
}
```

**Step 2: Create Custom Message Container Generator**

Implement a custom generator to use your custom containers:

```kotlin
class CustomMessageContainerGenerator(
    private val generator: MessageContainerGenerator
) : MessageContainerGenerator {

    override fun generate(context: Context, containerType: MessageContainerType): MessageContainerContract {
        return when (containerType) {
            MessageContainerType.LEFT -> CustomOtherMessageContainer(context)
            MessageContainerType.RIGHT -> CustomMyMessageContainer(context)
            else -> generator.generate(context, containerType)
        }
    }
}
```

**Step 3: Apply Custom Generator**

Apply your custom generator to the conversation adapter:

```kotlin
// In your activity or fragment
AIAgentAdapterProviders.conversation = ConversationAdapterProvider { channel, uiParams, generator ->
    ConversationMessageListAdapter(
        channel,
        uiParams,
        CustomMessageContainerGenerator(generator)
    )
}
```
