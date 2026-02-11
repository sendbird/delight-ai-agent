# Delight AI agent SDK Localization Guide (React-Native)

## Table of Contents

- [Delight AI agent SDK Localization Guide (React-Native)](#delight-ai-agent-sdk-localization-guide-react-native)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Supported Languages](#supported-languages)
  - [Setting the Language](#setting-the-language)
  - [Customizing Strings](#customizing-strings)
    - [Scenario 1: Customizing Strings in Supported Languages](#scenario-1-customizing-strings-in-supported-languages)
    - [Scenario 2: Adding Support for Unsupported Languages](#scenario-2-adding-support-for-unsupported-languages)
  - [Language Switching with React-Native](#language-switching-with-react-native)


## Overview

Delight AI agent SDK for React-Native includes a default set of user-facing strings such as button labels, error messages, input hints, and system texts. To support internationalization, you can set the language preference during component initialization or update it later using the `AIAgentProviderContainer` props.

The language setting influences both the UI text displayed in the messenger and potentially the AI Agent's responses.


## Supported Languages

The SDK currently provides built-in localization for the following languages:

- English (`en`)
- German (`de`)
- Spanish (`es`)
- French (`fr`)
- Hindi (`hi`)
- Italian (`it`)
- Japanese (`ja`)
- Korean (`ko`)
- Portuguese (`pt`)
- Turkish (`tr`)

If you need support for a language that is not listed above, you can customize the SDK strings by providing a complete set of string values.


## Setting the Language

You can set the language during component initialization:

```tsx
import { AIAgentProviderContainer, FixedMessenger } from '@sendbird/ai-agent-messenger-react-native';

function App() {
  return (
    <AIAgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      language={'ko-KR'}
      countryCode={'KR'}
    >
      <FixedMessenger />
    </AIAgentProviderContainer>
  );
}
```

## Customizing Strings

### Scenario 1: Customizing Strings in Supported Languages

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  language={'es-ES'}
  // You can still customize certain strings even in supported language
  strings={{
    conversation: {
      input_placeholder: '¡Pregúntame cualquier cosa!',
    },
    conversation_list: {
      header_title: 'Lista de conversaciones anteriores',
    },
  }}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

### Scenario 2: Adding Support for Unsupported Languages

```tsx
<AIAgentProviderContainer
  appId={'YOUR_APP_ID'}
  aiAgentId={'YOUR_AI_AGENT_ID'}
  language={'zh-CN'}
  // All strings for unsupported languages must be provided
  strings={{
    conversation: {
      input_placeholder: '请输入问题',
      // ... other conversation strings
    },
    conversation_list: {
      header_title: '对话列表',
      // ... other conversation_list strings
    },
    date_format: { /* ... */ },
    csat: { /* ... */ },
    form: { /* ... */ },
    common: { /* ... */ },
    feedback: { /* ... */ },
  }}
>
  <FixedMessenger />
</AIAgentProviderContainer>
```

## Language Switching with React-Native

```tsx
function App() {
  const [language, setLanguage] = useState('en-US');
  const [strings, setStrings] = useState(undefined);

  const switchLanguage = (newLanguage: string) => {
    if (newLanguage === 'zh-CN') {
      // Import Chinese strings
      const zhStrings = require('./languages/zh').default;
      setStrings(zhStrings);
    } else {
      setStrings(undefined);
    }
    setLanguage(newLanguage);
  };

  return (
    <>
      <Button title={'Switch to Chinese'} onPress={() => switchLanguage('zh-CN')} />
      <Button title={'Switch to English'} onPress={() => switchLanguage('en-US')} />
      <AIAgentProviderContainer
        appId={'YOUR_APP_ID'}
        aiAgentId={'YOUR_AI_AGENT_ID'}
        language={language}
        strings={strings}
      >
        <FixedMessenger />
      </AIAgentProviderContainer>
    </>
  );
}
```
