# 浏览器扩展翻译性能排查

本文说明如何定位浏览器扩展翻译请求的首字延迟（TTFT，Time To First Token）。

## 1. 指标含义

项目在性能日志中使用 `[ttft]` 标记一次翻译请求的阶段耗时。它用于判断首个有效文本从请求发起到页面显示经历了哪些阶段。

浏览器扩展环境下，日志可在网页开发者工具或扩展相关上下文的控制台中查看，具体取决于日志触发位置。

## 2. 日志示例

```text
[ttft] translate total=1284ms reason=stop mode=translate provider=DeepSeek
       target=zh-Hans chars=83 model=deepseek-flash
       | start->prompt 2 | prompt->settings 0 | settings->engine 0
       | engine->request 1 | request->dispatch 0 | dispatch->headers 191
       | headers->first-byte 12 | first-byte->first-token 1064
       | first-token->paint 14
```

## 3. 阶段说明

| 阶段 | 含义 |
| --- | --- |
| `start->prompt` | 组装提示词，主要逻辑位于 `src/common/translate.ts` |
| `prompt->settings` | 读取翻译配置 |
| `settings->engine` | 选择模型服务引擎 |
| `engine->request` | 生成请求地址、请求头和请求体 |
| `request->dispatch` | 发起流式网络请求 |
| `dispatch->headers` | 等待响应头到达 |
| `headers->first-byte` | 响应体首个字节到达 |
| `first-byte->first-token` | 服务商返回首个有效文本片段，通常主要受模型生成耗时影响 |
| `first-token->paint` | 首个文本片段提交并显示到页面 |

## 4. 开启与查看

在浏览器扩展运行环境的控制台中执行：

```js
localStorage.setItem('translate-perf', 'on')
```

关闭性能日志：

```js
localStorage.removeItem('translate-perf')
```

如果当前页面上下文无法访问扩展使用的存储，请在扩展对应的页面或上下文中执行，不要将网页自身的 localStorage 与扩展存储混为一谈。

如果代码暴露了 `window.__translatePerf`，可以通过其 `last()`、`all()`、`csv()`、`active()`、`enable()`、`disable()` 和 `clear()` 方法查看记录。具体以当前实现为准。

## 5. 常见排查方向

- 首字前耗时较长：检查网络连接、服务商响应、代理配置和请求超时。
- `first-byte->first-token` 较长：优先检查模型首 token 延迟、模型负载和提示词长度。
- `first-token->paint` 较长：检查流式解析、状态更新频率、React 渲染范围和页面主线程阻塞。
- 后续文本显示不连续：检查流分块解析、UTF-8 跨块解码、缓冲合并和 UI 更新节奏。

修改性能逻辑后，应使用相同浏览器、相同模型和可比输入重复测量，并同时关注首字延迟、完整响应耗时及文本完整性。
