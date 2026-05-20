[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the time label color in the conversation message

You can customize the time label color by creating a custom `SentTime` component and replacing the default component using the `IncomingMessageLayout` or `OutgoingMessageLayout`.

**Step 1: Create a Custom SentTime Component**

Create a custom component that accepts the `createdAt` prop:

```tsx
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { useLocalizationContext } from '@sendbird/ai-agent-messenger-react';

type SentTimeProps = Pick<IncomingMessageProps, 'createdAt'> | Pick<OutgoingMessageProps, 'createdAt'>;

const CustomSentTime = ({ createdAt }: SentTimeProps) => {
  const { format, stringSet } = useLocalizationContext();

  if (!createdAt) return null;

  return (
    <div style={{
      fontSize: '11px',
      color: '#7A50F2',  // Your custom color
      marginTop: '4px'
    }}>
      {format(createdAt, stringSet.DATE_FORMAT__MESSAGE_TIMESTAMP)}
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
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.SentTime component={CustomSentTime} />
      <OutgoingMessageLayout.SentTime component={CustomSentTime} />

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
- The example uses `useLocalizationContext()` to keep the SDK's localized timestamp format while changing only the style
