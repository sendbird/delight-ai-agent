[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Steps to Customize the Input Area Background Color

**Step 1: Define your custom `InputTheme`**

Override the `backgroundColor` or any other related style in your custom implementation.

```kotlin
class CustomInputBoxTheme : InputBoxTheme {
    override val backgroundColor: ColorRef = ColorRef(COLOR_INT)
    // You can also override inputTextAppearance, inputTextHintColor, etc.
}
```

**Step 2: Create a custom `MessengerTheme`**

Extend the default `LightTheme` and override the `input` theme inside the `ConversationTheme`.

```kotlin
class CustomLightTheme : MessengerTheme {
    override val conversation: ConversationTheme = LightTheme.ConversationThemeImpl(
            input = CustomInputBoxTheme()
        )
    override val conversationList: ConversationListTheme = LightTheme.ConversationListThemeImpl()
}
```

**Step 3: Register the custom theme**

Make sure to register your `MessengerTheme` using `AIAgentThemeProviders`.

```kotlin
AIAgentThemeProviders.light = ThemeProvider {
    CustomLightTheme()
}
```
