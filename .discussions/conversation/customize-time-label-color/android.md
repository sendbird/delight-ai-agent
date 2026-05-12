[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize "Sent At" Text Appearance in Other User Messages

The following steps show how to change only the sent-at (timestamp) text appearance of other users' messages, while keeping the rest of the UI/behavior intact.

**Step 1: Create a Custom Theme with Modified OtherUserMessageStyle**

Extend the default MessengerTheme and override only sentAtAppearance inside OtherUserMessageStyle.

```kotlin
class CustomLightTheme(val default: MessengerTheme) : MessengerTheme by default {
    override val conversation: ConversationTheme =
        object : ConversationTheme by default.conversation {

            override val messageList: MessageListTheme =
                object : MessageListTheme by default.conversation.messageList {

                    override val messageStyles: MessageStyles =
                        object : MessageStyles by default.conversation.messageList.messageStyles {

                            // Text message style
                            override val otherUserMessageStyle: OtherUserMessageStyle =
                                object : OtherUserMessageStyle by default.conversation.messageList.messageStyles.otherUserMessageStyle {
                                    override val sentAtAppearance: TextAppearance
                                        get() = TextAppearance(FONT_STYLE_RES, COLOR_INT)
                                }

                            // File message style
                            override val otherFileMessageStyle: OtherFileMessageStyle =
                                object : OtherFileMessageStyle by default.conversation.messageList.messageStyles.otherFileMessageStyle {
                                    override val sentAtAppearance: TextAppearance
                                        get() = TextAppearance(FONT_STYLE_RES, COLOR_INT)
                                }

                            // Image message style
                            override val otherImageMessageStyle: OtherImageMessageStyle =
                                object : OtherImageMessageStyle by default.conversation.messageList.messageStyles.otherImageMessageStyle {
                                    override val sentAtAppearance: TextAppearance
                                        get() = TextAppearance(FONT_STYLE_RES, COLOR_INT)
                                }

                            // Unknown message style
                            override val otherUnknownMessageStyle: OtherUnknownMessageStyle =
                                object : OtherUnknownMessageStyle by default.conversation.messageList.messageStyles.otherUnknownMessageStyle {
                                    override val sentAtAppearance: TextAppearance
                                        get() = TextAppearance(FONT_STYLE_RES, COLOR_INT)
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
