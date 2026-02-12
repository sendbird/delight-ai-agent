---

# Context object

Context object is a key–value store that sends customer-specific information to the AI agent. This enables more personalized and context-aware responses.

---

### Use case examples

The following examples show how context objects can be utilized.

#### User profile and preferences

The AI agent can greet the user by name, adjust its tone for premium mebmers, and display times in the correct time zone.

```json
{
  "userId": "u-928374",
  "membershipTier": "gold",
  "preferredLanguage": "en-US",
  "timezone": "America/New_York"
}
```

#### E-commerce checkout flow

The AI agent can help finalize the order, apply the discount, and offer relevant product recommendations.

```json
{
  "cartItemCount": "3",
  "cartTotalUSD": "249.99",
  "currency": "USD",
  "discountCode": "SUMMER25"
}
```

#### Travel booking

The AI agent can look up booking details, or suggest upgrades.

```json
{
  "bookingReference": "ABC123",
  "destination": "Tokyo",
  "departureDate": "2025-09-14",
  "seatClass": "business"
}
```

---

### When to set context

You can set the context object:

* **At initialization**: To pass initial user or environment information.
* **After initialization (at runtime)**: To update or add information after the messenger is running, or mid-conversation.

---

### Methods

The following methods can be used to add or update context objects after initialization.

| Method | Description |
| --- | --- |
| `updateContext` | Overwrites the entire context object. Keys not included will be removed. |
| `patchContext` | Merges the provided keys into the existing context. Other keys remain unchanged. |
| `getContextObject` | Retrieves the current context object. |

> For details on setting context at initialization, refer to the [React messenger quickstart guide](README.md#passing-context-object-to-agent).

---

### Manage context object

```tsx
import { FixedMessenger, type MessengerSessionRef } from '@sendbird/ai-messenger';
import { useRef } from 'react';

function App() {
  const messengerRef = useRef<MessengerSessionRef>(null);

  // Update context object
  async function updateContext() {
    await messengerRef.current?.updateContext({
      membership: 'gold',
      language: 'en-US'
    });
  }

  // Patch context object
  async function patchContext() {
    await messengerRef.current?.patchContext({
      bookingReference: 'ABC123'
    });
  }

  // Get context object
  async function getContext() {
    const context = await messengerRef.current?.getContextObject();
    console.log(context);
  }

  return (
    <FixedMessenger
      ref={messengerRef}
      appId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
    />
  );
}

```

---