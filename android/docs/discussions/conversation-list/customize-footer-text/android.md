[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Change the Footer Text

**Step 1: Override the Footer Text in the Module**

The easiest way to change the footer text is to override the module provider and apply your own string resource to footerComponent.params.textResId.

```kotlin
AIAgentModuleProviders.conversationList =
    ConversationListModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
        ConversationListModule(
            context,
            currentTheme,
            currentThemeMode,
            settings,
            args
        ).apply {
            footerComponent.params.textResId = R.string.sample_footer_text // Replace the footer text with a custom string resource
        }
    }
```
