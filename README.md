# NextAI Translator

An AI-powered browser extension for translation, polishing, and summarization.

## Supported browsers

- Chromium-based browsers (Chrome, Edge, Brave, etc.)
- Firefox

## Features

- Selection and page translation
- AI translation, rewriting, and summarization
- Streaming responses
- Configurable OpenAI-compatible providers, models, prompts, and languages
- Translation history and vocabulary tools
- Text-to-speech
- Custom API endpoint and key configuration

## Development

Requirements: Node.js 18+ and pnpm 9.1.3.

```bash
pnpm install
pnpm dev:chromium
# or
pnpm dev:firefox
```

## Build

```bash
pnpm build
pnpm build:extension
```

Build output:

- `dist/browser-extension/chromium/`
- `dist/browser-extension/firefox/`
- `dist/browser-extension/chromium.zip`
- `dist/browser-extension/firefox.zip`

## Load locally

1. Build the extension.
2. Open `chrome://extensions` (Chromium) or `about:debugging#/runtime/this-firefox` (Firefox).
3. Enable developer mode / temporary add-on loading.
4. Load the corresponding unpacked directory under `dist/browser-extension`.

## Configuration

Open the extension options page and configure an API provider, endpoint, API key, and model. Use an OpenAI-compatible endpoint for third-party providers.

## License

[AGPL-3.0](./LICENSE)
