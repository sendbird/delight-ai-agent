[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize the Footer Area Background Color


**Step 1: Create a Custom Theme with Modified ConversationListFooterTheme Style**

Extend the default theme and override only the footer.backgroundColor.

```kotlin
class CustomLightTheme(val default: MessengerTheme) : MessengerTheme by default {
    override val conversationList: ConversationListTheme =
        object : ConversationListTheme by default.conversationList {
            override val footer: ConversationListFooterTheme
                get() = object : ConversationListFooterTheme {
                    override val backgroundColor: ColorRef
                        get() = ColorRef(COLOR_INT)
                    override val textAppearance: TextAppearance
                        get() = TextAppearance(FONT_STYLE_RES, TEXT_COLOR_INT)
                }
        }
}
```

**Step 2: Register the custom theme**

Make sure to register your `MessengerTheme` using `AIAgentThemeProviders`.

```kotlin
AIAgentThemeProviders.light = ThemeProvider {
    CustomLightTheme(LightTheme())
}
```
