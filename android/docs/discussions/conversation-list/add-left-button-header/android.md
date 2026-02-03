[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize the Header

**Step 1: Create a Custom View**

Create a view class (e.g., `CustomConversationListHeaderView`) that:

- Displays a title and a left button.
- Applies theme values via `applyTheme(...)`.
- Renders text via `draw(...)`.
- Provides an interface like `setLeftButtonClickListener(...)`.


**Step 2: Create a Custom Component**

Create a component class that extends `ConversationListHeaderComponent` (e.g., `CustomConversationListHeaderComponent`) and override `onCreateView(...)` to return your custom view.

```kotlin
class CustomConversationListHeaderComponent(
    context: Context,
    private val theme: MessengerTheme,
    private val themeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle
) : ConversationListHeaderComponent(
    context,
    theme,
    themeMode,
    settings,
    args
) {
    override fun onCreateView(context: Context, inflater: LayoutInflater, parent: ViewGroup, args: Bundle?): View {
        // return the custom header view here
        return CustomConversationListHeaderView(context).apply {
            applyTheme(theme.conversationList.header)
            draw(context.getString(params.titleResId))
            setLeftButtonClickListener {
                  // Handle click (e.g., pop backstack)
            }
        }
    }
}

```


**Step 2: Register the Component via AIAgentModuleProviders**

```kotlin
AIAgentModuleProviders.conversationList =
    ConversationListModuleProvider { context, theme, themeMode, settings, args ->
        ConversationListModule(
            context,
            theme,
            themeMode,
            settings,
            args,
            headerComponent = CustomConversationListHeaderComponent(
                context,
                theme,
                themeMode,
                settings,
                args
            )
        )
    }
```
