# Multi-language support

This guide explains how to localize the UI strings used in the **Delight AI agent SDK for JavaScript** to support multiple languages in your web application.

This guide explains:
- [Overview](#overview)
    - [Supported languages](#supported-languages)
- [Setting the language](#setting-the-language)
- [Customizing strings](#customizing-strings)
    - [Scenario 1: Customizing strings in supported languages](#scenario-1-customizing-strings-in-supported-languages)
- [Default SDK strings](#default-sdk-strings)
- [Implementation examples](#implementation-examples)
    - [Best practice for initializing with custom strings:](#best-practice-for-initializing-with-custom-strings)
    - [Switching between languages at runtime:](#switching-between-languages-at-runtime)
    - [Dynamically loading language files:](#dynamically-loading-language-files)

---

## Overview

The Delight AI agent SDK includes a predefined set of UI string resources — including button labels, error messages, input hints, and system messages.

To support internationalization, you can set the language preference during initialization or update it later using the `updateConfig` method.

### Supported languages

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

If your target language is not listed above, you can customize the SDK strings by providing a complete set of string values.

---

## Setting the language

You can set the language during SDK initialization:

```javascript
// Setting language during initialization with messenger.initialize affects
// both the UI text display AND the AI Agent's responses
// The AI Agent will attempt to respond in the specified language.
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',

  // Set language in IETF BCP 47 format (e.g., "ko-KR", "en-US")
  // Default is navigator.language if not specified
  language: 'ko-KR',

  // Set country code in ISO 3166 format (e.g., "KR", "US")
  countryCode: 'KR',
});
```

Or update it later with the `updateConfig` method:

```javascript
// Changing language after initialization with messenger.updateConfig only affects the UI text
// elements and does NOT change the language of AI Agent responses.
messenger.updateConfig({
  language: 'es-ES',
});
```

---

## Customizing strings

There are two scenarios where you might want to customize the strings used in the messenger UI:

### Scenario 1: Customizing strings in supported languages

You can override specific UI strings in a language that Delight AI agent SDK already supports. This is useful when you want to change particular messages or labels to better match your application's terminology or tone.

```javascript
// Example: Customize specific strings in Spanish
const customLanguageConfig = {
  language: 'es-ES',
  stringSet: {
    // Override only specific keys
    MESSAGE_INPUT__PLACE_HOLDER: '¡Pregúntame cualquier cosa!', // original: 'Hacer una pregunta'
    CONVERSATION_LIST__HEADER_TITLE: 'Lista de conversaciones anteriores' // original: 'Historial de conversaciones'
  }
};

// Apply during initialization
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  ...customLanguageConfig
});

// Or update at runtime (affects UI only)
messenger.updateConfig({
  ...customLanguageConfig
});
```

{% hint style="info" %}
**Note**: When updating at runtime with `updateConfig`, only the UI strings will be changed. The AI Agent's language preference will not be affected.
{% endhint %}

#### Scenario 2: Adding support for unsupported languages

For languages not supported by Delight AI agent SDK, you must provide a complete set of string values for all UI elements.

Refer to the [Default SDK strings](#default-sdk-strings) section below for the full list of required string keys.

```javascript
// Example: Add support for Chinese (zh-CN)
messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  language: 'zh-CN',
  // Must provide all stringSet keys for unsupported languages
  stringSet: {
    // Channel - Common
    CHANNEL_FROZEN: '频道已冻结',
    PLACE_HOLDER__WRONG: '出现问题',
    PLACE_HOLDER__NO_MESSAGES: '没有消息',
    UNKNOWN__UNKNOWN_MESSAGE_TYPE: '(未知消息类型)',

    // Channel - Header
    HEADER_BUTTON__AGENT_HANDOFF: '连接客服',

    // Message Input
    MESSAGE_INPUT__PLACE_HOLDER: '请输入问题',
    MESSAGE_INPUT__PLACE_HOLDER__WAIT_AI_AGENT_RESPONSE: '等待回复中...',
    MESSAGE_INPUT__PLACE_HOLDER__DISABLED: '此频道不可用',

    // Common UI
    BUTTON__CANCEL: '取消',
    BUTTON__SAVE: '保存',
    BUTTON__OK: '确定',
    NO_NAME: '(无名)',
    RETRY: '重试',

    // ... and all other required strings
  }
});
```

---

## Default SDK strings

Below is a list of the key string identifiers used in the SDK. You'll need to provide translations for all of these keys when adding support for a new language:

```javascript
// Channel - Common
CHANNEL_FROZEN: 'Channel frozen',
PLACE_HOLDER__WRONG: 'Something went wrong',
PLACE_HOLDER__NO_MESSAGES: 'No messages',
UNKNOWN__UNKNOWN_MESSAGE_TYPE: '(Unknown message type)',

// Channel - Header
HEADER_BUTTON__AGENT_HANDOFF: 'Connect with an agent',

// Message Input
MESSAGE_INPUT__PLACE_HOLDER: 'Ask a question',
MESSAGE_INPUT__PLACE_HOLDER__WAIT_AI_AGENT_RESPONSE: 'Waiting for the agent's reply…',
MESSAGE_INPUT__PLACE_HOLDER__DISABLED: 'Chat is unavailable in this channel',

// Common UI
BUTTON__CANCEL: 'Cancel',
BUTTON__SAVE: 'Save',
BUTTON__OK: 'OK',
NO_NAME: '(No name)',
RETRY: 'Retry',

// Date format
DATE_FORMAT__MESSAGE_LIST__DATE_SEPARATOR: 'MMMM dd, yyyy',
DATE_FORMAT__MESSAGE_TIMESTAMP: 'p',

// File Upload
FILE_UPLOAD_NOTIFICATION__COUNT_LIMIT: "You can't upload more than one image",
FILE_UPLOAD_NOTIFICATION__SIZE_LIMIT: 'The maximum size per file is %d MB.',

// File Viewer
FILE_VIEWER__UNSUPPORT: 'Unsupported message',

// CSAT
CSAT_TITLE_UNSUBMITTED: 'Your feedback matters to us',
CSAT_TITLE_SUBMITTED: 'Successfully submitted!',
CSAT_CRE_TITLE: 'Was your issue resolved?',
CSAT_CRE_SOLVED: 'Yes, thank you! 👍',
CSAT_CRE_NOT_SOLVED: 'No, that didn't help.',
CSAT_REASON_PLACEHOLDER: 'Share your feedback',
CSAT_RATING_TITLE: 'How would you rate your experience?',
CSAT5_RATING_SCORE_1: 'Terrible',
CSAT5_RATING_SCORE_2: 'Bad',
CSAT5_RATING_SCORE_3: 'Okay',
CSAT5_RATING_SCORE_4: 'Good',
CSAT5_RATING_SCORE_5: 'Great',
CSAT_SUBMIT_LABEL: 'Submit',
CSAT_SUBMISSION_EXPIRED: 'We're sorry, the survey period has ended.',

POWERED_BY: 'Powered by',

// Conversation list
CONVERSATION_CLOSED_FOOTER_LABEL: 'Your conversation has ended',
START_NEW_CONVERSATION: '💬 Start a new conversation',
RETURN_TO_CONVERSATION: '💬 Return to conversation',
CONVERSATION_LIST__HEADER_TITLE: 'Conversation history',
CONVERSATION_LIST__TOPICS_FALLBACK: 'No category',
CONVERSATION_LIST__NO_CONVERSATIONS: 'No conversations yet',
DATE_FORMAT__CONVERSATION_LIST__LIST_ITEM_TITLE: 'MM/dd/yyyy',
DATE_FORMAT__CONVERSATION_LIST__LIST_ITEM_TITLE_CAPTION: 'h:mma',
```

---

## Implementation examples

### Best practice for initializing with custom strings:

For better code organization, you can define your string sets in separate files:

```javascript
// cn.ts - Chinese localization strings
export const cnStringSet = {
  // Channel - Common
  CHANNEL_FROZEN: '频道已冻结',
  // ... all other strings
};

// Then import and use in your initialization
import { cnStringSet } from './languages/cn.ts';

messenger.initialize({
  appId: 'YOUR_APP_ID',
  aiAgentId: 'YOUR_AI_AGENT_ID',
  language: 'zh-CN',
  stringSet: cnStringSet
});
```

### Switching between languages at runtime:

You can easily switch between different languages at runtime, allowing users to change the interface language without refreshing the page:

```javascript
// Switch to Chinese
const switchToChinese = () => {
  messenger.updateConfig({
    language: 'zh-CN',
    stringSet: cnStringSet // Import from your Chinese translations file
  });
};

// Switch back to Spanish
const switchToSpanish = () => {
  messenger.updateConfig({
    language: 'es-ES',
    stringSet: {
      MESSAGE_INPUT__PLACE_HOLDER: '¡Pregúntame cualquier cosa!',
      CONVERSATION_LIST__HEADER_TITLE: 'Lista de conversaciones anteriores'
    }
  });
};

// Add buttons to let users switch languages
<div>
  <button onClick={switchToChinese}>Switch to Chinese</button>
  <button onClick={switchToSpanish}>Switch back to Spanish</button>
</div>
```

### Dynamically loading language files:

For better performance, we recommend dynamically loading only the language string set files that your users actually need. This approach reduces the initial bundle size and improves load times:

```javascript
// Function to dynamically load language files
async function loadLanguageStrings(language) {
  let stringSet;

  // Only load the needed language file
  switch (language) {
    case 'zh-CN':
      // Dynamic import - only loads when needed
      const chineseModule = await import('./languages/cn.ts');
      stringSet = chineseModule.stringSet;
      break;
    case 'tr-TR':
      const turkishModule = await import('./languages/tr.ts');
      stringSet = turkishModule.stringSet;
      break;
    // Add other languages as needed
    default:
      // No stringSet needed for built-in languages
      stringSet = undefined;
  }

  // Update the messenger configuration with the loaded strings
  messenger.updateConfig({
    language,
    stringSet
  });
}
```

This approach ensures that only the language resources needed for the current user are loaded, which is particularly important when supporting multiple languages with large string sets.
