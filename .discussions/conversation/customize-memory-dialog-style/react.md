[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.26.0-grey.svg?style=flat-square)]()

## How to customize the user memory dialog style

You can customize the user memory dialog by passing `theme.colors.memoryDialog` to `AgentProviderContainer`.

The memory dialog supports separate color tokens for the title, markdown body, markdown links, and positive or negative action buttons.

### Example

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      theme={{
        colors: {
          memoryDialog: {
            titleText: '#111827',
            markdownBodyText: '#4B5563',
            markdownLinkText: '#2563EB',
            positiveBackground: '#111827',
            positiveText: '#FFFFFF',
            positiveBorderColor: '#111827',
            negativeBackground: '#FFFFFF',
            negativeText: '#111827',
            negativeBorderColor: '#D1D5DB',
          },
        },
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
}
```

### Theme-specific colors

Each token can also define separate light and dark values. If one side is omitted, the SDK uses the default generated color for that theme.

```tsx
<AgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  theme={{
    colors: {
      memoryDialog: {
        titleText: {
          light: '#111827',
          dark: '#F9FAFB',
        },
        positiveBackground: {
          light: '#111827',
          dark: '#F9FAFB',
        },
        positiveText: {
          light: '#FFFFFF',
          dark: '#111827',
        },
      },
    },
  }}
>
  <Conversation />
</AgentProviderContainer>
```

### Available tokens

| Token | Description |
| ----- | ----------- |
| `titleText` | Dialog title text color |
| `markdownBodyText` | Dialog body text color |
| `markdownLinkText` | Link text color inside the dialog body |
| `positiveBackground` | Positive button background color |
| `positiveText` | Positive button text color |
| `positiveBorderColor` | Positive button border color |
| `negativeBackground` | Negative button background color |
| `negativeText` | Negative button text color |
| `negativeBorderColor` | Negative button border color |

**Note:**

- This customization is supported in version `1.26.0` or later.
- `memoryDialog` only affects the user memory dialog.
- Use hex colors for custom color values.
