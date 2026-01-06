[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to customize the background color of the message input box

> **⚠️ Disclaimer**: The message input box component is not currently exposed for direct customization through the Layout API. The CSS approach below is a workaround and not the optimal solution. This may be subject to change in future SDK versions as the component structure evolves.

The message input box background is applied to a container that is the **grandparent** (parent's parent) of the textarea element. You can target it precisely using CSS with the `:has()` pseudo-class:

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <>
      <style>{`
        /* Target the grandparent div that contains the textarea with aria-label="Text Input" */
        [data-sb-agent-theme] div:has(> div > textarea[aria-label="Text Input"]) {
          background-color: #F0F9FF !important;
        }
      `}</style>

      <AgentProviderContainer
        applicationId="YOUR_APP_ID"
        aiAgentId="YOUR_AI_AGENT_ID"
      >
        <Conversation />
      </AgentProviderContainer>
    </>
  );
}
```

**DOM Structure Reference:**

```
Container (div)
└── MessageInputBox (div) ← Target this: Has background-color and border-radius: 20px
    └── TextAreaWrapper (div)
        └── TextArea (textarea with aria-label="Text Input")
```
