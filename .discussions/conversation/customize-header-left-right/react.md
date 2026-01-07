[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)]()

#### How to Customize the Left/Right Areas in the Conversation HeaderView

- Description

This guide shows how to set up and apply layouts for the left and right areas of the Conversation HeaderView.

You can customize the header layout of the conversation screen by using `ConversationHeaderLayout` and overriding specific components. This allows you to rearrange, add, or remove items in the header's left (StartArea) and right (EndArea) areas.

**Step 1: Create Custom Components**

Create custom components to replace the default header items:

```tsx
import { ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react';

// Empty component to hide items
const EmptyComponent = () => <></>;

// Custom end area with selected buttons
const CustomEndArea = () => {
  const { components } = ConversationHeaderLayout.useContext();
  return (
    <div style={{ display: 'flex', gap: '10px' }}>
      <components.HandoffButton />
      <components.CloseButton />
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
        <ConversationHeaderLayout.MenuButton component={EmptyComponent} />
        <ConversationHeaderLayout.EndArea component={CustomEndArea} />
      </ConversationHeaderLayout.Template>
    </AgentProviderContainer>
  );
};
```

**Available Default Components:**
- `MenuButton` - Opens the menu options
- `Title` - Displays conversation title
- `HandoffButton` - Handles agent handoff functionality
- `ConversationCloseButton` - Closes the conversation
- `ExpandButton` - Expands to fullscreen
- `CloseButton` - Closes the widget
