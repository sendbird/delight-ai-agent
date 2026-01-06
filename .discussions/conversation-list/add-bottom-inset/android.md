[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Steps to Add Bottom Inset to ListView
**Step 1: Create a Custom ConversationListModule**
To apply a bottom margin to the ListView, extend ConversationListModule and override onCreateContentView.
Wrap the list inside a FrameLayout and apply bottom margin via LayoutParams.

```kotlin
class CustomConversationListModule(
    context: Context,
    currentTheme: MessengerTheme,
    currentThemeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle,
) : ConversationListModule(
    context,
    currentTheme,
    currentThemeMode,
    settings,
    args
) {
    override fun onCreateContentView(context: Context, inflater: LayoutInflater, args: Bundle?): View {
        return LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
            if (params.isUsingHeader) {
                addView(headerComponent.onCreateView(context, inflater, this, args))
            }
            addView(FrameLayout(context).apply {
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    0,
                    1f
                ).apply {
                    setMargins(0, 0, 0, 20) // <-- Apply bottom inset here
                }
                addView(listComponent.onCreateView(context, inflater, this, args))
                addView(statusFrameComponent.onCreateView(context, inflater, this, args))
            })
            addView(footerComponent.onCreateView(context, inflater, this, args))
        }
    }
}
```

**Step 2: Register the Custom Module in AIAgentModuleProviders**
You must register the custom module before launching the messenger.
```kotlin
object CustomAIAgentProvider {
    fun register() {
        AIAgentModuleProviders.conversationList = ConversationListModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
            CustomConversationListModule(
                context,
                currentTheme,
                currentThemeMode,
                settings,
                args
            )
        }
    }
}
```
