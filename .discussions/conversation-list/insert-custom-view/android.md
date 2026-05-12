[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to insert a custom view into the Conversation List screen

**Step 1: Create a Custom ViewComponent**
Define a reusable ViewComponent that represents the custom content (in this case, an empty transparent view).

```kotlin
class CustomConversationListEmptyComponent : ViewComponent {
    override fun onCreateView(
        context: Context,
        inflater: LayoutInflater,
        parent: ViewGroup,
        args: Bundle?
    ): View {
        return View(context).apply {
            id = View.generateViewId()
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                100  // 100px height
            )
            setBackgroundResource(android.R.color.transparent) // Transparent background
        }
    }
}
```

**Step 2: Override the ConversationListModule to Insert the View**
Extend ConversationListModule and override onCreateContentView() to control how the conversation screen layout is composed.

```kotlin
class CustomConversationListModule(
    context: Context,
    currentTheme: MessengerTheme,
    currentThemeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle,
) : ConversationListModule(context, currentTheme, currentThemeMode, settings, args) {

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

            addView(headerComponent.onCreateView(context, inflater, this, args))

            // Insert custom empty view here
            addView(CustomConversationListEmptyComponent().onCreateView(context, inflater, this, args))

            addView(FrameLayout(context).apply {
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    0, 1f
                )
                addView(listComponent.onCreateView(context, inflater, this, args))
                addView(statusFrameComponent.onCreateView(context, inflater, this, args))
            })

            addView(footerComponent.onCreateView(context, inflater, this, args))
        }
    }
}
```

**Step 3: Register the Custom Module**
Finally, register your custom module so it will be used when launching the conversation list.

```kotlin
AIAgentModuleProviders.conversationList =
    ConversationListModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
        CustomConversationListModule(context, currentTheme, currentThemeMode, settings, args)
    }
```
