# Context object

Context object is a key–value store that sends customer-specific information to the AI agent. This enables more personalized and context-aware responses.

> ℹ️ **Note:** If you've integrated Delight AI agent with Sendbird Desk, the `contextObject` is automatically imported and displayed in Desk tickets. For details, [see our Desk guide](https://docs.delight.ai/dashboard-guide/integrations/sendbird-desk/handoff?q=auto+popu#auto-populated-ticket-fields).

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
| `awaitUpdateContext` | Overwrites the entire context object. Keys not included will be removed. |
| `awaitPatchContext` | Merges the provided keys into the existing context. Other keys remain unchanged. |
| `awaitGetContextObject` | Retrieves the current context object. |

> For details on setting context at initialization, refer to the [Android messenger quickstart guide](./#passing-context-object-to-agent).

---

### Update context object

```kotlin
// Using AIAgentMessenger (top-level)
val context: Map<String, String> = mapOf("key1" to "value1", "key2" to "value2")
val contextObject = AIAgentMessenger.awaitUpdateContext(
    aiAgentId = "YOUR_AI_AGENT_ID",
    channelUrl = "CHANNEL_URL",
    context = context
)

// Using ConversationViewModel (inside a conversation)
val contextObject = viewModel.awaitUpdateContext(context)
```

---

### Patch context object

```kotlin
// Using AIAgentMessenger (top-level)
val context: Map<String, String> = mapOf("key1" to "value3", "key2" to "value4")
val contextObject = AIAgentMessenger.awaitPatchContext(
    aiAgentId = "YOUR_AI_AGENT_ID",
    channelUrl = "CHANNEL_URL",
    context = context
)

// Using ConversationViewModel (inside a conversation)
val contextObject = viewModel.awaitPatchContext(context)
```

---

### Get context object

```kotlin
// Using ConversationViewModel (inside a conversation)
val contextObject = viewModel.awaitGetContextObject()
```