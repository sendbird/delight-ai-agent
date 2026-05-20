[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.22.0-grey.svg?style=flat-square)]()

## How to change the primary color used by the Conversation List footer

The Conversation List footer uses the SDK primary color. You can change that color through `theme.colors.base.primary` while keeping the default footer behavior that creates or opens a conversation.

```tsx
import {
  AgentProviderContainer,
  ConversationList,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      theme={{
        colors: {
          base: {
            primary: '#FFE5F0',
            primaryContrastContent: '#333333',
          },
        },
      }}
    >
      <ConversationList
        onOpenConversationView={(channelUrl, status) => {
          console.log('Opening conversation:', channelUrl, status);
        }}
      />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The default footer uses `theme.colors.base.primary` as its background color.
- The footer text uses `theme.colors.base.primaryContrastContent`.
- The default footer button text is the localized `stringSet.TALK_TO_AGENT` value (English default: `Start a conversation`).
- This is not a footer-only token. The primary color can also affect other SDK surfaces that use `theme.colors.base.primary`.
