[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to handle link presses in conversation messages

Intercept link presses the SDK opens — markdown links, admin-message URLs, citations, CTA buttons, and non-media file-preview clicks — through the `handlers.onClickLink` callback on `AIAgentProviderContainer`.

### Example

```tsx
import { Linking } from 'react-native';
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
      handlers={{
        onClickLink: ({ url }) => {
          analytics.track('agent_link_press', { url });

          if (url.startsWith('myapp://')) {
            navigation.navigate('Deeplink', { url });
            return;
          }

          Linking.openURL(url);
        },
      }}
    >
      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

### Notes

- Without `onClickLink`, the SDK falls back to `Linking.openURL(url)`.
- The MediaViewer's download button is intentionally excluded — it keeps the existing direct `Linking.openURL` behavior so downloads continue working without a custom handler.
- Media/image message previews still open the SDK MediaViewer; MediaViewer downloads stay excluded from `onClickLink`.
- If you replace message/layout slots and receive message props, slot-level callbacks (`onClickCTA`, `onClickCitation`, `onClickMedia`, `onClickFile`) still override that slot's behavior entirely and take precedence over `onClickLink`.
