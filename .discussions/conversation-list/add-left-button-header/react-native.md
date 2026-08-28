[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to Add a Left Button to the Conversation List Header

- Description

This guide explains how to customize the conversation list header to add a left-side button by creating a custom view.

You can add a custom button to the left side of the header by using `ConversationListHeaderLayout` and overriding the `StartArea` component.

**Step 1: Create a Custom Start Area Component**

```tsx
import { Pressable, Text } from 'react-native';

const CustomStartArea = () => {
  const handleMenuPress = () => {
    console.log('Menu button pressed');
    // Handle menu button press
  };

  return (
    <Pressable onPress={handleMenuPress} accessibilityRole={'button'} style={{ padding: 8 }}>
      <Text>{'☰'}</Text>
    </Pressable>
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
  ConversationListHeaderLayout,
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
      <ConversationListHeaderLayout.StartArea component={CustomStartArea} />

      <FixedMessenger windowMode={'floating'} entryPoint={'ConversationList'} />
    </AIAgentProviderContainer>
  );
};
```

**Available Default Components:**
- `StartArea` - Left section (empty by default)
- `TitleArea` - Center section (contains Title by default)
- `EndArea` - Right section (contains CloseButton by default)
- `Title` - Conversation list title
- `CloseButton` - Close messenger button

**Notes:**
- Set `entryPoint={'ConversationList'}` on `FixedMessenger` so the messenger opens on the conversation list.
- Add an `accessibilityLabel` to your custom button so screen readers announce what it does.
- The header start area shrinks to its content width. The title area takes the remaining space, so a wide custom button reduces the room available for the title.
