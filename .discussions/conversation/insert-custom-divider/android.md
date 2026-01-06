[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Steps to Insert a Divider into the Conversation Screen

**Step 1: Extend the ConversationModule**
Create a custom ConversationModule and override onCreateContentView() to build your own layout structure. In this layout, you can insert a View between listComponent and inputComponent.

```kotlin
class CustomConversationModule(
    context: Context,
    currentTheme: MessengerTheme,
    currentThemeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle,
) : ConversationModule(
    context,
    currentTheme,
    currentThemeMode,
    settings,
    args
) {
    override fun onCreateContentView(
        context: Context,
        inflater: LayoutInflater,
        args: Bundle?
    ): View {
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
                    0, 1f
                )
                addView(listComponent.onCreateView(context, inflater, this, args))
                addView(statusFrameComponent.onCreateView(context, inflater, this, args))
            })

            // Insert divider view here
            val divider = View(context).apply {
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    1 // 1dp height
                )
                setBackgroundColor(ContextCompat.getColor(context, R.color.gray)) // Use theme or custom color
            }
            addView(divider)
            if (!params.shouldHideInput) {
                addView(inputComponent.onCreateView(context, inflater, this, args))
            }
        }
    }
}
```

**Step 2: Register the Custom Module**
Tell the SDK to use your custom ConversationModule by registering it through the module provider

```kotlin
AIAgentModuleProviders.conversation =
    ConversationModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
        CustomConversationModule(context, currentTheme, currentThemeMode, settings, args)
    }
```
