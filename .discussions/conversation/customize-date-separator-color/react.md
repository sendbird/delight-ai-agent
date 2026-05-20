[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.15.0-grey.svg?style=flat-square)]()

## How to customize the date separator label color in the conversation

You can customize the date separator by replacing the `DateSeparator` component through `MessageListUILayout`.

**Step 1: Create a Custom DateSeparator Component**

```tsx
import type { DateSeparatorProps } from '@sendbird/ai-agent-messenger-react';
import { useLocalizationContext } from '@sendbird/ai-agent-messenger-react';

const CustomDateSeparator = ({ date = Date.now(), className, style }: DateSeparatorProps) => {
  const { format, stringSet } = useLocalizationContext();
  return (
    <div
      className={className}
      style={{
        ...style,
        display: 'flex',
        justifyContent: 'center',
        color: '#7A50F2',
        fontSize: '12px',
      }}
    >
      {format(date, stringSet.DATE_FORMAT__MESSAGE_LIST__DATE_SEPARATOR)}
    </div>
  );
};
```

**Step 2: Apply the Custom Component**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  MessageListUILayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <MessageListUILayout.DateSeparator component={CustomDateSeparator} />

      <Conversation />
    </AgentProviderContainer>
  );
}
```

**Notes:**
- `DateSeparatorProps` exposes `date`, `className`, and `style`. The example reuses the default `DATE_FORMAT__MESSAGE_LIST__DATE_SEPARATOR` formatter through `useLocalizationContext()`.
- The default date separator uses the `caption4` typography variant and the `textMidEmphasis` color from the theme.
