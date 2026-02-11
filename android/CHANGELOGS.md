# Changelog

## v1.7.0 (Feb 11, 2026) with Chat SDK `v4.33.0`

### Features

- Added conversation search functionality
    - Added `fun searchConversation(SearchConversationParams, ChannelUrlsHandler?)` in `AIAgentMessenger`
    - Added `SearchConversationParams` data class with `aiAgentId` and `context` properties
    - Added `ChannelUrlsHandler` interface for handling search results
    - Searches for conversations by exact context match (case-sensitive)
```kotlin
// Example: Search conversations by context
val params = SearchConversationParams(
    aiAgentId = "YOUR_AI_AGENT_ID",
    context = mapOf(
        "userId" to "user123",
        "department" to "support"
    )
)

AIAgentMessenger.searchConversation(params) { channelUrls, error ->
    if (error != null) {
        // Handle error
    } else {
        // Use matching channel URLs
        channelUrls?.forEach { url ->
            // Process each matching conversation
        }
    }
}
```

- Added conversation initialization control
    - Added `suspend fun awaitInitConversation(InitConversationParams)` in `ConversationRepository`

- Added channel refresh capability
    - Added `fun refreshChannel(CompletionHandler?)` in `ConversationRepository`
    - Allows manual refresh of channel data without full screen reload

### Deprecations

- Deprecated `fun refresh()` in `ConversationRepository`
    - Use `refreshChannel(CompletionHandler?)` instead for better async handling and error reporting
    - Migration example:
```kotlin
// Before (deprecated)
repository.refresh()

// After (recommended)
repository.refreshChannel { error ->
    if (error != null) {
        // Handle error
    } else {
        // Channel refreshed successfully
    }
}
```

---

## v1.6.0 (Feb 3, 2026) with Chat SDK `v4.32.0`

### Features

- Added support for custom message templates
    - Added `CustomMessageTemplateViewHandler` interface for creating custom template views
    - Added `CustomMessageTemplateViewCallback` interface for delivering created views to the SDK
    - Added `CustomMessageTemplateData` data class for representing custom template data
        - Contains `id`, `response` (with `status` and `content`), and `error` properties
    - Added `customMessageTemplateViewHandler` property in `ConversationMessageListUIParams`
    - Added `drawCustomMessageTemplate(ViewGroup, BaseMessage, ConversationMessageListUIParams)` method in `OtherMessageContainer`
```kotlin
// Example: Set custom message template handler
class MyCustomTemplateHandler : CustomMessageTemplateViewHandler {
    override fun onCreateCustomMessageTemplateView(
        context: Context,
        message: BaseMessage,
        data: List<CustomMessageTemplateData>,
        callback: CustomMessageTemplateViewCallback
    ) {
        val view = when (data.firstOrNull()?.id) {
            "product_card" -> createProductCard(context, data.first())
            else -> createFallbackView(context)
        }
        callback.onViewReady(view)
    }

    private fun createProductCard(context: Context, data: CustomMessageTemplateData): View {
        val content = data.response.content ?: return createFallbackView(context)
        return LayoutInflater.from(context).inflate(R.layout.custom_product_card, null).apply {
            // Populate view with data from JSON content
        }
    }

    private fun createFallbackView(context: Context): View {
        return TextView(context).apply {
            text = "Template not available"
            setPadding(16, 16, 16, 16)
        }
    }
}

// Register handler
AIAgentAdapterProviders.conversation =
    ConversationAdapterProvider { channel, uiParams, containerGenerator ->
        uiParams.customMessageTemplateViewHandler = MyCustomTemplateHandler()
        ConversationMessageListAdapter(
            channel,
            uiParams,
            containerGenerator
        )
    }
```

- Added new configuration options for conversation list settings
    - Added `shouldShowMessageFooterView` property in `ConversationConfig.List` - Controls visibility of "Start new conversation" view when conversation ends (default: `true`)
    - Added `enableNewMessageIndicator` property in `ConversationConfig.List` - Controls visibility of new message indicator (default: `true`)
    - Added `enableNewMessageIndicator` property in `MessageListComponent.Params`
```kotlin
// Example: Configure message footer and new message indicator
AIAgentMessenger.config.conversation.list.shouldShowMessageFooterView = false
AIAgentMessenger.config.conversation.list.enableNewMessageIndicator = false
```

- Added option selection required state for suggested replies
    - Added `fun notifyOptionSelectionRequired(Boolean)` in `MessageInputComponent`
    - Added `val optionSelectionRequired: Flow<Boolean>` in `ConversationViewModel`
    - Input is disabled when suggested replies require user selection before continuing

- Added always visible option for CSAT follow-up questions
    - Added `alwaysVisible` property in `FollowUp` data class - Controls whether follow-up question is always shown regardless of score (default: `false`)

### Improvements

- Improved image rendering in markdown messages
    - Implemented `MarkwonGlideImagePlugin` for better image loading and caching
    - Reduced image flickering when loading markdown content multiple times
    - Added LruCache for drawable caching in markdown image rendering

- Improved custom message template drawing logic
    - Enhanced view recycling to prevent unnecessary redraws
    - Added message ID tracking to optimize template view updates
    - Improved exception handling when creating custom template views

- Improved URI handling for file messages using `toUri()` extension function for better compatibility

### Bug Fixes

- Fixed permission dialog button color
    - Changed positive button text color from secondary to primary color

- Fixed enum values for `DisableState` to ensure proper state handling
    - Updated state flags: `MESSAGE_SENDING(0)`, `OPTION_SELECTION_REQUIRED(1)`, `BOT_SENDING(2)`, `CONVERSATION_CLOSED(3)`

---

## v1.5.1 (Dec 5, 2025) with Chat SDK `v4.32.0`
- Fixed an issue where events in Markdown syntax were not working properly.

---

## v1.5.0 (Dec 3, 2025) with Chat SDK `v4.32.0`

### Features

- Added scroll mode configuration for message list. The priority of values set in `MessageListComponent.Params` is higher than the priority of values set in `ConversationConfig.List`. If the two are configured differently, the values from `MessageListComponent.Params` will take precedence and be used.
    - Added `ScrollMode` enum with `AUTO` (default) and `FIX` options
        - `AUTO`: Normal scroll behavior without position adjustment (default)
        - `FIX`: Keeps the user message fixed at the top while the bot is responding
    - Added `scrollMode` property in `ConversationConfig.List`
    - Added `scrollMode` property in `MessageListComponent.Params`
```kotlin
// Example: Configure scroll mode
AIAgentMessenger.config.conversation.list.scrollMode = ScrollMode.FIX
```

- Added new message indicator UI
    - Added `NewMessageIndicatorStyle` interface for theme customization

### Improvements

- Updated string resource "Talk to agent" to "Start a conversation" for improved clarity

---

## v1.4.0 (Nov 18, 2025) with Chat SDK `v4.32.0`

### Features

- Added file attachment upload restrictions
    - Added `AttachmentRules` for controlling file upload limitations and handling
    - Added `MimeTypes` object for managing supported file types
    - Added input configuration to `ConversationConfig` for attachment settings
```kotlin
// Example: Configure attachment settings
AIAgentMessenger.config.conversation.input.camera.enablePhoto = true
AIAgentMessenger.config.conversation.input.enableFile = true
AIAgentMessenger.config.conversation.input.gallery.enablePhoto = true
```

### Improvements

- Improved attachment handling in message input component

- Updated Maven repository path
    - The Maven repository path in `settings.gradle` has been updated to reflect the new repository location.
    - **Note:** This update is optional. The previous Maven URL remains supported and fully compatible.
#### As-is
```groovy
dependencyResolutionManagement {
    repositories {
        maven { setUrl("https://repo.sendbird.com/public/maven") }
    }
}
```
#### To-be
```groovy
dependencyResolutionManagement {
    repositories {
        maven { setUrl("https://repo.delight.ai/public/maven") }
    }
}
```
---

## v1.3.0 (Nov 6, 2025) with Chat SDK `v4.32.0`

### Features

- Added the ability to send feedback on AI agent messages
    - Added `fun createMessageFeedback(params: AIAgentMessageFeedbackCreateParams, handler: AIAgentMessageFeedbackCreateHandler?)` in `ConversationViewModel`
    - Added `fun updateMessageFeedback(params: AIAgentMessageFeedbackUpdateParams, handler: AIAgentMessageFeedbackUpdateHandler?)` in `ConversationViewModel`
    - Added `fun deleteMessageFeedback(params: AIAgentMessageFeedbackDeleteParams, handler: AIAgentMessageFeedbackDeleteHandler?)` in `ConversationViewModel`
    - Added `suspend fun awaitCreateMessageFeedback(params: AIAgentMessageFeedbackCreateParams)` in `ConversationRepository`
    - Added `suspend fun awaitUpdateMessageFeedback(params: AIAgentMessageFeedbackUpdateParams)` in `ConversationRepository`
    - Added `suspend fun awaitDeleteMessageFeedback(params: AIAgentMessageFeedbackDeleteParams)` in `ConversationRepository`
    - Added `OnMessageFeedbackClickListener` interface for handling feedback clicks
    - Added `MessageFeedbackView` widget for displaying message feedback UI
    - Added `MessageFeedbackStyle` and `MessageFeedbackDialogStyle` for theme customization

### Improvements

- Improved CSAT to support optional Custom Response Elements (CRE)
    - Added `creOptionalLabelTextAppearance` property in theme styles
    - Added `csatOptionalLabelTextAppearance` property in theme styles

- Updated Sendbird Chat SDK to 4.32.0

---

## v1.2.2 (Nov 3, 2025) with Chat SDK `v4.31.1`

### Improvements

- Updated Sendbird Chat SDK to 4.31.1
    - Fixed a possible binary compatibility issue when using Chat SDK in multiple products

---

## v1.2.1 (Oct 30, 2025) with Chat SDK `v4.31.0`

### Improvements

- Enforced AppCompat theme for consistent UI across different app themes
    - Applied fixed `Theme.AppCompat.DayNight.NoActionBar` theme to `MessengerLauncher` using `ContextThemeWrapper`
    - Added explicit theme declarations in `AndroidManifest.xml` for `MessengerActivity` and `PhotoViewActivity`
    - Ensures consistent UI rendering regardless of host app's theme (Material3, Material2, or AppCompat)

- Updated CSAT string resources

- Optimized CSAT message update logic in `MessageDiffCallback`

---

## v1.2.0 (Oct 29, 2025) with Chat SDK `v4.31.0`

### Features

- Implemented failed message retry with better UX and disabled retry during AI response
    - Added `fun resendUserMessage(message: UserMessage, handler: UserMessageHandler?)` and `fun resendFileMessage(message: FileMessage, handler: FileMessageHandler?)` in `ConversationViewModel`
    - Added `fun resendUserMessage(message: UserMessage, handler: UserMessageHandler?)` and `fun resendFileMessage(message: FileMessage, handler: FileMessageHandler?)` in `ConversationRepository`

- Implemented support for closing conversation manually
    - Added `fun closeConversation(handler: CompletionHandler?)` in `ConversationViewModel`
    - Added `suspend fun awaitCloseConversation()` in `ConversationRepository`

- An interface has been added to `ConversationHeaderView` that allows you to add and remove a custom view
    - Added `fun addToRightSlot(view: View)`
    - Added `fun addToLeftSlot(view: View)`
    - Added `fun addToCenterSlot(view: View)`
    - Added `fun removeFromRightSlot(view: View)`
    - Added `fun removeFromLeftSlot(view: View)`
    - Added `fun removeFromCenterSlot(view: View)`
---

## v1.1.0 (Oct 2, 2025) with Chat SDK `v4.29.0`

### Features

- Custom CSAT support: Dashboard-driven CSAT UI customization with follow-up questions

---

## v1.0.0 (Sep 25, 2025) with Chat SDK `v4.29.0`

### Highlights

- **AI Agent Chat**: Engage in natural, context-aware conversations with an AI agent, including real-time messaging and conversation list.
- **Messenger Launcher Widget**: Easily add a floating launcher button to your app’s interface.
- **Full-Screen Messenger**: Instantly launch a full-screen chat with the AI agent via a dedicated activity.
- **Easy Integration**: Initialize and launch the AI agent messenger with just a few lines of code.
- **Customizable UI**: Configure launcher position, margin, and other appearance options.
- **Handoff & CSAT Support**: Future support for agent handoff and customer satisfaction surveys.

---

### Requirements
The minimum requirements for AI Agent for Android are the following.

- Android 5.0 (API level 21) or higher
- Java 11 or higher
- Android Gradle plugin 8.0.0 or higher
- Android ViewBinding enabled
- Sendbird Chat SDK 4.23.1 or higher
- Sendbird UIKit 3.22.1 or higher

---

### Features

**Delight AI Agent Messenger SDK has been officially released!**
This SDK enables you to seamlessly integrate an enterprise-grade AI-powered chat agent into your Android applications.

#### 1. Attaching the MessengerLauncher into the Screen
The SDK provides the MessengerLauncher view, which can be easily attached to your application’s root view programmatically without directly adding it to XML layouts.

> Since the SDK utilizes Fragments, make sure the context you pass to the MessengerLauncher is an instance of FragmentActivity. If you’re using standard Android components such as AppCompatActivity, there’s no need to worry, as it already inherits from FragmentActivity.
However, if you’re using a custom or legacy activity, verify that it inherits from FragmentActivity to avoid runtime issues.

To add the MessengerLauncher to your screen, simply call the `attach()` function of `MessengerLauncher`, specifying the AI agent ID and configuration parameters:

```kotlin
MessengerLauncher(context, "your_ai_agent_id").attach()
```

- `LauncherLayoutParams` allows you to configure the MessengerLauncher’s behavior and appearance:
    - **`launchMode`**:
        - `EXPANDED`: Opens the messenger in full-screen mode with predefined margins.
        - `ANCHORED`: Opens the messenger anchored near the launcher button, with adjustable positioning.

    - **`margin`**: Defines the margin around the launcher button itself (does not affect the messenger window).

    - **`location`**: Determines which corner of the screen the launcher will appear in. Available options are:
        - `TOP_START`
        - `TOP_END`
        - `BOTTOM_START`
        - `BOTTOM_END`

> Attach the launcher in your activity or view to create a floating entry point for AI chat.

---

#### 2. Launching the Full-Screen Messenger
You can open a full-screen conversation by starting an `Activity`.

```kotlin
startActivity(MessengerActivity.newIntentForConversation(context, "your_ai_agent_id"))
or
startActivity(MessengerActivity.newIntentForConversationList(context, "your_ai_agent_id"))
```
---
