# Changelog

## v1.18.0 (Jun 02, 2026) with ChatSDK ^4.22.4


### Minor Changes

- Add `markdownLinkRenderMode` config option to control display of incomplete markdown links during message streaming

```ts
// In your AIAgentConfig
{
  conversation: {
    list: {
      markdownLinkRenderMode: 'complete-only', // hides partial link tokens until the link is fully streamed
    }
  }
}
```

- Fix incomplete markdown image hiding when message text contains unmatched brackets before the image token

### Patch Changes

- Fix memory dialog title to display "Memory" instead of "User memory" across all supported languages


## v1.17.0 (May 27, 2026) with ChatSDK ^4.22.4


### Minor Changes

- Improve accessibility for media viewer, bottom sheet, confirm dialog, and conversation screens with modal focus trapping, initial focus on open, and escape gesture support for screen reader users
- Fix media viewer not opening when the initial file index is out of bounds
- Add `a11y_file_selected` and `a11y_file_remove_button` to the React Native `StringSet` for customizing accessibility labels on file attachment previews
- Add `IncomingMessageLayout.Challenge` slot for customizing challenge message rendering and `onSendChallengeAction` handler for responding to challenge messages
- Add opt-in `launcher.unreadBadgeEnabled` config that shows a red-dot badge on the closed launcher when AI agent channels have unread messages; the count is fetched on connect/reconnect (not polled)

```tsx
import { AIAgentProviderContainer, FixedMessenger } from '@sendbird/ai-agent-messenger-react-native';

<AIAgentProviderContainer
  appId="YOUR_APP_ID"
  aiAgentId="YOUR_AI_AGENT_ID"
  config={{ launcher: { unreadBadgeEnabled: true } }}
>
  <FixedMessenger />
</AIAgentProviderContainer>;
```


## v1.16.0 (May 22, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Add `handlers.onClickLink` for intercepting link navigation (markdown links, markdown image presses, admin-message URLs, citation links, CTA buttons, and non-media file-preview clicks); falls back to `Linking.openURL` when omitted

```tsx
import { Linking } from 'react-native';

import { AIAgentProviderContainer } from '@sendbird/ai-agent-messenger-react-native';

<AIAgentProviderContainer
  handlers={{
    onClickLink: ({ url }) => {
      Linking.openURL(url);
    },
  }}
/>;
```


## v1.15.0 (May 20, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Add `conversation.list.markdownImageRenderMode` config option to hide incomplete markdown images while a message is streaming in the conversation

```tsx
import { AIAgentProviderContainer, FixedMessenger } from '@sendbird/ai-agent-messenger-react-native';

<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  userSessionInfo={userSessionInfo}
  nativeModules={nativeModules}
  config={{ conversation: { list: { markdownImageRenderMode: 'complete-only' } } }}
>
  <FixedMessenger />
</AIAgentProviderContainer>;
```

- Group conversation list options under `conversation.list` (`isTalkToAgentViewEnabled`, `scrollMode`, `newMessageIndicatorEnabled`, `senderAvatarEnabled`); the legacy flat keys on `conversation` are still accepted and marked deprecated

### Patch Changes

- Fix conversation list screen entry not being announced to screen readers
- Fix accessibility labels and hints for the close-messenger button across all supported languages
- Fix accessibility for CSAT survey rating options, follow-up inputs, and radio controls
- Fix accessibility labels and live-region announcements in the conversation list screen
- Fix accessibility labels and hints for conversation screen header controls (close, menu, handoff, title)
- Fix accessibility for form error labels and text inputs
- Fix accessibility hint for the launcher button


## v1.14.1 (May 15, 2026) with ChatSDK ^4.22.3


### Patch Changes

- Move screen-reader focus to the conversation list header when the list becomes the active screen, including when returning to it from a conversation
- Expose the conversation list close button and header title to screen readers with consistent header and button semantics


## v1.14.0 (May 13, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Announce CSAT submission and expiration through the screen reader, and announce every incoming message in a realtime batch instead of collapsing to the latest
- Include sender, message body, and timestamp in new-message announcements, and align received-file labels (image, video, PDF, document) with the documented accessibility format
- Relocate focus after CSAT submission so screen readers continue from the conversation context
- Fix CSAT expiration announcements firing during an in-flight submit
- Add a user memory indicator to the conversation header that surfaces the consent dialog on first use and lets users manage whether the AI Agent remembers them; new `MemoryIndicator` slot is available on `ConversationHeaderLayout` for customization


## v1.13.0 (May 08, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add multi-file upload support to the React Native messenger. Users can now attach and send multiple files in a single message. Received multi-file messages are displayed as an image grid, and tapping any image opens a full-screen MediaViewer with prev/next navigation. Outgoing pending messages show local file previews with a dimmed overlay while uploading.
- Add connection delay dialog that shows a countdown when the SDK connection is delayed
- Add fixed scroll mode for streaming messages that anchors the user message in place while the AI response streams in above it
- Fix closed-conversation state being lost when switching channels
- Fix layout glitch when entering a conversation before messages load in fixed scroll mode
- Move screen-reader focus to the first header element (menu button, with header title as fallback) when entering a conversation
- Add `onCustomEvent` handler to receive message lifecycle events (`message-sent-pending`, `message-sent-succeeded`, `bot-message-received`, `user-action-requested`)

### Patch Changes

- Fix accessibility announcement to correctly name the most recently transferred agent after a handoff
- Fix image and multiple-file previews switching to server URLs after upload succeeds


## v1.12.0 (Apr 24, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add `icons` prop to customize icon components via a partial icon registry

### Patch Changes

- Fix contrast and accessibility in FeedbackModal and inline feedback pill components


## v1.11.1 (Apr 17, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Fix conversation header and list to show the most recently joined agent


## v1.11.0 (Apr 13, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Steward support: Introduced Steward, an agentic workflow layer that handles structured customer requests within the chat widget
  - The widget title now updates dynamically to reflect the current Steward state (e.g., processing, completed, cancelled)
  - Users can cancel an active Steward request directly from the chat interface
  - Users can demand a handoff to a human agent at any point during a Steward workflow
- Add `colors` prop to `MessengerThemeContext` and provider container theme props for per-value color overrides
- Add `AccessibilityAnnouncerContext` for platform-native accessibility announcements
- Add `ConversationAnnouncementsContext` for coordinating status, typing, and screen entry announcements
- Add `useA11y` hook for accessibility attributes on conversation UI elements
- Add status, typing, and screen entry announcement hooks
- Add `useReducedMotion` hook to respect user motion preferences


## v1.10.3 (Apr 03, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Improved stability and internal enhancements


## v1.10.2 (Apr 01, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Fix race condition where stale `refreshActiveChannel` closures from a previous session could overwrite the new session's active channel after a session switch


## v1.10.1 (Mar 27, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Fix scroll flicker during streaming by suppressing re-renders while programmatic scroll is in flight
- Fix away-from-bottom state going stale when repeated auto-scrolls were triggered rapidly
- Recompute scroll list scrollability when the viewport changes (rotation, keyboard, safe-area)
- Scroll to bottom when the typing indicator appears and the user is near the bottom, matching React web behavior
- Fix MMKV storage routing so it flows through `useMMKVStorage` instead of `chatParams.useMMKVStorageStore`
- Export `useAIAgentContext` from the package


## v1.10.0 (Mar 26, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add thinking mode to the typing indicator with shimmer animation

### Patch Changes

- Add `_agentVersion` support for internal conversation initialization via `requestMessengerSettings`
- Refactor `initConversationIfNeeded` to be accessible from the `AIAgent` instance
- Refactor active channel updates to use `_aiAgentSDK` session directly


## v1.9.0 (Mar 18, 2026) with ChatSDK ^4.21.2


### Minor Changes

- **Desk ticket support**: AI Agent SDK now includes Desk ticket support. You can now access Desk ticket information directly from the AI Agent SDK for conversations handed off to Desk, removing the need to use a separate Desk SDK for ticket lookup.
    - Added `DeskTicketInterface` with properties: `id`, `title`, `status`, `agent`, `priority`, `group`, `firstResponseTime`, `issuedAt`, `customFields`
    - Added `refresh(): Promise<DeskTicketInterface>` to reload latest ticket data
    - Added `deskClient.getTicket(id): Promise<DeskTicketInterface>` to fetch a ticket by ID
    - Added `DeskTicketAgent` interface with `userId`, `name`, `profileUrl` properties
    - Added `DeskTicketPriority` enum: `URGENT`, `HIGH`, `MEDIUM`, `LOW`
    - Added `DeskTicketStatus` enum: `INITIALIZED`, `PROACTIVE`, `PENDING`, `ACTIVE`, `CLOSED`, `WORK_IN_PROGRESS`, `IDLE`
    ```typescript
    // Access deskClient from context
    const { deskClient } = useAIAgentContext();

    // Get ticket information
    const ticket = await deskClient.getTicket(12345);
    console.log('Ticket status:', ticket.status);
    console.log('Assigned agent:', ticket.agent?.name);
    console.log('Priority:', ticket.priority);

    // Refresh ticket data
    const updatedTicket = await ticket.refresh();
    ```


## v1.8.1 (Mar 09, 2026) with ChatSDK ^4.21.2


### Patch Changes

- Fix message input being disabled after app switch by correctly restoring connection state when coming back online


## v1.8.0 (Mar 06, 2026) with ChatSDK ^4.21.2


### Minor Changes

- Handle session token expiration for anonymous widget users with native alert

### Patch Changes

- Auto-scroll to submit button when CSAT is displayed
- Fix channel state synchronization issue after conversation handoff and auto-close
- Add device OS version to platform configuration for better device tracking


## v1.7.0 (Feb 12, 2026) with ChatSDK ^4.21.2


### Minor Changes

- Add `presentMethod` prop for stats tracking support


## v1.6.0 (Feb 11, 2026) with ChatSDK ^4.21.1


### Minor Changes

- Implement FYC (first your conversation) with automatic conversation initialization for AI Agent channels
- Add `conversationStatus` field to `ActiveChannel` interface, decouple from `ConversationStatus` enum
- Improve StatefulFlatList with `empty` and `stackDirection` props
- Add stateful props to message list components


## v1.5.0 (Feb 06, 2026) with ChatSDK ^4.21.1


### Minor Changes

- Add DateSeparatorLayout for customizable date separators in conversation view

### Patch Changes

- Fix ESM/CJS module resolution issues by inlining hljs theme in CodeBlock component
- Improve `createLayout` type inference by reordering type parameters for better TypeScript inference
- Add explicit `ReactNode` return type annotations to all layout template and registered components
- Add `MessageListUILayout` to group date separator and scroll-to-bottom button components
- Simplify `DateSeparator` component props by moving locale and format string handling to internal logic


## v1.4.1 (Jan 30, 2026) with ChatSDK ^4.21.0


### Patch Changes

- Fix `searchConversation` to correctly pass `aiAgentId` via params instead of closure reference


## v1.4.0 (Jan 30, 2026) with ChatSDK ^4.21.0


### Minor Changes

- Add searchConversation API to find conversations by context


## v1.3.2 (Jan 29, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Add `always_visible` option to CSAT follow-up items, allowing follow-up questions to be displayed regardless of the selected CSAT score
- Only disconnect WebSocket when connectionState is OPEN to prevent request cancellation


## v1.3.1 (Jan 20, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Export `CustomMessageTemplateData` and `ExtendedMessagePayload` types for custom message template usage


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

