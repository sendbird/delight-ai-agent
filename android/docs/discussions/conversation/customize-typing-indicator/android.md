[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize the Typing Indicator

**Step 1: Create a custom view that represents the typing indicator**

You should create a view (`CustomTyingIndicator`) that visually represents the typing state.
This view will be used in your custom `ViewHolder`.

```kotlin
val customTypingView = CustomTyingIndicator(context)
```

**Step 2: Create a `ViewHolder` that wraps the custom view**

Extend `MessageViewHolder` and bind your custom view for the typing indicator.

```kotlin
class CustomTypingIndicatorViewHolder(
    layout: View,
    messageListUIParams: ConversationMessageListUIParams
) : MessageViewHolder(layout, messageListUIParams) {
    override fun bind(channel: GroupChannel, message: BaseMessage, messageUIParams: MessageUIParams) {
        // Optional: implement custom binding logic if needed
    }
}
```

**Step 3: Extend `ConversationMessageListAdapter` and return your custom `ViewHolder`**

Override `onCreateViewHolder` to detect `VIEW_TYPE_TYPING_INDICATOR` and return the custom `ViewHolder`.

```kotlin
class CustomConversationAdapter(
    channel: GroupChannel,
    private val messageListUIParams: ConversationMessageListUIParams,
    containerGenerator: MessageContainerGenerator
) : ConversationMessageListAdapter(channel, messageListUIParams, containerGenerator) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MessageViewHolder {
        if (viewType == MessageType.VIEW_TYPE_TYPING_INDICATOR.value) {
            return CustomTypingIndicatorViewHolder(
                CustomTyingIndicator(parent.context),
                messageListUIParams
            )
        }
        return super.onCreateViewHolder(parent, viewType)
    }
}
```

**Step 4: Register your custom adapter using `AIAgentAdapterProviders`**

Finally, inject the adapter into your AI Agent configuration:

```kotlin
AIAgentAdapterProviders.conversation =
    ConversationAdapterProvider { channel, uiParams, containerGenerator ->
        CustomConversationAdapter(channel, uiParams, containerGenerator)
    }
```
