[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize message element positions

The React SDK does not expose a granular prop for moving the default sender name, sent time, or sender avatar to a different row inside a message bubble.

For small visual changes, replace the individual element slots. For outer spacing around the whole message, wrap the default template. For exact reordering of the sender name, sent time, and avatar, replace the full message template and re-implement the message branches you need.

### Option 1: Adjust an individual element slot

Use this when you only need to change the element's own styling, spacing, or visibility.

```tsx
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <div
      style={{
        width: '100%',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        whiteSpace: 'nowrap',
        paddingBlock: 4,
        color: '#4F46E5',
      }}
    >
      {sender.nickname}
    </div>
  );
};
```

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.SenderName component={CustomSenderName} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

### Option 2: Add outer spacing around the default message

Wrap `IncomingMessageLayout.defaults.template` and `OutgoingMessageLayout.defaults.template` when you want to move the entire rendered message group without changing the internal sender name, sent time, or avatar order.

```tsx
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { IncomingMessageLayout, OutgoingMessageLayout } from '@sendbird/ai-agent-messenger-react';

const CustomIncomingTemplate = (props: IncomingMessageProps) => {
  const DefaultTemplate = IncomingMessageLayout.defaults.template;
  return (
    <div style={{ paddingInlineStart: 8 }}>
      <DefaultTemplate {...props} />
    </div>
  );
};

const CustomOutgoingTemplate = (props: OutgoingMessageProps) => {
  const DefaultTemplate = OutgoingMessageLayout.defaults.template;
  return (
    <div style={{ paddingInlineEnd: 8 }}>
      <DefaultTemplate {...props} />
    </div>
  );
};
```

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
      <IncomingMessageLayout.Template template={CustomIncomingTemplate} />
      <OutgoingMessageLayout.Template template={CustomOutgoingTemplate} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

### Option 3: Reorder sender name, sent time, and avatar

Exact internal reordering requires a full custom template. A full template owns every message branch it renders.

```tsx
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';

const CustomIncomingTemplate = (props: IncomingMessageProps) => {
  const { components } = IncomingMessageLayout.useContext();

  if (props.isTyping) {
    return <components.TypingIndicator {...props} />;
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, paddingInline: 12 }}>
        <components.SenderName {...props} />
        {props.createdAt && <components.SentTime {...props} />}
      </div>

      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 8, paddingInline: 12 }}>
        <components.SenderAvatar {...props} />
        <components.MessageBody {...props} />
      </div>
    </div>
  );
};
```

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.Template template={CustomIncomingTemplate} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- Option 1 preserves the default message layout and only replaces the selected element.
- Option 2 preserves every default runtime branch, but it only changes the outer position of the whole message group.
- Option 3 is the only public React path for changing the internal element order. The example is intentionally minimal and does not render message templates, custom templates, forms, citations, CTA buttons, feedback, suggested replies, message logs, streaming animation, or default message group spacing.
- For outgoing messages, apply the same full-template ownership model through `OutgoingMessageLayout.Template`.
