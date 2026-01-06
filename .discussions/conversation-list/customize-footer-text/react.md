[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to customize the footer text in the Conversation List

You can customize the footer button text by creating a custom `Footer` component or by using localization.

**Method 1: Using Custom Footer Component**

Create a custom footer with your desired text:

```tsx
import { ReactNode } from 'react';
import { useMessengerSessionContext, useMessengerContext } from '@sendbird/ai-agent-messenger-react';
import { ConversationStatus } from '@sendbird/chat/aiAgent';

const CustomFooterText = (): ReactNode => {
  const { createConversation, setActiveChannel, refreshActiveChannel, aiAgentInfo } = useMessengerSessionContext();
  const { language, countryCode, context } = useMessengerContext();

  const handleClick = async () => {
    if (aiAgentInfo.isMultipleActiveConversationsEnabled) {
      const url = await createConversation({
        aiAgentId: aiAgentInfo.userId,
        language,
        country: countryCode,
        context,
      });
      setActiveChannel({ url, status: ConversationStatus.OPEN });
    } else {
      await refreshActiveChannel();
    }
  };

  return (
    <div
      style={{ backgroundColor: '#FFE5F0', padding: '16px', textAlign: 'center' }}
      onClick={handleClick}
    >
      <span style={{ fontWeight: '700' }}>Start New Chat</span>
    </div>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  ConversationList,
  ConversationListLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <ConversationListLayout.Template>
        <ConversationListLayout.Footer component={CustomFooterText} />
      </ConversationListLayout.Template>

      <ConversationList
        onOpenConversationView={(channelUrl, status) => {
          console.log('Opening conversation:', channelUrl);
        }}
      />
    </AgentProviderContainer>
  );
}
```

**Method 2: Using Localization (String Set)**

Customize the footer text through the localization system:

```tsx
<AgentProviderContainer
  applicationId="YOUR_APP_ID"
  aiAgentId="YOUR_AI_AGENT_ID"
  stringSet={{
    TALK_TO_AGENT: 'Start New Chat'  // Your custom text
  }}
>
  <ConversationList />
</AgentProviderContainer>
```

**Notes:**
- The default text is "Talk to Agent"
- The footer button creates a new conversation or refreshes the active conversation
- Using localization is simpler but only changes the text
- Using a custom component gives full control over styling and behavior
- The string key is `TALK_TO_AGENT` in the default string set
