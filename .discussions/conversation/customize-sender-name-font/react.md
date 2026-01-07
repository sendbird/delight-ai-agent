[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## Customizing IncomingMessage SenderName Font Styles

This guide explains how to customize the font style of sender names displayed in IncomingMessage components in the Delight AI Agent React SDK.

## Overview

While global typography customization is possible through the theme system, the recommended approach for customizing sender names is to create a custom SenderName component to avoid unintended side effects on other components.

**Step 1: Create Custom Component**

Create a custom component for precise control over sender name font styling:

```tsx
import { type IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

export const CustomIncomingSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <div
      style={{
        // Custom font styling
        fontWeight: 600,
        fontSize: '14px',
        lineHeight: '18px',
        color: '#aaa',
      }}
    >
      {sender.nickname}
    </div>
  );
};
```

**Step 2: Apply Custom Component**

```tsx
import { FixedMessenger, IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';
import { CustomIncomingSenderName } from './components/CustomIncomingSenderName';

function App() {
  return (
    <FixedMessenger
      appId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <IncomingMessageLayout.SenderName component={CustomIncomingSenderName} />
    </FixedMessenger>
  );
}
```
