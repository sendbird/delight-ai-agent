[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to Customize the Left/Right Areas in the Conversation HeaderView

- Description

This guide shows how to set up and apply layouts for the left and right areas of the Conversation HeaderView.

You can customize the header layout of the conversation screen by using `ConversationHeaderLayout` and overriding specific components. This allows you to rearrange, add, or remove items in the header's left (`StartArea`) and right (`EndArea`) areas.

**Step 1: Create Custom Components**

```tsx
import { View } from 'react-native';

import { ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react-native';

// Empty component to hide items
const EmptyComponent = () => null;

// Custom end area that preserves the default right-side controls
const CustomEndArea = () => {
  const { components } = ConversationHeaderLayout.useContext();

  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
      <components.MemoryIndicator />
      <components.HandoffButton />
      <components.CloseButton />
    </View>
  );
};
```

**Step 2: Apply Customization**

Wrap your customizations within `AIAgentProviderContainer`:

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  ConversationHeaderLayout,
  FixedMessenger,
} from '@sendbird/ai-agent-messenger-react-native';

const nativeModules = {
  mmkv: createMMKV(),
};

export const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <ConversationHeaderLayout.MenuButton component={EmptyComponent} />
      <ConversationHeaderLayout.EndArea component={CustomEndArea} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
};
```

**Available Default Components:**

Replacing `EndArea` replaces the entire right section. Include each default control you want to keep, and omit only the controls you intentionally want to remove.

- `StartArea` - Left section (contains MenuButton by default)
- `TitleArea` - Center section (contains Title by default)
- `EndArea` - Right section (contains MemoryIndicator, HandoffButton, and CloseButton by default)
- `MenuButton` - Opens the menu options
- `Title` - Displays conversation title
- `MemoryIndicator` - Shows memory status when memory is enabled
- `HandoffButton` - Handles agent handoff functionality
- `CloseButton` - Closes the messenger

**Notes:**
- The React Native header does not have the web-only expand and conversation-close controls. `CloseButton` closes the messenger.
- Each default control renders `null` when its own feature is disabled, so keeping all three in a custom `EndArea` is safe.
