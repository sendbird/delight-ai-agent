[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## Customizing the Layout and Components of Message Bubbles

This guide explains how to customize the position and appearance of elements like senderName, sentTime, and senderAvatar in message bubbles using the Delight AI Agent React SDK.

### Customizing the Entire Layout (Custom Template)

You can fully control the arrangement and structure of message bubble elements by providing your own template to the existing layout system.

**Step 1: Create a Custom Message Template**

```tsx
// src/components/CustomIncomingMessageTemplate.tsx
import React from 'react';
import { IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

export function CustomIncomingMessageTemplate(props: IncomingMessageProps) {
  const { components } = IncomingMessageLayout.useContext();

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
      {/* Top row: Sender name and time */}
      <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', gap: '8px' }}>
        <components.SenderName {...props} />
        <components.SentTime {...props} />
      </div>

      {/* Middle row: Avatar and message body */}
      <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'flex-start', gap: '8px' }}>
        <components.SenderAvatar {...props} />
        <components.MessageBody {...props} />
      </div>
    </div>
  );
}
```

**Step 2: Apply the Custom Template**

```tsx
// src/App.tsx
import { FixedMessenger, IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';
import { CustomIncomingMessageTemplate } from './components/CustomIncomingMessageTemplate';

function App() {
  return (
    <FixedMessenger appId="YOUR_APP_ID" aiAgentId="YOUR_AI_AGENT_ID">
      <IncomingMessageLayout.Template template={CustomIncomingMessageTemplate} />
    </FixedMessenger>
  );
}
```
