[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the time label color in the conversation message

You can customize the time label color by creating a custom `SentTime` component and replacing the default component using the `IncomingMessageLayout` or `OutgoingMessageLayout`.

**Step 1: Create a Custom SentTime Component**

The slot receives a `containerStyle` that carries the message row's start padding. Apply it to your outermost view so the timestamp stays aligned with the message bubble.

```tsx
import type { ViewStyle } from 'react-native';
import { Text, View } from 'react-native';
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

type SentTimeProps = (Pick<IncomingMessageProps, 'createdAt'> | Pick<OutgoingMessageProps, 'createdAt'>) & {
  containerStyle?: ViewStyle;
};

const CustomSentTime = ({ createdAt, containerStyle }: SentTimeProps) => {
  if (!createdAt) return null;

  const label = new Date(createdAt).toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });

  return (
    <View style={[containerStyle, { marginTop: 4 }]}>
      <Text style={{ fontSize: 11, color: '#7A50F2' }}>{label}</Text>
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
  OutgoingMessageLayout,
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
      <IncomingMessageLayout.SentTime component={CustomSentTime} />
      <OutgoingMessageLayout.SentTime component={CustomSentTime} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- `IncomingMessageLayout.SentTime` replaces the time label for incoming (AI agent) messages.
- `OutgoingMessageLayout.SentTime` replaces the time label for outgoing (user) messages.
- The default time label uses the `caption4` typography variant and the low emphasis text color from the theme.
- A custom component owns date formatting. Use `Intl` or your own date library and keep it consistent with the `language` you pass to `AIAgentProviderContainer`.
