[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

### Changing titleView alignment in Conversation Header

This guide explains how to change the alignment of the titleView in the **Conversation Header** in the conversation message list.

You can set the alignment of the conversation header titleView using the `titleAlign` property in the `ConversationHeaderLayout` template.

**Example:**

```tsx
import { AgentProviderContainer, ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const CustomTemplate = () => {
  return <ConversationHeaderLayout.defaults.template titleAlign={'center'} />;
};

export const App = () => {
  return (
    <AgentProviderContainer>
      <ConversationHeaderLayout.Template template={CustomTemplate} />
    </AgentProviderContainer>
  );
};
```

**Explanation:**
- `titleAlign={'start'}` - Left-aligns the titleView in the header
- `titleAlign={'center'}` - Center-aligns the titleView in the header
- `titleAlign={'end'}` - Right-aligns the titleView in the header
