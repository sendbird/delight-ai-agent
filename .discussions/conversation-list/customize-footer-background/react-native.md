[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to change the primary color used by the Conversation List footer

The Conversation List footer uses the SDK primary palette color as its background. You can change that color through `theme.palette.primary` while keeping the default footer behavior that creates or opens a conversation.

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
        palette: {
          primary: {
            extraDark: '#4C1D95',
            dark: '#5B21B6',
            main: '#7C3AED',
            light: '#C4B5FD',
            extraLight: '#EDE9FE',
          },
        },
      }}
    >
      <FixedMessenger windowMode={'floating'} entryPoint={'ConversationList'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- `theme.palette.primary` requires the full `extraDark`, `dark`, `main`, `light`, and `extraLight` set. The SDK uses `main` in light mode and `light` in dark mode for the footer background.
- The footer text color is not a separate token. It is the inverse high-emphasis text color from `theme.palette.onlight` / `theme.palette.ondark`, so pick a footer background with enough contrast against it.
- The default footer button text is the localized `strings.conversation_list.footer_title` value (English default: `Start a conversation`).
- This is not a footer-only token. The primary palette color also affects other SDK surfaces such as the launcher, the suggested reply buttons, and the sender avatar.
