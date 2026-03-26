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
    CONVERSATION_LIST__HEADER_TITLE: 'Lista de conversaciones'
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

> **Note**: When updating at runtime with `updateConfig`, only the UI strings will be changed. The AI Agent's language preference will not be affected.

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
PLACE_HOLDER__WRONG: 'Something went wrong',
PLACE_HOLDER__NO_MESSAGES: 'No messages',
UNKNOWN__UNKNOWN_MESSAGE_TYPE: '(Unknown message type)',

// Channel - Header
HEADER_BUTTON__AGENT_HANDOFF: 'Connect with an agent',

// Message Input
MESSAGE_INPUT__PLACE_HOLDER: 'Ask a question',
MESSAGE_INPUT__PLACE_HOLDER__WAIT_AI_AGENT_RESPONSE: "Waiting for the agent's reply...",
MESSAGE_INPUT__PLACE_HOLDER__DISABLED: 'Chat is unavailable in this channel',
MESSAGE_INPUT__PLACE_HOLDER__SUGGESTED_REPLIES: 'Select an option to continue',
MESSAGE_INPUT__PLACE_HOLDER__RECONNECTING: 'Trying to reconnect. Refresh if persists.',

// Common UI
BUTTON__CANCEL: 'Cancel',
BUTTON__SUBMIT: 'Submit',
SUBMITTED: 'Submitted',
TRY_AGAIN: 'Please try again.',
RETRY: 'Retry',
POWERED_BY: 'Powered by',
OPTIONAL: 'optional',

// Date format
DATE_FORMAT__MESSAGE_LIST__DATE_SEPARATOR: 'MMMM dd, yyyy',
DATE_FORMAT__MESSAGE_TIMESTAMP: 'p',
DATE_FORMAT__JUST_NOW: 'Just now',
DATE_FORMAT__MINUTES_AGO: (minutes) => `${minutes} minutes ago`,
DATE_FORMAT__HOURS_AGO: (hours) => `${hours} hours ago`,
DATE_FORMAT__DATE_SHORT: 'MM/dd/yyyy',

// File Upload
FILE_UPLOAD_NOTIFICATION__COUNT_LIMIT: 'Up to %d files can be attached.',
FILE_UPLOAD_NOTIFICATION__SIZE_LIMIT: 'The maximum size per file is %d MB.',
FILE_UPLOAD_NOTIFICATION__FILES_EXCLUDED_BY_VALIDATION: '%d files were excluded due to limits. Please select files individually.',
FILE_UPLOAD_NO_SUPPORTED_FILES: 'No supported file types available.',
FILE_UPLOAD_PHOTOS: 'Photos',
FILE_UPLOAD_FILES: 'Files',

// File Viewer
FILE_VIEWER__UNSUPPORT: 'Unsupported message',

// Image Viewer
IMAGE_VIEWER__DEFAULT_TITLE: 'Image',

// CSAT
CSAT_TITLE_UNSUBMITTED: 'Your feedback matters to us',
CSAT_TITLE_SUBMITTED: 'Successfully submitted!',
CSAT_CRE_TITLE: 'Was your issue resolved?',
CSAT_CRE_SOLVED: 'Yes, thank you! 👍',
CSAT_CRE_NOT_SOLVED: "No, that didn't help.",
CSAT_REASON_PLACEHOLDER: 'Share your feedback',
CSAT_RATING_TITLE: 'How would you rate your experience?',
CSAT_SUBMIT_LABEL: 'Submit',
CSAT_SUBMISSION_EXPIRED: "We're sorry, the survey period has ended.",

// Conversation list
CONVERSATION_LIST__HEADER_TITLE: 'Conversations',
CONVERSATION_LIST__NO_CONVERSATIONS: 'No conversations yet',
CONVERSATION_LIST__ENDED: 'Ended',
CONVERSATION_LIST__MULTIPLE_FILES_COUNT: (count) => `${count} ${count === 1 ? 'file' : 'files'}`,
TALK_TO_AGENT: 'Start a conversation',

// Citation
CITATION_SOURCE_TITLE: 'Source',

// Forms
FORM_PLACEHOLDER: 'Please fill out the form to move forward.',
FORM_UNAVAILABLE: 'Form is no longer available.',
FORM_NOT_SUPPORTED: 'This form is not supported in the current version.',
FORM_VALIDATION_REQUIRED: 'This question is required',
FORM_VALIDATION_MIN_LENGTH: (minLength) => `Minimum ${minLength} characters required`,
FORM_VALIDATION_MAX_LENGTH: (maxLength) => `Maximum ${maxLength} characters allowed`,
FORM_VALIDATION_MIN: (minValue) => `Minimum value is ${minValue}`,
FORM_VALIDATION_MAX: (maxValue) => `Maximum value is ${maxValue}`,
FORM_VALIDATION_MIN_SELECT: (minSelect) => `Select at least ${minSelect} options`,
FORM_VALIDATION_MAX_SELECT: (maxSelect) => `Select at most ${maxSelect} options`,
FORM_VALIDATION_REGEX_FAILED: 'Invalid format',

// Feedback
FEEDBACK_TITLE: 'Submit feedback',
FEEDBACK_GOOD: 'Good',
FEEDBACK_BAD: 'Bad',
FEEDBACK_COMMENT_LABEL: 'Comment (optional)',
FEEDBACK_COMMENT_PLACEHOLDER: 'Leave a comment',
FEEDBACK_CANCEL: 'Cancel',
FEEDBACK_SUBMIT: 'Submit',
FEEDBACK_SAVE: 'Save',
FEEDBACK_EDIT: 'Edit feedback',
FEEDBACK_REMOVE: 'Remove feedback',

// Failed messages
FAILED_MESSAGE_RESEND: 'Retry',
FAILED_MESSAGE_REMOVE: 'Remove',

// Accessibility
A11Y_MESSAGE_LIST: 'Chat messages',
A11Y_SCROLL_TO_BOTTOM: 'Scroll to bottom',
A11Y_SCROLL_TO_NEW_MESSAGES: 'Scroll to new messages',
A11Y_OPEN_CONVERSATION_LIST: 'Open conversation list',
A11Y_IMAGE_VIEWER_CLOSE: 'Close image viewer',
A11Y_IMAGE_VIEWER_PREVIOUS: 'Previous image',
A11Y_IMAGE_VIEWER_NEXT: 'Next image',
A11Y_IMAGE_VIEWER_DOWNLOAD: 'Download image',
A11Y_ATTACH_FILE: 'Attach file',

SCROLL_TO_NEW_MESSAGES_LABEL: (messages) => 'New message',
```

---

## Implementation examples

### Best practice for initializing with custom strings:

For better code organization, you can define your string sets in separate files:

```javascript
// cn.ts - Chinese localization strings
export const cnStringSet = {
  // ... all required strings
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