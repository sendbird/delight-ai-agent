# Using the messenger on React 17 (unsupported)

> **Note:** This SDK does **not** support React below 18. Use React 18 or later in production. If you cannot upgrade yet, the steps below are an unsupported reference only.
>
> The webpack, Vite, and Next.js 12 recipes were checked on clean apps. Your bundler plugins, aliases, and SSR setup can change the result. Treat the snippets as a starting point, not a drop-in for every host.

If you cannot upgrade yet, treat this guide as the host recipe. Initialization props and component trees are the same as the [React messenger quickstart](./#getting-started).

This guide explains:

* [Why this is unsupported](#why-this-is-unsupported)
* [What you need](#what-you-need)
* [Install](#install)
* [Polyfill wrapper](#polyfill-wrapper)
* [webpack and CRA](#webpack-and-cra)
* [Vite](#vite)
* [Next.js 12](#nextjs-12)
* [SDK version notes](#sdk-version-notes)
* [Limitations](#limitations)

---

## Why this is unsupported

A React 17 host is missing hooks the SDK calls:

* `useId` — all published versions
* `useSyncExternalStore` — from **1.31.1**

Until those hooks exist, the messenger cannot render.

This guide backfills them with two npm shims: [`useid-polyfill`](https://www.npmjs.com/package/useid-polyfill) and [`use-sync-external-store`](https://www.npmjs.com/package/use-sync-external-store). A default `npm install` can fail when the host is React 17. Use `--legacy-peer-deps` as shown in [Install](#install). Older SDK releases are listed under [SDK version notes](#sdk-version-notes).

Do not mutate `React.useId` in place and do not globally alias `react` to the wrapper. webpack 5 rejects `import { useId } from 'react'` unless that import resolves to a module that **statically exports** `useId`. A global `react` alias also remaps the wrapper's own `react` import, so the wrapper loads itself and React APIs disappear.

---

## What you need

Use one of these paths. Do not mix them.

* **webpack / CRA:** Install + [Polyfill wrapper](#polyfill-wrapper) + [webpack and CRA](#webpack-and-cra). Stock CRA cannot edit webpack without CRACO or eject.
* **Vite:** Install + [Polyfill wrapper](#polyfill-wrapper) + [Vite](#vite).
* **Next.js 12:** Install + [Polyfill wrapper](#polyfill-wrapper) + [Next.js 12](#nextjs-12). Render `<Suspense>` only after the client has mounted.

If you later upgrade to React 18, remove the install flag, the polyfill packages, and the wrapper.

---

## Install

Install the same packages as the [quickstart](./#step-1-install-ai-agent-sdk), plus the two shims, and pass `--legacy-peer-deps` so npm accepts `react@17`:

```bash
npm install @sendbird/ai-agent-messenger-react @sendbird/chat styled-components useid-polyfill use-sync-external-store --legacy-peer-deps
```

You only need the shims on React 17.

---

## Polyfill wrapper

Provide a React module that re-exports the two package shims, and apply it **only** when `@sendbird/ai-agent-messenger-react` imports `react`. Keep `react/jsx-runtime` on the real `react` package.

On React 17, `useid-polyfill` returns `undefined` on the first client render. This SDK passes that value to `addConnectionHandler`, which requires a string. The wrapper keeps a fallback id so the first paint has a string.

### ESM wrapper (webpack and Vite)

```js
// polyfills/delight-react17-polyfill.js
import * as OriginalReact from 'react';
import { useState } from 'react';
import { useId as useIdPolyfill } from 'useid-polyfill';
import { useSyncExternalStore as useSyncExternalStoreShim } from 'use-sync-external-store/shim';

function useIdWithClientFallback() {
  const id = useIdPolyfill();
  const [fallback] = useState(() => `uid-${Math.random().toString(36).slice(2, 10)}`);
  return id ?? fallback;
}

export * from 'react';

export const useId = useIdWithClientFallback;
export const useSyncExternalStore = useSyncExternalStoreShim;

const ReactWithPolyfills = {
  ...OriginalReact,
  useId,
  useSyncExternalStore,
};

export default ReactWithPolyfills;
```

### CommonJS wrapper (Next.js 12)

```js
// polyfills/delight-react17-polyfill.cjs
const OriginalReact = require('react');
const { useId: useIdPolyfill } = require('useid-polyfill');
const { useSyncExternalStore } = require('use-sync-external-store/shim');

function useIdWithClientFallback() {
  const id = useIdPolyfill();
  const [fallback] = OriginalReact.useState(() => `uid-${Math.random().toString(36).slice(2, 10)}`);
  return id ?? fallback;
}

const ReactWithPolyfills = {
  ...OriginalReact,
  useId: useIdWithClientFallback,
  useSyncExternalStore,
};

module.exports = ReactWithPolyfills;
module.exports.default = ReactWithPolyfills;
module.exports.useId = ReactWithPolyfills.useId;
module.exports.useSyncExternalStore = ReactWithPolyfills.useSyncExternalStore;
```

---

## webpack and CRA

Scope the ESM wrapper to the messenger package. Also pin `react` and `react-dom` to one copy so the wrapper does not patch a different instance than `react-dom`.

```js
// webpack.config.js
const path = require('path');
const webpack = require('webpack');

module.exports = {
  resolve: {
    alias: {
      react: path.resolve(__dirname, 'node_modules/react'),
      'react-dom': path.resolve(__dirname, 'node_modules/react-dom'),
    },
  },
  plugins: [
    new webpack.NormalModuleReplacementPlugin(/^react$/, (resource) => {
      if (resource.context.includes('@sendbird/ai-agent-messenger-react')) {
        resource.request = path.resolve(__dirname, 'polyfills/delight-react17-polyfill.js');
      }
    }),
  ],
};
```

Use React 17's `ReactDOM.render`. The polyfill packages do not replace `React.lazy`. Some SDK paths call `React.lazy` without a local boundary, so wrap the messenger in a host `<Suspense>`. Client-side `<Suspense>` is valid on React 17. Without it, React 17 throws `A React component suspended while rendering, but no fallback UI was specified`.

```tsx
import { Suspense } from 'react';
import ReactDOM from 'react-dom';
import { FixedMessenger } from '@sendbird/ai-agent-messenger-react';
import '@sendbird/ai-agent-messenger-react/index.css';

ReactDOM.render(
  <Suspense fallback={<div>Loading…</div>}>
    <FixedMessenger appId="YOUR_APP_ID" aiAgentId="YOUR_AI_AGENT_ID" />
  </Suspense>,
  document.getElementById('root'),
);
```

The same `<Suspense>` wrap applies to `AgentProviderContainer`. Use the component tree from [quickstart Option 2](./#step-2-initialize-ai-agent-sdk).

---

## Vite

Use the ESM wrapper and a `resolveId` plugin that replaces `react` only when the importer is `@sendbird/ai-agent-messenger-react`. Do not add a `resolve.alias` for `react`, and do not alias `react/jsx-runtime` or `react-dom`.

```js
// vite.config.js
import path from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [
    {
      name: 'delight-react17-shim',
      enforce: 'pre',
      resolveId(source, importer) {
        if (source === 'react' && importer?.includes('@sendbird/ai-agent-messenger-react')) {
          return path.resolve(__dirname, 'polyfills/delight-react17-polyfill.js');
        }
      },
    },
  ],
});
```

Then wrap the messenger in `<Suspense>` and call `ReactDOM.render` as in [webpack and CRA](#webpack-and-cra).

---

## Next.js 12

Use the CommonJS wrapper. Scope it to `@sendbird/ai-agent-messenger-react` on the **client** compiler, and load the messenger with `dynamic(..., { ssr: false })`.

Do not patch the global `react` export. The polyfill packages do not replace `React.lazy`. React 17's `ReactDOMServer` does not support `<Suspense>`, so do not put it in the server-rendered tree. Mount the page first, then wrap the messenger in `<Suspense>` on the client so the SDK's `React.lazy` paths have a boundary.

```js
// next.config.js
const path = require('path');

module.exports = {
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.plugins.push(
        new (require('webpack').NormalModuleReplacementPlugin)(/^react$/, (resource) => {
          if (resource.context.includes('@sendbird/ai-agent-messenger-react')) {
            resource.request = path.resolve(__dirname, 'polyfills/delight-react17-polyfill.cjs');
          }
        }),
      );
    }
    return config;
  },
};
```

```tsx
import { Suspense, useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import '@sendbird/ai-agent-messenger-react/index.css';

const FixedMessenger = dynamic(
  () => import('@sendbird/ai-agent-messenger-react').then((mod) => mod.FixedMessenger),
  { ssr: false },
);

export default function Page() {
  const [ready, setReady] = useState(false);
  useEffect(() => setReady(true), []);
  if (!ready) return null;

  return (
    <Suspense fallback={<div>Loading…</div>}>
      <FixedMessenger appId="YOUR_APP_ID" aiAgentId="YOUR_AI_AGENT_ID" />
    </Suspense>
  );
}
```

---

## SDK version notes

The snippets in this guide target the **latest** SDK, which needs both packages. Releases **1.31.0 and earlier** do not need `use-sync-external-store`.

| SDK version | `useid-polyfill` | `use-sync-external-store` |
|---|---|---|
| 1.31.0 and earlier | Required | Not used |
| **1.31.1 and later** (including latest) | Required | **Required** |

---

## Limitations

* These packages backfill the two hooks this SDK currently calls. A later SDK release that uses another React 18+ API needs another host shim.
* Treat this guide as a POC, not a production contract.
* Validate live send, streaming, and WebSocket behavior in your own network after the messenger renders.
