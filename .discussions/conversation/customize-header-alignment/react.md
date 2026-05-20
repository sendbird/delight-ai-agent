[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.10.0-grey.svg?style=flat-square)]()

## How to set Conversation Header title alignment

This guide explains how to change the alignment of the titleView in the **Conversation Header** in the conversation message list.

You can set the conversation header title placement using the `titleAlign` property in the `ConversationHeaderLayout` template. This controls the title area inside the header row. It does not replace the right-side action area.

**Example:**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  ConversationHeaderLayout,
} from '@sendbird/ai-agent-messenger-react';

type HeaderTemplateProps = {
  titleAlign?: 'start' | 'center' | 'end';
};

const CenteredHeaderTemplate = (props: HeaderTemplateProps) => {
  const DefaultTemplate = ConversationHeaderLayout.defaults.template;
  return <DefaultTemplate {...props} titleAlign={'center'} />;
};

export const App = () => {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <ConversationHeaderLayout.Template template={CenteredHeaderTemplate} />

      <Conversation />
    </AgentProviderContainer>
  );
};
```

**Explanation:**
- `titleAlign={'start'}` - Vertically aligns the title to the top of the header row (default)
- `titleAlign={'center'}` - Centers the titleView between the start and end areas
- `titleAlign={'end'}` - Vertically aligns the title to the bottom of the header row. To place custom controls on the right side of the header, replace or wrap `ConversationHeaderLayout.EndArea`.
