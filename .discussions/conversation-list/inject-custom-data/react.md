[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to inject and render custom data in the Conversation List

You can inject and render custom data in the conversation list by creating a custom list item component that accesses channel metadata or custom data.

**Step 1: Store Custom Data in Channel Metadata**

First, ensure your channels have custom metadata:

```tsx
import { useMessengerSessionContext } from '@sendbird/ai-agent-messenger-react';

// When creating a conversation, add custom data
const { createConversation } = useMessengerSessionContext();

await createConversation({
  aiAgentId: 'YOUR_AI_AGENT_ID',
  language: 'en-US',
  metadata: {
    customerTier: 'premium',
    department: 'Support',
    priority: 'high'
  }
});
```

**Step 2: Create a Custom List Item that Renders Custom Data**

```tsx
import { ConversationListItemProps } from '@sendbird/ai-agent-messenger-react';

const CustomDataListItem = (props: ConversationListItemProps) => {
  const { channel, onClick } = props;

  // Access custom data from channel metadata
  const metadata = channel.data ? JSON.parse(channel.data) : {};
  const customerTier = metadata.customerTier || 'standard';
  const priority = metadata.priority || 'normal';

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        padding: '16px',
        borderBottom: '1px solid #E5E7EB',
        cursor: 'pointer'
      }}
      onClick={() => onClick?.()}
    >
      {/* Header with custom data badges */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
        <span style={{ fontSize: '15px', fontWeight: '600' }}>
          Conversation
        </span>

        {/* Priority badge */}
        {priority === 'high' && (
          <span style={{
            padding: '2px 8px',
            borderRadius: '12px',
            backgroundColor: '#FEE2E2',
            color: '#DC2626',
          }}>
            HIGH PRIORITY
          </span>
        )}

        {/* Tier badge */}
        {customerTier === 'premium' && (
          <span style={{
            padding: '2px 8px',
            borderRadius: '12px',
            backgroundColor: '#FEF3C7',
            color: '#D97706',
          }}>
            ⭐ PREMIUM
          </span>
        )}
      </div>

      {/* Last message */}
      <div style={{ fontSize: '14px', color: '#6B7280' }}>
        {channel.lastMessage?.message || 'No messages yet'}
      </div>

      {/* Custom data details */}
      <div style={{
        marginTop: '8px',
        fontSize: '12px',
        color: '#9CA3AF'
      }}>
        Department: {metadata.department || 'General'}
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
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <ConversationListItemLayout.Template template={CustomDataListItem} />

      <ConversationList />
    </AgentProviderContainer>
  );
}
```

**Alternative: Using Channel Custom Type**

You can also filter and render based on channel custom type:

```tsx
const CustomDataListItem = (props: ConversationListItemProps) => {
  const { channel } = props;
  const isVIPChannel = channel.customType === 'vip';

  return (
    <div style={{
      borderLeft: isVIPChannel ? '4px solid #F59E0B' : 'none'
    }}>
      {/* List item content */}
    </div>
  );
};
```

**Notes:**
- Channel metadata is accessible through `channel.data`
- You can store JSON data in channel metadata
- Custom types can be used for categorization
- You can combine custom data with filtering using `conversationListFilter` prop
