# Multi-language support

This guide explains how to localize the user-facing UI strings in the **Delight AI agent SDK for Android**, enabling support for multiple languages in your application.

This guide explains:
- [Overview](#overview)
- [Supported languages](#supported-languages)
- [Default SDK Strings](#default-sdk-strings)
- [Adding Translations](#adding-translations)
    - [1. Open the Translations Editor](#1-open-the-translations-editor)
    - [2. Add a New Language](#2-add-a-new-language)
- [Overriding SDK Strings](#overriding-sdk-strings)

---

## Overview

The Delight AI agent SDK includes a predefined set of UI string resources — including button labels, error messages, input hints, and system messages.

To support internationalization, you can localize these strings using standard Android localization patterns with `strings.xml`.

---

## Supported languages

The SDK includes built-in localization support for the following languages:

* English (`en`)
* German (`de`)
* Spanish (`es`)
* French (`fr`)
* Hindi (`hi`)
* Italian (`it`)
* Japanese (`ja`)
* Korean (`ko`)
* Portuguese (`pt`)
* Turkish (`tr`)

If your target language is not listed above, you can add translations or override default strings.

---

## Default SDK Strings

The SDK uses a fixed set of string keys for all user-facing text such as system messages, error messages, and UI labels.

You can download or view the full list of default string keys here:\
📄 [**`aiagent_sdk_strings.xml`**](https://github.com/sendbird/sendbird-ai-agent/blob/main/android/res/strings.xml)

Use this file as a reference when adding or overriding translations.

---

## Adding Translations

To localize your app using Android Studio:

### 1. Open the Translations Editor

* Navigate to `res/values/strings.xml`.
* Right-click the file or click the 🌐 icon to open the **Translations Editor**.

### 2. Add a New Language

* In the Translations Editor, click the **Globe ➕ (Add Locale)** icon.
* Select the language (e.g., Russian `ru`, Japanese `ja`, etc.) and click **OK**.
* Android Studio will generate a corresponding directory, e.g., `res/values-ru/strings.xml`.

---

## Overriding SDK Strings

To customize the SDK’s UI text, override the string resource by defining a new value using the **same string key** in your app’s localized `strings.xml`.

```xml
<!-- res/values-ru/strings.xml -->
<string name="aa_text_dialog_permission_title">Разрешить доступ</string>
<string name="aa_text_go_to_settings">Настройки</string>
<string name="aa_text_need_to_allow_permission_camera">%s
нужен доступ к камере. Перейдите в настройки, чтобы разрешить доступ.</string>
<string name="aa_text_need_to_allow_permission_storage">%s
нужен доступ к памяти устройства. Перейдите в настройки, чтобы разрешить доступ.</string>
<string name="aa_text_need_to_allow_permission_record_audio">%s
нужен доступ к микрофону. Перейдите в настройки, чтобы разрешить доступ.</string>
...
```

The SDK will use your overridden strings in place of its internal defaults.

