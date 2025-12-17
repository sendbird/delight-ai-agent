[iOS](https://github.com/sendbird/delight-ai-agent/blob/main/ios/README.md) / [Android](https://github.com/sendbird/delight-ai-agent/blob/main/android/README.md) / **JS**

# Delight AI agent Quickstart guide (JS)

The **Delight AI agent Messenger** allows seamless integration of chatbot features into your Web. Follow the steps below to initialize and utilize the SDK effectively.

This guide explains:
- [Delight AI agent Quickstart guide (JS)](#delight-ai-agent-quickstart-guide-js)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Step 1. Install AI Agent SDK](#step-1-install-ai-agent-sdk)
    - [Step 2. Initialize AI Agent SDK](#step-2-initialize-ai-agent-sdk)
      - [Custom Host Configuration](#custom-host-configuration)
  - [Running your application](#running-your-application)
    - [Manage user sessions](#manage-user-sessions)
      - [Session types](#session-types)
    - [Launch the messenger](#launch-the-messenger)
  - [Advanced Features](#advanced-features)
    - [Display messenger without launcher button](#display-messenger-without-launcher-button)
    - [Deauthenticate and clear session](#deauthenticate-and-clear-session)
    - [Passing context object to Agent](#passing-context-object-to-agent)
    - [Localization and Language Support](#localization-and-language-support)

## Prerequisites

Before you start, you'll need your Delight **Application ID** and **AI Agent ID**.
<br><br/>
You can find it under the **Channels** > **Messenger** menu on the Delight AI dashboard.

![ai-agent-app-id-agent-id](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-messenger-basic-information.png)

---

## Getting Started

Quickly install and initalize the AI Agent SDK by following the steps below.

### Step 1. Install AI Agent SDK

Add the AI Agent SDK to your web page by importing it as a module.

```html
<script type="module">
  import { loadMessenger } from "https://aiagent.delight.ai/orgs/default/index.js";
</script>
```

### Step 2. Initialize AI Agent SDK

```javascript
const messenger = await loadMessenger();
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  userSessionInfo: new messenger.AnonymousSessionInfo(),
});
```

#### Custom Host Configuration

If needed, you can specify custom API and WebSocket hosts during initialization:

```javascript
messenger.initialize({
  // ... Other initialization configurations
  customApiHost: 'https://your-proxy-api.example.com',
  customWebSocketHost: 'wss://your-proxy-websocket.example.com'
});
```

Both parameters are optional and only need to be configured if required.

---

## Running your application

Now that you have installed and initialized the AI Agent SDK, follow the steps below to run your application.

### Manage user sessions

The SDK supports two types of user sessions: **Manual Session** for authenticated users and **Anonymous Session** for temporary users.

#### Session types

**1. Manual Session (ManualSessionInfo):**
Use this when you have an authenticated user with a specific user ID and session token.

```javascript
messenger.initialize({
  // ... Other initialization configurations
  userSessionInfo: new messenger.ManualSessionInfo({
    userId: 'user_id',
    authToken: 'auth_token',
    sessionHandler: {
      // A new session token is required in the SDK to refresh the session.
      onSessionTokenRequired: async (resolve, reject) => {
        try {
          // Refresh the session token and pass it onto the SDK through resolve(NEW_TOKEN).
          // If you don't want to refresh the session, pass on a null value through resolve(null).
          const response = await fetch('new-token-endpoint');
          resolve(response.token);
        } catch (error) {
          // If any error occurs while refreshing the token, let the SDK know about it through reject(error).
          reject(error);
        }
      },
      // Called when the session refresh has been denied.
      // This event can occur if the client app doesn't explicitly refresh the token, the token is revoked, or the user is deactivated.
      // In this case, the client app should handle the UX appropriately — such as redirecting the user to a login page or hiding/destroying the messenger.
      onSessionClosed: () => { },
      // Optional: Called when an error occurs during session refresh.
      onSessionError: (error) => { },
      // Optional: Called when the session is refreshed.
      onSessionRefreshed: () => { },
    }
  })
});
```

**2. Anonymous Session (AnonymousSessionInfo):**
Use this for guest users or when user authentication is not available. The server will automatically create a temporary user.

```javascript
messenger.initialize({
  // ... Other initialization configurations
  userSessionInfo: new messenger.AnonymousSessionInfo(),
});
```

For updating session information at runtime, use the `updateUserSession()` method as follows:

```javascript
const newManualSessionInfo = new messenger.ManualSessionInfo({
  userId: 'new_user_id',
  authToken: 'new_auth_token',
  sessionHandler: {
    onSessionTokenRequired: async (resolve, reject) => {
      try {
        const response = await fetch('new-token-endpoint');
        resolve(response.token);
      } catch (error) {
        reject(error);
      }
    },
    onSessionClosed: () => { },
    onSessionError: (error) => { },
    onSessionRefreshed: () => { },
  },
});
messenger.updateUserSession(newManualSessionInfo);
```

### Launch the messenger

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-launcher.png" />

Once the authentication information has been successfully registered, you can launch the messenger to start a conversation with the ai agent.

To launch and display the messenger, implement the code below:

> **Note**: Replace `YOUR_APP_ID` AND `YOUR_AI_AGENT_ID` with your Application ID and AI agent ID which you can obtain from the Delight AI dashboard. To learn how do to so, refer to the [prerequisites](#prerequisites) section.

```javascript
const messenger = await loadMessenger();
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  userSessionInfo: new messenger.AnonymousSessionInfo(),
});
```

The messenger view can be programmatically controlled using the `messenger.open()` and `messenger.close()` methods:

```javascript
// Open the messenger view automatically after initialized
messenger.initialize({ appId, aiAgentId, userSessionInfo });
messenger.onLoad(() => {
  messenger.open();
});

// Close the messenger view by clicking a button
<button onClick={() => messenger.close()}>Close</button>;
```

The `messenger.setPosition` method allows you to customize its appearance and positioning:

```js
messenger.onLoad(() => {
  /**
   * @public
   * @description Set the position of the fixed messenger.
   * @param params.position - The position of the fixed messenger. (default: 'end-bottom')
   *  - 'start-top': Top-left corner
   *  - 'start-bottom': Bottom-left corner
   *  - 'end-top': Top-right corner
   *  - 'end-bottom': Bottom-right corner
   * @param params.margin - The margin around the fixed messenger. (default: { top: 24, bottom: 24, start: 24, end: 24 })
   *  - top: Margin from the top of the viewport
   *  - bottom: Margin from the bottom of the viewport
   *  - start: Margin from the start of the viewport
   *  - end: Margin from the end of the viewport
   * */
  messenger.setPosition({
    position: 'start-bottom',
    margin: { top: 24, bottom: 24, start: 24, end: 24 }
  })
})
```

To update the configurations:

```javascript
// Update configuration
messenger.updateConfig({
  appId: 'NEW_APP_ID',
  aiAgentId: 'NEW_BOT_ID',
  // ... other config options
});
```

---

## Advanced Features

The following are available advanced features.

### Display messenger without launcher button

<img width="361" height="642" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-web-suggested-replies.png" />

```javascript
const messenger = await loadMessenger({
  // Use Conversation component to display only the messenger without the launcher
  customMainComponent: ({ messenger, react }) => {
    return (props) => {
        return react.createElement(messenger.AgentProviderContainer, props, [
        react.createElement(messenger.Conversation),
      ]);
    };
  },
});
messenger.initialize({
  appId: 'APP_ID',
  aiAgentId: 'AI_AGENT_ID',
  userSessionInfo: new messenger.AnonymousSessionInfo(),
});
```

### Deauthenticate and clear session

The messenger provides two different methods for cleanup:

1. Use `deauthenticate()` to handle user logout by clearing session data and disconnecting from the chat SDK:
```javascript
messenger.deauthenticate();
```

2. Use `destroy()` to completely remove the messenger nodes from the DOM:
```javascript
messenger.destroy();
```

### Passing context object to Agent

You can predefine customer-specific information such as country, language, or other custom context data to guide the AI Agent in providing faster and more accurate responses.

This allows for a more personalized and context-aware interaction experience.

> **Important**: These settings can only be configured during initialization.

```javascript
const messenger = await loadMessenger();
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  userSessionInfo: new messenger.AnonymousSessionInfo(),
  // Language setting (IETF BCP 47 format)
  // default: navigator.language
  language: 'en-US',
  // Country code setting (ISO 3166 format)
  countryCode: 'US',
  // Context object for the AI Agent
  context: {
    userPreference: 'technical',
    customerTier: 'premium'
  }
});
```

### Localization and Language Support

The SDK supports multiple languages and allows you to customize UI strings. You can:

- Set the language during initialization or update it later
- Customize specific strings in a supported language
- Add support for languages not built into the SDK
- Dynamically load language files as needed for better performance

For detailed information about localization options and full list of available string sets, refer to our [Localization Guide](./MULTILANGUAGE.md).
