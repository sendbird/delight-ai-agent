[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to handle link clicks in conversation messages

Intercept link clicks the SDK opens — markdown links, admin-message URLs, citations, CTA buttons, and file-message file-preview clicks — through the `handlers.onClickLink` callback on `AgentProviderContainer`.

### Example

```tsx
import { AgentProviderContainer, Conversation } from '@sendbird/ai-agent-messenger-react';

export const App = () => {
  return (
    <AgentProviderContainer
      appId={'YOUR_APP_ID'}
      aiAgentId={'YOUR_AI_AGENT_ID'}
      handlers={{
        onClickLink: ({ url }) => {
          // analytics
          analytics.track('agent_link_click', { url });

          // in-app navigation for custom schemes
          if (url.startsWith('myapp://')) {
            router.push(url);
            return;
          }

          // default behavior
          window.open(url, '_blank', 'noopener,noreferrer');
        },
      }}
    >
      <Conversation />
    </AgentProviderContainer>
  );
};
```

### Notes

- Without `onClickLink`, the SDK falls back to `window.open(url, '_blank', 'noopener,noreferrer')`. If the URL has no protocol, the default prepends `https://`. Customer handlers receive the raw URL.
- The media viewer's download button is intentionally excluded — it never calls `onClickLink`. By default it keeps native `<a href download>` behavior: the user's tap follows the original file URL with the file name in `download`, so in-app WebView hosts that hand that URL to a native downloader keep working. A same-origin file saves under its name; a cross-origin file ignores `download`, so the file server's response decides whether it is saved or opened.
- Set `config.conversation.fileViewer.imageDownloadMode` to `'blob'` to save cross-origin images under their file names. The default is `'url'`, and videos always keep the link.
  - The SDK fetches the image and saves it under its file name through a `blob:` download link. The file host must allow CORS, and if your page sets a Content Security Policy, its `connect-src` must allow the file host.
  - If that request fails, the SDK retries once with `credentials: 'include'`, which also sends cookies to a cross-origin file host. A host that needs those cookies must answer with `Access-Control-Allow-Credentials: true` and your exact origin (not `*`) in `Access-Control-Allow-Origin`.
  - If both requests fail (CORS not allowed, `connect-src` blocked, network error, or an HTTP error status), the SDK clicks the plain link with the original URL instead.
  - If your page uses CSP `sandbox`, it must permit downloads with `allow-downloads`; otherwise the browser can block the `blob:` download even after a successful fetch.
  - Clicks with a modifier key or the middle button keep the plain link and are never fetched.
  - Keep the default in an in-app WebView unless the host app handles `blob:` downloads: iOS `WKWebView` needs `.download` from the navigation policy and a `WKDownloadDelegate`, and an Android `DownloadListener` cannot fetch a `blob:` URL on its own. When the fetch succeeds, the host sees only the `blob:` download, not the original HTTPS URL, and the click is made by script after an asynchronous request, so it may not carry a user gesture.
- If you replace message/layout slots and receive message props, slot-level callbacks (`onClickCTA`, `onClickCitation`, `onClickMedia`, `onClickFile`) still override that slot's behavior entirely and take precedence over `onClickLink`. `onClickLink` is the "last default" — used when no slot-level override is supplied.
