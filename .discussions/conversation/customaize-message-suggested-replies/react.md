[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)]()

## How to customize the suggested replies message UI

You can customize the suggested replies shown under the latest incoming message by replacing the `SuggestedReplies` component using `IncomingMessageLayout`.

**Step 1: Create a Custom SuggestedReplies Component**

The component receives the incoming message props. Read the reply labels from `extendedMessagePayload.suggested_replies` and send the selected one through `onClickSuggestedReply`.

```tsx
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomSuggestedReplies = ({
  extendedMessagePayload,
  suggestedRepliesDirection = 'vertical',
  onClickSuggestedReply,
}: IncomingMessageProps) => {
  const replies = extendedMessagePayload?.suggested_replies ?? [];

  if (replies.length === 0) return null;

  const isVertical = suggestedRepliesDirection === 'vertical';

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: isVertical ? 'column' : 'row',
        alignItems: isVertical ? 'flex-end' : 'center',
        overflowX: isVertical ? 'visible' : 'auto',
        gap: '8px',
        margin: '16px 0',
        padding: '0 12px',
      }}
    >
      {replies.map((reply, index) => (
        <button
          key={index}
          type={'button'}
          onClick={() => onClickSuggestedReply?.({ reply })}
          style={{
            padding: '8px 12px',
            borderRadius: '20px',
            border: '1px solid #7A50F2',
            backgroundColor: '#FFFFFF',
            color: '#7A50F2',
            cursor: 'pointer',
            whiteSpace: isVertical ? 'pre-wrap' : 'nowrap',
          }}
        >
          {reply}
        </button>
      ))}
    </div>
  );
};
```

**Step 2: Register the Custom Component**

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
} from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
    >
      <IncomingMessageLayout.SuggestedReplies component={CustomSuggestedReplies} />

      <Conversation />
    </AgentProviderContainer>
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
- `onClickSuggestedReply({ reply })` sends the label as a user message. The default component also hides itself after one selection. A custom component owns that behavior, so keep your own "already replied" state if you want the same behavior.
- `suggestedRepliesDirection` is `'vertical'` by default. Handle both values if you want to keep the SDK's horizontal scrolling layout.
- When Sendbird Desk asks the user to confirm ending the conversation, the default component renders confirm and decline choices in this same slot instead of `suggested_replies`, and reports the choice through `onConfirmTicketClosure`. A full replacement that only renders `suggested_replies` removes those choices, so keep the default component if your app uses Desk handoff.
