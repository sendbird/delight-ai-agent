[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.8.0-grey.svg?style=flat-square)]()

## How to customize the message bubble max width in the Conversation

You can customize the message bubble maximum width by overriding the `IncomingMessageLayout.Template` and `OutgoingMessageLayout.Template` with wrappers that pass a custom `maxBodyWidth` to the default templates. This preserves the default rendering of text, files, media, message templates, forms, citations, and feedback while only changing the bubble width.

**Step 1: Create Custom Template Wrappers**

```tsx
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { IncomingMessageLayout, OutgoingMessageLayout } from '@sendbird/ai-agent-messenger-react';

const CUSTOM_MAX_BODY_WIDTH = 400;

const CustomIncomingMessageTemplate = (props: IncomingMessageProps) => {
  const DefaultTemplate = IncomingMessageLayout.defaults.template;
  return <DefaultTemplate {...props} maxBodyWidth={CUSTOM_MAX_BODY_WIDTH} />;
};

const CustomOutgoingMessageTemplate = (props: OutgoingMessageProps) => {
  const DefaultTemplate = OutgoingMessageLayout.defaults.template;
  return <DefaultTemplate {...props} maxBodyWidth={CUSTOM_MAX_BODY_WIDTH} />;
};
```

**Step 2: Apply the Custom Templates**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
  OutgoingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.Template template={CustomIncomingMessageTemplate} />
      <OutgoingMessageLayout.Template template={CustomOutgoingMessageTemplate} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The default maximum width is 244px.
- `maxBodyWidth` is a public prop on `IncomingMessageProps` and `OutgoingMessageProps`. Passing it to the default template applies to text bubbles, the inline-extras bubble surface (CTA/citations), and form containers. Media, image grid, and file preview paths keep the SDK-defined sizing.
- Consider responsive design when setting custom widths.
