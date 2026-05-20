[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)]()

## How to Customize the HeaderView title in the Conversation

- Description

This guide shows how to change the title text of the Conversation Header TitleView.

You can customize the header title of the conversation screen by using `ConversationHeaderLayout` and overriding the `Title` component.

**Step 1: Create a Custom Title Component**

Create a custom component to replace the default title:

```tsx
import { ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const CustomTitle = () => {
  return (
    <div style={{ fontWeight: 'bold', fontSize: '18px' }}>
      {'Custom title'}
    </div>
  );
};
```

**Step 2: Apply Customization**

Wrap your customizations within `AgentProviderContainer`:

```tsx
import {
  AgentProviderContainer,
  Conversation,
  ConversationHeaderLayout,
} from '@sendbird/ai-agent-messenger-react';

export const App = () => {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <ConversationHeaderLayout.Title component={CustomTitle} />

      <Conversation />
    </AgentProviderContainer>
  );
};
```

**Available Default Components:**
- `StartArea` - Left section (contains MenuButton by default)
- `TitleArea` - Center section (contains Title by default)
- `EndArea` - Right section (contains action buttons by default)
- `MenuButton` - Menu/navigation button
- `Title` - Conversation title
- `MemoryIndicator` - Memory status indicator
- `HandoffButton` - Agent handoff button
- `ConversationCloseButton` - Close conversation button
- `ExpandButton` - Expand/fullscreen button
- `CloseButton` - Close widget button

**Notes:**
- Replacing `Title` means your component owns the title text. The default title dynamically renders the current conversation preview title and optional avatar.
- Keep your custom title short or add truncation styles if it can be longer than the header width.
