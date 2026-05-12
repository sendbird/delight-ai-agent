[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.14.0-grey.svg?style=flat-square)]()

## Steps to Customize the Memory Confirmation Dialog Style

This guide explains how to replace the full `ConfirmationDialogStyle` used by User Memory dialogs.
The same `userMemoryDialogStyle` is used for both the initial memory consent dialog and the memory state dialog.

### Step 1: Create Drawable Resources for the Dialog

Create the drawable resources you want to use for the dialog container and buttons.
For example, use one drawable for the dialog background, one for the positive button, and one for the negative button.
The sample below shows the negative button drawable; create similar resources for `bg_memory_dialog_container` and `bg_memory_dialog_positive_button`, or replace those names with your own drawable resources.

```xml
<!-- res/drawable/bg_memory_dialog_negative_button.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <corners android:radius="100dp" />
    <solid android:color="@android:color/transparent" />
    <stroke
        android:width="1dp"
        android:color="@color/memory_dialog_button_color" />
</shape>
```

### Step 2: Create a Custom ConfirmationDialogStyle

Create a custom `ConfirmationDialogStyle` and override every property that controls the dialog surface, text, and buttons.

```kotlin
class CustomConfirmationDialogStyle(
    private val default: ConfirmationDialogStyle
) : ConfirmationDialogStyle by default {

    private val brandColor = Color.parseColor("#B5002D")
    private val titleColor = Color.parseColor("#161616")
    private val descriptionColor = Color.parseColor("#5C5C5C")

    override val background: Int =
        R.drawable.bg_memory_dialog_container

    override val backgroundTint: ColorRef =
        ColorRef(Color.WHITE)

    override val titleAppearance: TextAppearance =
        TextAppearance(default.titleAppearance.fontStyleRes, titleColor)

    override val descriptionAppearance: TextAppearance =
        TextAppearance(default.descriptionAppearance.fontStyleRes, descriptionColor)

    override val positiveButtonBackground: Int =
        R.drawable.bg_memory_dialog_positive_button

    override val positiveButtonBackgroundTint: ColorRef =
        ColorRef(brandColor)

    override val positiveButtonTextAppearance: TextAppearance =
        TextAppearance(default.positiveButtonTextAppearance.fontStyleRes, Color.WHITE)

    override val negativeButtonBackground: Int =
        R.drawable.bg_memory_dialog_negative_button

    override val negativeButtonBackgroundTint: ColorRef =
        ColorRef(Color.TRANSPARENT)

    override val negativeButtonTextAppearance: TextAppearance =
        TextAppearance(default.negativeButtonTextAppearance.fontStyleRes, brandColor)
}
```

### Step 3: Set the Custom Style on ConversationHeaderTheme

Override `ConversationHeaderTheme.userMemoryDialogStyle` and return your `CustomConfirmationDialogStyle`.

```kotlin
class CustomMemoryDialogTheme(
    private val default: MessengerTheme
) : MessengerTheme by default {

    override val conversation: ConversationTheme =
        object : ConversationTheme by default.conversation {

            override val header: ConversationHeaderTheme =
                object : ConversationHeaderTheme by default.conversation.header {

                    override val userMemoryDialogStyle: ConfirmationDialogStyle =
                        CustomConfirmationDialogStyle(
                            default.conversation.header.userMemoryDialogStyle
                        )
                }
        }
}
```

### Step 4: Register the Custom Theme

Register the custom theme before launching `MessengerActivity` or calling `MessengerLauncher.attach()`.

```kotlin
AIAgentThemeProviders.light = ThemeProvider {
    CustomMemoryDialogTheme(LightTheme())
}

AIAgentThemeProviders.dark = ThemeProvider {
    CustomMemoryDialogTheme(DarkTheme())
}
```

### Notes

- `userMemoryDialogStyle` is read from `ConversationHeaderTheme`.
- The memory consent dialog and memory state dialog currently share the same `userMemoryDialogStyle`.
- This means the custom `ConfirmationDialogStyle` is applied consistently across all User Memory dialogs.
