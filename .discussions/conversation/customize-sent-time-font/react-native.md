[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## Customizing the Font Style of SentTime (Outgoing & Incoming)

This guide explains how to customize the font style of the SentTime (timestamp) component for both outgoing and incoming message bubbles in the Delight AI Agent React Native SDK.

### Overview

The SentTime component is rendered as part of both outgoing and incoming message layouts. To customize its font style, you can override the default component with your own implementation.

**Step 1: Create a Custom SentTime Component**

The slot receives a `containerStyle` that carries the message row's start padding. Apply it to your outermost view so the timestamp stays aligned with the message bubble.

```tsx
import type { ViewStyle } from 'react-native';
import { Text, View } from 'react-native';
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

type SentTimeProps = (Pick<IncomingMessageProps, 'createdAt'> | Pick<OutgoingMessageProps, 'createdAt'>) & {
  containerStyle?: ViewStyle;
};

export const CustomSentTime = ({ createdAt, containerStyle }: SentTimeProps) => {
  if (!createdAt) return null;

  const label = new Date(createdAt).toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });

  return (
    <View style={containerStyle}>
      <Text
        style={{
          fontFamily: 'FiraMono-Medium',
          fontSize: 11,
          fontWeight: '500',
          color: '#FF9500',
        }}
      >
        {label}
      </Text>
    </View>
  );
};
```

**Step 2: Apply the Custom SentTime Component**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
  IncomingMessageLayout,
  OutgoingMessageLayout,
} from '@sendbird/ai-agent-messenger-react-native';

import { CustomSentTime } from './components/CustomSentTime';

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
- The default component formats the timestamp with the SDK's localized `date_format.message_timestamp` string. A custom component owns formatting, so use `Intl` or your own date library and keep it consistent with the `language` you pass to `AIAgentProviderContainer`.
- The default timestamp uses the `caption4` typography variant and the low emphasis text color from the theme.
- `fontFamily` values must refer to a font already linked in your app.
- To change the timestamp font globally instead of per slot, pass `theme.typography` to `AIAgentProviderContainer`. That also affects every other `caption4` label.
