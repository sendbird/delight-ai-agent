[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to customize the message bubble max width in the Conversation

You can customize the message bubble maximum width by creating a custom `MessageBody` component that passes the `maxBodyWidth` prop.

**Step 1: Create a Custom MessageBody Component**

Create a custom component that wraps the message content with custom max-width:

```tsx
import { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';

const bubbleStyles = {
  maxWidth: 400; // Your custom max width in pixels (default is 480)
  backgroundColor: '#f8fafc',
  borderRadius: '12px',
  padding: '12px 16px',
  wordBreak: 'break-word'
}

const CustomIncomingMessageBody = (props: IncomingMessageProps) => {
  return (
    <div style={bubbleStyles}>
      {props.message}
    </div>
  );
};

const CustomOutgoingMessageBody = (props: OutgoingMessageProps) => {
  return (
    <div style={bubbleStyles}>
      {props.message}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

Replace the default message body component:

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
  OutgoingMessageLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <IncomingMessageLayout.Template>
        <IncomingMessageLayout.MessageBody component={CustomIncomingMessageBody} />
      </IncomingMessageLayout.Template>

      <OutgoingMessageLayout.Template>
        <OutgoingMessageLayout.MessageBody component={CustomOutgoingMessageBody} />
      </OutgoingMessageLayout.Template>

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The default maximum width is 480px
- Consider responsive design when setting custom widths
