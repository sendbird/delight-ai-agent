[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to disable the poweredBy message in the conversation

The React SDK does not expose a client-side prop, config, or layout slot for the "Powered by" message shown above the first message in the conversation. Its visibility is an application-level setting, so it is turned off through the support request described above rather than in code.

Once the setting is applied to your Sendbird application, the message stops rendering on the next messenger session. No code change or SDK upgrade is required, and the space it occupied is removed from the message list.

### Verifying the change

Reload the page after the setting is applied so the SDK fetches the updated application information, then confirm the message is gone above the first message in the conversation.

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- The setting applies to the whole Sendbird application, so it affects every AI agent and every platform SDK using that application.
- The message text itself is localized through the `POWERED_BY` string key. Overriding that string changes the wording but does not hide the message.
- While the message is visible, clicking the Sendbird link goes through `handlers.onClickLink`, so you can intercept or block that navigation without hiding the message.
- Do not try to hide it with CSS overrides against SDK-rendered elements. Those selectors are internal and can change in any release.
