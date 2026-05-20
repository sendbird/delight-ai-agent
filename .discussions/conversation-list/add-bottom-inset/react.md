[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.2.3-grey.svg?style=flat-square)]()

## How to reserve bottom space below the Conversation List

The React SDK does not currently expose a public API for adding padding inside the internal conversation-list scroll container.

If you need space below the conversation list for fixed bottom UI, reserve that space in your host layout and keep the `ConversationList` area sized explicitly.

### Reserve Space Below the Conversation List

```tsx
import { AgentProviderContainer, ConversationList } from '@sendbird/ai-agent-messenger-react';

const BOTTOM_INSET = 80;

function App() {
  return (
    <div style={{ height: '100vh' }}>
      <AgentProviderContainer
        appId={'YOUR_APP_ID'}
        aiAgentId={'YOUR_AI_AGENT_ID'}
        entryStyle={{ width: '100%', height: '100%' }}
      >
        <div style={{ height: `calc(100% - ${BOTTOM_INSET}px)`, minHeight: 0 }}>
          <ConversationList />
        </div>
        <div aria-hidden={true} style={{ height: BOTTOM_INSET }} />
      </AgentProviderContainer>
    </div>
  );
}
```

**Notes:**
- This reserves space below the `ConversationList` area. It does not add padding inside the SDK's internal scroll container.
- `entryStyle` makes the `AgentProviderContainer` entry element fill the host layout instead of using its default fit-content size.
- If you need true scroll-content inset behavior, please file a feature request so the SDK can expose a public list-content padding API.
