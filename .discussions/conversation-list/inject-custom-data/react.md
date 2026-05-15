[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to inject and render custom data in the Conversation List

You can render application-owned custom data in the conversation list by creating a custom list item component and matching your data to each conversation channel.

**Step 1: Prepare Custom Data**

Prepare custom data in your application state or store. This example uses a static map keyed by channel URL:

```tsx
type ConversationCustomData = {
  customerTier?: 'premium' | 'standard';
  department?: string;
  priority?: 'high' | 'normal';
};

const customDataByChannelUrl: Record<string, ConversationCustomData> = {
  'CHANNEL_URL_1': {
    customerTier: 'premium',
    department: 'Support',
    priority: 'high',
  },
};
```

**Step 2: Create a Custom List Item that Renders Custom Data**

```tsx
import type { ReactNode } from 'react';
import type { ConversationListItemProps } from '@sendbird/ai-agent-messenger-react';

const CustomDataListItem = (props: ConversationListItemProps): ReactNode => {
  const { channel, channelUrl, onClick } = props;

  const customData = customDataByChannelUrl[channelUrl] ?? {};
  const customerTier = customData.customerTier ?? 'standard';
  const priority = customData.priority ?? 'normal';

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        padding: '16px',
        borderBottom: '1px solid #E5E7EB',
        cursor: 'pointer',
      }}
      onClick={() => onClick?.()}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
        <span style={{ fontSize: '15px', fontWeight: '600' }}>
          {'Conversation'}
        </span>

        {priority === 'high' && (
          <span style={{
            padding: '2px 8px',
            borderRadius: '12px',
            backgroundColor: '#FEE2E2',
            color: '#DC2626',
          }}>
            {'HIGH PRIORITY'}
          </span>
        )}

        {customerTier === 'premium' && (
          <span style={{
            padding: '2px 8px',
            borderRadius: '12px',
            backgroundColor: '#FEF3C7',
            color: '#D97706',
          }}>
            {'PREMIUM'}
          </span>
        )}
      </div>

      <div style={{ fontSize: '14px', color: '#6B7280' }}>
        {channel.lastMessage?.message || 'No messages yet'}
      </div>

      <div style={{
        marginTop: '8px',
        fontSize: '12px',
        color: '#9CA3AF',
      }}>
        {'Department: '}{customData.department ?? 'General'}
      </div>
    </div>
  );
};
```

**Step 3: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  ConversationList,
  ConversationListItemLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <ConversationListItemLayout.Template template={CustomDataListItem} />

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
- Use `channelUrl` to match conversation list items with data from your own application state.
- Keep the custom data source updated when conversations are created, removed, or reloaded.
- You can combine custom data rendering with filtering using the `conversationListFilter` prop.
