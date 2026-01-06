[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the List Item View in the Conversation List

You can customize the conversation list item appearance by creating a custom template for `ConversationListItemLayout`.

**Step 1: Create a Custom List Item Component**

```tsx
import { ConversationListItemProps } from '@sendbird/ai-agent-messenger-react';

const CustomListItem = (props: ConversationListItemProps) => {
  const { channel, onClick } = props;
  const lastMessage = channel.lastMessage?.message || 'No messages yet';
  const unreadCount = channel.unreadMessageCount;

  return (
    <div
      style={{
        display: 'flex',
        padding: '16px',
        borderBottom: '1px solid #E5E7EB',
        cursor: 'pointer',
        backgroundColor: 'white',
      }}
      onClick={() => onClick?.()}
      onMouseEnter={(e) => {
        e.currentTarget.style.backgroundColor = '#F9FAFB';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.backgroundColor = 'white';
      }}
    >

      {/* Content */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          color: '#111827',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap'
        }}>
          {lastMessage}
        </div>

        <div style={{
          fontSize: '13px',
          color: '#6B7280',
          marginTop: '4px'
        }}>
          {new Date(channel.createdAt).toLocaleDateString()}
        </div>
      </div>

      {/* Badge */}
      {unreadCount > 0 && (
        <div style={{
          height: '20px',
          borderRadius: '10px',
          backgroundColor: '#EF4444',
          color: 'white',
        }}>
          {unreadCount > 99 ? '99+' : unreadCount}
        </div>
      )}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

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
      <ConversationListItemLayout.Template template={CustomListItem} />

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
- The default list item height is 72px
- List items display: channel cover, last message, timestamp, and unread badge
- You can customize layout, colors, fonts, and add additional information
- Consider accessibility when customizing (focus states, keyboard navigation, etc.)
