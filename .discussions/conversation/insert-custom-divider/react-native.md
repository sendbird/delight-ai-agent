[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to insert a custom divider between the message list and input field

Wrap the default Footer component with a divider:

```tsx
import { View } from 'react-native';
import { ConversationLayout } from '@sendbird/ai-agent-messenger-react-native';

const { Footer: DefaultFooter } = ConversationLayout.defaults.components;

const CustomFooter = () => {
  return (
    <View style={{ borderTopWidth: 1, borderTopColor: '#E5E7EB' }}>
      <DefaultFooter />
    </View>
  );
};
```

**Register the Custom Footer:**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  ConversationLayout,
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
      <ConversationLayout.Footer component={CustomFooter} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- Rendering `ConversationLayout.defaults.components.Footer` keeps the SDK message input, attachment button, send button, keyboard avoidance, and safe-area handling.
- Use `borderTopWidth` with `borderTopColor` rather than a fixed-height view so the divider stays crisp across screen densities.
