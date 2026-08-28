[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize message element positions

The React Native SDK does not expose a granular prop for moving the default sender name, sent time, or sender avatar to a different row inside a message bubble.

For small visual changes, replace the individual element slots. For outer spacing around the whole message, wrap the default template. For exact reordering of the sender name, sent time, and avatar, replace the full message template and re-implement the message branches you need.

### Option 1: Adjust an individual element slot

Use this when you only need to change the element's own styling, spacing, or visibility.

```tsx
import { Text, View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

const CustomSenderName = ({ sender }: Pick<IncomingMessageProps, 'sender'>) => {
  return (
    <View style={{ flex: 1, paddingVertical: 4, alignItems: 'flex-start' }}>
      <Text numberOfLines={1} style={{ color: '#4F46E5' }}>
        {sender.nickname}
      </Text>
    </View>
  );
};
```

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

### Option 2: Add outer spacing around the default message

Wrap `IncomingMessageLayout.defaults.template` and `OutgoingMessageLayout.defaults.template` when you want to move the entire rendered message group without changing the internal sender name, sent time, or avatar order.

```tsx
import { View } from 'react-native';
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react-native';
import { IncomingMessageLayout, OutgoingMessageLayout } from '@sendbird/ai-agent-messenger-react-native';

const CustomIncomingTemplate = (props: IncomingMessageProps) => {
  const DefaultTemplate = IncomingMessageLayout.defaults.template;
  return (
    <View style={{ paddingStart: 8 }}>
      <DefaultTemplate {...props} />
    </View>
  );
};

const CustomOutgoingTemplate = (props: OutgoingMessageProps) => {
  const DefaultTemplate = OutgoingMessageLayout.defaults.template;
  return (
    <View style={{ paddingEnd: 8 }}>
      <DefaultTemplate {...props} />
    </View>
  );
};
```

```tsx
<IncomingMessageLayout.Template template={CustomIncomingTemplate} />
<OutgoingMessageLayout.Template template={CustomOutgoingTemplate} />
```

### Option 3: Reorder sender name, sent time, and avatar

Exact internal reordering requires a full custom template. A full template owns every message branch it renders.

```tsx
import { View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';
import { IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react-native';

const CustomIncomingTemplate = (props: IncomingMessageProps) => {
  const { components } = IncomingMessageLayout.useContext();

  if (props.isTyping) {
    return <components.TypingIndicator {...props} />;
  }

  return (
    <View style={{ gap: 4, paddingHorizontal: 12 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
        <components.SenderName {...props} />
        {!!props.createdAt && <components.SentTime {...props} />}
      </View>

      <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 8 }}>
        <components.SenderAvatar {...props} />
        <components.MessageBody {...props} />
      </View>
    </View>
  );
};
```

```tsx
<IncomingMessageLayout.Template template={CustomIncomingTemplate} />
```

**Notes:**
- Option 1 preserves the default message layout and only replaces the selected element.
- Option 2 preserves every default runtime branch, but it only changes the outer position of the whole message group.
- Option 3 is the only public React Native path for changing the internal element order. The example is intentionally minimal and does not render message templates, custom templates, forms, citations, CTA buttons, feedback, suggested replies, streaming animation, or default message group spacing.
- A full template also owns the `containerStyle` the default template passes to `SentTime`, `MessageBody`, and `TypingIndicator` for avatar-gutter alignment. Reproduce that padding yourself, as the example above does with `paddingHorizontal`.
- For outgoing messages, apply the same full-template ownership model through `OutgoingMessageLayout.Template`. The outgoing layout exposes `SendingStatus`, `SentTime`, and `MessageBody`.
