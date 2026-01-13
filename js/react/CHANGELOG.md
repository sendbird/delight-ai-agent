# Changelog

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

