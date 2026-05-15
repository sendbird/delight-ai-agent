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
      appId="YOUR_APP_ID"
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

Create a custom body component that includes custom views and keeps the SDK list behavior:

```tsx
import { ReactNode } from 'react';
import {
  ConversationListLayout,
  useConversationListContext
} from '@sendbird/ai-agent-messenger-react';

const CustomListBody = (): ReactNode => {
  const { listSource } = useConversationListContext();
  const DefaultBody = ConversationListLayout.defaults.components.Body;

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      {listSource.initialized && listSource.channels.length > 0 && (
        <>
          {/* Custom promotional banner */}
          <div style={{ margin: '16px', padding: '16px', backgroundColor: '#F0FDF4', borderRadius: '8px' }}>
            <h4>🎉 New Feature Available!</h4>
            <p>Try our new AI-powered quick replies feature.</p>
          </div>

          {/* Separator */}
          <div style={{ margin: '16px', textAlign: 'center', borderTop: '1px solid #E5E7EB' }}>
            <span style={{ padding: '0 12px', backgroundColor: 'white' }}>CONVERSATIONS</span>
          </div>
        </>
      )}

      {/* Render the SDK conversation list items */}
      <div style={{ minHeight: 0, flex: 1 }}>
        <DefaultBody />
      </div>
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
      appId="YOUR_APP_ID"
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
