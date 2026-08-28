[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the message bubble max width in the Conversation

You can customize the message bubble maximum width by overriding the `IncomingMessageLayout.Template` and `OutgoingMessageLayout.Template` with wrappers that pass a custom `maxBodyWidth` to the default templates. This preserves the default rendering of text, files, media, message templates, forms, citations, and feedback while only changing the bubble width.

**Step 1: Create Custom Template Wrappers**

```tsx
import type { IncomingMessageProps, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react-native';
import { IncomingMessageLayout, OutgoingMessageLayout } from '@sendbird/ai-agent-messenger-react-native';

const CUSTOM_MAX_BODY_WIDTH = 280;

const CustomIncomingMessageTemplate = (props: IncomingMessageProps) => {
  const DefaultTemplate = IncomingMessageLayout.defaults.template;
  return <DefaultTemplate {...props} maxBodyWidth={CUSTOM_MAX_BODY_WIDTH} />;
};

const CustomOutgoingMessageTemplate = (props: OutgoingMessageProps) => {
  const DefaultTemplate = OutgoingMessageLayout.defaults.template;
  return <DefaultTemplate {...props} maxBodyWidth={CUSTOM_MAX_BODY_WIDTH} />;
};
```

**Step 2: Apply the Custom Templates**

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
      <IncomingMessageLayout.Template template={CustomIncomingMessageTemplate} />
      <OutgoingMessageLayout.Template template={CustomOutgoingMessageTemplate} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The default maximum width is 244px.
- `maxBodyWidth` is a public prop on `IncomingMessageProps` and `OutgoingMessageProps`. Passing it to the default template applies to incoming and outgoing text bubbles. Media, image grid, and file preview paths keep the SDK-defined sizing.
- Pick a value that fits the narrowest device you support, and account for the avatar gutter reserved on the start side of incoming messages.
