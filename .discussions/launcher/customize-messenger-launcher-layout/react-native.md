[![React Native](https://img.shields.io/badge/React_Native-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react-native/releases)

## Steps to Customize the Launcher Layout

You can customize the `FixedMessenger` layout using `FixedMessenger.Style` and `windowMode` props.

### Configuration Options

**FixedMessenger Props:**

| Property       | Type     | Default | Description                              | Available Options                     |
| -------------- | -------- | ------- | ---------------------------------------- | ------------------------------------- |
| `entryPoint`   | `string` | `'Conversation'` | Initial screen when launcher is clicked | `'Conversation'`, `'ConversationList'` |
| `windowMode`   | `string` | `'floating'` | Display mode for the messenger window | `'floating'`, `'fullscreen'`          |
| `fullscreenInsets` | `object` | `{ top: 0, left: 0, right: 0, bottom: 0 }` | Insets for fullscreen mode to handle safe areas | `{ top?, left?, right?, bottom? }` in pixels |
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
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react-native';

function App() {
  return (
    <FixedMessenger windowMode={'floating'}>
      <FixedMessenger.Style
        position={'end-bottom'}
        launcherSize={56}
        margin={{ start: 20, end: 20, top: 20, bottom: 20 }}
        spacing={12}
      />
    </FixedMessenger>
  );
}
```
