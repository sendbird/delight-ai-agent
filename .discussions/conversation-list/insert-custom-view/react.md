[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to insert a custom view into the Conversation List

You can insert custom views (like banners, separators, or information cards) into the conversation list by wrapping the list with custom components or by customizing the list layout.

**Method 1: Add Custom Views Around the List**

Insert custom content before or after the conversation list:

```tsx
import {
  AgentProviderContainer,
  ConversationList
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
        {/* Custom banner above the list */}
        <div style={{ padding: '16px', backgroundColor: '#EEF2FF', textAlign: 'center' }}>
          <p>💬 Welcome to AI Support</p>
        </div>

        {/* Conversation List */}
        <ConversationList
          onOpenConversationView={(channelUrl, status) => {
            console.log('Opening conversation:', channelUrl);
          }}
        />

        {/* Custom footer info */}
        <div style={{ padding: '12px', backgroundColor: '#F9FAFB', textAlign: 'center' }}>
          Average response time: 2 minutes
        </div>
      </div>
    </AgentProviderContainer>
  );
}
```

**Method 2: Custom Body with Injected Content**

**Step 1: Create a Custom Body Component**

Create a custom body component that includes custom views:

```tsx
import { ReactNode } from 'react';
import { useConversationListContext } from '@sendbird/ai-agent-messenger-react';

const CustomListBody = (): ReactNode => {
  const { channels, onClickChannel } = useConversationListContext();

  return (
    <div style={{ flex: 1, overflowY: 'auto' }}>
      {/* Custom promotional banner */}
      <div style={{ margin: '16px', padding: '16px', backgroundColor: '#F0FDF4', borderRadius: '8px' }}>
        <h4>🎉 New Feature Available!</h4>
        <p>Try our new AI-powered quick replies feature.</p>
      </div>

      {/* Separator */}
      <div style={{ margin: '16px', textAlign: 'center', borderTop: '1px solid #E5E7EB' }}>
        <span style={{ padding: '0 12px', backgroundColor: 'white' }}>CONVERSATIONS</span>
      </div>

      {/* Render conversation list items */}
      {channels.map((channel) => (
        <div
          key={channel.url}
          onClick={() => onClickChannel(channel)}
          style={{ padding: '16px', borderBottom: '1px solid #E5E7EB', cursor: 'pointer' }}
        >
          <div>{channel.lastMessage?.message || 'No messages'}</div>
        </div>
      ))}

      {/* Custom empty state */}
      {channels.length === 0 && (
        <div style={{ padding: '48px 24px', textAlign: 'center' }}>
          <div style={{ fontSize: '48px' }}>💬</div>
          <h3>No conversations yet</h3>
          <p>Start a new conversation with our AI agent</p>
        </div>
      )}
    </div>
  );
};
```

**Step 2: Register the Custom Body**

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
        <ConversationListLayout.Body component={CustomListBody} />
      </ConversationListLayout.Template>

      <ConversationList />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- Custom views can include banners, promotions, separators, empty states, etc.
- You can conditionally render custom views based on application state
