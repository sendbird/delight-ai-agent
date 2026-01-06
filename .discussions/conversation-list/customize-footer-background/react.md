[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to customize the background color of the Conversation List footer area

You can customize the footer background color by creating a custom `Footer` component.

**Step 1: Create a Custom Footer Component**

```tsx
import { useMessengerContext } from '@sendbird/ai-agent-messenger-react';

const CustomListFooter = () => {
  return (
    <div
      style={{
        backgroundColor: '#FFE5F0',  // Your custom background color (light pink)
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '16px',
        cursor: 'pointer'
      }}
      onClick={() => {
        console.log('Start new conversation');
      }}
    >
      <span style={{
        color: '#333333',
        fontSize: '16px',
        fontWeight: '700'
      }}>
        Talk to Agent
      </span>
    </div>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  ConversationList,
  ConversationListLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <ConversationListLayout.Template>
        <ConversationListLayout.Footer component={CustomListFooter} />
      </ConversationListLayout.Template>

      <ConversationList
        onOpenConversationView={(channelUrl, status) => {
          console.log('Opening conversation:', channelUrl);
        }}
      />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The default footer has the primary color background from the theme
- The footer button text uses the primary contrast content color (white by default)
- The footer includes a "Talk to Agent" button that creates or opens a conversation
