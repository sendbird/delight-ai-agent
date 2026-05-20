[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## Customizing the Font Style of SentTime (Outgoing & Incoming)

This guide explains how to customize the font style of the SentTime (timestamp) component for both outgoing and incoming message bubbles in the Delight AI Agent React SDK.

### Overview

The SentTime component is rendered as part of both outgoing and incoming message layouts. To customize its font style, you can override the default component with your own custom implementation.

**Step 1: Create a Custom SentTime Component**

```tsx
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { useLocalizationContext } from '@sendbird/ai-agent-messenger-react';

type SentTimeProps = Pick<OutgoingMessageProps, 'createdAt'> | Pick<IncomingMessageProps, 'createdAt'>;

export function CustomSentTime({ createdAt }: SentTimeProps) {
  const { format, stringSet } = useLocalizationContext();

  if (!createdAt) return null;

  return (
    <div
      style={{
        fontFamily: 'Fira Mono, monospace',
        fontSize: '11px',
        fontWeight: 500,
        color: '#FF9500',
      }}
    >
      {format(createdAt, stringSet.DATE_FORMAT__MESSAGE_TIMESTAMP)}
    </div>
  );
}
```

**Step 2: Apply the Custom SentTime Component**

```tsx
// src/App.tsx
import { FixedMessenger, OutgoingMessageLayout, IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';
import { CustomSentTime } from './components/CustomSentTime';

function App() {
  return (
    <FixedMessenger
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <OutgoingMessageLayout.SentTime component={CustomSentTime} />
      <IncomingMessageLayout.SentTime component={CustomSentTime} />
    </FixedMessenger>
  );
}
```
