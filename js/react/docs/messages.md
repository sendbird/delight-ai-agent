# Messages

In Delight AI agent messenger, AI agent and users can exchange various types of messages to enable rich and interactive conversations, including text, images, files, and rich template-based messages. It allows users to have comprehensive and engaging conversations with AI agents across different use cases.

This guide explains:
- [Types](#types)
    - [Text message](#text-message)
    - [Image message](#image-message)
    - [File message](#file-message)
    - [Rich message](#rich-message)
- [Key features](#key-features)
    - [Citation](#citation)
    - [Special notice](#special-notice)

---

## Types

Delight AI agent messenger supports various message types to provide comprehensive communication capabilities between users and AI agents. Each message type is designed for specific use cases and content formats.

|  Type | Description | Content format | Use cases |
|-------------|------------|----------------|-----------|
| [Text message](#text-message) | Regular text-based communication | Plain text | Basic conversational interactions, Q&A, general dialogue |
| [Image message](#image-message) | Visual file sharing | Image files in `PNG` and `JPG` only | Visual communication, screenshots, diagrams |
| [File message](#file-message) | Document and file sharing | Various file formats | Document sharing, attachments, downloadable resources |
| [Rich message](#rich-message)| Template-based messages with interactive UI | Structured JSON templates | Product displays, carousels, CTAs and more. See below section for details. |


### Text message

**Text message** represents regular text-based communication between users and AI agents. These messages support plain text content and are the foundation of conversational interactions.

- Content: Plain text messages. Markdown supported.
- Use case: Basic conversational interactions.
- Support: Full text rendering with proper formatting.

### Image message

**Image message** enables sharing of image files within conversations. This message type supports common image formats for visual communication.

- Supported formats: `JPEG`, `PNG` only. Can be sent with text.
- Use case: Sharing visual content.
- Display: Optimized image rendering with proper scaling.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-image-message.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

>__Note__: However, once handed off to a human agent, users can send image files in any format.

### File message

**File message** allows sharing of various file formats within conversations, enabling sharing document and resource between users and AI agents.

- Supported formats: `PDF` only. Can be sent with text.
- Use case: Document sharing and file-based communication.
- Display: File preview with download capabilities.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-file-message.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Rich message

**Rich message** utilizes predefined templates to create interactive and visually appealing message experiences. These templates are configurable through the Delight AI dashboard settings and provide enhanced user interaction.

#### Call to Action (CTA) button

**CTA** messages contain a button that allows users to take specific actions directly from the conversation interface. In the Delight AI messenger, the button opens the specified external URL in a web browser.

- Components: A single button that links to an external webpage. Custom link formats are not supported.
- Use case: Action-oriented user interactions.
- Configuration: Available through dashboard template configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-cta.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Carousel

**Carousel** messages present multiple items that can be horizontally scrolled. This allows users to browse through various options or content pieces in a compact format.

- Layout: Horizontal scrolling interface.
- Content: Multiple items with individual interactions.
- Use case: Product showcases, option selection, content browsing.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-carousel.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Suggested replies

**Suggested replies** provide predefined quick responses for users, enabling faster and more efficient conversation flow by offering common response options.

- Functionality: Quick response selection.
- Use case: Streamlined user interactions and faster response times.
- Display: Accessible quick reply buttons.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-suggested-replies.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### CSAT message

**CSAT message** is designed to collect user feedback for customer satisfaction (CSAT) survey within conversations.

- Purpose: Customer satisfaction measurement.
- Components: Rating systems and feedback collection.
- Use case: Service quality assessment and user experience evaluation.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-csat.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

#### Product list

**Product list** messages display product information in a vertical scrolling format, different from Carousel with its vertical layout optimized for product browsing and selection.

- Layout: Vertical scrolling interface.
- Content: Product information and details.
- Use case: E-commerce integration, product showcases, inventory display.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-product-list.png" alt="cascade" width="375">
  <figcaption></figcaption>
</figure>

#### Custom message template

Custom message templates enable Delight AI agent server to send structured data that clients can render with their own UI components. Unlike pre-defined message templates, clients must implement and register components beforehand, enabling business-specific UIs such as coupons, product lists, and reservations.

##### How it works

**Raw response delivery**

- Templates are delivered as raw responses as `custom_message_templates`.
- Client app is responsible for [rendering the UI](#register-custom-component).
- Provides flexibility for business-specific interfaces.

**Multiple templates support**

- `custom_message_templates` is an **array** - a single message can include multiple templates separated by commas.
- Each template can represent different UI components.

**Backward compatibility**

- Client app must [register the custom template](#register-custom-component) as a message component in advance.
- If client app receives unregistered template ID, [display a fallback UI](#a-fallback-ui-for-unregistered-template).
- This ensures app doesn't break with unknown templates.

##### Data structure

The interface for `custom_message_templates` is defined as `CustomMessageTemplateData`.

```typescript
interface CustomMessageTemplateData {
  id: string;
  response: {
    status: number;
    content: string | null;
  };
  error: string | null;
}
interface ExtendedMessagePayload {
  // ... other fields
  custom_message_templates: CustomMessageTemplateData[];
}
```

| Property | Type | Description |
|----------|------|-------------|
| id | string | Specifies the unique ID of the custom message template. Make sure it is an exact match with the ID you've set in Delight AI agent dashboard. |
| response.status | number | Indicates the HTTP request status. |
| response.content | JSON string | Specifies the content of the message. |
| error | string | Specifies the reason why the request failed if it failed. |

**Sample JSON payload**

The client app will receive a JSON payload of `custom_message_templates` like below:

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

##### How to implement {#register-custom-component}

To render a custom message template, you must:

1) understand message component layout;

2) register a custom component;

3) process the template data.

**1) Message component layout**

Custom templates are rendered in a dedicated slot within the message structure. Understanding a message layout helps you see where your custom component will appear:

```xml
<MessageBubble>
  <Message />
  <CTAButton />
  <Citation />
</MessageBubble>

<MessageTemplate />

<!-- Place CustomMessageTemplate here -->
<CustomMessageTemplateSlot />

<Feedback />
<SuggestedReplies />
```

**2) Register a custom message template**

Register your custom message template as `IncomingMessageLayout.MessageTemplate` under `AgentProviderContainer`. In the following snippet, you'll register `MyCustomMessageTemplate` as a component.

{% hint style="info" %}
If you don't register a custom component, this template slot renders nothing by default.
{% endhint %}

```typescript
import { AgentProviderContainer, IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';

<AgentProviderContainer {...props}>
  <IncomingMessageLayout.CustomMessageTemplate component={MyCustomMessageTemplate} />
</AgentProviderContainer>;
```

**3) Render with `CustomMessageTemplateData`**

Your custom component receives `extendedMessagePayload` which contains the `custom_message_templates` array. You can retrieve the data to render the message. Here's how to access and render it:

```typescript
type Props = {
  extendedMessagePayload?: {
    custom_message_templates?: CustomMessageTemplateData[];
  };
};
function MyCustomMessageTemplate({ extendedMessagePayload }: Props) {
  const template = extendedMessagePayload?.custom_message_templates?.[0];

  if (!template) return null;

  const data = JSON.parse(template.response.content ?? '{}');
  return <div>{data.title}</div>;
}
```

##### How to handle a fallback and an error {#a-fallback-ui-for-unregistered-template}

Refer to the snippets in the tabs in the case of exceptions such as:

- Fallback
- API request fail
- Runtime error

{% tabs %}
{% tab title="a) Fallback UI" %}
**a) Fallback UI for unregistered template**

The following snippet demonstrates how to render a fallback UI when an unregistered template ID is passed through. In the SDK for JavaScript, an "Unsupported template" UI will appear against a yellow background.

```typescript
function MyCustomMessageTemplate({ extendedMessagePayload }) {
  const template = extendedMessagePayload?.custom_message_templates?.[0];

  if (!template) return null;

  switch (template.id) {
    case 'coupon_template':
      return <CouponCards data={JSON.parse(template.response.content)} />;
    default:
      return <FallbackUI />;
  }
}

const FallbackUI = () => <div>Unsupported template type</div>;
```
{% endtab %}

{% tab title="b) API fail" %}
**b) Error UI - API call failed**

The following snippet demonstrates how to handle when an API request for a custom template failed.

```typescript
function MyCustomMessageTemplate({ extendedMessagePayload }) {
  const template = extendedMessagePayload?.custom_message_templates?.[0];

  if (!template) return null;

  if (template.error) {
    return <RequestErrorUI />;
  }

  return <CouponCards data={JSON.parse(template.response.content)} />;
}

const RequestErrorUI = () => <div>Please retry later</div>;
```
{% endtab %}

{% tab title="c) Runtime error" %}
**c) Error Boundary - Runtime error**

The following snippet demonstrates how to handle when a runtime error occurs due to unexpected causes such as an API response change.

```typescript
import { ErrorBoundary } from './ErrorBoundary';

function MyCustomMessageTemplate({ extendedMessagePayload }) {
  const template = extendedMessagePayload?.custom_message_templates?.[0];

  if (!template) return null;

  return (
    <ErrorBoundary fallback={<ComponentErrorUI />}>
      <CouponCards data={JSON.parse(template.response.content)} />
    </ErrorBoundary>
  );
}

const ComponentErrorUI = () => <div>Sorry, please contact Admin</div>;
```
{% endtab %}
{% endtabs %}

---

## Key features

The core features supported for messages in Delight AI agent include:

- [Citation](#citation)
- [Special notice](#special-notice)

### Citation

**Citation** feature displays source information of AI agent responses, allowing users to see the references and sources that the AI agent used to generate its responses. This feature provides transparency and credibility to the AI agent's answers.

- Default: Disabled by default.
- Configuration: Requires dashboard configuration to be displayed.
- Activation settings: Adjustable through dashboard configuration values.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-citation.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

### Special notice

**Special notice** displays important information to users before conversation starts. This feature helps communicate important guidelines, terms, or instructions to users at the beginning of their interaction.

- Display location: Bottom of the screen.
- Behavior: Automatically disappears when a conversation starts.
- Configuration: Available through dashboard configuration.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-special-notice.png" alt="special_notice" width="375">
  <figcaption></figcaption>
</figure>
