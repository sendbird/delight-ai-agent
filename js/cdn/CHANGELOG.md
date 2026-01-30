# Changelog

## v1.14.0 (Jan 30, 2026) with ChatSDK ^4.21.0


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.14.0


## v1.13.2 (Jan 29, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.13.2


## v1.13.1 (Jan 20, 2026) with ChatSDK ^4.20.6


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.13.1


## v1.13.0 (Jan 13, 2026) with ChatSDK ^4.20.4


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.13.0


## v1.12.2 (Jan 09, 2026) with ChatSDK ^4.20.4


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.12.2


## v1.12.1 (Jan 05, 2026) with ChatSDK ^4.20.4


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.12.1


## v1.12.0 (Dec 24, 2025) with ChatSDK ^4.20.4


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.12.0


## v1.11.0 (Dec 22, 2025) with ChatSDK ^4.20.4


### Patch Changes

- Updated dependencies
  - @sendbird/ai-agent-messenger-react@1.11.0


## v1.10.2 (Dec 04, 2025) with ChatSDK ^4.20.3


### Features

- Add initialChannelUrl option to messenger for specifying initial channel
- Add ConversationChildren and ConversationListChildren props to FixedMessenger
- Introduce header layout for React messenger

### Improvements

- Optimize streaming text animation and throttle channel change handlers for better performance
- Update "Talk to agent" string to "Start a conversation"

### Bug Fixes

- Reset conversation context and state when channel URL changes
- Add defensive logic to special notice to prevent errors
- Add overscroll-behavior to prevent scroll chaining to parent page

### Dependencies

- Updated messenger-react to v1.10.2


## v1.9.5 (Nov 19, 2025) with ChatSDK ^4.20.1


### Improvements

- Add reconnecting state to input field for network disconnection feedback, showing "Trying to reconnect" instead of silently disabling input
- Add useConnectionState hook with SSR-safe initial state based on navigator.onLine
- Add localized reconnecting placeholder strings for all supported languages

### Bug Fixes

- Ensure fresh values by passing directly through context

### Dependencies

- Updated messenger-react to v1.9.5



## v1.9.4 (Nov 18, 2025) with ChatSDK ^4.20.1


### Bug Fixes

- Ensure ConversationScrollProvider always wraps ConversationContext to maintain backward compatibility and prevent context errors when upgrading to v1.9.0+

### Improvements

- Update branding from Sendbird to Delight across UI components and documentation
- Update bot icon to new Delight icon design
- Refresh color palette with updated basic colors
- Add ellipse fill color support for improved visual consistency

### Dependencies

- Updated messenger-react to v1.9.4


## v1.9.3 (Nov 18, 2025) with ChatSDK ^4.20.1


### Bug Fixes

- Fix stale closure in useAuthentication hook
- Fix stale context values in AIAgentProvider

### Improvements

- Buffer extendedMessagePayload until text streaming completes to prevent suggested replies and citations from appearing before message text finishes displaying
- Centralize streaming text logic in parent component to eliminate duplicate hook calls and improve performance

### Dependencies

- Updated messenger-react to v1.9.3


## v1.9.2 (Nov 13, 2025) with ChatSDK v4.20.1

### Bug Fixes

- Fix scroll positioning by adjusting top margin offset
- Fix channel fetch being attempted without authenticated user

## v1.9.0 (Nov 13, 2025) with ChatSDK v4.20.1

### Features

- Add progressive streaming text animation for AI responses
- Add message retry functionality for failed messages
- Add file attachment rules to control file upload limits and types
- Add fixed scroll mode for controlled message streaming behavior
- Make CSAT5 CRE field optional

### Bug Fixes

- Fix underscore characters in email addresses being incorrectly rendered as italic markdown formatting
- Fix scroll behavior conflicts during AI streaming
- Fix scroll-to-bottom button flashing during message send
- Fix scroll position interference when conversation closes
- Fix welcome message grouping when feedback is enabled

## v1.7.0 (Oct 30, 2025) with ChatSDK v4.20.1

### Features

- Add user feedback feature with feedback modal and sentiment icons
- Add closeConversation method to AIAgentConversationContext to enable closing conversations programmatically

### Bug Fixes

- Fix underscore characters in email addresses being incorrectly rendered as italic markdown formatting

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

- Add new channel list UI with conversation status and navigation improvements
- Add copilot conversation filters to AIAgentGroupChannelFilter
- Enable file upload for non-AI agent channels
- Add entryPoint prop to control initial messenger screen
- Add tester mode conversation details footer and copy link functionality
- Add close button to conversation list header
- Enable multiple active conversations and refactor exports
- Add support for multiple active conversations setting
- Replace Suspense with FallbackBoundary and add broken icon fallback for Icon component
- Add bold markdown support to SystemAdminMessage
- Sync localization strings and update conversation header titles

### Bug Fixes

- Add automatic navigation for proactive conversation join
- Fix input blocking to only apply after sending in AI agent channels
- Fix word-break styling issues
- Fix last message streaming issue
- Fix text overflow in MessageLogs labels and ConversationListItem
- Fix activeScreenId initialization error in Navigator component
- Fix launcher icon display logic for bot avatar
- Fix French localization string escaping
- Unify handoff status logic and update channel profile icons

## v1.4.0 (Sep 19, 2025) with ChatSDK v4.19.10

- Updated messenger-react to v1.4.0
- Add custom chat SDK injection support with validation
- Add ExtendedForm component with comprehensive form handling integration
- Implement FormElements component library with styled form controls
- Add form field validation constraints and optional label support
- Implement input blocking after user message sending
- Add user action required event handling for ADMM messages
- Disable form submission when conversation is handed off or closed
- Add typing indicator invalidation time configuration
- Add query params and conversation list limit support
- Add message feedback type to extendedMessagePayload
- Fix active channel updates on reconnected flow
- Fix userId validation and improve manual session handling
- Update chat SDK version

## v1.3.0 (Aug 28, 2025) with ChatSDK v4.19.5

- Updated messenger-react to v1.3.0
- Add custom event interface for bot message receive
- Add typing event support in message input  
- Pass isStreaming prop to incoming message component
- Add strict session check with class instances
- Fix connection handler ID to use unique handler

## v1.2.0 (Aug 12, 2025) with ChatSDK v4.19.5

- Updated messenger-react to v1.2.7
- Support setPosition to CDN build for positioning control
- Add update/get context object API to CDN

## v1.1.0 (Jul 16, 2025) with ChatSDK v4.19.2

- Updated messenger-react version to v1.1.2

## v1.0.4 (Jun 19, 2025) with ChatSDK v4.19.2

- Updated messenger-react version to v1.0.1

## v1.0.3 (May 23, 2025) with ChatSDK v4.16.1

- Added forceCreateChannel option to allow bypassing channel reuse
- Trigger initialization when authToken changes
- Added maxBodyWidth of 640px for expanded messenger view
- Added support for unknown message types in both incoming and outgoing messages
- Fixed the order of setSessionHandler to ensure correct initialization

## v1.0.2 (May 15, 2025) with ChatSDK v4.16.1

- Fixed a bug where the human agent message bubble was not displayed correctly

## v1.0.1 (May 14, 2025) with ChatSDK v4.16.1

- Fixed session management issues
- Improved stability

## v1.0.0 (May 07, 2025) with ChatSDK v4.16.1

- release v1.0.0

