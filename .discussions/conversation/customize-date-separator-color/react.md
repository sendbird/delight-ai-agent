[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.12.0-grey.svg?style=flat-square)]()

## How to customize the date separator label color in the conversation

Currently, the date separator color customization is not directly supported through component replacement. However, you can customize it using CSS variables through the theme provider.

**Method: Using Theme Palette**

Customize the date separator color by overriding the theme's text color values:

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
      theme={{
        palette: {
          onLight: {
            textMidEmphasis: '#7A50F2',  // Date separator color for light mode
          },
          onDark: {
            textMidEmphasis: '#7A50F2',  // Date separator color for dark mode
          }
        }
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Note:**
- The date separator uses the `caption4` typography variant and `textMidEmphasis` color
- You must configure both `onLight` and `onDark` to ensure consistent appearance across themes
- Changing `textMidEmphasis` will affect other UI elements that use the same color token (e.g., secondary text, captions)
- Direct component customization is not currently supported - theme palette is the only method available
