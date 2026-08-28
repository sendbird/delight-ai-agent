[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the footer text in the Conversation List

You can customize the footer button text through the localization string set. This keeps the default footer behavior that creates or opens a conversation.

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
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
      strings={{
        conversation_list: {
          footer_title: 'Start New Chat',
        },
      }}
    >
      <FixedMessenger windowMode={'floating'} entryPoint={'ConversationList'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The default text is `Start a conversation`.
- The string key is `conversation_list.footer_title` in the React Native string set. The React Native `strings` prop takes a nested, partial object, so you only need to declare the keys you override.
- Overrides apply to every language. To vary the text per language, switch the value based on the `language` prop you pass to `AIAgentProviderContainer`.
- Use a custom `Footer` component through `ConversationListLayout.Footer` only when you need to own the full create, open, and navigation behavior yourself.
