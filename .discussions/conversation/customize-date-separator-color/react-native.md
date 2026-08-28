[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the date separator label color in the conversation

You can customize the date separator by replacing the `DateSeparator` component through `MessageListUILayout`.

**Step 1: Create a Custom DateSeparator Component**

```tsx
import { Text, View } from 'react-native';
import type { DateSeparatorProps } from '@sendbird/ai-agent-messenger-react-native';

const CustomDateSeparator = ({ date = Date.now(), style, ...props }: DateSeparatorProps) => {
  const label = new Date(date).toLocaleDateString([], { month: 'short', day: 'numeric', year: 'numeric' });

  return (
    <View style={[{ flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }, style]} {...props}>
      <Text style={{ color: '#7A50F2', fontSize: 12 }}>{label}</Text>
    </View>
  );
};
```

**Step 2: Apply the Custom Component**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
  MessageListUILayout,
} from '@sendbird/ai-agent-messenger-react-native';

const nativeModules = {
  mmkv: createMMKV(),
};

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <MessageListUILayout.DateSeparator component={CustomDateSeparator} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Notes:**
- `DateSeparatorProps` extends `ViewProps` and adds an optional `date` of type `Date | number`. Spread the remaining props onto your outermost view so the list keeps passing through layout and accessibility props.
- The default date separator uses the `caption4` typography variant and the mid emphasis text color from the theme.
- The default component formats the date with the SDK's localized `date_format.date_separator` string. A custom component owns formatting, so keep it consistent with the `language` you pass to `AIAgentProviderContainer`.
