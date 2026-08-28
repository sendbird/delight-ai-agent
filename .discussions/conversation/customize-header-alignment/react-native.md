[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to set Conversation Header title alignment

This guide explains how to change the alignment of the titleView in the **Conversation Header** in the conversation message list.

You can set the conversation header title placement using the `titleAlign` property in the `ConversationHeaderLayout` template. This controls the title area inside the header row. It does not replace the right-side action area.

**Example:**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  ConversationHeaderLayout,
  FixedMessenger,
} from '@sendbird/ai-agent-messenger-react-native';

const nativeModules = {
  mmkv: createMMKV(),
};

type HeaderTemplateProps = {
  titleAlign?: 'start' | 'center' | 'end';
};

const CenteredHeaderTemplate = (props: HeaderTemplateProps) => {
  const DefaultTemplate = ConversationHeaderLayout.defaults.template;
  return <DefaultTemplate {...props} titleAlign={'center'} />;
};

export const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <ConversationHeaderLayout.Template template={CenteredHeaderTemplate} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
};
```

**Explanation:**
- `titleAlign={'start'}` - Places the title next to the start area (default)
- `titleAlign={'center'}` - Centers the titleView between the start and end areas
- `titleAlign={'end'}` - Places the title next to the end area. To place custom controls on the right side of the header, replace or wrap `ConversationHeaderLayout.EndArea`.

**Notes:**
- The same `titleAlign` property is available on `ConversationListHeaderLayout.Template` for the conversation list header.
