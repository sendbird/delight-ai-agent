[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to handle link clicks in conversation messages

Intercept link clicks the SDK opens — markdown links, admin-message URLs, citations, CTA buttons, and file-message file-preview clicks — through the `handlers.onClickLink` callback on `AgentProviderContainer`.

### Example

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

export const App = () => {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      handlers={{
        onClickLink: ({ url }) => {
          // analytics
          analytics.track('agent_link_click', { url });

          // in-app navigation for custom schemes
          if (url.startsWith('myapp://')) {
            router.push(url);
            return;
          }

          // default behavior
          window.open(url, '_blank', 'noopener,noreferrer');
        },
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
};
```

### Notes

- Without `onClickLink`, the SDK falls back to `window.open(url, '_blank', 'noopener,noreferrer')`. If the URL has no protocol, the default prepends `https://`. Customer handlers receive the raw URL.
- The MediaViewer's download button is intentionally excluded — it keeps native `<a href download>` behavior so browser-side downloads continue working without a custom handler.
- If you replace message/layout slots and receive message props, slot-level callbacks (`onClickCTA`, `onClickCitation`, `onClickMedia`, `onClickFile`) still override that slot's behavior entirely and take precedence over `onClickLink`. `onClickLink` is the "last default" — used when no slot-level override is supplied.
