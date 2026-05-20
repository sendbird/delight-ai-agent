[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)![React Version](https://img.shields.io/badge/1.0.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-react/releases)

## How to handle link clicks in conversation messages

There is no public hook to intercept link clicks inside conversation message text at this time.

**Default behavior**
- Incoming text messages render Markdown links through the SDK's internal Markdown renderer and open in a new tab.
- Outgoing text messages do not render Markdown; URLs are not converted into `<a>` tags by the SDK.

If you need a programmatic link-click handler, please file a feature request so the SDK can expose a public Markdown renderer override or a link-click callback. Until then, do not replace the message body to inject DOM listeners; that path drops the SDK's text, file, media, multi-file, message-template, form, and citation rendering branches.
