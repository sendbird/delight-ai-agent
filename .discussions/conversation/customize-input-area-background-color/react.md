[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.14.0-grey.svg?style=flat-square)]()

## How to customize the background color of the message input box

You can customize the message input box background color by passing `theme.colors.messageInput.background` to `AgentProviderContainer`.

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      theme={{
        colors: {
          messageInput: {
            background: '#F2F4F7',
          },
        },
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- `messageInput.background` changes only the message input box background.
- You can also customize `messageInput.text` and `messageInput.placeholderText` in the same `theme.colors.messageInput` object.
