[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Handle Link Taps
**Step 1: Create a Custom ConversationMessageListAdapter**

Extend ConversationMessageListAdapter and override the onMarkdownLinkClickListener to implement your own logic.

```kotlin
class CustomConversationListAdapter(
    channel: GroupChannel,
    messageListUIParams: ConversationMessageListUIParams,
    containerGenerator: MessageContainerGenerator
) : ConversationMessageListAdapter(channel, messageListUIParams, containerGenerator) {

    init {
        eventListeners.apply {
            onMarkdownLinkClickListener = object : OnMessageClickListener<String> {
                override fun onItemClick(view: View, data: String, type: MessageClickTarget) {
                    // Handle markdown link click
                    Log.v("Markdown", "Clicked link: $data, type: $type")
                    // You can handle custom schemes like tel:, mailto:, or in-app deep links here
                }
            }
        }
    }
}
```

**Step 2: Register the Custom Adapter with AIAgentAdapterProviders**

You must register your custom adapter before launching the messenger UI:

```kotlin
AIAgentAdapterProviders.conversation = ConversationAdapterProvider { channel, uiParams, containerGenerator ->
    CustomConversationListAdapter(channel, uiParams, containerGenerator)
}
```
