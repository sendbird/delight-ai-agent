[![React-Native](https://img.shields.io/badge/React--Native-61DAFB?style=flat-square&logo=react&logoColor=black)![RN Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the suggested replies message UI

You can customize the suggested replies shown under the latest incoming message by replacing the `SuggestedReplies` component using `IncomingMessageLayout`.

**Step 1: Create a Custom SuggestedReplies Component**

The component receives the incoming message props. Read the reply labels from `extendedMessagePayload.suggested_replies` and send the selected one through `onClickSuggestedReply`.

```tsx
import { Pressable, Text, View } from 'react-native';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react-native';

const CustomSuggestedReplies = ({ extendedMessagePayload, onClickSuggestedReply }: IncomingMessageProps) => {
  const replies = extendedMessagePayload?.suggested_replies ?? [];

  if (replies.length === 0) return null;

  return (
    <View
      style={{
        alignItems: 'flex-end',
        gap: 8,
        marginVertical: 16,
        paddingHorizontal: 12,
      }}
    >
      {replies.map((reply, index) => (
        <Pressable
          key={index}
          onPress={() => onClickSuggestedReply?.({ reply })}
          style={{
            maxWidth: 336,
            paddingHorizontal: 12,
            paddingVertical: 8,
            borderRadius: 16,
            borderWidth: 1,
            borderColor: '#7A50F2',
            backgroundColor: '#FFFFFF',
          }}
        >
          <Text style={{ color: '#7A50F2' }}>{reply}</Text>
        </Pressable>
      ))}
    </View>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import { createMMKV } from 'react-native-mmkv';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
  IncomingMessageLayout,
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
      <IncomingMessageLayout.SuggestedReplies component={CustomSuggestedReplies} />

      <FixedMessenger windowMode={'floating'} />
    </AIAgentProviderContainer>
  );
}
```

**Hide suggested replies entirely**

Replace the slot with a component that renders nothing.

```tsx
const HiddenSuggestedReplies = () => null;

<IncomingMessageLayout.SuggestedReplies component={HiddenSuggestedReplies} />
```

**Notes:**
- The slot is rendered only for the last incoming message, so the custom component does not need to check message position.
- The reply labels come from `extendedMessagePayload.suggested_replies`. Return `null` when the array is empty so no empty container is rendered.
- `onClickSuggestedReply({ reply })` sends the label as a user message. The default component also disables the choices after one selection. A custom component owns that behavior, so keep your own "already replied" state if you want the same behavior.
- When Sendbird Desk asks the user to confirm ending the conversation, the default component renders confirm and decline choices in this same slot instead of `suggested_replies`, and reports the choice through `onConfirmTicketClosure`. A full replacement that only renders `suggested_replies` removes those choices, so keep the default component if your app uses Desk handoff.
