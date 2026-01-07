[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Steps to Customize Timeline Message Text Color

The following steps show how to change only the Timeline message text color, while keeping the rest of the UI/behavior intact.

**Step 1: Create a Custom Theme with Modified Timeline Style**

Extend the default theme and override only the timelineStyle.textAppearance.

```kotlin
class CustomLightTheme(val default: MessengerTheme) : MessengerTheme by default {
    override val conversation: ConversationTheme =
        object : ConversationTheme by default.conversation {

            override val messageList: MessageListTheme =
                object : MessageListTheme by default.conversation.messageList {

                    override val messageStyles: MessageStyles =
                        object : MessageStyles by default.conversation.messageList.messageStyles {

                            override val timelineStyle: TimelineMessageStyle =
                                object : TimelineMessageStyle by default.conversation.messageList.messageStyles.timelineStyle {
                                    override val textAppearance: TextAppearance
                                        get() = TextAppearance(
                                            FONT_STYLE_RES,   // e.g. R.style.Caption2OnLightMidEmphasis
                                            TEXT_COLOR_INT   // e.g. Color.RED
                                        )
                                }
                        }
                }
        }
}
```

•    FONT_STYLE_RES: the text style resource (e.g., R.style.Caption2OnLightMidEmphasis).
•    TEXT_COLOR_INT: the color integer (e.g., Color.RED).

**Step 2: Register the Custom Theme with AIAgentThemeProviders**

Assign your theme to the light provider:

```kotlin
AIAgentThemeProviders.light = ThemeProvider {
    CustomLightTheme(LightTheme())
}
```

Note: Dark Theme

To apply the same customization for dark mode, register with the dark provider:

```kotlin
AIAgentThemeProviders.dark = ThemeProvider {
    CustomLightTheme(DarkTheme())
}
```
Important: This registration must be done before calling MessengerLauncher.attach() or launching MessengerActivity.
The provider must be ready before the screen is created in order for the custom component to take effect.
