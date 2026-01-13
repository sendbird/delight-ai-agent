# Changelog

## v1.3.0 (Jan 13, 2026) with ChatSDK ^4.20.4


### Minor Changes

- Add CustomMessageTemplate component to IncomingMessageLayout


## v1.2.0 (Dec 24, 2025) with ChatSDK ^4.20.4


### Minor Changes

- Add configuration flags to control avatar visibility: `config.conversation.header.avatarEnabled` for header avatar and `config.conversation.senderAvatarEnabled` for message sender avatars (both default to true for backward compatibility)


## v1.1.0 (Dec 22, 2025) with ChatSDK ^4.20.4


### Minor Changes

- Add newMessageIndicatorEnabled config option
- Implement new messages button with localization support
- Improve connection state handling by adding support for the new `onConnectionLost` callback from `@sendbird/chat` 4.20.4. The messenger now displays a more accurate "reconnecting" state when the connection is lost, providing better feedback to users during network interruptions.
- Add `data` field to `BaseMessageProps` to allow passing custom data to message components

### Patch Changes

- Fixed auto-scroll not updating during streaming text animation


## v1.0.1 (Dec 10, 2025) with ChatSDK ^4.20.3


### Fixes

- Separate transform and overflow layers to fix iOS animation bug in FixedMessenger

### Improvements

- Make onSubmitCSAT callback async for better error handling


## v1.0.0 (Dec 04, 2025) with ChatSDK ^4.20.3


The first official release of the AI Agent Messenger SDK for React Native.

### Highlights

A messenger SDK that enables seamless AI chatbot integration into your React Native app.

#### FixedMessenger

An all-in-one messenger component with a floating launcher button and fullscreen mode support.

```tsx
import { createMMKV } from 'react-native-mmkv';

import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
  FixedMessenger,
} from '@sendbird/ai-agent-messenger-react-native';

const mmkv = createMMKV();

const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv }}
    >
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
};
```

#### With React Navigation

For custom navigation flows, use `Conversation` and `ConversationList` components with `@react-navigation/native`.

```tsx
// App.tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import {
  AIAgentProviderContainer,
  AnonymousSessionInfo,
} from '@sendbird/ai-agent-messenger-react-native';
import { createMMKV } from 'react-native-mmkv';

const mmkv = createMMKV();
const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      userSessionInfo={new AnonymousSessionInfo()}
      nativeModules={{ mmkv }}
    >
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name={'Conversation'} component={ConversationScreen} />
          <Stack.Screen name={'ConversationList'} component={ConversationListScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </AIAgentProviderContainer>
  );
};

// ConversationScreen.tsx
import { useNavigation, useRoute } from '@react-navigation/native';
import { Conversation } from '@sendbird/ai-agent-messenger-react-native';

const ConversationScreen = () => {
  const navigation = useNavigation();
  const route = useRoute();
  const { channelUrl } = route.params || {};

  return (
    <Conversation
      channelUrl={channelUrl}
      onClose={() => navigation.goBack()}
      onNavigateToConversationList={() => navigation.navigate('ConversationList')}
    />
  );
};

// ConversationListScreen.tsx
import { useNavigation } from '@react-navigation/native';
import { ConversationList } from '@sendbird/ai-agent-messenger-react-native';

const ConversationListScreen = () => {
  const navigation = useNavigation();

  return (
    <ConversationList
      onNavigateToConversation={(channelUrl) => navigation.navigate('Conversation', { channelUrl })}
      onClose={() => navigation.goBack()}
    />
  );
};
```

#### Key Features

- **Session Management**: Manual (authenticated) and Anonymous (guest) session support
- **Localization**: 10 languages supported (en, ko, ja, de, es, fr, hi, it, pt, tr)
- **File Attachments**: Image and document uploads via Expo or Community picker packages
- **Theming**: Light/Dark mode with customizable styling
- **CSAT Feedback**: Built-in customer satisfaction survey support
- **Markdown Rendering**: Rich text display with code syntax highlighting

