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

// Message Input
MESSAGE_INPUT__PLACE_HOLDER__STEWARD: 'Processing your request...',

// Common UI
BUTTON__OK: 'OK',

// Conversation List
CONVERSATION_LIST__SYSTEM_MESSAGE: 'System message',

// File Upload
FILE_UPLOAD_REPLACE_ALERT__TITLE: 'Replace attachment?',
FILE_UPLOAD_REPLACE_ALERT__DESCRIPTION: 'Uploading a different file type will replace the current one.',

// Handoff
HANDOFF_CONFIRM__TITLE: 'Request handoff?',
HANDOFF_CONFIRM__DESCRIPTION: "You'll be transferred to a human agent. Your conversation history will be shared.",
HANDOFF_CONFIRM__CANCEL: 'Cancel',
HANDOFF_CONFIRM__HANDOFF: 'Handoff',

// Accessibility
A11Y_OPEN_CONVERSATION: 'Open conversation',
A11Y_OPEN_CONVERSATIONS: 'Open conversations',
A11Y_CLOSE_CONVERSATION: 'Close conversation',
A11Y_CLOSE_CONVERSATIONS: 'Close conversations',
A11Y_MENU: 'Menu',
A11Y_MESSAGE_INPUT: 'Message',
A11Y_SEND_MESSAGE: 'Send message',
A11Y_MESSAGE_SENDER_YOU: 'You',
A11Y_SUGGESTED_REPLY: 'Suggested reply',
A11Y_TYPING_INDICATOR: 'Typing',
A11Y_CODE_BLOCK_PLACEHOLDER: 'Code block',
A11Y_CSAT_RATING_LABEL: (score, label) => `${score} — ${label}`,
A11Y_FILE_UPLOAD_OPTIONS: 'File upload options',
A11Y_FAILED_MESSAGE_OPTIONS: 'Failed message options',
A11Y_FEEDBACK_OPTIONS: 'Feedback options',
A11Y_CSAT_TEXT_INPUT_LABEL: 'Enter answer',
A11Y_TYPING_FORMAT: (name) => `${name} is typing`,
A11Y_MESSAGE_FAILED: 'Message send failed',
A11Y_NEW_MESSAGES_RECEIVED: (count) => `${count} new ${count === 1 ? 'message' : 'messages'} received`,
A11Y_NEW_MESSAGES_RECEIVED_FROM_SENDER: (sender, count) => `${sender}: ${count} new ${count === 1 ? 'message' : 'messages'} received`,
A11Y_AGENT_CONNECTED: (name) => 'Connected to human agent',
A11Y_CONVERSATION_CLOSED: 'Conversation has ended',
A11Y_FILE_IMAGE: (name) => `Image file: ${name}`,
A11Y_FILE_VIDEO: (name) => `Video file: ${name}`,
A11Y_FILE_DOCUMENT: (name) => `Document file: ${name}`,
A11Y_FILE_SELECTED: (label) => `${label}, selected`,
A11Y_FILE_REMOVE_BUTTON: (name) => `Remove file: ${name}`,
A11Y_SCREEN_CONVERSATION: 'Conversation',
A11Y_SCREEN_CONVERSATION_WITH_AGENT: (name) => `Conversation with ${name}`,
A11Y_SCREEN_CONVERSATION_LIST_NO_COUNT: 'Conversation list',
A11Y_SCREEN_CONVERSATION_LIST_WITH_COUNT: (count) => `Conversations, ${count} total`,
A11Y_CSAT_DISPLAYED: 'Satisfaction survey displayed',
A11Y_EMPTY_CONVERSATION: 'No messages in this conversation',
A11Y_INPUT_DISABLED: 'Message input is disabled',
A11Y_FILE_SIZE_EXCEEDED: (maxSizeMB) => `File exceeds size limit of ${maxSizeMB}MB`,
A11Y_CSAT_FORM_ERROR: 'Please complete the required fields',
A11Y_CONVERSATION_ITEM: (agent, status, time, count) => `${agent}, ${status}, ${time}, ${count} unread ${count === 1 ? 'message' : 'messages'}`,
A11Y_RATING_LABEL: (score, label) => `${score} out of 5 — ${label}`,
A11Y_CONNECT_AGENT: 'Talk to human agent',
A11Y_CLOSE_MESSENGER: 'Close messenger',
A11Y_EXPAND_MESSENGER: 'Expand messenger',
A11Y_COLLAPSE_MESSENGER: 'Collapse messenger',
A11Y_HINT_SEND_MESSAGE: 'Sends the message',
A11Y_HINT_OPEN_CONVERSATION: 'Opens the conversation',
A11Y_HINT_OPEN_CONVERSATIONS: 'Opens conversations',
A11Y_HINT_CLOSE_CONVERSATION: 'Closes the conversation',
A11Y_HINT_OPEN_MENU: 'Opens the menu',
A11Y_HINT_CONNECT_TO_AGENT: 'Escalates to a human agent',
A11Y_HINT_ATTACH_FILE: 'Opens file attachment options',
A11Y_HINT_VIEW_NEW_MESSAGES: 'Scrolls to new messages',
A11Y_HINT_OPEN_FILE: 'Opens the file',
A11Y_HINT_OPEN_IMAGE: 'Opens the image',
A11Y_HINT_SEND_REPLY: 'Sends this reply',
A11Y_HINT_SELECT_RATING: 'Selects this rating',
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