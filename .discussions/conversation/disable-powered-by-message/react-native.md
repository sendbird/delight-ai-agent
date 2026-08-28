[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to disable the poweredBy message in the conversation

The React Native SDK does not expose a client-side prop, config, or layout slot for the "Powered by" message shown above the first message in the conversation. Its visibility is an application-level setting, so it is turned off through the support request described above rather than in code.

Once the setting is applied to your Sendbird application, the message stops rendering on the next messenger session. No code change or SDK upgrade is required, and the space it occupied is removed from the message list.

### Verifying the change

Restart the app after the setting is applied so the SDK fetches the updated application information, then confirm the message is gone above the first message in the conversation.

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
    >
      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- The setting applies to the whole Sendbird application, so it affects every AI agent and every platform SDK using that application.
- The message text itself is localized through the `conversation.powered_by` string key. Overriding that string changes the wording but does not hide the message.
- While the message is visible, tapping the Sendbird link goes through `handlers.onClickLink`, so you can intercept or block that navigation without hiding the message.
