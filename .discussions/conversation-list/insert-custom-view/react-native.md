[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to insert a custom view into the Conversation List

You can insert custom views (like banners, separators, or information cards) into the conversation list by replacing the list body with a component that keeps the SDK list and adds your own content around it.

**Step 1: Create a Custom Body Component**

Render `ConversationListLayout.defaults.components.Body` so the SDK keeps its loading, empty, error, pagination, and item press behavior.

```tsx
import { Text, View } from 'react-native';
import {
  ConversationListLayout,
  useConversationListContext,
} from '@sendbird/ai-agent-messenger-react-native';

const CustomListBody = () => {
  const { listSource } = useConversationListContext();
  const DefaultBody = ConversationListLayout.defaults.components.Body;

  return (
    <View style={{ flex: 1 }}>
      {listSource.initialized && listSource.channels.length > 0 && (
        <View style={{ margin: 16, padding: 16, backgroundColor: '#F0FDF4', borderRadius: 8 }}>
          <Text style={{ fontWeight: '600' }}>{'New Feature Available!'}</Text>
          <Text>{'Try our new AI-powered quick replies feature.'}</Text>
        </View>
      )}

      <View style={{ flex: 1 }}>
        <DefaultBody />
      </View>
    </View>
  );
};
```

**Step 2: Register the Custom Body**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  ConversationListLayout,
  FixedMessenger,
} from '@sendbird/ai-agent-messenger-react-native';

const nativeModules = {
  mmkv: createMMKV(),
};

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <ConversationListLayout.Body component={CustomListBody} />

      <FixedMessenger windowMode={'floating'} entryPoint={'ConversationList'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- Keep `flex: 1` on the wrapper around `DefaultBody`. The SDK list fills its parent, so without it the list collapses to zero height.
- Content added this way is pinned above the list and does not scroll with it. The SDK does not expose a public API for injecting rows inside the list's own scroll content.
- `useConversationListContext()` exposes `listSource` so you can show custom views only after the list has loaded or only when it has conversations.
- You can also render fixed content around the whole screen by replacing `ConversationListLayout.Header` or `ConversationListLayout.Footer` instead.
