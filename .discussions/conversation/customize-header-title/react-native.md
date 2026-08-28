[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to Customize the HeaderView title in the Conversation

- Description

This guide shows how to change the title text of the Conversation Header TitleView.

You can customize the header title of the conversation screen by using `ConversationHeaderLayout` and overriding the `Title` component.

**Step 1: Create a Custom Title Component**

```tsx
import { Text } from 'react-native';

const CustomTitle = () => {
  return (
    <Text style={{ fontWeight: 'bold', fontSize: 18 }} numberOfLines={1}>
      {'Custom title'}
    </Text>
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
      <ConversationHeaderLayout.Title component={CustomTitle} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
};
```

**Available Default Components:**
- `StartArea` - Left section (contains MenuButton by default)
- `TitleArea` - Center section (contains Title by default)
- `EndArea` - Right section (contains MemoryIndicator, HandoffButton, and CloseButton by default)
- `MenuButton` - Menu button
- `Title` - Conversation title
- `MemoryIndicator` - Memory status indicator
- `HandoffButton` - Agent handoff button
- `CloseButton` - Close messenger button

**Notes:**
- Replacing `Title` means your component owns the title text. The default title renders the current conversation preview title and optional avatar.
- Keep your custom title short or set `numberOfLines` so it can not overflow the header row.
