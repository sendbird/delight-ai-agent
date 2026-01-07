[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## How to Customize the Left/Right Areas in the Conversation HeaderView
- This guide explains how to configure the use of the Left and Right buttons in the conversation header and how to change their icon resources.

You can modify the conversation header information through ConversationModuleProviders, and the properties changed here are applied to the View when onCreateView is executed after the module is created.
```kotlin
AIAgentModuleProviders.conversation = ConversationModuleProvider { context, currentTheme, currentThemeMode, settings, args ->
    ConversationModule(
        context = context,
        currentTheme = currentTheme,
        currentThemeMode = currentThemeMode,
        settings = settings,
        args = args,
    ).apply {
        // left icon button hide
        headerComponent.params.useLeftButton = false
        // right icon button hide
        headerComponent.params.useRightButton = false

        // set custom left button icon
        headerComponent.params.leftButtonResId = R.drawable.aa_icon_close

        // set custom right button icon
        headerComponent.params.rightButtonResId = R.drawable.aa_icon_close
    }
}
```
