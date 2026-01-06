[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to custom profile view visibility

You can control the visibility of profile elements (sender avatar and sender name) by conditionally rendering custom components.

**Hide Profile Elements Using Custom Components**

Create empty components to hide specific profile elements:

```tsx
// Hide sender avatar
const HiddenSenderAvatar = () => null;

// Hide sender name
const HiddenSenderName = () => null;
```

Then register them:

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
        {/* Hide sender avatar */}
        <IncomingMessageLayout.SenderAvatar component={HiddenSenderAvatar} />

        {/* Hide sender name */}
        <IncomingMessageLayout.SenderName component={HiddenSenderName} />
      </IncomingMessageLayout.Template>

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- Profile elements (avatar and name) only appear on incoming messages
- The avatar and name visibility is controlled by the message grouping logic by default
