# 浏览器扩展翻译性能排查

本文介绍如何定位浏览器扩展翻译请求的首字延迟（TTFT，Time To First Token），并根据各阶段耗时判断性能瓶颈。

## 1. 指标含义

项目使用 `[ttft]` 标记一次翻译请求的阶段耗时，用于记录首个有效文本从请求发起到页面显示的完整过程。

日志输出到加载性能追踪模块的浏览器上下文控制台。排查时先确认开发者工具连接的是实际触发翻译的页面或扩展上下文。

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

在加载性能追踪模块的浏览器上下文 Console 中执行：

```js
localStorage.setItem('translate-perf', 'on')
```

关闭性能日志：

```js
localStorage.removeItem('translate-perf')
```

`localStorage` 按当前执行上下文所属页面保存。调试时请确认 Console 连接的是实际运行翻译逻辑的上下文，再设置性能开关。

性能模块会在 `window.__translatePerf` 上提供以下方法：

| 方法 | 作用 |
| --- | --- |
| `enable()` | 开启性能日志 |
| `disable()` | 关闭性能日志 |
| `last()` | 获取最近一次完成的记录 |
| `all()` | 获取最近 20 次完成记录 |
| `csv()` | 导出记录为 CSV 文本 |
| `active()` | 查看当前正在记录的请求 |
| `clear()` | 清空已完成的记录 |

## 5. 常见排查方向

- 首字前耗时较长：检查网络连接、服务商响应、代理配置和请求超时。
- `first-byte->first-token` 较长：优先检查模型首 Token 延迟、模型负载和提示词长度。
- `first-token->paint` 较长：检查流式解析、状态更新频率、React 渲染范围和页面主线程占用。
- 后续文本出现间断或片段缺失：检查流分块解析、UTF-8 跨块解码、缓冲合并和 UI 更新节奏。

修改性能逻辑后，使用相同浏览器、相同模型和可比输入重复测量，同时关注首字延迟、完整响应耗时及文本完整性。
