# Conversations

In Delight AI agent, a conversation refers to a channel where an AI Agent communicates with a user. Depending on your service requirements, you can allow users to maintain a single active conversation or multiple. Delight AI agent supports two different conversation modes: Single active conversation and Multiple active conversation mode, which is the default.

When the launcher is clicked, a user can be led to either their conversation list or a conversation depending on your choice of the conversation mode.

| Feature| Single active conversation| Multiple active conversations (Default)|
|-------------------|------------------|----------------|
| Number of active conversation| A user can have only one active conversation with your AI agent at a time.| A user can have multiple active conversations with your AI agent at the same time.|
| Starting a new conversation | A new conversation can't be created if there is an active conversation at the moment. The existing conversation must end first.| New conversations can be created anytime using the `createConversation()` function from `useMessengerSessionContext()`.|

>__Note__: Whichever conversation mode you choose, if there is no active conversation, a new conversation is automatically created and the user can start a dialogue with your AI agent. This provides seamless user experience without requiring manual conversation setup.

This guide explains:

- [Conversations](#conversations)
  - [Prerequisites](#prerequisites)
  - [Start a conversation](#start-a-conversation)
    - [With `FixedMessenger`](#with-fixedmessenger)
      - [Launch a conversation](#launch-a-conversation)
      - [Launch a conversation list](#launch-a-conversation-list)
      - [Set the window mode](#set-the-window-mode)
      - [Set the launcher layout (position, margin, size, spacing)](#set-the-launcher-layout)
      - [Customize the launcher appearance](#customize-the-launcher-appearance)
    - [With direct presentation](#with-direct-presentation)
  - [Advanced configuration](#advanced-configuration)
    - [Context object for personalized conversation](#context-object-for-personalized-conversation)
    - [Opening a specific conversation with channel URL](#opening-a-specific-conversation-with-channel-url)
    - [Start a conversation in multiple conversation mode](#start-a-conversation-in-multiple-conversation-mode)
  - [API Reference](#api-reference)

---

## Prerequisites

Before using the Delight AI agent Messenger in React Native, you need to install and configure required native modules for local storage and file picking functionality.

### Install required packages

Install the following packages using your package manager:

```bash
# Using npm
npm install react-native-mmkv expo-image-picker expo-document-picker

# Using yarn
yarn add react-native-mmkv expo-image-picker expo-document-picker

# Using pnpm
pnpm add react-native-mmkv expo-image-picker expo-document-picker
```

>__Note__: If you're using bare React Native instead of Expo, use `react-native-image-picker` and `react-native-document-picker` instead of the Expo packages. Make sure to follow the installation instructions for each package.

### Configure native modules

Initialize the required native modules before using the messenger. The following table and snippet describes the purpose of each module and its settings.

| Module | Purpose |
|--------|----------|
| `MMKV` | Local storage for caching and session management |
| `ImagePicker` | Selecting images from the gallery or camera |
| `DocumentPicker` | Selecting files for sharing in conversations |

```tsx
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

// Create MMKV instance for local storage
const mmkv = createMMKV();

// Native modules configuration
const nativeModules = {
  mmkv,
  imagePicker: ImagePicker,
  documentPicker: DocumentPicker
};
```

---

## Start a conversation

Once you have determined which conversation mode to apply, you should also consider how the messenger will be launched. Delight AI agent SDK for React Native provides two launch methods: `FixedMessenger` and directly using the `Conversation` component. The following table describes the characteristics of each approach.

| Launch Method | Description | Recommended Use Case |
|----------------|--------------|-----------------------|
| FixedMessenger | Provides a floating launcher button that automatically manages conversation creation and navigation. | Ideal when you want a persistent, always-accessible AI agent across your application. |
| Direct Conversation Usage | Programmatically render the Conversation component directly, offering fine-grained control over layout and navigation. | Best for custom UI layouts, embedded conversations, or when you need full control over the conversation interface. |

### With `FixedMessenger`

`FixedMessenger` provides a floating UI approach for launching the messenger and starting a conversation. The `entryPoint` prop allows you to lead the user to either a conversation view or a conversation list view. Simply mounting the `<FixedMessenger />` component automatically creates a conversation (if none exists) when the launcher is clicked. If you wish to show a conversation list first, set `entryPoint` to `ConversationList`.

The launcher's appearance can be customized via the dashboard. For positioning and sizing customization, see the launcher customization sections below.

>__Note__: `FixedMessenger` must be used within an `AIAgentProviderContainer` which handles initialization, authentication, and configuration.

```tsx
import { useState } from 'react';
import {
  AIAgentProviderContainer,
  FixedMessenger,
  AnonymousSessionInfo
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

// Basic launcher setup - automatically starts conversation when clicked
const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
    >
      <YourAppContent />
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
};
```

#### Launch a conversation

By default, the launcher opens a conversation when clicked. You can explicitly configure this behavior using the `entryPoint` prop:

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <YourAppContent />
  {/* Configure messenger to open conversation directly (default behavior) */}
  <FixedMessenger entryPoint={'Conversation'} />
</AIAgentProviderContainer>
```

You can also provide additional context, language, and country settings at the provider level:

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
  language={'en-US'}
  countryCode={'US'}
  context={{
    user_type: 'premium',
    session_id: 'session_123'
  }}
>
  <YourAppContent />
  <FixedMessenger entryPoint={'Conversation'} />
</AIAgentProviderContainer>
```

#### Launch a conversation list

You can configure the messenger to show the conversation list first. Simply set `entryPoint` to `ConversationList`.

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <YourAppContent />
  {/* Configure messenger to open conversation list */}
  <FixedMessenger entryPoint={'ConversationList'} />
</AIAgentProviderContainer>
```

#### Set the window mode

React Native allows you to control how the messenger window is displayed using the `windowMode` prop. Available modes are `floating` (default) and `fullscreen`.

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <YourAppContent />
  {/* Floating window mode (default) - appears as a floating window */}
  <FixedMessenger windowMode={'floating'} />
</AIAgentProviderContainer>
```

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <YourAppContent />
  {/* Full-screen mode - takes up the entire screen */}
  <FixedMessenger windowMode={'fullscreen'} />
</AIAgentProviderContainer>
```

You can also configure full-screen insets for safe area handling:

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <YourAppContent />
  {/* Fullscreen with custom insets */}
  <FixedMessenger
    windowMode={'fullscreen'}
    fullscreenInsets={{ top: 0, bottom: 0, left: 0, right: 0 }}
  />
</AIAgentProviderContainer>
```

#### Set the launcher layout

You can customize the launcher's position, margin, size and spacing between the launcher and browser using the `FixedMessenger.Style` component.

<img width="441" height="737" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/aa-launcher.png" />

The following example demonstrates all customization options together:

```tsx
import { useState } from 'react';
import {
  AIAgentProviderContainer,
  FixedMessenger,
  AnonymousSessionInfo
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
      language={'en-US'}
      context={{ user_type: 'premium' }}
    >
      <YourAppContent />
      <FixedMessenger
        entryPoint={'Conversation'}
        windowMode={'floating'}
      >
        <FixedMessenger.Style
          position={'start-bottom'}
          margin={{
            start: 20,
            bottom: 20
          }}
          launcherSize={56}
          spacing={12}
        />
      </FixedMessenger>
    </AIAgentProviderContainer>
  );
};
```

- Position

Set the launcher position on the screen using the `position` prop. Available positions are: `start-top`, `start-bottom`, `end-top`, and `end-bottom`.
The following table lists available position values:

| Position | Description |
|----------|-------------|
| `'start-top'` | Top-left corner of the screen |
| `'start-bottom'` | Bottom-left corner of the screen |
| `'end-top'` | Top-right corner of the screen |
| `'end-bottom'` | Bottom-right corner of the screen (default) |

- Margin

Adjust the spacing around the launcher using the `margin` prop. You can set margins for each side individually.
The `margin` prop accepts an object with the following optional properties.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `top` | number | 24 | Top margin in pixels |
| `bottom` | number | 24 | Bottom margin in pixels |
| `start` | number | 24 | Start margin in pixels (left in LTR, right in RTL) |
| `end` | number | 24 | End margin in pixels (right in LTR, left in RTL) |

- Size

Customize the launcher button size in pixels using the `launcherSize` prop. The default size is `48` pixels.

- Spacing

You can also set the spacing between the launcher and the messenger window using `spacing`. The default is `12`.

#### Customize the launcher appearance

The launcher's icon and color can be configured through the [Delight AI dashboard](https://dashboard.delight.ai) - no code changes required. Simply go to **[Build > Channels > Messenger](https://dashboard.delight.ai/ai-agent/{application-id}/channels/messenger/?active_tab=Appearance)** in the dashboard and click on the **Appearance** tab to customize your launcher.

<img width="821" height="909" src="https://sendbird-files.s3.ap-northeast-1.amazonaws.com/docs/da-messenger-appearance.png">

### With direct presentation

For advanced use cases where you need direct control over the conversation view without the floating launcher, you can use the `Conversation` component directly. This provides both a full-screen or custom-sized conversation interface.

This approach is recommended when:
- You want to embed the conversation in a specific part of your UI.
- You need custom navigation or layout control.
- You want to build a full-page conversation experience.
- You need to open a specific conversation programmatically with its `channelUrl`.

```tsx
import { useState } from 'react';
import {
  AIAgentProviderContainer,
  Conversation,
  AnonymousSessionInfo
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

function DirectConversationView() {
  const [channelUrl, setChannelUrl] = useState<string | undefined>();

  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
      language={'en-US'}
      context={{ launch_source: 'direct_view' }}
    >
      <Conversation
        channelUrl={channelUrl}
        onClearChannelUrl={() => setChannelUrl(undefined)}
        onClose={() => {/* Handle close */}}
      />
    </AIAgentProviderContainer>
  );
}
```

---

## Advanced configuration

Beside the conversation mode, you can further configure how the conversation channels are created and built.

When a new conversation begins, you can pass over user information to the channel so that AI agent can provide more personalized assistance to the user. This information is contained in a `context` object, which can be set at the creation of the conversation.

Also, you can open a specific conversation channel by passing its URL, or manually create a new one while in multiple conversation mode.

### Context object for personalized conversation

The `context` object allows you to provide user's information to AI agents for more personalized service, such as their country code and language preference. This context can be set when creating conversations to enhance the user experience. You can configure these settings at the provider level using the `AIAgentProviderContainer` component props.

```tsx
import { useState } from 'react';
import {
  AIAgentProviderContainer,
  FixedMessenger,
  AnonymousSessionInfo
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

// Setting context through AIAgentProviderContainer props
const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
      language={'en-US'}  // IETF BCP 47 format
      countryCode={'US'}  // ISO 3166 format
      context={{
        customer_tier: 'premium',
        previous_interaction: 'support_ticket_123',
        user_preferences: 'technical_support'
      }}
    >
      <YourAppContent />
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
};
```

### Opening a specific conversation with channel URL

You can open a specific conversation by passing its channel URL to the `Conversation` component. This is useful when you want to display a specific conversation directly without using the launcher.

```tsx
import { useState } from 'react';
import {
  AIAgentProviderContainer,
  Conversation,
  AnonymousSessionInfo
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';

const mmkv = createMMKV();

// Using Conversation component directly to open specific conversation
function CustomMessengerView() {
  const [channelUrl] = useState('sendbird_group_channel_12345');

  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
    >
      <Conversation
        channelUrl={channelUrl}
        onClearChannelUrl={() => {/* Handle clear */}}
        onClose={() => {/* Handle close */}}
      />
    </AIAgentProviderContainer>
  );
}
```

### Start a conversation in multiple conversation mode

Multiple active conversation mode allows users to simultaneously communicate with your AI agent in different channels. In this case, use the `createConversation()` function from `useMessengerSessionContext()` to create a new conversation whenever needed.

>__Note__: In single conversation mode, a new conversation can't be created if there is an active conversation.

```tsx
import { useState } from 'react';
import { Button } from 'react-native';
import { useMessengerSessionContext } from '@sendbird/ai-agent-messenger-react-native';

function CreateConversationButton() {
  const { createConversation } = useMessengerSessionContext();

  const handleCreateConversation = async () => {
    try {
      const channelUrl = await createConversation({
        aiAgentId: 'YOUR_AI_AGENT_ID',
        language: 'en-US',
        country: 'US',
        context: {
          user_type: 'premium',
          session_id: 'session_123'
        }
      });

      console.log('Successfully created conversation:', channelUrl);

      // You can now use this channelUrl to open the specific conversation
      // See "With direct presentation" section for details

    } catch (error) {
      console.error('Failed to create conversation:', error);
    }
  };

  return (
    <Button title={'Create New Conversation'} onPress={handleCreateConversation} />
  );
}
```

>__Note__: The `CreateConversationButton` component must be used within an `AIAgentProviderContainer` to access the `useMessengerSessionContext` hook.

```tsx
// Usage within AIAgentProviderContainer
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={new AnonymousSessionInfo()}
  nativeModules={{ mmkv, imagePicker: ImagePicker, documentPicker: DocumentPicker }}
>
  <CreateConversationButton />
  <FixedMessenger />
</AIAgentProviderContainer>
```

---

## API Reference

### AIAgentProviderContainer Props

Configuration options for the `AIAgentProviderContainer` component. This component must wrap `FixedMessenger` or `Conversation` components.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `appId` | string | Required | Your application ID |
| `aiAgentId` | string | Required | AI agent identifier for conversation target |
| `userSessionInfo` | ManualSessionInfo \| AnonymousSessionInfo | Required | User session information for authentication |
| `nativeModules` | NativeAdapterConfig | Required | Native modules configuration (mmkv, imagePicker, documentPicker) |
| `chatParams` | Partial<SendbirdChatParams> | - | Custom parameters for initializing the chat SDK |
| `theme` | object | - | Theme customization including mode, palette and typography |
| `logLevel` | LogLevel | LogLevel.WARN | Log level for the AI agent client |
| `language` | string | System default | Language setting following IETF BCP 47 format (e.g., "en-US", "ko-KR") |
| `strings` | PartialDeep<StringSet> | - | Localization strings for the messenger |
| `countryCode` | string | - | Country code following ISO 3166 format (e.g., "US", "KR") |
| `context` | Record<string, string> | - | Context object for personalized AI agent responses |
| `queryParams` | AIAgentQueryParams | - | Global default query parameters for AI agent |
| `config` | AIAgentConfig | - | Global default configuration for AI agent |

### FixedMessenger Props

Configuration options for the `FixedMessenger` component. Must be used within `AIAgentProviderContainer`.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `entryPoint` | 'Conversation' \| 'ConversationList' | 'Conversation' | Which screen to show when the messenger is first loaded |
| `initialChannelUrl` | string | - | The URL of the channel to open initially when the messenger is first loaded |
| `windowMode` | 'floating' \| 'fullscreen' | 'floating' | Display mode for the messenger window |
| `fullscreenInsets` | Partial<{ top: number; left: number; right: number; bottom: number }> | - | Insets for fullscreen mode to handle safe areas |
| `edgeToEdgeEnabled` | boolean | true | (Android only) Enable edge-to-edge display |
| `windowContainerProps` | ViewProps | - | Props to pass to the window container |
| `children` | ReactNode | - | Child components (e.g., FixedMessenger.Style) |

### FixedMessenger.Style Props

Configuration options for customizing the launcher appearance.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `position` | 'start-top' \| 'start-bottom' \| 'end-top' \| 'end-bottom' | 'end-bottom' | Position of the launcher button |
| `margin` | Partial<{ top: number; bottom: number; start: number; end: number }> | { top: 24, bottom: 24, start: 24, end: 24 } | Margin around the launcher |
| `launcherSize` | number | 48 | Size of the launcher button in pixels |
| `spacing` | number | 12 | Space between launcher and messenger window in pixels |

### NativeAdapterConfig

Native modules configuration.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `mmkv` | MMKVInstance | Required | MMKV instance for local storage |
| `imagePicker` | typeof ImagePicker | Optional | Image picker module (expo-image-picker or react-native-image-picker). Can be omitted if attachment features are not used. |
| `documentPicker` | typeof DocumentPicker | Optional | Document picker module (expo-document-picker or @react-native-documents/picker). Can be omitted if attachment features are not used. |
| `permissions` | typeof RNPermissions | Optional | react-native-permissions module. Only required when using react-native-image-picker. |

### Conversation Props

Configuration options for the `Conversation` component.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `channelUrl` | string | - | Channel URL to open. If not provided, uses active channel from context |
| `onClearChannelUrl` | () => void | - | Callback when channel URL should be cleared |
| `onNavigateToConversationList` | () => void | - | Callback to navigate to conversation list |
| `onClose` | () => void | - | Callback when conversation should be closed |

### useMessengerSessionContext Hook

Access to messenger session context and conversation management functions.

- Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `sdkUser` | User \| null | Sendbird Chat SDK user object |

- Methods

| Method | Parameters | Return Type | Description |
|--------|------------|-------------|-------------|
| `createConversation` | params: ConversationCreateParams | Promise<string> | Creates a new conversation and returns the channel URL |
| `refreshActiveChannel` | - | Promise<string> | Refreshes the active channel and returns URL |
| `authenticate` | - | Promise<MessengerSettingsResponse> | Authenticates the user session |
| `deauthenticate` | - | Promise<void> | Deauthenticates the user session |

### ConversationCreateParams

Parameters for creating new conversations.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `aiAgentId` | string | Required | AI agent identifier |
| `language` | string | - | Language code (IETF BCP 47) |
| `country` | string | - | Country code (ISO 3166) |
| `context` | Record<string, string> | - | Additional metadata for AI agent |
