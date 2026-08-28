[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.8.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## How to customize the Suggested Replies UI in the conversation message

By default, the SDK renders suggested replies as **right-aligned rounded chips outlined with the primary color**. You can replace them with your own layout by subclassing `OtherMessageContainer` and overriding only `drawSuggestedReplies(...)`, then registering a custom `MessageContainerGenerator`.

The example below renders suggested replies as **full-width, left-aligned "menu rows" with a trailing chevron**. Everything else (profile, nickname, timestamp, template, feedback) keeps the default behavior inherited from `OtherMessageContainer`.

**Step 1: Subclass `OtherMessageContainer` and override `drawSuggestedReplies`**

`OtherMessageContainer` is `open` and so is `drawSuggestedReplies`, so you can override just the suggested replies rendering.

The parent keeps `onSuggestedRepliesClickListener` in a `private` field, so capture your own reference from `eventListeners` inside `initialize(...)` to forward clicks. The SDK hands you a `SuggestedRepliesView` (a `FrameLayout`); you can reuse it as a plain container by clearing its default content and adding your own views.

```kotlin
class CustomOtherMessageContainer(context: Context) : OtherMessageContainer(context) {

    // The parent keeps onSuggestedRepliesClickListener private, so capture our own
    // reference here in order to forward clicks from the custom rows.
    private var suggestedRepliesClickListener: OnMessageClickListener<String>? = null

    override fun initialize(
        contentView: View,
        eventListeners: MessageEventListeners,
        messageListUIParams: ConversationMessageListUIParams,
        messageType: MessageType
    ) {
        super.initialize(contentView, eventListeners, messageListUIParams, messageType)
        suggestedRepliesClickListener = eventListeners.onSuggestedRepliesClickListener
    }

    override fun drawSuggestedReplies(
        suggestedRepliesView: SuggestedRepliesView,
        message: BaseMessage,
        messageListUIParams: ConversationMessageListUIParams
    ) {
        // Let the parent apply its visibility rules first: it hides the view when the
        // list is empty or while the message is still playing its streaming animation.
        super.drawSuggestedReplies(suggestedRepliesView, message, messageListUIParams)
        if (suggestedRepliesView.visibility != VISIBLE) return

        val replies = message.suggestedReplies
        val context = suggestedRepliesView.context
        // Reuse the SDK-provided host view as a plain container: drop its default
        // RecyclerView content and render our own rows instead.
        suggestedRepliesView.removeAllViews()

        val list = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(context, 12)
                marginEnd = dp(context, 12)
            }
            setPaddingRelative(dp(context, 12), 0, dp(context, 12), dp(context, 12))
        }

        replies.forEachIndexed { index, reply ->
            val row = createReplyRow(context, reply).apply {
                setOnClickListener { view ->
                    suggestedRepliesView.visibility = GONE
                    suggestedRepliesClickListener?.onItemClickWithPosition(
                        view,
                        reply,
                        index,
                        MessageClickTarget.SUGGESTED_REPLIES
                    )
                }
            }
            (row.layoutParams as LinearLayout.LayoutParams).topMargin =
                if (index == 0) 0 else dp(context, 8)
            list.addView(row)
        }

        suggestedRepliesView.addView(list)
    }

    private fun createReplyRow(context: Context, reply: String): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            background = createRowBackground(context)
            val padH = dp(context, 20)
            val padV = dp(context, 16)
            setPaddingRelative(padH, padV, padH, padV)
            isClickable = true
            isFocusable = true
            contentDescription = reply
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        val label = TextView(context).apply {
            text = reply
            setTextColor(TEXT_COLOR)
            textSize = 15f
            layoutParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f)
        }

        val chevron = ImageView(context).apply {
            setImageResource(R.drawable.sample_ic_chevron_right)
            layoutParams = LinearLayout.LayoutParams(
                dp(context, 20),
                dp(context, 20)
            ).apply { marginStart = dp(context, 8) }
        }

        row.addView(label)
        row.addView(chevron)
        return row
    }

    private fun createRowBackground(context: Context): Drawable {
        val radius = dp(context, 16).toFloat()
        val content = GradientDrawable().apply {
            cornerRadius = radius
            setColor(ROW_BACKGROUND_COLOR)
        }
        val mask = GradientDrawable().apply {
            cornerRadius = radius
            setColor(Color.WHITE)
        }
        return RippleDrawable(ColorStateList.valueOf(RIPPLE_COLOR), content, mask)
    }

    private fun dp(context: Context, value: Int): Int =
        (value * context.resources.displayMetrics.density).toInt()

    private companion object {
        const val ROW_BACKGROUND_COLOR = 0xFFF2F3F5.toInt()
        const val TEXT_COLOR = 0xFF1F1F1F.toInt()
        const val RIPPLE_COLOR = 0x33000000
    }
}
```

The chevron above uses a small vector drawable. Add it to your app resources (e.g. `res/drawable/sample_ic_chevron_right.xml`):

```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="20dp"
    android:height="20dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#8A8A8E"
        android:pathData="M8.59,16.59L13.17,12 8.59,7.41 10,6l6,6 -6,6z" />
</vector>
```

**Step 2: Provide a custom `MessageContainerGenerator`**

Extend `DefaultMessageContainerGenerator` and return your container for the `LEFT` (bot) side only, keeping the defaults for `RIGHT` (my) and `PLAIN`.

```kotlin
class CustomMessageContainerGenerator : DefaultMessageContainerGenerator() {
    override fun generate(context: Context, containerType: MessageContainerType): MessageContainerContract {
        return when (containerType) {
            MessageContainerType.LEFT -> CustomOtherMessageContainer(context)
            else -> super.generate(context, containerType)
        }
    }
}
```

**Step 3: Register the generator with `AIAgentAdapterProviders.conversation`**

Provide the conversation adapter yourself and pass your custom generator into `ConversationMessageListAdapter`. (The third parameter is the default generator supplied by the SDK; ignore it and pass your own.)

```kotlin
AIAgentAdapterProviders.conversation =
    ConversationAdapterProvider { channel, uiParams, _ ->
        ConversationMessageListAdapter(channel, uiParams, CustomMessageContainerGenerator())
    }
```

Important: This registration must be done before calling `MessengerLauncher.attach()` or launching `MessengerActivity`.
The provider must be ready before the screen is created in order for the custom container to take effect.

**Notes:**
- The click is forwarded through `onSuggestedRepliesClickListener` exactly like the default, so tapping a reply hides the list and sends the reply.
- Tune the look by editing the `companion object` colors and the paddings/corner radius/text size in `createReplyRow` / `createRowBackground`.
- The example uses fixed colors. If you support dark mode, derive the row background/text from the theme (for example `messageListUIParams.messageListTheme.backgroundColor.color` and `messageListUIParams.aiAgentTheme.primaryColor`) instead of hardcoded values.
- Calling `super.drawSuggestedReplies(...)` first keeps the SDK's visibility rules: the replies stay hidden while the message is still playing its streaming animation and appear only once it finishes.
