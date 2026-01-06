[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to add bottom inset to the ListView in the Conversation List

You can add bottom padding or inset to the conversation list by customizing the list body or using CSS.

**Method 1: Using Custom Body Component with Padding**

Create a custom body component with bottom padding:

```tsx
import { ReactNode } from 'react';

const ListBodyWithInset = (): ReactNode => {
  return (
    <div style={{ flex: 1, overflowY: 'auto', paddingBottom: '80px' }}>
      {/* List items will be rendered here by the default implementation */}
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
        <ConversationListLayout.Body component={ListBodyWithInset} />
      </ConversationListLayout.Template>

      <ConversationList />
    </AgentProviderContainer>
  );
}
```

**Method 2: Using Wrapper Component**

Wrap the entire list with custom padding:

```tsx
import { ConversationList } from '@sendbird/ai-agent-messenger-react';

function ConversationListWithInset() {
  return (
    <div style={{
      height: '100%',
      display: 'flex',
      flexDirection: 'column'
    }}>
      <ConversationList
        onOpenConversationView={(channelUrl, status) => {
          console.log('Opening conversation:', channelUrl);
        }}
      />

      {/* Bottom spacer */}
      <div style={{ height: '80px', flexShrink: 0 }} />
    </div>
  );
}
```

**Use Case: Bottom Navigation**

Commonly used when you have a fixed bottom navigation or action bar:

```tsx
function App() {
  return (
    <div style={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
      <AgentProviderContainer
        applicationId="YOUR_APP_ID"
        aiAgentId="YOUR_AI_AGENT_ID"
      >
        <div style={{ flex: 1, paddingBottom: '60px' }}>
          <ConversationList />
        </div>
      </AgentProviderContainer>

      {/* Fixed bottom navigation */}
      <div style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        height: '60px',
        backgroundColor: 'white',
        borderTop: '1px solid #E5E7EB',
        display: 'flex',
        justifyContent: 'space-around',
        alignItems: 'center'
      }}>
        <button>Home</button>
        <button>Chats</button>
        <button>Settings</button>
      </div>
    </div>
  );
}
```

**Notes:**
- Bottom insets are useful for avoiding overlap with fixed bottom UI elements
- The default list body has no bottom padding
- Consider safe area insets on mobile devices (iOS notch, etc.)
- Make sure the inset value matches your fixed bottom UI height
