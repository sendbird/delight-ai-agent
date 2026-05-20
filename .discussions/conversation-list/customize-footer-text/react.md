[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the footer text in the Conversation List

You can customize the footer button text through the localization string set. This keeps the default footer behavior that creates or opens a conversation.

```tsx
import {
  AgentProviderContainer,
  ConversationList,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      stringSet={{
        TALK_TO_AGENT: 'Start New Chat',
      }}
    >
      <ConversationList
        onOpenConversationView={(channelUrl, status) => {
          console.log('Opening conversation:', channelUrl, status);
        }}
      />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The default text is `Start a conversation`.
- The string key is `TALK_TO_AGENT` in the React string set.
- Use a custom `Footer` component only when you need to own the full create, open, and navigation behavior yourself.
