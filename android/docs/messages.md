# Messages

In Delight AI agent messenger, AI agent and users can exchange various types of messages to enable rich and interactive conversations, including text, images, files, and rich template-based messages. It allows users to have comprehensive and engaging conversations with AI agents across different use cases.

This guide explains:

- [Messages](#messages)
  - [Types](#types)
    - [Text Message](#text-message)
    - [Image Message](#image-message)
    - [File Message](#file-message)
    - [Rich Message](#rich-message)
      - [Call to Action (CTA) button](#call-to-action-cta-button)
      - [Carousel](#carousel)
      - [Suggested replies](#suggested-replies)
      - [CSAT Message](#csat-message)
      - [Product List](#product-list)
  - [Key features](#key-features)
    - [Read receipt](#read-receipt)
    - [Citation](#citation)
    - [Special notice](#special-notice)
  - [API reference](#api-reference)

---

## Types

Delight AI agent messenger supports various message types to provide comprehensive communication capabilities between users and AI agents. Each message type is designed for specific use cases and content formats.

|  Type | Description | Content format | Use cases |
|-------------|------------|----------------|-----------|
| [Text message](#text-message) | Regular text-based communication | Plain text | Basic conversational interactions, Q&A, general dialogue |
| [Image message](#image-message) | Visual file sharing | Image files in `PNG` and `JPG` only | Visual communication, screenshots, diagrams |
| [File message](#file-message) | Document and file sharing | Various file formats | Document sharing, attachments, downloadable resources |
| [Rich message](#rich-message)| Template-based messages with interactive UI | Structured JSON templates | Product displays, carousels, CTAs and more. See below section for details. |


### Text Message

**Text Message** represents regular text-based communication between users and AI agents. These messages support plain text content and are the foundation of conversational interactions.

- Content: Plain text messages. Markdown supported.
- Use case: Basic conversational interactions.
- Support: Full text rendering with proper formatting.

### Image Message

**Image Message** enables sharing of image files within conversations. This message type supports common image formats for visual communication.

- Supported formats: `JPEG`, `PNG` only. Can be sent with text.
- Use case: Sharing visual content.
- Display: Optimized image rendering with proper scaling.

<img width="362" height="641" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-image-message.png" />

>__Note__: However, once handed off to a human agent, users can send image files in any format.

### File Message

**File Message** allows sharing of various file formats within conversations, enabling sharing document and resource between users and AI agents.

- Supported formats: `PDF` only. Can be sent with text.
- Use case: Document sharing and file-based communication.
- Display: File preview with download capabilities.

<img width="363" height="645" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-file-message.png" />

### Rich Message

**Rich Message** utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

#### Call to Action (CTA) button

**CTA** messages contain a button that allows users to take specific actions directly from the conversation interface. In the Delight AI messenger, the button opens the specified external URL in a web browser.

- Components: A single button that links to an external webpage. Custom link formats are not supported.
- Use case: Action-oriented user interactions.
- Configuration: Available through dashboard template configuration.

<img width="363" height="641" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-cta.png" />

#### Carousel

**Carousel** messages present multiple items that can be horizontally scrolled. This allows users to browse through various options or content pieces in a compact format.

- Layout: Horizontal scrolling interface.
- Content: Multiple items with individual interactions.
- Use case: Product showcases, option selection, content browsing.

<img width="361" height="641" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-carousel.png" />

#### Suggested replies

**Suggested replies** provide predefined quick responses for users, enabling faster and more efficient conversation flow by offering common response options.

- Functionality: Quick response selection.
- Use case: Streamlined user interactions and faster response times.
- Display: Accessible quick reply buttons.

<img width="360" height="639" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies.png" />

#### CSAT Message

**CSAT Message** is designed to collect user feedback for customer satisfaction (CSAT) survey within conversations.

- Purpose: Customer satisfaction measurement.
- Components: Rating systems and feedback collection.
- Use case: Service quality assessment and user experience evaluation.

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-csat.png" />

#### Product List

**Product List** messages display product information in a vertical scrolling format, different from Carousel with its vertical layout optimized for product browsing and selection.

- Layout: Vertical scrolling interface.
- Content: Product information and details.
- Use case: E-commerce integration, product showcases, inventory display.

<img width="360" height="639" alt="cascade" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-product-list.png" />

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

### Citation

**Citation** feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

- Default: Disabled by default.
- Configuration: Requires dashboard configuration to be displayed.
- Activation settings: Adjustable through dashboard configuration values.

<img width="359" height="643" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-citation.png" />

### Special notice

**Special Notice** displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

- Display location: Bottom of the screen.
- Behavior: Automatically disappears when a conversation starts.
- Configuration: Available through dashboard configuration.

<img width="359" height="799" alt="special_notice" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-special-notice.png" />

---

## API reference

The following table provides comprehensive API reference information for message-related functionality:

### ConversationConfig

The `ConversationConfig` class provides configuration options for the conversation screen, organized into two sub-configurations: `header` and `list`.

#### ConversationConfig.Header

The following table lists the configuration options for the conversation header component.

| Property Name | Description | Default Value |
|--------------|-------------|---------------|
| `shouldShowProfile` | A boolean flag indicating whether the profile should be shown in the conversation header | `true` |

```kotlin
// Hide profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = false

// Show profile in conversation header
AIAgentMessenger.config.conversation.header.shouldShowProfile = true
```

#### Configuration properties

The following table lists the configuration options available in `AIAgentMessenger.config.conversation.list` besides read receipt. 
These options control how the conversation list and messages are displayed in the messenger UI.

| Property | Type | Default | Description |
|---|---|---|---|
| `enableMessageReceiptState` | Boolean | `true` | Whether to display message receipt status |
| `shouldShowSenderProfile` | Boolean | `true` | Whether to show sender's profile information |
| `shouldShowProfile` | Boolean | `true` | Whether profile should be shown in header |
