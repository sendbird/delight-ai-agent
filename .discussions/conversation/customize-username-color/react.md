[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the user name color in the conversation message

You can customize the sender name color by creating a custom `SenderName` component and replacing it using `IncomingMessageLayout`.

**Step 1: Create a Custom SenderName Component**

Create a custom component that accepts the `sender` prop:

```tsx
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <div style={{
      width: '100%',
      fontSize: '13px',
      fontWeight: '600',
      color: '#7A50F2',  // Your custom color
      marginBottom: '4px',
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      whiteSpace: 'nowrap'
    }}>
      {sender.nickname}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

Use the layout customization API to replace the default `SenderName` component:

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

**Notes:**
- The sender name only appears on incoming (AI agent) messages, not outgoing user messages
- The default sender name uses the `caption1` typography variant and mid emphasis color from the theme
- Add truncation styles when replacing `SenderName`; otherwise long names can overflow the message row
- You can add additional styling like text transform, letter spacing, or icons
