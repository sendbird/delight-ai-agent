[iOS](https://github.com/sendbird/delight-ai-agent/blob/main/ios/README.md) / [Android](https://github.com/sendbird/delight-ai-agent/blob/main/android/README.md) / **JS**

# Delight AI agent Quickstart guide (React-Native)

The **Delight AI agent Messenger React-Native** allows seamless integration of chatbot features into your React-Native application.

- [Delight AI agent Quickstart guide (React-Native)](#delight-ai-agent-quickstart-guide-react-native)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Step 1. Install AI Agent SDK](#step-1-install-ai-agent-sdk)
    - [Step 2. Configure Native Modules](#step-2-configure-native-modules)
    - [Step 3. Initialize AI Agent SDK](#step-3-initialize-ai-agent-sdk)
  - [Component Overview](#component-overview)
    - [FixedMessenger vs AIAgentProviderContainer](#fixedmessenger-vs-aiagentprovidercontainer)
  - [Running your application](#running-your-application)
    - [FixedMessenger styles](#fixedmessenger-styles)
    - [Window modes](#window-modes)
    - [Entry points](#entry-points)
    - [Manage user sessions](#manage-user-sessions)
      - [Session types](#session-types)
      - [Authentication](#authentication)
      - [Deauthentication](#deauthentication)
  - [Advanced Features](#advanced-features)
    - [Customizing Theme](#customizing-theme)
    - [Display messenger without launcher button](#display-messenger-without-launcher-button)
    - [Passing context object to Agent](#passing-context-object-to-agent)
    - [Localization and Language Support](#localization-and-language-support)

## Prerequisites

Before you start, you'll need your **Application ID** and **AI Agent ID**.
<br><br/>
You can find it under the **Channels** > **Messenger** menu on the Delight AI dashboard.

![ai-agent-app-id-agent-id](https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-messenger-basic-information.png)

**System Requirements:**

- React >= 18.0.0
- React-Native >= 0.80.0
- @sendbird/chat ^4.19.0
- react-native-mmkv >= 3.0.0
- react-native-safe-area-context >= 5.0.0
- date-fns >= 4.0.0

---

## Getting Started

Quickly install and initialize the AI Agent SDK by following the steps below.

### Step 1. Install AI Agent SDK

Install the package with its peer dependencies using npm or yarn:

```bash
npm install @sendbird/ai-agent-messenger-react-native @sendbird/chat react-native-mmkv react-native-safe-area-context date-fns
```

**(Optional) File attachment support:**

If file attachment is enabled in your AI Agent settings, install one of the following picker modules:

**Option A: Expo modules (Recommended for Expo projects)**

```bash
npm install expo-image-picker expo-document-picker
```

**Option B: Community modules (For bare React-Native projects)**

```bash
npm install react-native-image-picker @react-native-documents/picker react-native-permissions
```

> **Note:** When using `react-native-image-picker`, you must also install `react-native-permissions` for camera access.

### Step 2. Configure Native Modules

The SDK requires native module configuration. Only `mmkv` is required; picker modules are optional.

**Minimal setup (without file attachment):**

```tsx
import { createMMKV } from 'react-native-mmkv';

const mmkv = createMMKV();

const nativeModules = {
  mmkv,
};
```

**With file attachment support (Expo modules):**

```tsx
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

const nativeModules = {
  mmkv,
  imagePicker: ImagePicker,
  documentPicker: DocumentPicker,
};
```

**With file attachment support (Community modules):**

```tsx
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'react-native-image-picker';
import * as DocumentPicker from '@react-native-documents/picker';
import * as Permissions from 'react-native-permissions';

const mmkv = createMMKV();

const nativeModules = {
  mmkv,
  imagePicker: ImagePicker,
  documentPicker: DocumentPicker,
  permissions: Permissions, // Required for react-native-image-picker
};
```

### Step 3. Initialize AI Agent SDK

The React-Native SDK provides two main approaches for integration:

**Option 1: FixedMessenger (Recommended for quick setup)**

FixedMessenger provides a predefined UI toolkit with launcher and messenger:

```tsx
import { AIAgentProviderContainer, FixedMessenger, AnonymousSessionInfo } from '@sendbird/ai-agent-messenger-react-native';

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
}
```

**Option 2: AIAgentProviderContainer with Conversation (For custom UI implementations)**

AIAgentProviderContainer allows for custom UI implementations and component-level integration:

```tsx
import { AIAgentProviderContainer, Conversation, AnonymousSessionInfo } from '@sendbird/ai-agent-messenger-react-native';
import { View } from 'react-native';

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <View style={{ flex: 1 }}>
        <Conversation />
      </View>
    </AIAgentProviderContainer>
  );
}
```

---

## Component Overview

### FixedMessenger vs AIAgentProviderContainer

**FixedMessenger:**

- Complete UI toolkit with launcher and messenger window
- Supports floating and fullscreen window modes
- Includes navigation between Conversation and ConversationList
- Handles Android back button automatically
- Recommended for most use cases

**AIAgentProviderContainer + Conversation:**

- Provider component for custom UI implementations
- Allows building custom messenger interfaces
- Use when you need specific UI layouts or custom components
- Must be combined with conversation components like `<Conversation />`

---

## Running your application

Now that you have installed and initialized the AI Agent SDK, follow the steps below to run your application.

To launch and display the messenger, implement the code below:

> **Note:** Replace `YOUR_APP_ID` and `YOUR_AI_AGENT_ID` with your Application ID and AI agent ID which you can obtain from the Delight AI dashboard. To learn how to do so, refer to the [prerequisites](#prerequisites) section.

```tsx
function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      nativeModules={nativeModules}
      userSessionInfo={new AnonymousSessionInfo()}
    >
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
}
```

### FixedMessenger styles

When using the fixed messenger, `FixedMessenger.Style` allows you to customize its appearance and positioning:

- `position`: Determines which corner of the screen the launcher will appear in. Available options are: `start-top`, `start-bottom`, `end-top` and `end-bottom`.
- `margin`: Defines the margin around the fixed messenger and its launcher.
- `launcherSize`: Defines the size of the launcher button in pixels (width and height are equal).
- `spacing`: Defines the spacing between the launcher and the messenger window.

```tsx
function App() {
  return (
    <AIAgentProviderContainer {...props}>
      <FixedMessenger>
        <FixedMessenger.Style
          position={'end-bottom'}
          launcherSize={56}
          spacing={16}
          margin={{ start: 16, end: 16, bottom: 16, top: 16 }}
        />
      </FixedMessenger>
    </AIAgentProviderContainer>
  );
}
```

### Window modes

FixedMessenger supports two window modes:

- `floating` (default): The messenger appears as a floating window above your app content.
- `fullscreen`: The messenger takes up the full screen.

```tsx
<FixedMessenger windowMode={'fullscreen'} />
```

When using fullscreen mode, you can specify insets:

```tsx
<FixedMessenger
  windowMode={'fullscreen'}
  fullscreenInsets={{ top: 50, bottom: 34, left: 0, right: 0 }}
/>
```

### Entry points

You can configure which screen appears first when opening the messenger:

- `Conversation` (default): Opens directly to a conversation.
- `ConversationList`: Opens to the list of conversations.

```tsx
<FixedMessenger entryPoint={'ConversationList'} />
```

You can also specify an initial channel URL to open a specific conversation:

```tsx
<FixedMessenger initialChannelUrl={'sendbird_group_channel_xxx'} />
```

### Manage user sessions

The SDK supports two types of user sessions: **Manual Session** for authenticated users and **Anonymous Session** for temporary users.

#### Session types

**1. Manual Session (ManualSessionInfo):**
Use this when you have an authenticated user with a specific user ID and session token.

```tsx
import { ManualSessionInfo } from '@sendbird/ai-agent-messenger-react-native';

<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  nativeModules={nativeModules}
  userSessionInfo={new ManualSessionInfo({
    userId: 'user_id',
    authToken: 'auth_token',
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
      onSessionRefreshed: () => { }
    }
  })}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

**2. Anonymous Session (AnonymousSessionInfo):**
Use this when you don't have user authentication or want to allow guest access. The server will automatically create a temporary user.

```tsx
import { AnonymousSessionInfo } from '@sendbird/ai-agent-messenger-react-native';

<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  nativeModules={nativeModules}
  userSessionInfo={new AnonymousSessionInfo()}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

#### Authentication

You can manually control user authentication using `useMessengerSessionContext`. Call `authenticate()` before showing the messenger to avoid loading delays.

```tsx
import { useMessengerSessionContext } from '@sendbird/ai-agent-messenger-react-native';

const App = () => {
  const { authenticate, sdkUser } = useMessengerSessionContext();

  useEffect(() => {
    authenticate();
  }, []);

  return <FixedMessenger />;
};
```

#### Deauthentication

To log out the current user, call `deauthenticate()`. This disconnects the user session and clears the authentication state.

```tsx
import { useMessengerSessionContext } from '@sendbird/ai-agent-messenger-react-native';

const LogoutButton = () => {
  const { deauthenticate } = useMessengerSessionContext();

  const handleLogout = () => {
    deauthenticate();
  };

  return <Button title={'Logout'} onPress={handleLogout} />;
};
```

---

## Advanced Features

The following are available advanced features.

### Customizing Theme

You can customize the messenger theme by passing a `theme` prop to `AIAgentProviderContainer`.

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  nativeModules={nativeModules}
  userSessionInfo={new AnonymousSessionInfo()}
  theme={{
    mode: 'dark', // 'light' or 'dark'
    typography: {
      h1: { fontSize: 24, fontWeight: '700' },
      body1: { fontSize: 16, fontWeight: '400' },
    },
  }}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

### Display messenger without launcher button

Build custom messenger UI using AIAgentProviderContainer with Conversation directly:

```tsx
import { AIAgentProviderContainer, Conversation, AnonymousSessionInfo } from '@sendbird/ai-agent-messenger-react-native';
import { View } from 'react-native';

function App() {
  return (
    <View style={{ flex: 1 }}>
      <AIAgentProviderContainer
        appId={'YOUR_APP_ID'}
        aiAgentId={'YOUR_AI_AGENT_ID'}
        nativeModules={nativeModules}
        userSessionInfo={new AnonymousSessionInfo()}
      >
        <Conversation />
      </AIAgentProviderContainer>
    </View>
  );
}
```

### Passing context object to Agent

You can predefine customer-specific information such as country, language, or other custom context data to guide the AI Agent in providing faster and more accurate responses.

This allows for a more personalized and context-aware interaction experience.

> **Important**: These settings can only be configured during initialization.

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  nativeModules={nativeModules}
  userSessionInfo={new AnonymousSessionInfo()}
  // Language setting (IETF BCP 47 format)
  language={'en-US'}
  // Country code setting (ISO 3166 format)
  countryCode={'US'}
  // Context object for the AI Agent
  context={{
    userPreference: 'technical',
    customerTier: 'premium',
  }}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

### Localization and Language Support

The SDK supports multiple languages and allows you to customize UI strings. You can:

- Set the language during initialization
- Customize specific strings in supported languages
- Add support for additional languages

**Supported languages:** German (de), English (en), Spanish (es), French (fr), Hindi (hi), Italian (it), Japanese (ja), Korean (ko), Portuguese (pt), Turkish (tr)

**Example of customizing strings:**

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  nativeModules={nativeModules}
  userSessionInfo={new AnonymousSessionInfo()}
  language={'ko-KR'}
  strings={{
    conversation: {
      input_placeholder: '질문을 입력하세요...',
    },
  }}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

For detailed information about localization options and full list of available string sets, refer to our [Localization Guide](./MULTILANGUAGE.md).
