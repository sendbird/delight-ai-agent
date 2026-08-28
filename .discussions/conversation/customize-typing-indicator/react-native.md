[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the typing indicator appearance in the conversation

You can customize the typing indicator by replacing the `TypingIndicator` component using `IncomingMessageLayout`.

**Step 1: Create a Custom TypingIndicator Component**

The slot receives a `containerStyle` that carries the message row's start padding. Apply it to your outermost view so the indicator stays aligned with the message bubbles.

```tsx
import type { ViewStyle } from 'react-native';
import { Text, View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

type CustomTypingIndicatorProps = IncomingMessageProps & {
  containerStyle?: ViewStyle;
};

const CustomTypingIndicator = ({ thinkingMessage, containerStyle }: CustomTypingIndicatorProps) => {
  if (thinkingMessage) {
    return (
      <View style={containerStyle}>
        <Text style={{ paddingVertical: 12, color: '#7C3AED' }}>{thinkingMessage}</Text>
      </View>
    );
  }

  return (
    <View style={containerStyle}>
      <View
        style={{
          alignSelf: 'flex-start',
          backgroundColor: '#F3E8FF',
          paddingHorizontal: 12,
          paddingVertical: 8,
          borderRadius: 12,
        }}
      >
        <Text style={{ color: '#7C3AED' }}>{'Typing...'}</Text>
      </View>
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
      <IncomingMessageLayout.TypingIndicator component={CustomTypingIndicator} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The `TypingIndicator` component is part of `IncomingMessageLayout`.
- The default typing indicator shows three animated dots, and switches to the agent's `thinkingMessage` text with a shimmer effect when one is provided. Handle both cases if you want to keep that behavior.
- The default indicator stops animating when the device has "Reduce Motion" enabled. Consider the same when adding your own animation.
