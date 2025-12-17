# Messages

Delight AI agent messenger provides various message types to enable rich and interactive conversations with AI Agents. The messenger supports diverse message formats including text, images, files, and rich template-based messages, allowing users to have comprehensive and engaging conversations with AI agents across different use cases.

This guide explains:
- [Types](#types)
    - [Text message](#text-message)
    - [Image message](#image-message)
    - [File message](#file-message)
    - [Rich message](#rich-message)
- [Key features](#key-features)
    - [Read receipt](#read-receipt)
    - [Citation](#citation)
    - [Special notice](#special-notice)
- [API references](#api-references)

---

## Types

Delight AI agent messenger supports various message types to provide comprehensive communication capabilities between users and AI agents. Each message type is designed for specific use cases and content formats.

| Type                                       | Description                      | Content format                      | Use cases                                                 |
| ------------------------------------------ | -------------------------------- | ----------------------------------- | --------------------------------------------------------- |
| [Text message](messages.md#text-message)   | Regular text-based communication | Plain text                          | Basic conversational interactions, Q\&A, general dialogue |
| [Image message](messages.md#image-message) | Visual file sharing              | Image files in `PNG` and `JPG` only | Visual communication, screenshots, diagrams               |
| [File message](messages.md#file-message)   | Document and file sharing        | Various file formats                | Document sharing, attachments, downloadable resources     |
| [Rich message](messages.md#rich-message)   | Template-based interactive UI    | Structured JSON templates           | Product displays, carousels, forms, interactive elements  |

### Text message

**Text message** represents regular text-based communication between users and AI agents. These messages support plain text content and are the foundation of conversational interactions.

* Content: Plain text messages. Markdown supported.
* Use case: Basic conversational interactions.
* Support: Full text rendering with proper formatting.

### Image message

**Image message** enables sharing of image files within conversations. This message type supports common image formats for visual communication.

* Supported formats: `JPEG`, `PNG` only. Can be sent with text.
* Use case: Sharing visual content.
* Display: Optimized image rendering with proper scaling.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-image-message2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

> **Note**: However, once handed off to a human agent, users can send image files in any format.

### File message

**File message** allows sharing of various file formats within conversations, enabling sharing document and resource between users and AI agents.

* Supported formats: `PDF` only. Can be sent with text.
* Use case: Document sharing and file-based communication.
* Display: File preview with download capabilities.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-file-message2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Rich message

**Rich message** utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

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

#### CSAT message

**CSAT message** is designed to collect user feedback for customer satisfaction (CSAT) survey within conversations.

* Purpose: Customer satisfaction measurement.
* Components: Rating systems and feedback collection.
* Use case: Service quality assessment and user experience evaluation.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-csat2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Product list

**Product list** messages display product information in a vertical scrolling format, different from Carousel with its vertical layout optimized for product browsing and selection.

* Layout: Vertical scrolling interface.
* Content: Product information and details.
* Use case: E-commerce integration, product showcases, inventory display.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-product-list2.png" alt="cascade" width="375">
  <figcaption></figcaption>
</figure>

---

## Key features

The core features supported for messages in Delight AI agent include:

* [Read receipt](messages.md#read-receipt)
* [Citation](messages.md#citation)
* [Special notice](messages.md#special-notice)

### Read receipt

Messages in a conversation can display their read status, indicating when they have been viewed by participants. By default, read status isn't displayed, but it can be enabled through `AIAgentMessenger.config`.

```swift
import SendbirdAIAgentMessenger

// Enable message receipt state
AIAgentMessenger.config.conversation.list.isMessageReceiptStateEnabled = true
```

#### SDK configuration

The read receipt feature can also be controlled through the SDK configuration:

```swift
// Access conversation list configuration
let listConfig = AIAgentMessenger.config.conversation.list

// Enable or disable read receipts
listConfig.isMessageReceiptStateEnabled = true  // Show read receipts
listConfig.isMessageReceiptStateEnabled = false // Hide read receipts
```

When enabled, messages can also display visual indicators as following:

* Sent status
* Read status with timestamp

### Citation

**Citation** feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

* Default: Disabled by default.
* Configuration: Requires dashboard configuration to be displayed.
* Activation settings: Adjustable through dashboard configuration values.

#### Implementation

**Citations** are automatically rendered by the SDK when provided by the AI agent. No additional code is required in your iOS application - the feature is configured entirely through Delight AI dashboard.

When enabled, citations appear as:

* Source links or references.
* Document titles.
* URL references.
* Knowledge base articles.

Citations appear inline within the message content, providing users with source references and additional context for the AI agent's responses. They display as clickable elements that can expand and collapse, with more details about the source.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-citation2.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Special notice

**Special notice** displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

* Display location: Bottom of the screen.
* Behavior: Automatically disappears when a conversation starts.
* Configuration: Available through dashboard configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-special-notice2.png" alt="special_notice" width="375">
  <figcaption></figcaption>
</figure>

#### Usage

Special notices are configured through Delight AI dashboard and automatically displayed by the SDK. The notice appears:

* When conversation screen is first opened.
* Before any messages are sent.
* At the bottom of the conversation view.
* Dismisses automatically when user sends first message.

---

## API references

### SBAConfig.Conversation.List

The following table lists the configuration options that control how the conversation list and messages are displayed in the messenger UI.

| Property                     | Type | Description                                                   |
| ---------------------------- | ---- | ------------------------------------------------------------- |
| `isMessageReceiptStateEnabled` | Bool | Turns on and off message read receipts. (Default: `false`) |

### Message types

The SDK automatically handles different message types without requiring explicit type checking in most cases.

| Type  | Class                      | Description                                      |
| ----- | -------------------------- | ------------------------------------------------ |
| Text  | UserMessage              | Plain text messages.                             |
| Image | FileMessage              | Image files in `JPEG` and `PNG`.                 |
| File  | FileMessage              | Document files in `PDF`.                         |
| Rich  | UserMessage with template | Template-based interactive messages.            |
