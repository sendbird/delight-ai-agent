## How to customize the time label color in the conversation message

You can customize the time label color by creating a custom `SentTime` component and replacing the default component using the `IncomingMessageLayout` or `OutgoingMessageLayout`.

**Step 1: Create a Custom SentTime Component**

Create a custom component that accepts the `createdAt` prop:

```tsx
import { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomSentTime = ({ createdAt }: Pick<IncomingMessageProps, 'createdAt'>) => {
  return (
    <div style={{
      fontSize: '11px',
      color: '#7A50F2',  // Your custom color
      marginTop: '4px'
    }}>
      {new Date(createdAt).toLocaleTimeString()}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

Use the layout customization API to replace the default `SentTime` component:

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
      {/* Apply custom component for incoming messages */}
      <IncomingMessageLayout.Template>
        <IncomingMessageLayout.SentTime component={CustomSentTime} />
      </IncomingMessageLayout.Template>

      {/* Apply custom component for outgoing messages */}
      <OutgoingMessageLayout.Template>
        <OutgoingMessageLayout.SentTime component={CustomSentTime} />
      </OutgoingMessageLayout.Template>

      <Conversation />
    </AgentProviderContainer>
  );
}
```


**Notes:**
- The `IncomingMessageLayout.SentTime` replaces the time label for incoming (AI agent) messages
- The `OutgoingMessageLayout.SentTime` replaces the time label for outgoing (user) messages
- You can customize the styling, formatting, and content as needed
- The default time label uses the `caption4` typography variant and low emphasis color from the theme
