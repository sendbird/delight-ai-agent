# Multi-language support

This guide explains how to localize the UI strings used in the **Delight AI agent SDK for React** to support multiple languages in your web application.

This guide explains:
- [Overview](#overview)
    - [Supported languages](#supported-languages)
- [Setting the language](#setting-the-language)
- [Customizing strings](#customizing-strings)
    - [Scenario 1: Customizing strings in supported languages](#scenario-1-customizing-strings-in-supported-languages)
    - [Scenario 2: Adding support for unsupported languages](#scenario-2-adding-support-for-unsupported-languages)
- [Language switching with React](#language-switching-with-react)
- [Organizing and loading language files](#organizing-and-loading-language-files)
    - [Dynamic loading implementation Recommended:](#dynamic-loading-implementation-recommended)
    - [Alternative: Static import Not recommended for multiple languages:](#alternative-static-import-not-recommended-for-multiple-languages)
- [Default SDK strings](#default-sdk-strings)

---

## Overview

**Delight AI agent SDK for React** includes a default set of user-facing strings such as button labels, error messages, input hints, and system texts. To support internationalization, you can set the language preference during component initialization or update it later using the `FixedMessenger` props.

The language setting influences both the UI text displayed in the messenger and potentially the AI Agent's responses.

### Supported languages

The SDK currently provides built-in localization for the following languages:

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

If you need support for a language that is not listed above, you can customize the SDK strings by providing a complete set of string values.

---

## Setting the language

You can set the language during component initialization:

```tsx
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';

function App() {
  return (
    <FixedMessenger
      appId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
      language="ko-KR"
      countryCode="KR"
    />
  );
}
```

---

## Customizing strings

### Scenario 1: Customizing strings in supported languages

```tsx
<FixedMessenger
  appId="YOUR_APP_ID"
  aiAgentId="YOUR_AI_AGENT_ID"
  language="es-ES"
  // You can still customize certain stringSet keys even in supported language
  stringSet={{
    MESSAGE_INPUT__PLACE_HOLDER: '¡Pregúntame cualquier cosa!',
    CONVERSATION_LIST__HEADER_TITLE: 'Lista de conversaciones anteriores'
  }}
/>
```

### Scenario 2: Adding support for unsupported languages

```tsx
<FixedMessenger
  appId="YOUR_APP_ID"
  aiAgentId="YOUR_AI_AGENT_ID"
  language="zh-CN"
  // All stringSet keys for unsupported languages must be provided
  stringSet={{
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

    // ... other string key-value pairs
  }}
/>
```

---

## Language switching with React

```tsx
function App() {
  const [language, setLanguage] = useState('en-US');
  const [stringSet, setStringSet] = useState(undefined);

  const switchLanguage = async (newLanguage: string) => {
    if (newLanguage === 'zh-CN') {
      const { zhStringSet } = await import('./languages/zh');
      setStringSet(zhStringSet);
    } else {
      setStringSet(undefined);
    }
    setLanguage(newLanguage);
  };

  return (
    <>
      <button onClick={() => switchLanguage('zh-CN')}>Switch to Chinese</button>
      <button onClick={() => switchLanguage('en-US')}>Switch to English</button>
      <FixedMessenger
        appId="YOUR_APP_ID"
        aiAgentId="YOUR_AI_AGENT_ID"
        language={language}
        stringSet={stringSet}
      />
    </>
  );
}
```

---

## Organizing and loading language files

```tsx
// languages/zh.ts
export default {
  CHANNEL_FROZEN: '频道已冻结',
  PLACE_HOLDER__WRONG: '出现问题',
  PLACE_HOLDER__NO_MESSAGES: '没有消息',
  UNKNOWN__UNKNOWN_MESSAGE_TYPE: '(未知消息类型)',
  HEADER_BUTTON__AGENT_HANDOFF: '连接客服',
  MESSAGE_INPUT__PLACE_HOLDER: '请输入问题',
  MESSAGE_INPUT__PLACE_HOLDER__WAIT_AI_AGENT_RESPONSE: '等待回复中...',
  MESSAGE_INPUT__PLACE_HOLDER__DISABLED: '此频道不可用',
  BUTTON__CANCEL: '取消',
  BUTTON__SAVE: '保存',
  BUTTON__OK: '确定',
  NO_NAME: '(无名)',
  RETRY: '重试',
  // ... other string key-value pairs
};
```

### Dynamic loading implementation (Recommended):

```tsx
function App() {
  const [language, setLanguage] = useState('en-US');
  const [stringSet, setStringSet] = useState(undefined);

  const loadLanguage = async (newLanguage: string) => {
    let newStringSet;

    try {
      // Dynamic import only loads the file when needed
      const module = await import(`./languages/${newLanguage}.ts`);
      newStringSet = module.default;
    } catch {
      // Fallback to default strings for supported languages
      newStringSet = undefined;
    }

    setLanguage(newLanguage);
    setStringSet(newStringSet);
  };

  return (
    <>
      <button onClick={() => loadLanguage('zh')}>中文</button>
      <button onClick={() => loadLanguage('ja')}>日本語</button>
      <button onClick={() => loadLanguage('en-US')}>English</button>

      <FixedMessenger
        appId="YOUR_APP_ID"
        aiAgentId="YOUR_AI_AGENT_ID"
        language={language}
        stringSet={stringSet}
      />
    </>
  );
}
```

### Alternative: Static import (Not recommended for multiple languages):

```tsx
// Only use this approach if you need just one additional language
import { zhStringSet } from './languages/zh';

function App() {
  return (
    <FixedMessenger
      appId="YOUR_APP_ID"
      aiAgentId="YOUR_AI_AGENT_ID"
      language="zh-CN"
      stringSet={zhStringSet}
    />
  );
}
```

---

## Default SDK strings

The string keys remain the same as the JavaScript version. Please refer to the [JavaScript version's string keys ](../cdn/MULTILANGUAGE.md#default-sdk-strings)for the complete list.
