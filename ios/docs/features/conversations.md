# Conversations

In Delight AI agent, a conversation refers to a channel where an AI Agent communicates with a user. Depending on your service requirements, you can allow users to maintain a single active conversation or multiple. Delight AI agent supports two different conversation modes: Single active conversation and Multiple active conversation mode, which is the default.

When the launcher is clicked, a user can be led to either their conversation list or a conversation depending on your choice of the conversation mode.

| Feature                      | Single active conversation                                                                 | Multiple active conversations (Default)                                                                 |
| ---------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| Number of active conversation | A user can have only one active conversation with your AI agent at a time.                 | A user can have multiple active conversations with your AI agent at the same time.                      |
| Starting a new conversation   | A new conversation can't be created if there is an active conversation at the moment. The existing conversation must end first. | New conversations can be created anytime using `AIAgentMessenger.createConversation()`.                 |

> **Note**: Whichever conversation mode you choose, if there is no active conversation, a new conversation is automatically created and the user can start a dialogue with your AI agent. This provides seamless user experience without requiring manual conversation setup.

This guide explains:
- [Start a conversation](#start-a-conversation)
    - [With Launcher](#with-launcher)
    - [With direct presentation](#with-direct-presentation)
- [Advanced configuration](#advanced-configuration)
    - [Context object for personalized conversation](#context-object-for-personalized-conversation)
    - [Opening a specific conversation with channel URL](#opening-a-specific-conversation-with-channel-url)
    - [Start a conversation in multiple conversation mode](#start-a-conversation-in-multiple-conversation-mode)
    - [Presentation methods](#presentation-methods)
- [API references](#api-references)

---

## Start a conversation

Once you have determined which conversation mode to apply, you should also consider how the messenger will be launched. Delight AI agent SDK supports two launch methods: `Launcher` and directly calling `present`. The following table describes the characteristics of each class.

| Launch Method       | Description                                                                                                                   | Recommended Use Case                                                                          |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Launcher            | Provides a persistent floating button UI that automatically handles conversation creation and presentation.                   | Ideal when the AI agent should be accessible from any screen within the app.                  |
| Direct Presentation | Programmatically presents a conversation or conversation list screen, offering fine-grained control over timing and triggers. | Best for custom UI flows, button-triggered interactions, or controlled conversation launches. |

### With `Launcher`

`Launcher` provides a floating UI approach for launching the messenger and starting a conversation. With `SBALauncherOptions.entryPoint`, you can lead the user to either a conversation view or a conversation list view. In the snippet below, simply calling `attachLauncher()` automatically starts a conversation when the launcher is clicked. If you wish to show a conversation list first, set `entryPoint` to `conversationList`.

For detailed API reference and comprehensive integration guide, see [our Launcher guide](launcher.md).

```swift
import SendbirdAIAgentMessenger

// Basic launcher setup - automatically starts conversation when clicked
AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
)
```

#### Launch a conversation

By default, the launcher opens a conversation when clicked. You can explicitly configure this behavior:

```swift
// Configure launcher to open conversation directly
let launcherOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = launcherOptions
}

// Configure launcher to open specific conversation with channel URL
let specificConversationOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversation,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID",
    channelURL: "sendbird_group_channel_12345"
) { params in
    params.options = specificConversationOptions
}
```

#### Launch a conversation list

You can configure the launcher to show the conversation list first:

```swift
// Configure launcher to open conversation list
let listOptions = SBALauncherOptions(
    parentView: nil,
    entryPoint: .conversationList,
    layout: .default,
    displayStyle: .default
)

AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.options = listOptions
}
```

### With direct presentation

Direct presentation provides a programmatic approach without the launcher button for starting a conversation. Like `Launcher`, you can lead the user to either a conversation view or a conversation list view.

When directly opening a conversation, use `AIAgentMessenger.presentConversation()` and pass `channelURL` to open an existing channel. If `nil`, a new conversation is created. If you wish to open a conversation list first, use `AIAgentMessenger.presentConversationList()`.

#### Launch a conversation

```swift
// Start new conversation directly
AIAgentMessenger.presentConversation(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.language = "en-US"
    params.countryCode = "US"
    params.context = [
        "user_type": "premium"
    ]
    params.presentationStyle = .fullScreen
}

// Start specific existing conversation
AIAgentMessenger.presentConversation(
    aiAgentId: "YOUR_AI_AGENT_ID",
    channelURL: "sendbird_group_channel_12345"
) { params in
    params.language = "en-US"
    params.context = [
        "user_type": "premium"
    ]
}
```

#### Launch a conversation list

```swift
// Open conversation list directly
AIAgentMessenger.presentConversationList(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.language = Locale.current.languageCode
    params.countryCode = Locale.current.regionCode
    params.presentationStyle = .fullScreen
}
```

---

## Advanced configuration

Beside the conversation mode, you can further configure how the conversation channels are created and built.

When a new conversation begins, you can pass over user information to the channel so that AI agent can provide more personalized assistance to the user. This information is contained in a `context` object, which can be set at the creation of the conversation.

Also, you can open a specific conversation channel by passing its URL to either the launcher or direct presentation methods, or manually create a new one while in multiple conversation mode.

### Context object for personalized conversation

The `context` object allows you to provide user's information to AI agents for more personalized service, such as their country code and language preference. This context can be set when creating conversations to enhance the user experience. The following table lists configuration classes where you can initialize a `context` object.

| Class                        | Purpose                                                                          |
| ---------------------------- | -------------------------------------------------------------------------------- |
| `ConversationSettingsParams` | Configures the conversation settings when launching via `presentConversation()`. |
| `ConversationCreateParams`   | Manually creates a new conversation via `createConversation()`.                  |
| `LauncherSettingsParams`     | Configures the floating launcher’s behavior and appearance.                      |

```swift
// Setting context through ConversationSettingsParams
AIAgentMessenger.presentConversation(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.language = "en-US"  // IETF BCP 47 format
    params.countryCode = "US"  // ISO 3166 format
    params.context = [
        "customer_tier": "premium",
        "previous_interaction": "support_ticket_123",
        "user_preferences": "technical_support"
    ]
}

// Using context with manual conversation creation
AIAgentMessenger.createConversation(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.language = "en-US"
    params.countryCode = "US"
    params.context = [
        "customer_tier": "premium",
        "session_type": "first_visit"
    ]
} completionHandler: { result in
    switch result {
    case .success(let channelURL):
        print("Conversation created: \(channelURL)")
    case .failure(let error):
        print("Failed to create: \(error.localizedDescription)")
    }
}
```

### Opening a specific conversation with channel URL

You can open a specific conversation by passing its channel URL to either the launcher or direct presentation methods:

#### With `Launcher`

```swift
// Configure launcher to open specific conversation
AIAgentMessenger.attachLauncher(
    aiAgentId: "YOUR_AI_AGENT_ID",
    channelURL: "sendbird_group_channel_12345"
)

// Or present specific conversation directly
AIAgentMessenger.presentConversation(
    aiAgentId: "YOUR_AI_AGENT_ID",
    channelURL: "sendbird_group_channel_12345"
)
```

#### With direct presentation

```swift
// Open specific conversation with channel URL
AIAgentMessenger.presentConversation(
    aiAgentId: "YOUR_AI_AGENT_ID",
    channelURL: "sendbird_group_channel_12345"
) { params in
    params.presentationStyle = .fullScreen
}
```

### Start a conversation in multiple conversation mode

Multiple active conversation mode allows users to simultaneously communicate with your AI agent in different channels. In this case, use `AIAgentMessenger.createConversation(aiAgentId:paramsBuilder:completionHandler:)` to create a new conversation whenever needed.

> **Note**: In single conversation mode, a new conversation can't be created if there is an active conversation.

```swift
// Create conversation manually
AIAgentMessenger.createConversation(
    aiAgentId: "YOUR_AI_AGENT_ID"
) { params in
    params.language = "en-US"
    params.countryCode = "US"
    params.context = [
        "user_type": "premium",
        "session_id": "session_123"
    ]
} completionHandler: { result in
    switch result {
    case .success(let channelURL):
        // Use the returned channel URL to launch the conversation

        // Option 1: Present via direct method
        AIAgentMessenger.presentConversation(
            aiAgentId: "YOUR_AI_AGENT_ID",
            channelURL: channelURL
        )

        // Option 2: Attach launcher with specific channel
        AIAgentMessenger.attachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID",
            channelURL: channelURL
        )

        print("Successfully created conversation: \(channelURL)")

    case .failure(let error):
        // Handle error case
        print("Failed to create conversation: \(error.localizedDescription)")
    }
}
```

### Presentation methods

`AIAgentMessenger` provides the following public methods for conversation management:

| Method                   | Parameters                         | Description                          | Usage case                                                      |
| ------------------------ | ---------------------------------- | ------------------------------------ | ---------------------------------------------------------------- |
| `presentConversation`    | aiAgentId, channelURL?, paramsBuilder? | Presents a conversation screen.      | Use when you want to show a specific or new conversation.       |
| `presentConversationList` | aiAgentId, paramsBuilder?      | Presents the conversation list screen. | Use when you want to show all conversations to let user choose. |
| `attachLauncher`         | aiAgentId, channelURL?, paramsBuilder? | Attaches the launcher button to screen. | Use when you want a persistent floating button.                 |

#### Full code for integration

The following example demonstrates how to integrate all conversation launch methods in a single view controller. It shows the launcher setup, direct conversation creation, conversation list presentation, and full-screen conversation presentation.

```swift
import UIKit
import SendbirdAIAgentMessenger

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConversationIntegration()
    }

    private func setupConversationIntegration() {
        // Setup launcher for floating UI
        AIAgentMessenger.attachLauncher(
            aiAgentId: "YOUR_AI_AGENT_ID"
        )

        // Setup buttons for different conversation launch methods
        setupButtons()
    }

    private func setupButtons() {
        // Button actions would be connected in storyboard or programmatically
    }

    @IBAction func newConversationButtonTapped(_ sender: Any) {
        createNewConversation()
    }

    @IBAction func conversationListButtonTapped(_ sender: Any) {
        openConversationList()
    }

    @IBAction func fullscreenConversationButtonTapped(_ sender: Any) {
        openFullScreenConversation()
    }

    private func createNewConversation() {
        AIAgentMessenger.createConversation(
            aiAgentId: "YOUR_AI_AGENT_ID"
        ) { params in
            params.language = Locale.current.languageCode
            params.context = ["source": "main_view_controller"]
        } completionHandler: { result in
            switch result {
            case .success(let channelURL):
                // Launch the created conversation
                AIAgentMessenger.presentConversation(
                    aiAgentId: "YOUR_AI_AGENT_ID",
                    channelURL: channelURL
                )
            case .failure(let error):
                self.showError("Failed to create conversation: \(error.localizedDescription)")
            }
        }
    }

    private func openConversationList() {
        AIAgentMessenger.presentConversationList(
            aiAgentId: "YOUR_AI_AGENT_ID"
        ) { params in
            params.presentationStyle = .fullScreen
        }
    }

    private func openFullScreenConversation() {
        AIAgentMessenger.presentConversation(
            aiAgentId: "YOUR_AI_AGENT_ID"
        ) { params in
            params.language = "en-US"
            params.context = ["launch_source": "fullscreen_button"]
            params.presentationStyle = .fullScreen
        }
    }

    deinit {
        AIAgentMessenger.detachLauncher(aiAgentId: "YOUR_AI_AGENT_ID")
    }

    private func showError(_ message: String) {
        // Display error to user using your app's error handling
        // Example: show alert, toast, or custom error view
        print("Error: \(message)")
    }
}
```

---

## API references

### AIAgentMessenger conversation methods

Core methods for managing conversations in the AI Agent Messenger SDK.

#### presentConversation

Presents a conversation screen in full-screen or modal mode.

```swift
static func presentConversation(
    aiAgentId: String,
    channelURL: String? = nil,
    paramsBuilder: ConversationSettingsParamsBuilder? = nil
)
```

| Parameter     | Type                              | Description                                                            |
| ------------- | --------------------------------- | ---------------------------------------------------------------------- |
| `aiAgentId`   | `String`                          | The unique identifier of the AI agent.                                 |
| `channelURL`  | `String?`                         | (Optional) The channel URL. If `nil`, a new conversation is created.   |
| `paramsBuilder` | `ConversationSettingsParamsBuilder?` | (Optional) A closure used to configure conversation settings.          |

#### presentConversationList

Presents the conversation list screen.

```swift
static func presentConversationList(
    aiAgentId: String,
    paramsBuilder: ConversationSettingsParamsBuilder? = nil
)
```

| Parameter     | Type                              | Description                                                                 |
| ------------- | --------------------------------- | --------------------------------------------------------------------------- |
| `aiAgentId`   | `String`                          | The unique identifier of the AI agent.                                      |
| `paramsBuilder` | `ConversationSettingsParamsBuilder?` | (Optional) A closure used to configure the conversation list settings.      |

#### createConversation

Creates a new conversation with an AI agent.

```swift
static func createConversation(
    aiAgentId: String,
    paramsBuilder: ConversationCreateParamsBuilder? = nil,
    completionHandler: @escaping ChannelURLResponseHandler
)
```

| Parameter           | Type                               | Description                                                              |
| ------------------- | ---------------------------------- | ------------------------------------------------------------------------ |
| `aiAgentId`         | `String`                           | The unique identifier of the AI agent.                                   |
| `paramsBuilder`     | `ConversationCreateParamsBuilder?` | (Optional) A closure used to configure conversation creation parameters. |
| `completionHandler` | `ChannelURLResponseHandler`        | A completion handler that returns the created channel URL or an error.   |

### ConversationSettingsParams

Configuration parameters for conversation and conversation list screens.

| Property            | Type                      | Description                              | Default     |
| ------------------- | ------------------------- | ---------------------------------------- | ----------- |
| `parent`            | UIViewController?       | Parent view controller for presentation. | nil       |
| `presentationStyle` | UIModalPresentationStyle | Modal presentation style.                | .fullScreen |
| `language`          | String?                 | Language code (IETF BCP 47).             | nil       |
| `countryCode`       | String?                 | Country code (ISO 3166).                 | nil       |
| `context`           | \[String: String]        | Additional metadata for AI agent.        | \[:]       |

### ConversationCreateParams

Parameters for creating new conversations with AI agents.

| Property      | Type              | Description                       | Default |
| ------------- | ----------------- | --------------------------------- | ------- |
| `language`    | String?           | Language code (IETF BCP 47).      | nil     |
| `countryCode` | String?           | Country code (ISO 3166).          | nil     |
| `context`     | \[String: String] | Additional metadata for AI agent. | \[:]    |

### LauncherSettingsParams

Configuration parameters for the launcher button.

| Property      | Type               | Description                          | Default  |
| ------------- | ------------------ | ------------------------------------ | -------- |
| `options`     | SBALauncherOptions | Launcher layout and display options. | .default |
| `language`    | String?            | Language code (IETF BCP 47).         | nil      |
| `countryCode` | String?            | Country code (ISO 3166).             | nil      |
| `context`     | \[String: String]  | Additional metadata for AI agent.    | \[:]     |

### ChannelURLResponseHandler

Type alias for conversation creation completion handler.

```swift
typealias ChannelURLResponseHandler = (Result<String, Error>) -> Void
```

### UIModalPresentationStyle

Standard UIKit presentation styles supported by the SDK.

| Style             | Description                                  |
| ----------------- | -------------------------------------------- |
| `.fullScreen`     | Full screen modal presentation.              |
| `.pageSheet`      | Sheet that covers most of the screen.        |
| `.formSheet`      | Form-style centered modal.                   |
| `.currentContext` | Presents over current context.               |
| `.overFullScreen` | Presents over full screen with transparency. |
