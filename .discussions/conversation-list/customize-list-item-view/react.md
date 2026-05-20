[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.1.0-grey.svg?style=flat-square)]()

## How to customize the List Item View in the Conversation List

You can customize the conversation list item appearance by creating a custom template for `ConversationListItemLayout`.

**Step 1: Create a Custom List Item Component**

```tsx
import type { ReactNode } from 'react';
import type { ConversationListItemProps } from '@sendbird/ai-agent-messenger-react';
import { ConversationListItemLayout } from '@sendbird/ai-agent-messenger-react';

const CustomListItem = (props: ConversationListItemProps): ReactNode => {
  const DefaultListItem = ConversationListItemLayout.defaults.template;
  const isUnread = props.channel.unreadMessageCount > 0;

  return (
    <div
      style={{
        backgroundColor: isUnread ? '#F8FBFF' : '#FFFFFF',
        borderInlineStart: isUnread ? '4px solid #3B82F6' : '4px solid transparent',
      }}
    >
      <DefaultListItem {...props} />
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
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <ConversationListItemLayout.Template template={CustomListItem} />

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
- Wrapping `ConversationListItemLayout.defaults.template` keeps the SDK preview text, timestamp, unread badge, click handler, and accessibility behavior.
- Use a full replacement only when you also preserve the SDK's file message, multiple-file message, timestamp, click, and accessibility behavior.
