[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to handle link clicks in conversation messages

Currently, links in messages automatically open in a new tab with `target="_blank"`. To customize link behavior, you need to create a custom `MessageBody` component that handles link clicks.

**Step 1: Create a Custom MessageBody with Link Handler**

```tsx
import { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';
import { useEffect, useRef } from 'react';

const CustomMessageBodyWithLinkHandler = (props: IncomingMessageProps) => {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const handleClick = (e: MouseEvent) => {
      const target = e.target as HTMLElement;
      if (target.tagName === 'A') {
        e.preventDefault();
        const href = target.getAttribute('href');
        if (href) {
          console.log('Link clicked:', href);

          // Custom logic here (e.g., handle deep links)
          if (href.startsWith('tel:')) {
            // Handle phone number links
            window.location.href = href;
          } else if (href.startsWith('mailto:')) {
            // Handle email links
            window.location.href = href;
          } else {
            window.open(href, '_blank');
          }
        }
      }
    };

    container.addEventListener('click', handleClick);
    return () => container.removeEventListener('click', handleClick);
  }, []);

  return (
    <div ref={containerRef}>
      {props.message}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      applicationId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    >
      <IncomingMessageLayout.Template>
        <IncomingMessageLayout.MessageBody component={CustomMessageBodyWithLinkHandler} />
      </IncomingMessageLayout.Template>

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- By default, all links open in a new tab with `target="_blank"` and `rel="noopener noreferrer"`
- Custom link handling requires replacing the `MessageBody` component
- The message content is rendered as Markdown, so links are automatically converted to `<a>` tags
- Consider security implications when handling custom URL schemes
