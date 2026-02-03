# Multi-language support

This guide walks you through adding a `Localizable.strings` file to your Xcode project and configuring it to support multiple languages.

***

## 1. Add `Localizable.strings` File

1. In the **Project Navigator**, right-click on your target group or folder.
2. Select **New File from Template…**
3. Choose **Strings File(Legacy)** under the **Resource** section.
4. Name the file exactly: `Localizable.strings`
5. Click **Create**

> Note: Do this process when you don't have a `Localizable.strings` file.

***

## 2. Enable Localization

1. In the **Project Navigator**, click on your project (blue icon) to open the project editor.
2. Select the **Project** (not the target) in the left sidebar of the project editor.
3. Open the **Info** tab at the top.
4. Scroll down to the **Localizations** section.
5. Click the **+** button to add a new language (e.g., **Korean**).
6. A dialog will appear asking which files to localize — make sure to select `Localizable.strings`.
7. Xcode will generate a separate `Localizable.strings` file for the newly added language.

> This step ensures your app is properly configured to support multiple languages and allows Xcode to manage localized resources.

***

## 3. Add Translations

Edit the `Localizable.strings` files per language:

### `Localizable.strings` (English)

```swift
"SBA_Common_cancel" = "Cancel";
"SBA_Common_retry" = "Retry";
...
```

Refer to the [English-based `Localizable.string` file](https://github.com/sendbird/delight-ai-docs/blob/katherine/guide/donna/sdk-docs/ios/en.lproj/Localizable.strings) to set the language-specific strings to use for the keys you need.

> If you set the key-value of `Localizable.string` for each language you need, it will use the internally customized string first.

## Tips

### Test Different Languages in Simulator

1. Run your app in the **iOS Simulator**
2. Open **Settings > General > Language & Region**
3. Change the language to your desired option (e.g., Bangla)
4. Relaunch your app — localized strings should appear accordingly

***
