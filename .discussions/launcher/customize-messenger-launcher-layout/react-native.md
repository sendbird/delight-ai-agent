[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## Steps to Customize the Launcher Layout

You can customize the `FixedMessenger` layout using `FixedMessenger.Style` and `windowMode` props.

Before using this example, install the required peer dependencies used by the provider and storage example:

```sh
pnpm add react-native-safe-area-context react-native-mmkv
```

Attachment features require additional picker or permission modules only when you configure those native adapters.

### Configuration Options

**FixedMessenger Props:**

| Property       | Type     | Default | Description                              | Available Options                     |
| -------------- | -------- | ------- | ---------------------------------------- | ------------------------------------- |
| `entryPoint`   | `string` | `'Conversation'` | Initial screen when launcher is clicked | `'Conversation'`, `'ConversationList'` |
| `windowMode`   | `string` | `'floating'` | Display mode for the messenger window | `'floating'`, `'fullscreen'`          |
| `fullscreenInsets` | `object` | Device safe-area insets | Insets for fullscreen mode. Passed values override the corresponding safe-area inset. | `{ top?, left?, right?, bottom? }` in pixels |
| `edgeToEdgeEnabled` | `boolean` | `true` | (Android only) Enable edge-to-edge display, bottom inset considered when keyboard opens | `true`, `false` |

**FixedMessenger.Style Properties:**

| Property       | Type     | Default | Description                                              | Available Options                                           |
| -------------- | -------- | ------- | -------------------------------------------------------- | ----------------------------------------------------------- |
| `position`     | `string` | `'end-bottom'` | Position of the launcher button on screen                | `'start-top'`, `'start-bottom'`, `'end-top'`, `'end-bottom'` |
| `launcherSize` | `number` | `48` | Size of the launcher button in pixels (width and height) | Any positive number (e.g., `32`, `48`, `56`)                |
| `margin`       | `object` | `{ top: 24, bottom: 24, start: 24, end: 24 }` | Margins around the launcher                              | `{ start?, end?, top?, bottom? }` in pixels                     |
| `spacing`      | `number` | `12` | Space between launcher and messenger window in pixels    | Any positive number                                         |

### Example

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
      <FixedMessenger windowMode={'floating'}>
        <FixedMessenger.Style
          position={'end-bottom'}
          launcherSize={56}
          margin={{ start: 20, end: 20, top: 20, bottom: 20 }}
          spacing={12}
        />
      </FixedMessenger>
    </AIAgentProviderContainer>
  );
}
```
