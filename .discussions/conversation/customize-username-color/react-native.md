[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the user name color in the conversation message

You can customize the sender name color by creating a custom `SenderName` component and replacing it using `IncomingMessageLayout`.

**Step 1: Create a Custom SenderName Component**

Create a custom component that accepts the `sender` prop:

```tsx
import { Text, View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

const CustomSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <View style={{ flex: 1, paddingVertical: 5, paddingEnd: 7, alignItems: 'flex-start' }}>
      <Text
        numberOfLines={1}
        style={{
          fontSize: 13,
          fontWeight: '600',
          color: '#7A50F2',
        }}
      >
        {sender.nickname}
      </Text>
    </View>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
  IncomingMessageLayout,
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
      <IncomingMessageLayout.SenderName component={CustomSenderName} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The sender name only appears on incoming (AI agent) messages, not outgoing user messages.
- The default sender name uses the `caption1` typography variant and the mid emphasis text color from the theme.
- Keep `numberOfLines={1}` when replacing `SenderName`; otherwise long names can push the message row taller.
- The sender name row is hidden from screen readers by the default message template, so the message itself is announced as one unit.
