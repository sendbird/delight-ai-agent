[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.12.0-grey.svg?style=flat-square)]()

## How to custom profile view visibility

You can control the visibility of profile elements (sender avatar and sender name) for incoming messages.

**Hide the sender avatar (recommended)**

Use the `senderAvatarEnabled` config to hide the avatar AND remove the avatar gutter spacing reserved on the left of the message bubble.

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      config={{
        conversation: {
          senderAvatarEnabled: false,
        },
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Hide the sender name**

There is no dedicated config for the sender name. Replace the `SenderName` slot with an empty component.

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

const HiddenSenderName = () => null;

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.SenderName component={HiddenSenderName} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- Profile elements (avatar and name) only appear on incoming messages.
- Replacing the `SenderAvatar` slot alone hides the avatar visually but the layout still reserves avatar-width padding controlled by `senderAvatarEnabled`. Use the config above to also remove that padding.
