[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## Customizing IncomingMessage SenderName Font Styles

This guide explains how to customize the font style of sender names displayed in IncomingMessage components in the Delight AI Agent React Native SDK.

## Overview

While global typography customization is possible through the `theme.typography` prop, the recommended approach for customizing sender names is to create a custom SenderName component to avoid unintended side effects on other components.

**Step 1: Create Custom Component**

```tsx
import { Text, View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

export const CustomIncomingSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <View style={{ flex: 1, paddingVertical: 5, paddingEnd: 7, alignItems: 'flex-start' }}>
      <Text
        numberOfLines={1}
        style={{
          fontWeight: '600',
          fontSize: 14,
          lineHeight: 18,
          color: '#AAAAAA',
        }}
      >
        {sender.nickname}
      </Text>
    </View>
  );
};
```

**Step 2: Apply Custom Component**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react-native';

import { CustomIncomingSenderName } from './components/CustomIncomingSenderName';

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
      <IncomingMessageLayout.SenderName component={CustomIncomingSenderName} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The default sender name truncates long names with `numberOfLines={1}`. Keep the same setting in a custom component unless you intentionally want wrapping.
- To change the font globally instead, pass `theme.typography` to `AIAgentProviderContainer`. The default sender name uses the `caption1` variant.
- Custom fonts must be linked in your app before you can reference them by `fontFamily`.
