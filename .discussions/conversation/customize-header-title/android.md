[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize Conversation Header Title

The following steps show how to replace only the **Conversation header title**, while keeping the rest of the UI/behavior intact.

**Step 1: Create a Custom Conversation Header Component**

Extend `ConversationHeaderComponent` and override only what you need.

```kotlin
class CustomConversationHeaderComponent(
    context: Context,
    currentTheme: MessengerTheme,
    currentThemeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle,
) : ConversationHeaderComponent(
    context,
    currentTheme,
    currentThemeMode,
    settings,
    args
)
```

**Step 2: Override notifyChannelUpdated to Change the Title**

Since the header is redrawn whenever the channel/status updates, override notifyChannelUpdated and replace the title after the default draw.

```kotlin
class CustomConversationHeaderComponent(
    context: Context,
    currentTheme: MessengerTheme,
    currentThemeMode: MessengerThemeMode,
    settings: MessengerSettings?,
    args: Bundle,
) : ConversationHeaderComponent(context, currentTheme, currentThemeMode, settings, args) {

    override fun notifyChannelUpdated(channel: GroupChannel?, settings: MessengerSettings?) {
        super.notifyChannelUpdated(channel, settings)
        // The header is redrawn whenever the channel is updated,
        // so overwrite the title after the default draw
        setTitle("Custom title")
    }
}
```
Why call setTitle inside notifyChannelUpdated?
Because the header is redrawn whenever the channel information (name, status, handoff, etc.) changes.
Overwriting the title after the default update ensures your custom title remains in place.

**Step 3: Register the Custom Component with the Provider**

When creating the ConversationModule, inject your custom component as headerComponent.

```kotlin
AIAgentModuleProviders.conversation = ConversationModuleProvider {
        context, currentTheme, currentThemeMode, settings, args ->
    ConversationModule(
        context = context,
        currentTheme = currentTheme,
        currentThemeMode = currentThemeMode,
        settings = settings,
        args = args,
        headerComponent = CustomConversationHeaderComponent(
            context,
            currentTheme,
            currentThemeMode,
            settings,
            args
        )
    )
}
```
Important: This registration must be done before calling MessengerLauncher.attach() or launching MessengerActivity.
The provider must be ready before the screen is created in order for the custom component to take effect.
