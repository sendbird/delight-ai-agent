[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

##  Steps to Customize the Launcher Layout

**Step 1: Set Up `LauncherLayoutParams`**

You can define the following parameters:

| Parameter      | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `launchMode`   | Display mode: `EXPANDED` (full screen) or `ANCHORED` (popup near launcher) |
| `margin`       | Margins around the launcher (start, top, end, bottom)                     |
| `location`     | Position on screen: `TOP_START`, `TOP_END`, `BOTTOM_START`, `BOTTOM_END`   |

**Step 2: Example (Kotlin)**

```kotlin
val layoutParams = LauncherLayoutParams(
    LaunchMode.ANCHORED,
    LauncherMargin(start = 12, top = 12, end = 12, bottom = 12),
    LauncherLocation.BOTTOM_END
)

val launcherSettings = LauncherSettingsParams(
    layoutParams = layoutParams
)

// Pass this into your MessengerLauncher or relevant configuration
```
