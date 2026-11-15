# NextAI Translator

NextAI Translator 是一款基于大语言模型的浏览器翻译扩展，面向网页划词翻译、文本润色和内容总结等使用场景。项目围绕 Chromium 内核浏览器与 Firefox 提供统一的扩展体验。

## 支持的浏览器

- Chromium 内核浏览器：Chrome、Edge、Brave 等
- Firefox

## 功能

- 网页划词翻译与文本选择翻译
- AI 翻译、文本润色和内容总结
- 流式输出
- 自定义 OpenAI 兼容服务商、API 地址、模型和提示词
- 多语言互译
- 翻译历史与生词本
- 文本语音朗读（TTS）

## 开发环境

- Node.js 20（建议使用 LTS 版本）
- pnpm 9.1.3

安装依赖：

```bash
pnpm install
```

启动开发模式：

```bash
pnpm dev:chromium
# Firefox
pnpm dev:firefox
```

## 构建与验证

构建 Chromium 和 Firefox 两个浏览器版本：

```bash
pnpm build
```

生成可分发压缩包：

```bash
pnpm build:extension
```

执行检查：

```bash
pnpm exec tsc --noEmit
pnpm test
pnpm lint
```

构建产物：

| 浏览器 | 未压缩目录 | 分发包 |
| --- | --- | --- |
| Chromium | `dist/browser-extension/chromium/` | `dist/browser-extension/chromium.zip` |
| Firefox | `dist/browser-extension/firefox/` | `dist/browser-extension/firefox.zip` |

## 本地安装

### Chromium

1. 执行构建。
2. 打开 `chrome://extensions`。
3. 开启开发者模式。
4. 选择“加载已解压的扩展程序”，载入 `dist/browser-extension/chromium`。

### Firefox

1. 执行构建。
2. 打开 `about:debugging#/runtime/this-firefox`。
3. 选择“临时载入附加组件”。
4. 载入 `dist/browser-extension/firefox/manifest.json`。

## 配置

打开扩展的选项页面，配置 AI 服务商、API 地址、API Key 和模型。使用第三方服务时，确认服务端接口与项目当前支持的 OpenAI 兼容协议相匹配。

## 项目结构

- `src/browser-extension/`：浏览器扩展入口，包括后台脚本、内容脚本、弹出页和选项页。
- `src/common/`：翻译引擎、通用组件、状态管理、国际化及共享业务逻辑。
- `public/`：静态资源。
- `e2e/`：Playwright 端到端测试。
- `docs/`：中文使用说明和开发文档。
- `.github/workflows/`：持续集成与浏览器扩展发布工作流。

## 贡献与协作

开发前阅读 [AGENTS.md](./AGENTS.md)，了解项目结构、代码约定和验证流程。每项独立修改完成后，按影响范围执行验证，并创建对应的 Git 提交；提交前核对变更范围，保持提交历史清晰可追溯。

## 许可证

[AGPL-3.0](./LICENSE)
