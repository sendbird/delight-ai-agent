[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)]()

## Steps to Customize the Launcher Layout

You can customize the `FixedMessenger` layout using `FixedMessenger.Style`.

### Configuration Options

| Property       | Type     | Default | Description                                              | Available Options                                           |
| -------------- | -------- | ------- | -------------------------------------------------------- | ----------------------------------------------------------- |
| `position`     | `string` | `'end-bottom'` | Position of the launcher button on screen                | `'start-top'`, `'start-bottom'`, `'end-top'`, `'end-bottom'` |
| `launcherSize` | `number` | `48` | Size of the launcher button in pixels (width and height) | Any positive number (e.g., `32`, `48`, `56`)                |
| `margin`       | `object` | `{ top: 24, bottom: 24, start: 24, end: 24 }` | Margins around the launcher                              | `{ start?, end?, top?, bottom? }` in pixels                     |

### Example

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <FixedMessenger
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <FixedMessenger.Style
        position={'end-bottom'}
        launcherSize={56}
        margin={{ start: 16, end: 16, top: 16, bottom: 16 }}
      />
    </FixedMessenger>
  );
}
```

**Notes:**
- On desktop, these values position the launcher and the floating messenger window.
- On mobile web, `FixedMessenger` opens a fullscreen messenger window. The style values still control the launcher button, but the opened window uses the fullscreen layout.
