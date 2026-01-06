[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to insert a custom divider between the message list and input field

Wrap the default Footer component with a divider:

```tsx
import { ConversationLayout } from '@sendbird/ai-agent-messenger-react';

const { Footer: DefaultFooter } = ConversationLayout.defaults.components;

const CustomFooter = () => {
  return (
    <div style={{ borderTop: '1px solid #E5E7EB' }}>
      <DefaultFooter />
    </div>
  );
};
```

**Register the Custom Footer:**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  ConversationLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <ConversationLayout.Footer component={CustomFooter} />
      <Conversation />
    </AgentProviderContainer>
  );
}
```
