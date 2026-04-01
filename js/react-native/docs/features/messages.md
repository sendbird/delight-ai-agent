# Messages

In Delight AI agent messenger, AI agent and users can exchange various types of messages to enable rich and interactive conversations, including text, images, files, and rich template-based messages. It allows users to have comprehensive and engaging conversations with AI agents across different use cases.

---

## Types

Delight AI agent messenger supports various message types to provide comprehensive communication capabilities between users and AI agents. Each message type is designed for specific use cases and content formats.

| Type                                       | Description                                 | Content format                      | Use cases                                                                  |
| ------------------------------------------ | ------------------------------------------- | ----------------------------------- | -------------------------------------------------------------------------- |
| [Text message](messages.md#text-message)   | Regular text-based communication            | Plain text                          | Basic conversational interactions, Q\&A, general dialogue                  |
| [Image message](messages.md#image-message) | Visual file sharing                         | Image files in `PNG` and `JPG` only | Visual communication, screenshots, diagrams                                |
| [File message](messages.md#file-message)   | Document and file sharing                   | Various file formats                | Document sharing, attachments, downloadable resources                      |
| [Multiple files message](messages.md#multiple-files-message) | Multiple image sharing in a single message | Image files in `JPEG` and `PNG` only | Sharing multiple photos at once |
| [Rich message](messages.md#rich-message)   | Template-based messages with interactive UI | Structured JSON templates           | Product displays, carousels, CTAs and more. See below section for details. |

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

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-image-message2.png)

> **Note**: However, once handed off to a human agent, users can send image files in any format.

### File message

**File message** allows sharing of various file formats within conversations, enabling sharing document and resource between users and AI agents.

* Supported formats: `PDF` only. Can be sent with text.
* Use case: Document sharing and file-based communication.
* Display: File preview with download capabilities.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-file-message2.png)

### Multiple files message

**Multiple files message** allows users to send multiple image files in a single message. Selected images are displayed in a grid layout within the conversation.

* Supported formats: Images only (`JPEG`, `PNG`). Can be sent with text. Documents and videos must be sent individually.
* Max count: One image by default. The maximum can be adjusted by your Delight representative. Maximum file size is 300 MB per file.
* Display: Grid layout for multiple images.

<figure><img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-sdk-multi-file-message%403x.png" alt="" width="375"><figcaption></figcaption></figure>

> **Note**: By default, only single-file sending is enabled. To enable multiple files message, contact your Delight representative.

### Rich message

**Rich message** utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

#### Call to Action (CTA) button

**CTA** messages contain a button that allows users to take specific actions directly from the conversation interface. In the Delight AI messenger, the button opens the specified external URL in a web browser.

* Components: A single button that links to an external webpage. Custom link formats are not supported.
* Use case: Action-oriented user interactions.
* Configuration: Available through dashboard template configuration.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-cta2.png)

#### Carousel

> **Note**: **This feature is not yet supported in React Native and will be available in a future release.**

**Carousel** messages present multiple items that can be horizontally scrolled. This allows users to browse through various options or content pieces in a compact format.

* Layout: Horizontal scrolling interface.
* Content: Multiple items with individual interactions.
* Use case: Product showcases, option selection, content browsing.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-carousel2.png)

#### Suggested replies

**Suggested replies** provide predefined quick responses for users, enabling faster and more efficient conversation flow by offering common response options.

* Functionality: Quick response selection.
* Use case: Streamlined user interactions and faster response times.
* Display: Accessible quick reply buttons.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-suggested-replies2.png)

#### CSAT message

**CSAT message** is designed to collect user feedback for customer satisfaction (CSAT) survey within conversations.

* Purpose: Customer satisfaction measurement.
* Components: Rating systems and feedback collection.
* Use case: Service quality assessment and user experience evaluation.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-csat2.png)

---

## Key features

The core features supported for messages in Delight AI agent include:

* [Citation](messages.md#citation)
* [Special notice](messages.md#special-notice)

### Citation

**Citation** feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

* Default: Disabled by default.
* Configuration: Requires dashboard configuration to be displayed.
* Activation settings: Adjustable through dashboard configuration values.

![](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-citation2.png)

### Special notice

**Special notice** displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

* Display location: Bottom of the screen.
* Behavior: Automatically disappears when a conversation starts.
* Configuration: Available through dashboard configuration.

![special\_notice](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-mobile-special-notice2.png)