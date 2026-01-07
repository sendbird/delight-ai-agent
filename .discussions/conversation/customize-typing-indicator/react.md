[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the typing indicator appearance in the conversation

You can customize the typing indicator by replacing the `TypingIndicator` component using `IncomingMessageLayout`.

**Step 1: Create a Custom TypingIndicator Component**

```tsx
import { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomTypingIndicator = (props: IncomingMessageProps) => {
  return (
    <div style={{
      backgroundColor: '#F3E8FF',
      padding: '12px',
      borderRadius: '12px',
      color: '#7C3AED'
    }}>
      ✍️ Typing...
    </div>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <IncomingMessageLayout.Template>
        <IncomingMessageLayout.TypingIndicator component={CustomTypingIndicator} />
      </IncomingMessageLayout.Template>

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The `TypingIndicator` component is part of `IncomingMessageLayout`
- The default typing indicator shows three animated dots
