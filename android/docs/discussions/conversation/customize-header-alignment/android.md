[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize Conversation Header content Gravity

The following steps show how to change only the Conversation header's gravity (alignment) while keeping the rest of the UI/behavior intact. Unlike title customization, no subclass is required—just set the gravity on the provided component.

**Step 1: Register a ConversationModule with header gravity**

Call the provider and set the header gravity using setContentGravity(...).

```kotlin
AIAgentModuleProviders.conversation = ConversationModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
    ConversationModule(context, currentTheme, currentThemeMode, settings, args,
        headerComponent = ConversationHeaderComponent(
            context,
            currentTheme,
            currentThemeMode,
            settings,
            args
        ).apply {
            // Choose one: Gravity.START, Gravity.CENTER, or Gravity.END
            setContentGravity(Gravity.CENTER)
        }
    )
}
```
Important: This registration must be done before calling MessengerLauncher.attach() or launching MessengerActivity.
The provider must be ready before the screen is created in order for the custom component to take effect.
