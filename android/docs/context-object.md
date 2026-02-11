# Context object

Context object is a key–value store that sends customer-specific information to the AI agent. This enables more personalized and context-aware responses.&#x20;

***

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

***

### When to set context

You can set the context object:

* **At initialization**: To pass initial user or environment information.
* **After initialization (at runtime)**: To update or add information after the messenger is running, or mid-conversation.

***

### Methods

The following methods can be used to add or update context objects after initialization.

<table><thead><tr><th width="186.49609375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>updateContext</code></td><td>Overwrites the entire context object. Keys not included will be removed. </td></tr><tr><td><code>patchContext</code></td><td>Merges the provided keys into the existing context. Other keys remain unchanged.</td></tr><tr><td><code>getContextObject</code></td><td>Retrieves the current context object.</td></tr></tbody></table>

> For details on setting context at initialization, refer to the [Android messenger quickstart guide](README.md#passing-context-object-to-agent).

***

### Update context object

```kotlin
val context: Map<String, String> = mapOf("key1" to "value1", "key2" to "value2")
updateContext(context) { contextObject, e ->
    if (e != null) {
        // Handle the error
    }
    // Handle the context object
}
```

***

### Patch context object

```kotlin
val context: Map<String, String> = mapOf("key1" to "value3", "key2" to "value4")
patchContext(context) { contextObject, e ->
    if (e != null) {
        // Handle the error
    }
    // Handle the context object
}
```

***

### Get context object

```kotlin
getContextObject { contextObject, e ->
    if (e != null) {
        // Handle the error
    }
    // Handle the context object
}
```
