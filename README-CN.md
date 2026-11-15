# NextAI Translator

基于大语言模型的浏览器翻译扩展，专注于网页划词翻译、润色和总结。

## 支持浏览器

- Chromium 内核浏览器：Chrome、Edge、Brave 等
- Firefox

## 功能

- 划词翻译与网页内容翻译
- AI 翻译、文本润色和内容总结
- 流式输出
- 自定义 OpenAI 兼容服务商、模型、提示词和目标语言
- 翻译历史与生词本
- 文本语音朗读（TTS）
- 自定义 API 地址和密钥

## 开发环境

需要 Node.js 18+ 和 pnpm 9.1.3。

```bash
pnpm install
pnpm dev:chromium
# 或
pnpm dev:firefox
```

## 构建

```bash
pnpm build
pnpm build:extension
```

构建产物：

- `dist/browser-extension/chromium/`
- `dist/browser-extension/firefox/`
- `dist/browser-extension/chromium.zip`
- `dist/browser-extension/firefox.zip`

## 本地安装

1. 执行构建。
2. Chromium 浏览器打开 `chrome://extensions`，Firefox 打开 `about:debugging#/runtime/this-firefox`。
3. 开启开发者模式或临时加载扩展。
4. 分别加载 `dist/browser-extension` 下对应浏览器的目录。

## 配置

打开扩展选项页，配置 API 服务商、接口地址、API Key 和模型。第三方服务商请使用兼容 OpenAI Chat Completions 的接口。

## 许可证

[AGPL-3.0](./LICENSE)
