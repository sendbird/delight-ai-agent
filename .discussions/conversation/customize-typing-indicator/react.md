[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.21.0-grey.svg?style=flat-square)]()

## How to customize the typing indicator appearance in the conversation

You can customize the typing indicator by replacing the `TypingIndicator` component using `IncomingMessageLayout`.

**Step 1: Create a Custom TypingIndicator Component**

```tsx
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomTypingIndicator = ({ thinkingMessage }: IncomingMessageProps) => {
  if (thinkingMessage) {
    return (
      <div style={{
        padding: '12px',
        color: '#7C3AED',
      }}>
        {thinkingMessage}
      </div>
    );
  }

  return (
    <div style={{
      backgroundColor: '#F3E8FF',
      padding: '12px',
      borderRadius: '12px',
      color: '#7C3AED',
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
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.TypingIndicator component={CustomTypingIndicator} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The `TypingIndicator` component is part of `IncomingMessageLayout`
- The default typing indicator shows three animated dots
