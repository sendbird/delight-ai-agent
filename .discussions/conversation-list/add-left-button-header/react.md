[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

#### How to Add a Left Button to the Conversation List Header

- Description

This guide explains how to customize the conversation list header to add a left-side button by creating a custom view.

You can add a custom button to the left side of the header by using `ConversationListHeaderLayout` and overriding the `StartArea` component.

**Step 1: Create a Custom Start Area Component**

Create a custom component for the left side of the header:

```tsx
import { ConversationListHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const CustomStartArea = () => {
  const handleMenuClick = () => {
    console.log('Menu button clicked');
    // Handle menu button click
  };

  return (
    <button onClick={handleMenuClick} style={{ padding: '8px' }}>
      {'☰'}
    </button>
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
      <ConversationListHeaderLayout.Template>
        <ConversationListHeaderLayout.StartArea component={CustomStartArea} />
      </ConversationListHeaderLayout.Template>
    </AgentProviderContainer>
  );
};
```

**Available Default Components:**
- `StartArea` - Left section (empty by default)
- `TitleArea` - Center section (contains Title by default)
- `EndArea` - Right section (contains CloseButton by default)
- `Title` - Conversation list title
- `CloseButton` - Close widget button
