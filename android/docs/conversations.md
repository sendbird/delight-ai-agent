# Conversations

In Delight AI agent, a conversation refers to a channel where an AI Agent communicates with a user. Depending on your service requirements, you can allow users to maintain a single active conversation or multiple. Delight AI agent supports two different conversation modes: Single active conversation and Multiple active conversation mode, which is the default.

When the launcher is clicked, a user can be led to either their conversation list or a conversation depending on your choice of the conversation mode.

| Feature                    | Single active conversation                                                                 | Multiple active conversations (Default)                                                                 |
| -------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| Number of active conversation | A user can have only one active conversation with your AI agent at a time.                 | A user can have multiple active conversations with your AI agent at the same time.                      |
| Starting a new conversation   | A new conversation can't be created if there is an active conversation at the moment. The existing conversation must end first. | New conversations can be created anytime using `AIAgentMessenger.createConversation()`.                 |

> **Note**: Whichever conversation mode you choose, if there is no active conversation, a new conversation is automatically created and the user can start a dialogue with your AI agent. This provides seamless user experience without requiring manual conversation setup.

This guide explains:
- [Start a conversation](#start-a-conversation)
    - [With MessengerLauncher](#with-messengerlauncher)
    - [With MessengerActivity](#with-messengeractivity)
- [Advanced configuration](#advanced-configuration)
    - [Context object for personalized conversation](#context-object-for-personalized-conversation)
    - [Opening a specific conversation with channel URL](#opening-a-specific-conversation-with-channel-url)
    - [Start a conversation in multiple conversation mode](#start-a-conversation-in-multiple-conversation-mode)
- [API references](#api-references)

---

## Start a conversation

Once you have determined which conversation mode to apply, you should also consider how the messenger will be launched. Delight AI agent SDK supports two launch methods: `MessengerLauncher` and `MessengerActivity`. The following table describes the characteristics of each class.

| Feature              | MessengerLauncher                                                                                      | MessengerActivity                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| UI Presentation      | A floating widget attached to the client app's screen.                                                 | A full-screen activity.                                                           |
| Context requirement  | Requires a `FragmentActivity`.                                                                         | Any `Context` can start the activity.                                             |
| Lifecycle management | Requires calling `attach()` and `detach()` manually.                                                   | Standard Android activity lifecycle.                                              |
| Entry point          | Configured via `LauncherSettingsParams.entryPoint`.                                                    | Specified when creating an intent such as `newIntentForConversation` or `newIntentForConversationList`. |
| Customization        | Extensive layout customization, such as position, size, and margins, via `LauncherLayoutParams`.       | Standard activity appearance. It can be customized through themes.                         |
| Launcher appearance  | Customizable appearance via dashboard.                                                                 | N/A - no launcher icon needed.                                                    |

### With `MessengerLauncher`

`MessengerLauncher` provides a floating UI approach for launching the messenger and starting a conversation. In the `MessengerLauncher`, you can lead the user to either a conversation view or a conversation list view. In the snippet below, simply calling `attach()` automatically starts a conversation when the launcher is clicked. If you wish to show a conversation list first, use `openConversationList()` method.

For detailed `MessengerLauncher` API reference and comprehensive integration guide, see [our Launcher guide](launcher.md).

```kotlin
// Basic launcher setup - automatically starts conversation when clicked
val messengerLauncher = MessengerLauncher(
    context = this, // Must be FragmentActivity
    aiAgentId = "YOUR_AI_AGENT_ID"
)
messengerLauncher.attach() // After attach(), clicking launcher automatically starts a conversation.
```

#### Launch a conversation

```kotlin
// Direct conversation launch through MessengerLauncher
messengerLauncher.openConversation()

// Launch specific conversation with channel URL
messengerLauncher.openConversation(channelUrl = "sendbird_group_channel_12345")
```

#### Launch a conversation list

```kotlin
// Launch conversation list through MessengerLauncher
messengerLauncher.openConversationList()
```

### With `MessengerActivity`

`MessengerActivity` provides a full-screen approach for launching the messenger and starting a conversation. Like `MessengerLauncher`, you can lead the user to either a conversation view or a conversation list view. What differentiates the two is the `conversationChannelUrl` parameter. When creating a new `intent` instance, if you don't use the parameter, it leads the user to their conversation list. If the `conversationChannelUrl` is `null`, it creates a new conversation. If the URL is specified, it opens the existing channel.

#### Launch a conversation

```kotlin
// Start a new conversation in full-screen mode.
val intent = MessengerActivity.newIntentForConversation(
    context = this,
    aiAgentId = "YOUR_AI_AGENT_ID",
    conversationChannelUrl = null, // Passing null as conversationChannelUrl creates a new conversation.
    conversationSettingsParams = ConversationSettingsParams()
)
startActivity(intent)

// Launch an existing conversation by specifying its channel URL.
val existingConversationIntent = MessengerActivity.newIntentForConversation(
    context = this,
    aiAgentId = "YOUR_AI_AGENT_ID",
    conversationChannelUrl = "sendbird_group_channel_12345",
    conversationSettingsParams = ConversationSettingsParams(
        language = "en-US",
        context = mapOf("user_type" to "premium")
    )
)
startActivity(existingConversationIntent)
```

#### Launch a conversation list

```kotlin
// Open the conversation list in full-screen mode
val intent = MessengerActivity.newIntentForConversationList(
    context = this,
    aiAgentId = "YOUR_AI_AGENT_ID",
    conversationSettingsParams = ConversationSettingsParams(
        language = Locale.getDefault().toLanguageTag(),
        country = Locale.getDefault().country
    )
)
startActivity(intent)
```

---

## Advanced configuration

Beside the conversation mode, you can further configure how the conversation channels are created and built.

When a new conversation begins, you can pass over user information to the channel so that AI agent can provide more personalized assistance to the user. This information is contained in a `context` object, which can be set at the creation of the conversation.

Also, you can open a specific conversation channel by passing its URL to either `MessengerLauncher` or `MessengerActivity`, or manually create a new one while in multiple conversation mode.

### Context object for personalized conversation

The `context` object allows you to provide user's information to AI agents for more personalized service, such as their country code and language preference. This context can be set when creating conversations to enhance the user experience. The following table lists configuration classes where you can initialize a `context` object.

| Class                        | Purpose                                                                 | Used With                                                                                 |
| ---------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `ConversationSettingsParams` | Configures the conversation settings when launching via `MessengerActivity`. | `MessengerActivity.newIntentForConversation()`, `MessengerActivity.newIntentForConversationList()` |
| `ConversationCreateParams`   | Manually creates a new conversation.                                    | `AIAgentMessenger.createConversation()`                                                   |
| `LauncherSettingsParams`     | Configures the floating launcher’s behavior and appearance.             | `MessengerLauncher` constructor                                                           |

```kotlin
// Setting context through ConversationSettingsParams
val conversationSettings = ConversationSettingsParams(
    language = "en-US", // IETF BCP 47 format
    country = "US",     // ISO 3166 format
    context = mapOf(
        "customer_tier" to "premium",
        "previous_interaction" to "support_ticket_123",
        "user_preferences" to "technical_support"
    )
)

// Using context with MessengerActivity
val intent = MessengerActivity.newIntentForConversation(
    context = this,
    aiAgentId = "YOUR_AI_AGENT_ID",
    conversationChannelUrl = null,
    conversationSettingsParams = conversationSettings
)
startActivity(intent)

// Using context with manual conversation creation
val createParams = ConversationCreateParams(
    aiAgentId = "YOUR_AI_AGENT_ID",
    language = "en-US",
    country = "US",
    context = mapOf(
        "customer_tier" to "premium",
        "session_type" to "first_visit"
    )
)

AIAgentMessenger.createConversation(createParams) { channelUrl, error ->
    // Handle result
}
```

### Opening a specific conversation with channel URL

You can open a specific conversation by passing its channel URL to either `MessengerLauncher` or `MessengerActivity`:

#### With `MessengerLauncher`

```kotlin
// Using MessengerLauncher with specific channel URL
messengerLauncher.openConversation(channelUrl = "sendbird_group_channel_12345")
```

#### With `MessengerActivity`

```kotlin
// Using MessengerActivity with specific channel URL
val intent = MessengerActivity.newIntentForConversation(
    context = this,
    aiAgentId = "YOUR_AI_AGENT_ID",
    conversationChannelUrl = "sendbird_group_channel_12345"
)
startActivity(intent)
```

### Start a conversation in multiple conversation mode

Multiple active conversation mode allows users to simultaneously communicate with your AI agent in different channels. In this case, use `AIAgentMessenger.createConversation()` to create a new conversation whenever needed.

> **Note**: In single conversation mode, a new conversation can't be created if there is an active conversation.

```kotlin
// Create conversation manually
val params = ConversationCreateParams(
    aiAgentId = "YOUR_AI_AGENT_ID",
    language = "en-US",
    country = "US",
    context = mapOf(
        "user_type" to "premium",
        "session_id" to "session_123"
    )
)

AIAgentMessenger.createConversation(params) { channelUrl, error ->
    if (error == null && channelUrl != null) {
        // Use the returned channel URL to launch the conversation

        // Option 1: Launch via MessengerLauncher
        messengerLauncher.openConversation(channelUrl = channelUrl)

        // Option 2: Launch via MessengerActivity
        val intent = MessengerActivity.newIntentForConversation(
            context = this,
            aiAgentId = "YOUR_AI_AGENT_ID",
            conversationChannelUrl = channelUrl
        )
        startActivity(intent)

        Log.d("Conversation", "Successfully created conversation: $channelUrl")
    } else {
        // Handle error case
        Log.e("Conversation", "Failed to create conversation: ${error?.message}")
    }
}
```

---

## API references

### ConversationCreateParams

The following table lists the configuration options in `ConversationCreateParams`, which can be used when creating new conversations programmatically.

| Property                          | Type                   | Default       | Description                                           |
| --------------------------------- | ---------------------- | ------------- | ----------------------------------------------------- |
| `aiAgentId`                       | String               | Required      | AI agent identifier for conversation target.          |
| `language`                        | String               | System locale | Language setting following IETF BCP 47 format.        |
| `country`                         | String?              | null        | Country code following ISO 3166 format.               |
| `context`                         | Map<String, String>  | Empty map     | Meta context map for additional AI agent information. |
| `shouldUseCurrentActiveChannelUrl` | Boolean             | true        | Whether to use known channel URL if available.        |

### ConversationSettingsParams

The following table lists the configuration options in `ConversationSettingsParams`, which can be used when configuring the conversation settings when launching via `MessengerActivity`.

| Property                          | Type                  | Default       | Description                                           |
| --------------------------------- | --------------------- | ------------- | ----------------------------------------------------- |
| `language`                        | String              | System locale | Language setting following IETF BCP 47 format.        |
| `country`                         | String?             | null        | Country code following ISO 3166 format.               |
| `context`                         | Map<String, String> | Empty map     | Meta context map for additional AI agent information. |
| `shouldUseCurrentActiveChannelUrl` | Boolean            | true        | Whether to use known channel URL if available.        |

### ConversationCreateHandler

The following table lists the interface for handling conversation creation results.

| Method     | Parameters                                         | Description                                                 |
| ---------- | -------------------------------------------------- | ----------------------------------------------------------- |
| `onResult` | channelUrl: String?, exception: SendbirdException? | Callback method called when conversation creation completes. |

### AIAgentMessenger Methods

The following table lists the core conversation management methods in `AIAgentMessenger` object.

| Method               | Parameters                                                            | Return Type | Description                                          |
| -------------------- | --------------------------------------------------------------------- | ----------- | ---------------------------------------------------- |
| `createConversation` | params: ConversationCreateParams, handler: ConversationCreateHandler? | Unit        | Creates a new conversation with specified parameters. |

### MessengerActivity Methods

The following table lists the static methods for creating intents to launch `MessengerActivity`.

| Method                         | Parameters                                                                                                          | Description                                                                 |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `newIntentForConversation`     | context: Context, aiAgentId: String, conversationChannelUrl: String?, conversationSettingsParams: ConversationSettingsParams | Creates intent for opening specific conversation or starting new one. Return type is `intent`. |
| `newIntentForConversationList` | context: Context, aiAgentId: String, conversationSettingsParams: ConversationSettingsParams                   | Creates intent for displaying conversation list. Return type is `intent`.   |
