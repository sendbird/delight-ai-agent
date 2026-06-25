# Changelog

## v1.34.0 (Jun 25, 2026) with ChatSDK ^4.22.5


### Minor Changes

- Export `LiveMetric` type for typing the `onLiveMetric` handler payload in real-time SDK analytics

```tsx
import { AgentProviderContainer, Conversation, type LiveMetric } from '@sendbird/ai-agent-messenger-react';

<AgentProviderContainer
  handlers={{
    onLiveMetric: (metric: LiveMetric) => {
      console.log(metric.category, metric.metricKey, metric.data);
    },
  }}
>
  <Conversation />
</AgentProviderContainer>;
```

### Patch Changes

- Fix streaming animation for non-last bubbles in multi-bubble responses, showing full text immediately when the stream ends instead of leaving them partially animated


## v1.33.0 (Jun 17, 2026) with ChatSDK ^4.22.5


### Minor Changes

- Add `conversationStatsEnabled` prop to `Conversation` for controlling stats collection when building custom conversation navigation
- Add `conversationListStatsEnabled` prop to `ConversationList` for controlling stats collection when building custom conversation list navigation

### Patch Changes

- Fix date dividers so consecutive welcome messages spanning multiple days stay grouped with one divider.
- Fix auto scroll losing bottom pin when message content resizes (e.g., streaming text or image load) in auto mode
- Fix avatar and channel cover images not falling back to the placeholder icon when the image URL fails to load
- Fix date dividers so consecutive welcome messages spanning multiple days stay grouped with one divider.


## v1.32.0 (Jun 10, 2026) with ChatSDK ^4.22.5


### Minor Changes

- Add `FixedMessenger.Conversation` and `FixedMessenger.ConversationList` for replacing the default conversation and conversation-list views with custom components

```tsx
import { type ConversationListProps, type ConversationProps, FixedMessenger } from '@sendbird/ai-agent-messenger-react';

const CustomConversation = (props: ConversationProps) => <MyConversation {...props} />;
const CustomConversationList = (props: ConversationListProps) => <MyConversationList {...props} />;
<FixedMessenger appId={'APP_ID'} aiAgentId={'AGENT_ID'}>
  <FixedMessenger.Conversation component={CustomConversation} />
  <FixedMessenger.ConversationList component={CustomConversationList} />
</FixedMessenger>;
```

### Patch Changes

- Fix focus not returning to the launcher button when closing the messenger window


## v1.31.1 (Jun 09, 2026) with ChatSDK ^4.22.5


### Patch Changes

- Fix focus ring appearing on the header menu button when the messenger window opens programmatically
- Fix background surface stealing keyboard focus from an open modal dialog
- Fix MediaViewer layout on mobile devices to fill the viewport and respect safe area insets (notch, home bar)
- Fix backdrop click to close MediaViewer while the image is still loading
- Fix placeholder text color in disabled and blocked message input to use the correct disabled color token


## v1.31.0 (Jun 04, 2026) with ChatSDK ^4.22.5


### Minor Changes

- Add `deferredMarkdownElements` config option to control which markdown elements are hidden during message streaming; deprecates `markdownImageRenderMode` and `markdownLinkRenderMode`

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

<FixedMessenger
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  config={{
    conversation: {
      list: {
        deferredMarkdownElements: ['image', 'link'],
      },
    },
  }}
/>;
```


## v1.30.0 (Jun 02, 2026) with ChatSDK ^4.22.4


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

- Fix screen-reader focus timing in windowed dialogs so initial focus waits until the conversation title is registered
- Fix accessibility of sender information, sent time, and message body — these are no longer incorrectly hidden from screen readers
- Improve focus trap behavior and accessible labeling of form inputs, date separators, and the feedback comment field
- Fix memory dialog title to display "Memory" instead of "User memory" across all supported languages
- Fix screen reader experience for incoming markdown messages so that structured content (bold text, lists, links) is read directly instead of a flattened plain-text duplicate


## v1.29.0 (May 27, 2026) with ChatSDK ^4.22.4


### Minor Changes

- Add `IncomingMessageLayout.Challenge` slot for customizing challenge message rendering and `onSendChallengeAction` handler for responding to challenge messages

```tsx
import { IncomingMessageLayout } from '@sendbird/ai-agent-messenger-react';
import type { IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

const MyChallenge = ({ extendedMessagePayload, onSendChallengeAction }: IncomingMessageProps) => {
  const challenge = extendedMessagePayload?.challenge;
  if (!challenge) return null;
  return (
    <button
      onClick={() => onSendChallengeAction?.({ key: challenge.key, requestId: challenge.request_id, action: 'submit' })}
    >
      Submit
    </button>
  );
};
<IncomingMessageLayout.Challenge component={MyChallenge} />;
```

- Add opt-in `launcher.unreadBadgeEnabled` config that shows a red-dot badge on the closed launcher when AI agent channels have unread messages; the count is fetched on connect/reconnect (not polled)

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

<FixedMessenger appId="YOUR_APP_ID" aiAgentId="YOUR_AI_AGENT_ID" config={{ launcher: { unreadBadgeEnabled: true } }} />;
```

### Patch Changes

- Fix accessibility label for PDF files in the file viewer so screen readers announce "PDF file" instead of "Document file"


## v1.28.0 (May 22, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Add `handlers.onClickLink` for intercepting link navigation (markdown links, admin-message URLs, citation links, CTA buttons, and non-media file-preview clicks); falls back to `window.open` when omitted

```tsx
import { AgentProviderContainer } from '@sendbird/ai-agent-messenger-react';

<AgentProviderContainer
  handlers={{
    onClickLink: ({ url }) => {
      // custom analytics or deep-link handling
      window.open(url, '_blank');
    },
  }}
/>;
```


## v1.27.0 (May 20, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Add `conversation.list.markdownImageRenderMode` config option to hide incomplete markdown images while a message is streaming in the conversation

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

<FixedMessenger config={{ conversation: { list: { markdownImageRenderMode: 'complete-only' } } }} />;
```

- Group conversation list options under `conversation.list` (`isTalkToAgentViewEnabled`, `scrollMode`, `newMessageIndicatorEnabled`, `senderAvatarEnabled`); the legacy flat keys on `conversation` are still accepted and marked deprecated

### Patch Changes

- Fix message input not honoring `theme.colors.messageInput.background`, `theme.colors.messageInput.text`, and `theme.colors.messageInput.placeholderText`
- Fix conversation list screen entry announcement to include the conversation count for screen reader users


## v1.26.1 (May 15, 2026) with ChatSDK ^4.22.3


### Patch Changes

- Expose the open messenger window as a labeled modal dialog so screen readers announce it on open and restore focus to the opener on close
- Contain keyboard focus inside the open messenger window so Tab and Shift+Tab cycle within it instead of escaping to the host page
- Announce the conversation list as a labeled list with list-item semantics for assistive technologies
- Move screen-reader focus to the conversation list header when entering the list, including when returning via the launcher's lazy navigator
- Re-announce incoming messages when their bodies arrive or are enriched after the initial event
- Restore focus correctly when a portaled dialog (such as the feedback modal) opened from inside the messenger window closes


## v1.26.0 (May 13, 2026) with ChatSDK ^4.22.3


### Minor Changes

- Announce CSAT submission and expiration to screen readers, and announce every incoming message in a realtime batch instead of collapsing to the latest
- Include sender, message body, and timestamp in new-message announcements, and align received-file labels (image, video, PDF, document) with the documented accessibility format
- Add `A11Y_RECEIVED_FILE_IMAGE`, `A11Y_RECEIVED_FILE_VIDEO`, `A11Y_RECEIVED_FILE_PDF`, and `A11Y_RECEIVED_FILES_IMAGE_COUNT` string set entries for received-file announcements
- Fix duplicate CSAT expiration announcements when the form transitions through submit
- Add a user memory indicator to the conversation header that surfaces the consent dialog on first use and lets users manage whether the AI Agent remembers them; new `MemoryIndicator` slot is available on `ConversationHeaderLayout` for customization

### Patch Changes

- Improve CSAT score screen-reader announcement to include the total (e.g. "1 out of 5 — Terrible") across all supported languages


## v1.25.0 (May 08, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add compile-time feature flags (`__SBA_USE_SYNTAX_HIGHLIGHT__`, `__SBA_USE_MESSAGE_TEMPLATE__`, `__SBA_USE_FORM__`) for selective tree-shaking; flags are inlined at dynamic import sites so Webpack can statically eliminate disabled async chunks; disabling all flags reduces ESM gzip size by ~35%
- Add connection delay dialog that shows a countdown when the SDK connection is delayed
- Improve accessibility attributes across the launcher, message list, forms, and file previews
- Move screen-reader focus to the first header element (menu button, with header title as fallback) when entering a conversation

### Patch Changes

- Fix accessibility announcement to correctly name the most recently transferred agent after a handoff
- Fix FixedMiniWindow close animation not playing by delaying the visibility transition to hidden
- Refactor escape key handling to use a centralized dismiss stack so that pressing Escape reliably closes only the topmost open element (modal, alert, bottom sheet, mini window, etc.) instead of multiple components reacting at once


## v1.24.0 (Apr 24, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add `icons` prop to customize icon components via a partial icon registry

### Patch Changes

- Fix z-index layering for DefaultMessenger to use auto stacking context instead of hardcoded max z-index
- Flatten incoming message layout variables by inlining intermediate JSX fragments directly into the return statement.
- Fix CSAT score button alignment and focus ring
- Fix contrast and accessibility in FeedbackModal, CSAT message, StartNewConversationButton, and inline feedback pill components


## v1.23.0 (Apr 17, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Improve message list keyboard traversal and screen-reader accessibility
- Stabilize conversation announcements and input focus management
- Improve CSAT accessibility semantics and radio-group keyboard interaction
- Fix header button voiceover hints, focus targeting, and decorative cover hiding
- Pause incoming message announcements during focus sync to reduce noise
- Add scroll-to-bottom button and fixed mini-window accessibility

### Patch Changes

- Show confirmation alert when uploading a different file type that would replace the current attachment; confirmation is checked before file validation
- Fix validation alerts being cleared after replacement confirmation
- Add `cancelText` and `onCancel` props to `Alert` component to support cancel actions
- Fix conversation header and list to show the most recently joined agent


## v1.22.0 (Apr 13, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Steward support: Introduced Steward, an agentic workflow layer that handles structured customer requests within the chat widget
  - The widget title now updates dynamically to reflect the current Steward state (e.g., processing, completed, cancelled)
  - Users can cancel an active Steward request directly from the chat interface
  - Users can demand a handoff to a human agent at any point during a Steward workflow
- Add `colors` prop to `MessengerThemeContext` and provider container theme props for per-value color overrides
- Add `AriaLiveRegionContext` for ARIA live region screen reader announcements
- Add `ConversationAnnouncementsContext` for coordinating status, typing, and screen entry announcements
- Add `ScreenReaderOnly` component for visually-hidden accessible text
- Add focus management hooks: `useFocusTrap`, `useKeyboardFocusVisibility`, `useEscapeKey`
- Add `useA11y` hook for comprehensive accessibility attributes on conversation UI elements
- Add status, typing, and screen entry announcement hooks
- Add `useReducedMotion` hook to respect user motion preferences
- Add new a11y localization string keys


## v1.21.3 (Apr 03, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Improved stability and internal enhancements


## v1.21.2 (Apr 01, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Fix race condition where stale `refreshActiveChannel` closures from a previous session could overwrite the new session's active channel after a session switch


## v1.21.1 (Mar 27, 2026) with ChatSDK ^4.22.0


### Patch Changes

- Export `useAIAgentContext` from the package


## v1.21.0 (Mar 26, 2026) with ChatSDK ^4.22.0


### Minor Changes

- Add thinking mode to the typing indicator with shimmer animation

### Patch Changes

- Add `_agentVersion` support for internal conversation initialization via `requestMessengerSettings`
- Refactor `initConversationIfNeeded` to be accessible from the `AIAgent` instance
- Refactor active channel updates to use `_aiAgentSDK` session directly
- Fix premature unread count reset during scroll reconciliation by guarding the reset until the scroll animation completes
- Stabilize initial auto scroll by re-running a bounded bottom sync during the initial settle window when the first message layout grows after mount


## v1.20.1 (Mar 20, 2026) with ChatSDK ^4.21.2


### Patch Changes

- Fix scroll-to-bottom button not disappearing after click by optimistically resetting scroll distance to 0 when `scrollToBottom()` is called
- Fix scroll-to-bottom button reappearing unexpectedly by detecting external scroll intervention during programmatic scroll


## v1.20.0 (Mar 18, 2026) with ChatSDK ^4.21.2


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

### Patch Changes

- Fix template rendering when message template key is missing
- Fix sideEffects field in package.json to prevent incorrect tree-shaking of entry points
- Pin dompurify to 3.3.2


## v1.19.1 (Mar 09, 2026) with ChatSDK ^4.21.2


### Patch Changes

- Fix message input being disabled after app switch by correctly restoring connection state when coming back online


## v1.19.0 (Mar 06, 2026) with ChatSDK ^4.21.2


### Minor Changes

- Handle session token expiration for anonymous widget users with alert dialog

### Patch Changes

- Prevent duplicate alert sounds across tabs viewing the same channel
- Auto-scroll to submit button when CSAT is displayed
- Fix channel state synchronization issue after conversation handoff and auto-close


## v1.18.0 (Feb 20, 2026) with ChatSDK ^4.21.2


### Minor Changes

- **Multi-file attachment support**: Users can now send and receive multiple files in a single message. Photos and documents are selectable via a bottom sheet UI, received images display in a responsive grid layout, and all file types (images, videos, documents) can be browsed through a unified media viewer with navigation.
- **Customizable message body layout**: Individual message body sub-components are now overridable through the layout context for fine-grained UI customization.
- Fix: File count limit validation now correctly rejects file selections exceeding the configured maximum.
- Deprecation: `CSAT5_RATING_SCORE_*` localization keys removed; rating labels now come from the server payload.
- Removal: `FILE_UPLOAD_NOTIFICATION__FILES_REMOVED_OVER_COUNT_LIMIT` localization key removed (previously deprecated).


## v1.17.0 (Feb 12, 2026) with ChatSDK ^4.21.2


### Minor Changes

- Add conversation initialization performance tracking
- Add message alert sound for incoming messages when browser is unfocused


## v1.16.0 (Feb 11, 2026) with ChatSDK ^4.21.1


### Minor Changes

- Implement FYC (first your conversation) with automatic conversation initialization for AI Agent channels
- Add `conversationStatus` field to `ActiveChannel` interface, decouple from `ConversationStatus` enum
- Refactor ChatMessageList component for improved message rendering
- Add stateful props to message list components


## v1.15.0 (Feb 06, 2026) with ChatSDK ^4.21.1


### Minor Changes

- Add DateSeparatorLayout for customizable date separators in conversation view
- Add AI event handler for external authentication token expiration events with `onExternalAuthTokenExpired` callback
- Add overloads to `updateContext` and `patchContext` to support specific conversations by aiAgentId and channelUrl

### Patch Changes

- Fix scroll behavior when `messageStackDirection` is set to `'bottom'` by treating it as auto scroll mode
- Improve `createLayout` type inference by reordering type parameters for better TypeScript inference
- Add explicit `ReactNode` return type annotations to all layout template and registered components
- Add `MessageListUILayout` to group date separator and scroll-to-bottom button components
- Simplify `DateSeparator` component props by moving locale and format string handling to internal logic


## v1.14.1 (Jan 30, 2026) with ChatSDK ^4.21.0


### Patch Changes

- Fix `searchConversation` to correctly pass `aiAgentId` via params instead of closure reference


## v1.14.0 (Jan 30, 2026) with ChatSDK ^4.21.0


### Minor Changes

- Add searchConversation API to find conversations by context
- Add style prop to Conversation and ConversationList components
- Use theme.colors.messageInput for MessageInput styles
- Remove unused colors.metadata property

### Patch Changes

- Fixed an issue where `chatParams` would be overridden with `undefined` values when `customApiHost` or `customWebSocketHost` props are not provided


## v1.13.2 (Jan 29, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Add `always_visible` option to CSAT follow-up items, allowing follow-up questions to be displayed regardless of the selected CSAT score
- Only disconnect WebSocket when connectionState is OPEN to prevent request cancellation


## v1.13.1 (Jan 20, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Export `CustomMessageTemplateData` type for custom message template usage


## v1.13.0 (Jan 13, 2026) with ChatSDK ^4.20.4


### Minor Changes

- Add CustomMessageTemplate component to IncomingMessageLayout

### Patch Changes

- Fix auto-scroll behavior when typing indicator appears in `scrollMode: auto`. The scroll now correctly maintains position at bottom when new typing indicators are added.


## v1.12.2 (Jan 09, 2026) with ChatSDK ^4.20.4


### Patch Changes

- Fix chatParams prop to be partial for flexible configuration
- Prevent chatParams from being overridden by props spread
- Fixed unwanted bottom spacing in closed conversations with fixed scroll mode by resetting bottomSpace and disconnecting MutationObserver


## v1.12.1 (Jan 05, 2026) with ChatSDK ^4.20.4


### Patch Changes

- Add downloadEnabled config for FileViewer
- Fix FileViewer image overflow and modal dir inheritance


## v1.12.0 (Dec 24, 2025) with ChatSDK ^4.20.4


### Minor Changes

- Add configuration flags to control avatar visibility: `config.conversation.header.avatarEnabled` for header avatar and `config.conversation.senderAvatarEnabled` for message sender avatars (both default to true for backward compatibility)

### Patch Changes

- Fixed file download functionality in FileViewer by adding download attribute to anchor tag


## v1.11.0 (Dec 22, 2025) with ChatSDK ^4.20.4


### Minor Changes

- Add newMessageIndicatorEnabled config option
- Implement new messages button with localization support
- Improve connection state handling by adding support for the new `onConnectionLost` callback from `@sendbird/chat` 4.20.4. The messenger now displays a more accurate "reconnecting" state when the connection is lost, providing better feedback to users during network interruptions.
- Add `data` field to `BaseMessageProps` to allow passing custom data to message components

### Patch Changes

- Fixed auto-scroll not updating during streaming text animation


## v1.10.3 (Dec 10, 2025) with ChatSDK ^4.20.3


### Fixes

- Add PageChildrenContextProvider to DefaultMessenger

### Improvements

- Add accessibility improvements: proper aria-label attributes, list roles, and alt attributes for images
- Make onSubmitCSAT callback async for better error handling


## v1.10.2 (Dec 04, 2025) with ChatSDK ^4.20.3


### Features

- Add ConversationChildren and ConversationListChildren to FixedMessenger

### Fixes

- Reset the conversation context and state when changed url
- Add defensive logic to special notice

### Improvements

- Update "Talk to agent" string to "Start a conversation"

### Performance

- Optimize streaming text animation and throttle channel change handlers


## v1.10.1 (Nov 24, 2025) with ChatSDK ^4.20.1


### Features

- Add initial channel URL support to messenger components

## v1.10.0 (Nov 21, 2025) with ChatSDK ^4.20.1


### Features

- Introduce header layout customization support

### Fixes

- Add overscroll-behavior to prevent scroll chaining to parent page


## v1.9.5 (Nov 19, 2025) with ChatSDK ^4.20.1


### Features

- Add reconnecting state to input field for network disconnection feedback with "Trying to reconnect" placeholder

### Fixes

- Ensure fresh values by passing directly through context

### Improvements

- Refactor useConnectionState to use NetworkStateAdapter pattern for cross-platform compatibility


## v1.9.4 (Nov 18, 2025) with ChatSDK ^4.20.1


### Fixes

- Ensure ConversationScrollProvider always wraps ConversationContext to maintain backward compatibility and prevent context errors when upgrading to v1.9.0+

### Improvements

- Update branding from Sendbird to Delight across UI components and documentation
- Update bot icon to new Delight icon design
- Refresh color palette with updated basic colors
- Add ellipse fill color support for improved visual consistency


## v1.9.3 (Nov 17, 2025) with ChatSDK ^4.20.1


### Fixes

- Buffer extendedMessagePayload until text streaming completes to prevent suggested replies and citations from appearing before message text finishes displaying

### Improvements

- Centralize streaming text logic in parent component to eliminate duplicate hook calls and improve performance
- Mark unused localization strings as deprecated


## v1.9.2 (Nov 13, 2025) with ChatSDK v4.20.1

### Improvements

- Adjust top margin offset in ConversationScrollContext for improved scroll positioning

## v1.9.1 (Nov 13, 2025) with ChatSDK v4.20.1

### Bug Fixes

- Prevent channel fetch without authenticated user
- Fix welcome message grouping when feedback is enabled

## v1.9.0 (Nov 11, 2025) with ChatSDK v4.20.1

### Features

- Implement progressive streaming text animation for AI responses with smooth character-by-character display

## v1.8.2 (Nov 06, 2025) with ChatSDK v4.20.1

### Bug Fixes

- Fix scroll jitter issue during AI message streaming when user attempts to scroll up

## v1.8.1 (Nov 07, 2025) with ChatSDK v4.20.1

### Features

- Add file attachment rules configuration for file upload validation
- Make CSAT5 CRE (Customer Relationship Effort) field optional

### Internal

- Refactor attachment handling and validation logic

## v1.8.0 (Nov 04, 2025) with ChatSDK v4.20.1

### Features

- Add `scrollMode` configuration (`fixed` / `auto`) for controlled message streaming scroll behavior
- Add message retry functionality for failed messages
- Add shared localization strings to core package

### Fixes

- Fix scroll position interference when conversation closes during message streaming

### Internal

- Upgrade TypeScript target and lib to ES2023
- Refactor localization architecture across core, React, and React Native packages

## v1.7.0 (Oct 30, 2025) with ChatSDK v4.20.1

### Features

- Add user feedback feature with feedback modal and sentiment icons
- Add closeConversation method to AIAgentConversationContext to enable closing conversations programmatically

### Fixes

- Fix underscore characters in email addresses being incorrectly rendered as italic markdown formatting

## v1.6.4 (Oct 23, 2025) with ChatSDK v4.20.1

### Features

- Add support for user_input_disabled_by field in extended message payload to control input state based on extended message data
- Add form_type to UserActionRequestedData for enhanced form type tracking
- Add deleteMessage to AIAgentConversationContext to enable message deletion functionality

## v1.6.3 (Oct 22, 2025) with ChatSDK v4.20.1

### Features

- Add bottom sheet component

### Improvements

- Move input state and typing hooks to core package
- Convert BottomSheet to compound component pattern
- Update typing indicator invalidate time to 20 seconds
- Update internal dependencies

## v1.6.2 (Oct 10, 2025) with ChatSDK v4.20.1

### Fixes

- Fix rendering of square brackets without URLs in markdown text

## v1.6.1 (Oct 06, 2025) with ChatSDK v4.20.1

### Features

- Add onInitializeFailed handler to AgentClientHandlers
- Implement PlaceholderLayout

## v1.6.0 (Oct 02, 2025) with ChatSDK v4.20.1

### Features

- Support customizable CSAT with improved component structure
- Add csatStartedAt and resolutionScore parameters to CSAT submission

### Bug Fixes

- Switch to useLayoutEffect in createLayout to avoid UI flicker
- Fix text overflow in radio label
- Fix text overflow in submit button label

## v1.5.0 (Sep 25, 2025) with ChatSDK v4.20.0

### Features

- Add new channel list UI
- Add copilot conversation filters to AIAgentGroupChannelFilter
- Enable file upload for non-AI agent channels
- Add entryPoint prop to control initial messenger screen
- Add startNewConversation visibility control flag to config prop

### Bug Fixes

- Prevent text overflow in MessageLogs labels
- Add automatic navigation for proactive conversation join
- Prevent text overflow in ConversationListItem
- Only apply input blocking after sending in AI agent channels
- Resolve last message streaming issue

## v1.4.1 (Sep 22, 2025) with ChatSDK v4.19.11

### Features

- Add copilot conversation only mode and support channel URL to AIAgentGroupChannelFilter
- Add tester mode conversation details footer and copy link functionality
- Trigger custom events for user_action_required on initial render with improved message processing

### Improvements

- Optimize scroll trigger logic for closed conversations
- Improve CustomEventHandler performance and reliability
- Centralize handler check in useCustomEventForMessageReceive
- Enhance custom event handling for user_action_required events

## v1.4.0 (Sep 19, 2025) with ChatSDK v4.19.10

### Features

- Add custom chat SDK injection support with validation
- Implement comprehensive form system with validation constraints and styled components
- Add user action required event handling for ADMM messages
- Implement input blocking and form state management during conversations
- Add message feedback type to extended message payload

### Bug Fixes

- Fix active channel update on reconnected flow
- Prevent MessageBody rendering during typing indicator display
- Add userId validation and improve manual session handling

## v1.3.2 (Sep 10, 2025) with ChatSDK v4.19.5

### Features

- Update typing indicator invalidation time configuration

## v1.3.1 (Sep 08, 2025) with ChatSDK v4.19.5

### Features

- Add query params and conversation list limit support
- Add id to DateSeparator component for external styling

## v1.3.0 (Aug 27, 2025) with ChatSDK v4.19.5

### Features

- Add custom event interface for bot message receive
- Pass isStreaming prop to incoming message component
- Add typing event support in message input
- Add strict session check with class instances

### Bug Fixes

- Use a uniq handler id for connection handler
- Fix deauthenticate bugfix

### Refactoring

- Refactor authentication hooks

### Tests

- Wrap assertions in waitFor for useConversationChannels test
- Add comprehensive cache tests and export STORAGE_PREFIX constant
- Add comprehensive integration tests for useAuthentication hook

## v1.2.7 (Aug 12, 2025) with ChatSDK v4.19.5

### Features

- Add citation component support for incoming messages
- Support attachment mode-based file upload button visibility

### Bug Fixes

- Add type details to replaceVariable error message

## v1.2.6 (Aug 12, 2025) with ChatSDK v4.19.5

### Features

- Add citation component support for incoming messages
- Support attachment mode-based file upload button visibility

### Bug Fixes

- Add type details to replaceVariable error message

## v1.2.5 (Aug 07, 2025) with ChatSDK v4.19.5

### Bug Fixes

- Added missing activeChannel in messenger session ref type

## v1.2.4 (Aug 07, 2025) with ChatSDK v4.19.5

### Features

- Added context to collection event handlers
- Added activeChannel to messenger session ref

## v1.2.3 (Aug 06, 2025) with ChatSDK v4.19.5

### Features

- Added deauthenticate method to messenger session ref
- Added support for file viewer in markdown images
- Added entryStyle prop to AgentProviderContainer for custom entry styling

## v1.2.2 (Jul 29, 2025) with ChatSDK v4.19.5

### Features

- Added bold styling to outgoing message text

### Bug Fixes

- Fixed issue with ESM file extension resolution and module paths
- Fixed scroll issue when typing indicator or resolution feedback message appears

## v1.2.1 (Jul 28, 2025) with ChatSDK v4.19.5

### Features

- Added support for HELPDESK_CSAT_5 type in customer satisfaction messages

### Bug Fixes

- Fixed scroll-to-bottom behavior for improved message list stability
- Fixed component re-mounting when context object changes

## v1.2.0 (Jul 23, 2025) with ChatSDK v4.19.5

### Features

- Added groupChannel data prop to ConversationListItem for enhanced channel information access
- Introduced onHandleTemplateInternalAction for improved message template interaction handling
- Implemented FixedMessenger.Style API to support dynamic position, margin, and size updates
- Added MessengerSessionRef API for programmatic context object updates
- Introduced createConversation method to MessengerSessionContext for programmatic conversation creation
- Added token refresh hook to automatically update user session on token renewal
- Added conversationListFilter prop to ConversationList for custom conversation filtering

### Bug Fixes

- Fixed conversation closure to target specific channels only instead of all conversations
- Improved createConversation error handling with better condition checks
- Applied patch for markdown renderer to resolve rendering issues
- Enhanced session handling with stricter validation

### Chores

- Updated Chat SDK and various dependencies

## v1.1.2 (Jul 16, 2025) with ChatSDK v4.19.2

### Features

- Enabled file upload during human agent handoff

### Bug Fixes

- Fixed bot typing indicator by adding isBotMessage flag

## v1.1.1 (Jul 02, 2025) with ChatSDK v4.19.2

### Features

- Added lineHeight support to Typography customization

### Bug Fixes

- Fixed wrong selected theme key issue
- Fixed tooltip not dismissing properly on mobile devices
- Applied dynamic border-radius based on computed line-height for suggested reply items

## v1.1.0 (Jun 24, 2025) with ChatSDK v4.19.2

- Added AIAgentThemeContext for better theme management (support palette and typography)
- Added ConversationListItemLayout for improved customization.
- Added ConversationLayout and ConversationListLayout for improved customization.
- Added customizable message bubble style to Incoming and Outgoing message layouts.

### Bug Fixes

- Updated global font specificity for better style inheritance

### Improvements

- Migrated color names for consistency across the codebase

## v1.0.1 (Jun 16, 2025) with ChatSDK v4.19.2

- Added user data cache and known channel URL support for improved performance
- Added file download functionality with onClickFile handler
- Added message template fetching context for dynamic message handling
- Added styled-components-minify plugin for optimized bundle size
- Added prompt cache support to agent attributes for faster responses

### Bug Fixes

- Fixed incoming file message rendering issues
- Fixed missing dispatcher injection in messenger
- Added length validation for tester message logs to prevent errors

### Improvements

- Added AI Agent conversation context for better conversation management
- Added AI Agent conversation list context for managing multiple conversations
- Added strict streaming order for conversation messages
- Updated Chat SDK to latest version with minimum version requirements
- Improved test coverage with unit tests for AgentProviderContainer
- Enhanced createContextInternal function for better context creation
- Optimized useConversationList initialization flow for better performance

## v1.0.0 (Jun 11, 2025) with ChatSDK v4.19.0

### Feature

#### Messenger Components

- **DefaultMessenger**: Main messenger component for standard chat interface
- **FixedMessenger**: Fixed position messenger component for embedded use cases
- **LauncherBase**: Base launcher component for triggering messenger UI

#### Message Components & Layouts

- **MessageLogs**: Component for displaying chat message history
- **IncomingMessageLayout**: Layout for incoming agent/user messages
- **OutgoingMessageLayout**: Layout for outgoing user messages
- **SystemMessageLayout**: Layout for system notifications and status messages
- Support for extended message payloads (function calls, groundedness info, actionbook info)
- **CSAT Integration**: Customer satisfaction rating system

#### React Hooks & Context

- **AgentProviderContainer**: Main provider for AI agent functionality
- **AgentUIProviderContainer**: UI-specific context provider
- **useAgentContext**: Hook for accessing agent state and methods
- **useAgentSessionContext**: Hook for managing agent sessions
- **useLocalizationContext**: Hook for internationalization support

#### Communication & Domain

- **messengerDispatcher**: Core communication dispatcher for agent interactions
- **Commands**: Command system for programmatic control
- **Conversation**: Individual conversation management
- **ConversationList**: Multiple conversation handling

---

### Documentation

- **📚 Public Documentation**: [https://github.com/sendbird/delight-ai-agent/blob/main/react/](https://github.com/sendbird/delight-ai-agent/blob/main/react/)
- **🚀 Live Example**: [https://ai-agent-messenger-sample.netlify.app/react](https://ai-agent-messenger-sample.netlify.app/react)

