[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)]()

#### How to Customize the HeaderView title in the Conversation

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
import { AgentProviderContainer } from '@sendbird/ai-agent-messenger-react';

export const App = () => {
  return (
    <AgentProviderContainer>
      <ConversationHeaderLayout.Template>
        <ConversationHeaderLayout.Title component={CustomTitle} />
      </ConversationHeaderLayout.Template>
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
- `HandoffButton` - Agent handoff button
- `ConversationCloseButton` - Close conversation button
- `ExpandButton` - Expand/fullscreen button
- `CloseButton` - Close widget button
