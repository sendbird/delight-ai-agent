[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## Steps to Customize the Launcher Layout

You can customize the `FixedMessenger` layout using `FixedMessenger.Style`.

### Configuration Options

| Property       | Type     | Description                                              | Available Options                                           |
| -------------- | -------- | -------------------------------------------------------- | ----------------------------------------------------------- |
| `position`     | `string` | Position of the launcher button on screen                | `'start-top'`, `'start-bottom'`, `'end-top'`, `'end-bottom'` |
| `launcherSize` | `number` | Size of the launcher button in pixels (width and height) | Any positive number (e.g., `32`, `48`, `56`)                |
| `margin`       | `object` | Margins around the launcher                              | `{ start, end, top, bottom }` in pixels                     |

### Example

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <FixedMessenger>
      <FixedMessenger.Style
        position={'end-bottom'}
        launcherSize={56}
        margin={{ start: 16, end: 16, top: 16, bottom: 16 }}
      />
    </FixedMessenger>
  );
}
```
