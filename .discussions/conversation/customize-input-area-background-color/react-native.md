[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.12.0-grey.svg?style=flat-square)]()

## How to customize the background color of the message input box

You can customize the message input box background color by passing `theme.colors.messageInput.background` to `AIAgentProviderContainer`.

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
      theme={{
        colors: {
          messageInput: {
            background: '#F2F4F7',
          },
        },
      }}
    >
      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

### Theme-specific colors

Each token can also define separate light and dark values. If one side is omitted, the SDK uses the default generated color for that theme.

```tsx
theme={{
  colors: {
    messageInput: {
      background: {
        light: '#F2F4F7',
        dark: '#2C2C2C',
      },
    },
  },
}}
```

**Notes:**
- `messageInput.background` changes only the message input box background.
- You can also customize `messageInput.text` and `messageInput.placeholderText` in the same `theme.colors.messageInput` object.
- Use hex colors for custom color values.
- This customization is supported in version `1.12.0` or later.
