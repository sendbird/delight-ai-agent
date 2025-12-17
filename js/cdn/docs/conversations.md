# Conversations

In Delight AI agent, a conversation refers to a channel where an AI agent communicates with a user. Depending on your service requirements, you can allow users to maintain a single active conversation or multiple. Delight AI agent supports two different conversation modes: Single active conversation and Multiple active conversation mode, which is the default.

When the launcher is clicked, a user can be led to either their conversation list or a conversation depending on your choice of the conversation mode.

| Feature                       | Single active conversation                                                                                                      | Multiple active conversations (Default)                                                    |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Number of active conversation | A user can have only one active conversation with your AI agent at a time.                                                      | A user can have multiple active conversations with your AI agent at the same time.         |
| Starting a new conversation   | A new conversation can't be created if there is an active conversation at the moment. The existing conversation must end first. | New conversations can be created anytime. However, this is not currently supported in CDN. |

> **Note**: Whichever conversation mode you choose, if there is no active conversation, a new conversation is automatically created and the user can start a dialogue with your AI agent. This provides seamless user experience without requiring manual conversation setup.

This guide explains:
- [Start a conversation](#start-a-conversation)
    - [With Messenger](#with-messenger)
    - [With custom main component](#with-custom-main-component)
- [Advanced configuration](#advanced-configuration)
    - [Context object for personalized conversation](#context-object-for-personalized-conversation)
    - [Managing messenger lifecycle](#managing-messenger-lifecycle)
- [API references](#api-references)

---

## Start a conversation

Once you have determined which conversation mode to apply, you should also consider how the messenger will be launched. Delight AI agent SDK for CDN provides two launch methods: using the default `Messenger` with a `launcher` or customizing with `custom main component`. The following table describes the characteristics of each approach.

| Launch method         | Description                                                                                                 | Recommended use case                                                                                               |
| --------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Messenger             | Provides a floating launcher button that automatically manages conversation creation and navigation.        | Ideal when you want a persistent, always-accessible AI agent across your application.                              |
| Custom main component | Programmatically provide your own main component, offering fine-grained control over layout and navigation. | Best for custom UI layouts, embedded conversations, or when you need full control over the conversation interface. |

### With `Messenger`

Load the messenger and initialize it with your application credentials.

#### Launch a conversation

The messenger provides a floating UI approach for launching the messenger and starting a conversation by default. During initialization, you can determine whether to launch either a conversation view or a conversation list view using `entryPoint`. The messenger provides a floating UI approach for launching the messenger and starting a conversation by default.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>AI Agent Messenger</title>
</head>
<body>
  <script type="module">
    import { loadMessenger } from 'https://aiagent.delight.ai/orgs/default/index.js';

    // Load messenger
    const messenger = await loadMessenger();

    // Initialize messenger
    messenger.initialize({
      appId: 'YOUR_APP_ID',
      aiAgentId: 'YOUR_AI_AGENT_ID',
      userSessionInfo: new messenger.AnonymousSessionInfo()
    });
  </script>
</body>
</html>
```

#### Launch a conversation list

Use `entryPoint` to configure which view to display when the messenger is launched. As its `entryPoint` is set to `ConversationList`, the following code snippet will show the user's conversation list instead of a conversation view.

```javascript
// Configure messenger to open conversation directly (default behavior)
const messenger = await loadMessenger();

messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  entryPoint: 'ConversationList'  // Values can be 'Conversation' or 'ConversationList'
});
```

#### Without `ShadowDOM`

By default, the messenger uses `ShadowDOM` for style encapsulation, enabling the SDK to maintain its own styling independent of outside codes. However, you can disable the functionality if needed as follows:

```javascript
const messenger = await loadMessenger({
  useShadowDOM: false
});

messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  userSessionInfo: new messenger.AnonymousSessionInfo()
});
```

#### Set the launcher layout

On mobile devices, the messenger automatically opens in full-screen mode. On the other hand, it displays as a floating mini-window anchored near a small icon called `launcher` on the desktop devices.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-launcher.png" alt="" width="375">
  <figcaption></figcaption>
</figure>

You can configure the launcher's positioning and margin on the screen using the `setPosition()` method.

```javascript
messenger.setPosition({
  position: 'end-bottom',
  margin: {
    top: 24,
    bottom: 24,
    start: 24,
    end: 24
  }
});
```

- Position

| Position         | Description                                 |
| ---------------- | ------------------------------------------- |
| `'start-top'`    | Top-left corner of the screen               |
| `'start-bottom'` | Bottom-left corner of the screen            |
| `'end-top'`      | Top-right corner of the screen              |
| `'end-bottom'`   | Bottom-right corner of the screen (default) |

- Margin

| Property | Type   | Default | Description                                        |
| -------- | ------ | ------- | -------------------------------------------------- |
| `top`    | number | 24      | Top margin in pixels                               |
| `bottom` | number | 24      | Bottom margin in pixels                            |
| `start`  | number | 24      | Start margin in pixels (left in LTR, right in RTL) |
| `end`    | number | 24      | End margin in pixels (right in LTR, left in RTL)   |

#### Customize the launcher appearance

The launcher's icon and color can be configured through the [Delight AI dashboard](https://dashboard.delight.ai) - no code changes required. Simply go to [**Build > Channels > Messenger**](https://dashboard.delight.ai/ai-agent/%7Bapplication-id%7D/channels/messenger/?active_tab=Appearance) in the dashboard and click on the **Appearance** tab to customize your launcher.

<figure>
  <img src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-messenger-appearance.png" alt="" width=50%>
  <figcaption></figcaption>
</figure>

---

### With custom main component

For advanced use cases where you need direct control over the conversation view without the floating launcher, you can provide a custom main component. This provides a full-screen or custom-sized conversation interface.

This approach is recommended when:

- You want to embed the conversation in a specific part of your UI.
- You need custom navigation or layout control.
- You want to build a full-page conversation experience.
- You need to open a specific conversation programmatically with its `channelUrl`.

The following snippet demonstrates how to load the messenger with a custom main component that renders `AgentProviderContainer` and a `Conversation` view.

```javascript
const messenger = await loadMessenger({
  customMainComponent: ({ messenger, react }) => {
    return (props) => {
      return react.createElement(
        messenger.AgentProviderContainer,
        props,
        [react.createElement(messenger.Conversation)]
      );
    };
  }
});

messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID'
});
```

---

## Advanced configuration

Beside the conversation mode, you can further configure how the conversation channels are created and built.

When a new conversation begins, you can pass over user information to the channel so that AI agent can provide more personalized assistance to the user. This information is contained in a `context` object, which can be set at the creation of the conversation.

### Context object for personalized conversation

The `context` object allows you to provide user's information to AI agents for more personalized service, such as their country code and language preference. This context can be set when initializing the messenger to enhance the user experience.

```javascript
// Setting context through initialize configuration
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  language: 'en-US',  // IETF BCP 47 format
  countryCode: 'US',  // ISO 3166 format
  context: {
    customer_tier: 'premium',
    previous_interaction: 'support_ticket_123',
    user_preferences: 'technical_support'
  }
});
```

### Managing messenger lifecycle

The messenger provides methods to control visibility and manage conversations.

#### Open and close the messenger

Control the messenger visibility programmatically:

```javascript
// Open the messenger
messenger.open();

// Close the messenger
messenger.close();
```

#### Update the messenger configuration

You can update the messenger configuration even after initialization:

```javascript
messenger.updateConfig({
  appId: 'NEW_APP_ID',
  aiAgentId: 'NEW_AI_AGENT_ID',
  language: 'ko-KR',
  countryCode: 'KR',
  theme: {
    palette: {
      primary: '#6210CC'
    }
  }
});
```

#### Update the user session

When the user's session token expires or a new session token is required, you need to update the user session information. Use `messenger.updateUserSession()` to do so dynamically:

```javascript
// With ManualSessionInfo
const sessionInfo = new messenger.ManualSessionInfo({
  userId: 'user_123',
  authToken: 'your_auth_token',
  sessionHandler: {
    onSessionTokenRequired: (resolve, reject) => {
      // Fetch new token when required
      fetchNewToken()
        .then(token => resolve(token))
        .catch(error => reject(error));
    },
    onSessionError: (error) => {
      console.error('Session error:', error);
    },
    onSessionRefreshed: () => {
      console.log('Session refreshed');
    },
    onSessionClosed: () => {
      console.log('Session closed');
    }
  }
});

messenger.updateUserSession(sessionInfo);
```

#### Deauthenticate

To log out the current user, use `deauthenticate()`.

```javascript
messenger.deauthenticate();
```

#### Destroy messenger

You can also completely remove the messenger instance using `destroy()`.

```javascript
messenger.destroy();
```

---

## API references

### loadMessenger()

Loads the AI Agent Messenger module. It returns `Promise<Messenger>`.

```javascript
await loadMessenger(config)
```

| Parameter            | Type     | Default | Description                                                               |
| -------------------- | -------- | ------- | ------------------------------------------------------------------------- |
| `useShadowDOM`       | boolean  | true    | Use Shadow DOM for style encapsulation (set to `false` to disable)        |
| `customMainComponent` | function | -       | Custom main component function for advanced customization                 |

### messenger.initialize()

Initializes the AI Agent Messenger with configuration.

```javascript
messenger.initialize(config)
```

| Parameters        | Type                                      | Default            | Description                                                            |
| ----------------- | ----------------------------------------- | ------------------ | ---------------------------------------------------------------------- |
| `appId`           | string                                    | Required           | Your application ID                                                    |
| `aiAgentId`       | string                                    | Required           | AI agent identifier for conversation target                            |
| `userSessionInfo` | ManualSessionInfo \| AnonymousSessionInfo | -                  | User session information for authentication                            |
| `entryPoint`      | 'Conversation' \| 'ConversationList'      | 'Conversation'     | Which screen to show when the messenger is first loaded                |
| `language`        | string                                    | navigator.language | Language setting following IETF BCP 47 format (e.g., "en-US", "ko-KR") |
| `countryCode`     | string                                    | -                  | Country code following ISO 3166 format (e.g., "US", "KR")              |
| `context`         | Record\<string, string>                   | -                  | Context object for personalized AI agent responses                     |
| `config`          | object                                    | -                  | AI agent configuration object                                          |
| `theme`           | object                                    | -                  | Theme customization for palette and typography                         |
| `stringSet`       | Partial                                   | -                  | Localization string set for the messenger                              |
| `logLevel`        | LogLevel                                  | -                  | Log level for the AI agent client                                      |

### Messenger methods

#### Lifecycle methods

| Method      | Parameters | Description                              |
| ----------- | ---------- | ---------------------------------------- |
| `open()`    | -          | Open the messenger                       |
| `close()`   | -          | Close the messenger                      |
| `destroy()` | -          | Completely remove the messenger instance |

#### Configuration methods

| Method                       | Parameters                                         | Description                       |
| ---------------------------- | -------------------------------------------------- | --------------------------------- |
| `updateConfig(config)`       | config: Partial                                    | Update messenger configuration    |
| `updateUserSession(session)` | session: ManualSessionInfo \| AnonymousSessionInfo | Update user session information   |
| `setPosition(params)`        | params: { position?, margin? }                     | Set launcher position and margins |

#### Session methods

| Method             | Description              |
| ------------------ | ------------------------ |
| `deauthenticate()` | Log out the current user |

### Session info classes

#### ManualSessionInfo

```javascript
new messenger.ManualSessionInfo({
  userId: string,
  authToken: string,
  sessionHandler: {
    onSessionTokenRequired?: (resolve, reject) => void,
    onSessionError?: (error) => void,
    onSessionRefreshed?: () => void,
    onSessionClosed?: () => void
  }
})
```

#### AnonymousSessionInfo

```javascript
new messenger.AnonymousSessionInfo()
```

### setPosition()

Parameters for `setPosition()` method:

| Parameter | Type                                                | Description                                         |
| --------- | --------------------------------------------------- | --------------------------------------------------- |
| `position` | 'start-top' \| 'start-bottom' \| 'end-top' \| 'end-bottom' | Position of the launcher button. (Default: -)       |
| `margin`   | Partial<{ top: number; bottom: number; start: number; end: number }> | Margin around the launcher in pixels. (Default: -) |
