[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.15.0-grey.svg?style=flat-square)]()

## How to custom profile view visibility

You can control the visibility of profile elements (sender avatar and sender name) for incoming messages.

**Hide the sender avatar (recommended)**

Use the `conversation.list.senderAvatarEnabled` config to hide the avatar AND remove the avatar gutter spacing reserved on the start side of the message bubble.

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
      config={{
        conversation: {
          list: {
            senderAvatarEnabled: false,
          },
        },
      }}
    >
      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Hide the sender name**

There is no dedicated config for the sender name. Replace the `SenderName` slot with an empty component.

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

const HiddenSenderName = () => null;

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <IncomingMessageLayout.SenderName component={HiddenSenderName} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- Profile elements (avatar and name) only appear on incoming messages.
- Replacing the `SenderAvatar` slot alone hides the avatar visually, but the layout still reserves avatar-width padding controlled by `senderAvatarEnabled`. Use the config above to also remove that padding.
- `senderAvatarEnabled` is `true` by default.
