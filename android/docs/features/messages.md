# Messages

In Delight AI agent messenger, AI agent and users can exchange various types of messages to enable rich and interactive conversations, including text, images, files, and rich template-based messages. It allows users to have comprehensive and engaging conversations with AI agents across different use cases.

This guide explains:
- [Types](#types)
    - [Text Message](#text-message)
    - [Image Message](#image-message)
    - [File Message](#file-message)
    - [Rich Message](#rich-message)
- [Key features](#key-features)
    - [Read receipt](#read-receipt)
    - [Citation](#citation)
    - [Special notice](#special-notice)
- [API references](#api-references)

---

## Types

Delight AI agent messenger supports various message types to provide comprehensive communication capabilities between users and AI agents. Each message type is designed for specific use cases and content formats.

| Type                                       | Description                                 | Content format                      | Use cases                                                                  |
| ------------------------------------------ | ------------------------------------------- | ----------------------------------- | -------------------------------------------------------------------------- |
| [Text message](messages.md#text-message)   | Regular text-based communication            | Plain text                          | Basic conversational interactions, Q\&A, general dialogue                  |
| [Image message](messages.md#image-message) | Visual file sharing                         | Image files in `PNG` and `JPG` only | Visual communication, screenshots, diagrams                                |
| [File message](messages.md#file-message)   | Document and file sharing                   | Various file formats                | Document sharing, attachments, downloadable resources                      |
| [Rich message](messages.md#rich-message)   | Template-based messages with interactive UI | Structured JSON templates           | Product displays, carousels, CTAs and more. See below section for details. |

### Text Message

**Text Message** represents regular text-based communication between users and AI agents. These messages support plain text content and are the foundation of conversational interactions.

* Content: Plain text messages. Markdown supported.
* Use case: Basic conversational interactions.
* Support: Full text rendering with proper formatting.

### Image Message

**Image Message** enables sharing of image files within conversations. This message type supports common image formats for visual communication.

* Supported formats: `JPEG`, `PNG` only. Can be sent with text.
* Use case: Sharing visual content.
* Display: Optimized image rendering with proper scaling.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-image-message2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

> **Note**: However, once handed off to a human agent, users can send image files in any format.

### File Message

**File Message** allows sharing of various file formats within conversations, enabling sharing document and resource between users and AI agents.

* Supported formats: `PDF` only. Can be sent with text.
* Use case: Document sharing and file-based communication.
* Display: File preview with download capabilities.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-file-message2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Rich Message

**Rich Message** utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

#### Call to Action (CTA) button

**CTA** messages contain a button that allows users to take specific actions directly from the conversation interface. In the Delight AI messenger, the button opens the specified external URL in a web browser.

* Components: A single button that links to an external webpage. Custom link formats are not supported.
* Use case: Action-oriented user interactions.
* Configuration: Available through dashboard template configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-cta2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Carousel

**Carousel** messages present multiple items that can be horizontally scrolled. This allows users to browse through various options or content pieces in a compact format.

* Layout: Horizontal scrolling interface.
* Content: Multiple items with individual interactions.
* Use case: Product showcases, option selection, content browsing.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-carousel2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Suggested replies

**Suggested replies** provide predefined quick responses for users, enabling faster and more efficient conversation flow by offering common response options.

* Functionality: Quick response selection.
* Use case: Streamlined user interactions and faster response times.
* Display: Accessible quick reply buttons.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### CSAT Message

**CSAT Message** is designed to collect user feedback for customer satisfaction (CSAT) survey within conversations.

* Purpose: Customer satisfaction measurement.
* Components: Rating systems and feedback collection.
* Use case: Service quality assessment and user experience evaluation.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-csat2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Product List

**Product List** messages display product information in a vertical scrolling format, different from Carousel with its vertical layout optimized for product browsing and selection.

* Layout: Vertical scrolling interface.
* Content: Product information and details.
* Use case: E-commerce integration, product showcases, inventory display.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-sdk-mobile-message-product-list.png" alt="cascade" width="375">
  <figcaption></figcaption>
</figure>

#### Custom message template

**Custom message template** enables implementation of business-specific UI components beyond pre-defined templates. The Delight AI agent server sends structured data that clients render with their own custom UI components.

**Core Features**

- **Data Delivery**: Templates arrive as `custom_message_templates` array in the message's `extendedMessagePayload`. Clients handle UI rendering.
- **Multiple Templates**: A single message can include multiple templates, each representing different UI elements.
- **Backward Compatibility**: Unregistered template IDs trigger fallback UI, preventing application breakage.

**Data Structure**

The `CustomMessageTemplateData` interface structure:

```kotlin
data class CustomMessageTemplateData(
    val id: String,              // Unique template identifier matching dashboard configuration
    val response: Response,
    val error: String?           // Failure reason, if applicable
) {
    data class Response(
        val status: Int,         // HTTP request status code
        val content: String?     // Message content payload (JSON string)
    )
}
```

**Implementation Steps**

**1. Understand the message layout**

Custom templates render in a dedicated slot within the message structure, appearing below the standard message content.
```
┌──────────────────────────────────────────────────────────┐
│                      <MessageBubble>                     │
│   ┌──────────────────────────────────────────────────┐   │
│   │                    <Message>                     │   │
│   └──────────────────────────────────────────────────┘   │
│   ┌──────────────────────────────────────────────────┐   │
│   │                  <CTAButton>                     │   │
│   └──────────────────────────────────────────────────┘   │
│   ┌──────────────────────────────────────────────────┐   │
│   │                  <Citation>                      │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                   <MessageTemplate>                      │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│            <CustomMessageTemplateSlot>                   │
│        (Place CustomMessageTemplate here)                │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                      <Feedback>                          │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                 <SuggestedReplies>                       │
└──────────────────────────────────────────────────────────┘
```

**2. Register custom handler**

Implement `CustomMessageTemplateViewHandler` and set it in `ConversationMessageListUIParams`:

```kotlin
class MyCustomTemplateHandler : CustomMessageTemplateViewHandler {
    override fun onCreateCustomMessageTemplateView(
        context: Context,
        message: BaseMessage,
        data: List<CustomMessageTemplateData>,
        callback: CustomMessageTemplateViewCallback
    ) {
        val view = when (data.firstOrNull()?.id) {
            "product_card" -> createProductCard(context, data.first())
            else -> createFallbackView(context)
        }
        callback.onViewReady(view)
    }

    private fun createProductCard(context: Context, data: CustomMessageTemplateData): View {
        val content = data.response.content ?: return createFallbackView(context)
        return LayoutInflater.from(context).inflate(R.layout.custom_product_card, null).apply {
            // Populate view with data from JSON content
        }
    }

    private fun createFallbackView(context: Context): View {
        return TextView(context).apply {
            text = "Template not available"
            setPadding(16, 16, 16, 16)
        }
    }
}

// Register handler
AIAgentAdapterProviders.conversation =
    ConversationAdapterProvider { channel, uiParams, containerGenerator ->
        uiParams.customMessageTemplateViewHandler = MyCustomTemplateHandler()
        ConversationMessageListAdapter(
            channel,
            uiParams,
            containerGenerator
        )
    }
```

**3. Process template data**

Access custom template data from the message:

```kotlin
val customTemplates = message.extendedMessagePayload["custom_message_templates"]
// SDK automatically parses this to List<CustomMessageTemplateData>
```

**4. Handle exceptions**

Implement error handling for various failure scenarios:

```kotlin
override fun onCreateCustomMessageTemplateView(
    context: Context,
    message: BaseMessage,
    data: List<CustomMessageTemplateData>,
    callback: CustomMessageTemplateViewCallback
) {
    try {
        // Check for errors in data
        val templateData = data.firstOrNull()
        if (templateData?.error != null) {
            callback.onViewReady(createErrorView(context, templateData.error))
            return
        }

        // Validate response status
        when (templateData?.response?.status) {
            200 -> callback.onViewReady(createTemplateView(context, templateData))
            else -> callback.onViewReady(createErrorView(context, "Failed to load template"))
        }
    } catch (e: Exception) {
        callback.onViewReady(createErrorView(context, "Template error"))
    }
}
```

**Error Handling Patterns**

**Unregistered templates**: Return fallback UI for unknown template IDs
```kotlin
when (templateData.id) {
    "known_template" -> createKnownTemplate(context, data)
    else -> createFallbackView(context)
}
```

**API failures**: Check response status and error field
```kotlin
if (data.error != null) return createErrorView(context, data.error)
if (data.response.status != 200) return createErrorView(context, "API error")
```

**Runtime errors**: Wrap handler logic in try-catch; SDK also wraps calls to prevent crashes
```kotlin
try {
    callback.onViewReady(createView(context, data))
} catch (e: Exception) {
    callback.onViewReady(createFallbackView(context))
}
```

---

## Key features

The core features supported for messages in Delight AI agent include:

* [Read receipt](messages.md#read-receipt)
* [Citation](messages.md#citation)
* [Special notice](messages.md#special-notice)

### Read receipt

Messages in a conversation can display their read status, indicating when they have been viewed by participants. By default, read status isn't displayed, but it can be enabled through `AIAgentMessenger.config`.

```kotlin
// Enable message receipt state
AIAgentMessenger.config.conversation.list.enableMessageReceiptState = true
```

### Citation

**Citation** feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

* Default: Disabled by default.
* Configuration: Requires dashboard configuration to be displayed.
* Activation settings: Adjustable through dashboard configuration values.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-citation2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Special notice

**Special Notice** displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

* Display location: Bottom of the screen.
* Behavior: Automatically disappears when a conversation starts.
* Configuration: Available through dashboard configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-special-notice2.png" alt="special_notice" width="375">
  <figcaption></figcaption>
</figure>

---

## API references

The following table provides comprehensive API reference information for message-related functionality:

### ConversationConfig

The `ConversationConfig` class provides configuration options for the conversation screen, organized into two sub-configurations: `header` and `list`.

#### ConversationConfig.Header

The following table lists the configuration options for the conversation header component.

| Property Name       | Description                                                                               | Default Value |
| ------------------- | ----------------------------------------------------------------------------------------- | ------------- |
| `shouldShowProfile` | A boolean flag indicating whether the profile should be shown in the conversation header. | `true`        |

```kotlin
// Hide profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = false

// Show profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = true
```

#### ConversationConfig.List

The following table lists the configuration options available in `AIAgentMessenger.config.conversation.list` besides read receipt. These options control how the conversation list and messages are displayed in the messenger UI.

| Property                      | Type       | Default           | Description                                                                                                                     |
|-------------------------------|------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| `enableMessageReceiptState`   | Boolean    | `false`           | Whether to display message receipt status.                                                                                      |
| `shouldShowSenderProfile`     | Boolean    | `true`            | Whether to show sender's profile information.                                                                                   |
| `scrollMode`                  | ScrollMode | `ScrollMode.AUTO` | Scroll behavior of the message list. `AUTO` for normal scroll, `FIX` to keep user message fixed at the top during bot responses |
| `shouldShowMessageFooterView` | Boolean    | `true`            | Whether the "Start new conversation" view is shown when conversation has ended                                                  |
| `enableNewMessageIndicator`   | Boolean    | `true`            | Whether the the new message indicator is enabled                                                                                |

```kotlin
// Configure conversation list settings
AIAgentMessenger.config.conversation.list.enableMessageReceiptState = true
AIAgentMessenger.config.conversation.list.shouldShowSenderProfile = false
AIAgentMessenger.config.conversation.list.scrollMode = ScrollMode.FIX
AIAgentMessenger.config.conversation.list.shouldShowMessageFooterView = false
AIAgentMessenger.config.conversation.list.enableNewMessageIndicator = false
```

#### ConversationConfig.Input

The following table lists the configuration options available in `AIAgentMessenger.config.conversation.input`.
These options control the message input component and attachment capabilities.

| Property               | Type      | Default | Description                                     |
|------------------------|-----------|---------|-------------------------------------------------|
| `camera.enablePhoto`   | Boolean   | `true` | Whether photo capture from camera is enabled    |
| `gallery.enablePhoto`  | Boolean   | `true` | Whether photo selection from gallery is enabled |
| `enableFile`           | Boolean   | `true` | Whether file attachment is enabled              |

```kotlin
// Configure input settings
AIAgentMessenger.config.conversation.input.camera.enablePhoto = false
AIAgentMessenger.config.conversation.input.gallery.enablePhoto = false
AIAgentMessenger.config.conversation.input.enableFile = false
```
