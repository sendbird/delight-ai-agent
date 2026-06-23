# Messages

In Delight AI agent, users and AI agents can exchange various types of messages including text, images, files, and rich template-based messages. This enables interactive conversations across different use cases.

This guide covers:
- [Types](#types)
    - [Text message](#text-message)
    - [Image message](#image-message)
    - [File message](#file-message)
    - [Multiple files message](#multiple-files-message)
    - [Rich message](#rich-message)
- [Key features](#key-features)
    - [Read receipt](#read-receipt)
    - [Citation](#citation)
    - [Special notice](#special-notice)
- [API references](#api-references)

---

## Types

Delight AI agent supports the following message types.

| Type                                       | Description                                 | Content format                      | Use cases                                                                  |
| ------------------------------------------ | ------------------------------------------- | ----------------------------------- | -------------------------------------------------------------------------- |
| [Text message](#text-message)   | Regular text-based communication            | Plain text                          | Basic conversational interactions, Q\&A, general dialogue                  |
| [Image message](#image-message) | Visual file sharing                         | Image files in `JPEG` and `PNG` only | Visual communication, screenshots, diagrams                                |
| [File message](#file-message)   | Document and file sharing                   | Various file formats                | Document sharing, attachments, downloadable resources                      |
| [Multiple files message](#multiple-files-message) | Multiple image sharing in a single message | Image files in `JPEG` and `PNG` only | Sharing multiple photos at once |
| [Rich message](#rich-message)   | Template-based messages with interactive UI | Structured JSON templates           | Product displays, carousels, CTAs and more. See below section for details. |

### Text message

Text message represents regular text-based communication between users and AI agents. These messages support plain text content and are the foundation of conversational interactions.

- Content: Plain text messages. Markdown supported.
- Use case: Basic conversational interactions.
- Support: Full text rendering with proper formatting.

### Image message

Image message enables sharing of image files within conversations. This message type supports common image formats for visual communication.

- Supported formats: `JPEG` and `PNG` only. Can be sent with text.
- Use case: Sharing visual content.
- Display: Optimized image rendering with proper scaling.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-image-message2.png" alt="Image message in a conversation" width="375">
</figure>

{% hint style="info" %}
Once handed off to a human agent, users can send image files in any format.
{% endhint %}

### File message

File message allows sharing of various file formats within conversations, enabling the sharing of documents and resources between users and AI agents.

- Supported formats: `PDF` only. Can be sent with text.
- Use case: Document sharing and file-based communication.
- Display: File preview with download capabilities.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-file-message2.png" alt="File message in a conversation" width="375">
</figure>

### Multiple files message

Multiple files message allows users to send multiple image files in a single message. Selected images are displayed in a grid layout within the conversation.

- Supported formats: Images only (`JPEG`, `PNG`). Can be sent with text. Documents must be sent individually.
- Max count: One image by default. The maximum can be adjusted by your Delight representative. Maximum file size is 25 MB per file.
- Display: Grid layout for multiple images.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-sdk-multi-file-message%403x.png" alt="Multiple files message displaying images in a grid layout" width="375">
</figure>

{% hint style="info" %}
By default, only single-file sending is enabled. To enable multiple files message, contact your Delight representative.
{% endhint %}

### Rich message

Rich message utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

#### Call to Action (CTA) button

CTA messages contain a button that allows users to take specific actions directly from the conversation interface. In the Delight AI messenger, the button opens the specified external URL in a web browser.

- Components: A single button that links to an external webpage. Custom link formats are not supported.
- Use case: Action-oriented user interactions.
- Configuration: Available through dashboard template configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-cta2.png" alt="CTA button message in a conversation" width="375">
</figure>

#### Carousel

Carousel messages present multiple items that can be horizontally scrolled. This allows users to browse through various options or content pieces in a compact format.

- Layout: Horizontal scrolling interface.
- Content: Multiple items with individual interactions.
- Use case: Product showcases, option selection, content browsing.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-carousel2.png" alt="Carousel message in a conversation" width="375">
</figure>

#### Suggested replies

Suggested replies provide predefined quick responses for users, enabling faster and more efficient conversation flow by offering common response options.

- Functionality: Quick response selection.
- Use case: Streamlined user interactions and faster response times.
- Display: Accessible quick reply buttons.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies2.png" alt="Suggested replies in a conversation" width="375">
</figure>

#### CSAT message

A **CSAT message** collects user feedback through a customer satisfaction (CSAT) survey within conversations.

- Purpose: Customer satisfaction measurement.
- Components: Rating systems and feedback collection.
- Use case: Service quality assessment and user experience evaluation.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-csat2.png" alt="CSAT survey message in a conversation" width="375">
</figure>

#### Product list

Product list messages display product information in a vertical scrolling format optimized for product browsing and selection, unlike Carousel which uses horizontal scrolling.

- Layout: Vertical scrolling interface.
- Content: Product information and details.
- Use case: E-commerce integration, product showcases, inventory display.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-sdk-mobile-message-product-list.png" alt="Product list message displaying items in a vertical format" width="375">
</figure>

#### Custom message template

Custom message template enables implementation of business-specific UI components beyond pre-defined templates. The Delight AI agent server sends structured data that clients render with their own custom UI components.

##### Core features

- **Data delivery**: Templates arrive as `custom_message_templates` array in the message's `extendedMessagePayload`. Clients handle UI rendering.
- **Multiple templates**: A single message can include multiple templates, each representing different UI elements.
- **Backward compatibility**: Unregistered template IDs trigger fallback UI, preventing application breakage.

##### Data structure

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

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique template identifier matching dashboard configuration. |
| `response.status` | Int | HTTP request status code. |
| `response.content` | String? | Message content payload (JSON string). |
| `error` | String? | Reason for failure, if applicable. |

**Sample JSON payload**

The client receives a JSON payload of `custom_message_templates` like below:

```json
{
  "custom_message_templates": [
    {
      "id": "coupon",
      "response": {
        "status": 200,
        "content": "{\"title\": \"20% Off\", \"code\": \"SAVE20\"}"
      },
      "error": null
    },
    {
      "id": "product-list",
      "response": {
        "status": 404,
        "content": null
      },
      "error": "Failed to fetch products"
    }
  ]
}
```

##### Implementation steps

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

##### Error handling patterns

{% tabs %}
{% tab title="Fallback UI" %}
**Fallback UI for unregistered template**

Return fallback UI for unknown template IDs:

```kotlin
val templateData = data.firstOrNull() ?: return createFallbackView(context)
when (templateData.id) {
    "known_template" -> createKnownTemplate(context, templateData)
    else -> createFallbackView(context)
}
```
{% endtab %}
{% tab title="API fail" %}
**Error UI - API call failed**

Check response status and error field:

```kotlin
val templateData = data.firstOrNull() ?: return createErrorView(context, "No template data")
if (templateData.error != null) return createErrorView(context, templateData.error)
if (templateData.response.status != 200) return createErrorView(context, "API error")
```
{% endtab %}
{% tab title="Runtime error" %}
**Error Boundary - Runtime error**

Wrap handler logic in try-catch. SDK also wraps calls to prevent crashes:

```kotlin
try {
    callback.onViewReady(createView(context, data))
} catch (e: Exception) {
    callback.onViewReady(createFallbackView(context))
}
```
{% endtab %}
{% endtabs %}

#### Challenge

Challenge enables in-chat secure form flows such as identity verification. When the AI agent needs the user to complete a verification step, the Delight AI agent server attaches challenge data to a message and the client renders its own form. After the user submits or cancels, the client reports the result to the server through a dedicated action API. The SDK does not render any default challenge UI.

##### Core features

- **Data delivery**: Challenge arrives as a `challenge` object in the message's `extendedMessagePayload`. The client handles UI rendering.
- **Action API**: Submit and cancel results are reported with `AIAgentMessenger.awaitSendChallengeAction`. The server verifies the result and updates the challenge status.
- **Status updates**: The server updates the challenge `status` on the same message (for example `pending` → `succeeded`). The SDK re-invokes your handler so you can reflect the new state.

##### Data structure

The `Challenge` model and `ChallengeStatus` enum:

```kotlin
data class Challenge(
    val key: String,             // Challenge identifier; decides which form to render
    val requestId: String,       // Server-side request identifier, paired with the submitted data during verification
    val status: ChallengeStatus  // Current status of the challenge
)

enum class ChallengeStatus {
    PENDING,    // Form is exposed and waiting for user input
    SUCCEEDED,  // Server-side verification succeeded
    FAILED,     // Server-side verification failed
    CANCELED,   // User canceled the form
    UNKNOWN     // Unrecognized status delivered by a newer server version
}
```

| Property | Type | Description |
|----------|------|-------------|
| `key` | String | Challenge identifier configured by the customer. The application decides which form to render based on this value. |
| `requestId` | String | Server-side request identifier, paired with the submitted data during verification. |
| `status` | ChallengeStatus | Current status of the challenge. An unrecognized value decodes to `UNKNOWN`. |

**Sample JSON payload**

The client receives a `challenge` object in `extendedMessagePayload` like below:

```json
{
  "challenge": {
    "key": "bjs-cpa",
    "request_id": "req-123456",
    "status": "pending"
  }
}
```

##### Implementation steps

**1. Understand the message layout**

The challenge form renders in a dedicated slot within the message structure, below the custom message template slot.

```
┌──────────────────────────────────────────────────────────┐
│                   <MessageTemplate>                      │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│            <CustomMessageTemplateSlot>                   │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                   <ChallengeSlot>                        │
│             (Place challenge form here)                  │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│                      <Feedback>                          │
└──────────────────────────────────────────────────────────┘
```

**2. Register challenge handler**

Implement `ChallengeViewHandler` and set it in `ConversationMessageListUIParams`. Render the form only while the status is `PENDING`; do not call the callback for challenge keys you do not handle.

```kotlin
class MyChallengeHandler : ChallengeViewHandler {
    override fun onCreateChallengeView(
        context: Context,
        message: BaseMessage,
        challenge: Challenge,
        callback: ChallengeViewCallback
    ) {
        if (challenge.status != ChallengeStatus.PENDING) {
            // Reflect a resolved state (succeeded / failed / canceled) instead of the form.
            callback.onViewReady(createStatusView(context, challenge.status))
            return
        }
        val view = when (challenge.key) {
            "identity_verification" -> createVerificationForm(context, message, challenge)
            else -> return // Render nothing for unknown keys
        }
        callback.onViewReady(view)
    }
}

// Register handler
AIAgentAdapterProviders.conversation =
    ConversationAdapterProvider { channel, uiParams, containerGenerator ->
        uiParams.challengeViewHandler = MyChallengeHandler()
        ConversationMessageListAdapter(
            channel,
            uiParams,
            containerGenerator
        )
    }
```

{% hint style="info" %}
The SDK calls `onCreateChallengeView` every time the message or its challenge content changes (for example a `pending` → `succeeded` status update), so by default a new form view is built on each invocation. The SDK does not cache the view on your behalf — identical challenge values may still warrant a different presentation depending on your app's own state, so the caching policy is left to you. If repeated view creation is a performance concern, cache and reuse your own views in the handler (for example, keyed by `requestId` and `status`) and return the cached instance instead of rebuilding it.
{% endhint %}

**3. Process challenge data**

Access the parsed challenge from the message:

```kotlin
val challenge = message.extendedMessagePayload["challenge"]
// The SDK automatically parses this to a Challenge object for the handler.
```

**4. Send the action result**

When the user submits or cancels the form, report the result with `AIAgentMessenger.awaitSendChallengeAction`. `data` is required for `ChallengeAction.SUBMIT` and may be omitted for `ChallengeAction.CANCEL`. The call suspends until the server acknowledges and returns no payload; the resulting status arrives as a later update to the message.

`data` is an arbitrary `Map<String, Any>` whose contents are defined by your verification flow and the server — the SDK does not interpret it. The `authorization_code` key below is only an example; use whatever fields your server expects for the given challenge.

```kotlin
// On submit
scope.launch {
    try {
        AIAgentMessenger.awaitSendChallengeAction(
            SendChallengeActionParams(
                channelUrl = message.channelUrl,
                key = challenge.key,
                requestId = challenge.requestId,
                action = ChallengeAction.SUBMIT,
                // Keys are defined by your verification flow; this is just an example.
                data = mapOf("authorization_code" to authorizationCode)
            )
        )
    } catch (e: SendbirdException) {
        // Handle the failure (for example, show a retry affordance).
    }
}

// On cancel (no data)
scope.launch {
    AIAgentMessenger.awaitSendChallengeAction(
        SendChallengeActionParams(
            channelUrl = message.channelUrl,
            key = challenge.key,
            requestId = challenge.requestId,
            action = ChallengeAction.CANCEL
        )
    )
}
```

{% hint style="info" %}
The SDK does not retry automatically and does not disable input on its own — the application decides whether to re-show the form. Because the message list recycles views, your handler may be invoked again for the same challenge; preserve any in-progress input outside the view (for example, keyed by `requestId`) if it must survive scrolling. The application owns the accessibility semantics of the form it creates.
{% endhint %}

---

## Key features

The core features supported for messages in Delight AI agent include:

- [Read receipt](#read-receipt)
- [Citation](#citation)
- [Special notice](#special-notice)

### Read receipt

Messages in a conversation can display their read status, indicating when they have been viewed by participants. By default, read status isn't displayed, but it can be enabled through `AIAgentMessenger.config`.

```kotlin
// Enable message receipt state
AIAgentMessenger.config.conversation.list.enableMessageReceiptState = true
```

When enabled, messages display visual indicators for:

- Sent status
- Read status with timestamp

### Citation

The citation feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

- Default: Disabled.
- Configuration: Dashboard only — no additional code required.
- Activation settings: Adjustable through dashboard configuration values.

When enabled, citations are automatically rendered by the SDK. They appear as clickable elements that expand to show source details such as document titles, URL references, and knowledge base articles.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-citation2.png" alt="Citation displayed below an AI agent response" width="375">
</figure>

### Special notice

Special notice displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

- Display location: Bottom of the screen.
- Behavior: Automatically disappears when the user sends their first message.
- Configuration: Available through dashboard configuration.

Special notices are configured through Delight AI dashboard and automatically displayed by the SDK. The notice appears when the conversation screen is first opened, before any messages are sent. It dismisses automatically when the user sends their first message.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-special-notice2.png" alt="Special notice displayed at the bottom of the conversation screen" width="375">
</figure>

---

## API references

### ConversationConfig

The `ConversationConfig` class provides configuration options for the conversation screen, organized into three sub-configurations: `header`, `list`, and `input`.

#### ConversationConfig.Header

The following table lists the configuration options for the conversation header component.

| Property name | Type | Description |
|---------------|------|-------------|
| `shouldShowProfile` | Boolean | Determines whether to show the profile in the conversation header. (Default: `true`) |

```kotlin
// Hide profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = false

// Show profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = true
```

#### ConversationConfig.List

The following table lists the configuration options available in `AIAgentMessenger.config.conversation.list`. For the `enableMessageReceiptState` property, see [Read receipt](#read-receipt).

| Property name | Type | Description |
|---------------|------|-------------|
| `enableMessageReceiptState` | Boolean | Determines whether to display message receipt status. (Default: `false`) |
| `shouldShowSenderProfile` | Boolean | Determines whether to show sender's profile information. (Default: `true`) |
| `scrollMode` | ScrollMode | Scroll behavior of the message list. Acceptable values are `AUTO` for normal scroll and `FIX` to keep user message fixed at the top during AI agent responses. (Default: `ScrollMode.AUTO`) |
| `shouldShowMessageFooterView` | Boolean | Determines whether the **Start new conversation** view is shown when conversation has ended. (Default: `true`) |
| `enableNewMessageIndicator` | Boolean | Determines whether the new message indicator is enabled. (Default: `true`) |

```kotlin
// Configure conversation list settings
AIAgentMessenger.config.conversation.list.enableMessageReceiptState = true
AIAgentMessenger.config.conversation.list.shouldShowSenderProfile = false
AIAgentMessenger.config.conversation.list.scrollMode = ScrollMode.FIX
AIAgentMessenger.config.conversation.list.shouldShowMessageFooterView = false
AIAgentMessenger.config.conversation.list.enableNewMessageIndicator = false
```

#### ConversationConfig.Input

The following table lists the configuration options available in `AIAgentMessenger.config.conversation.input` for the message input component and attachment capabilities.

| Property name | Type | Description |
|---------------|------|-------------|
| `camera.enablePhoto` | Boolean | Determines whether photo capture from camera is enabled. (Default: `true`) |
| `gallery.enablePhoto` | Boolean | Determines whether photo selection from gallery is enabled. (Default: `true`) |
| `enableFile` | Boolean | Determines whether file attachment is enabled. (Default: `true`) |

```kotlin
// Configure input settings
AIAgentMessenger.config.conversation.input.camera.enablePhoto = false
AIAgentMessenger.config.conversation.input.gallery.enablePhoto = false
AIAgentMessenger.config.conversation.input.enableFile = false
```