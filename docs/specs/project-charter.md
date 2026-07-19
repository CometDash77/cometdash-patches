# CometDash Patches 项目章程

## 目标

CometDash Patches 是一个公开、独立维护、兼容 Morphe 的个人 Patch Source。项目同时培养 Codex Agent 的可复用 Morphe Patch 开发能力：能力必须沉淀为版本化规范、证据、工具、测试和可发布代码，而不是依赖单次对话记忆。

首个产品目标是 `Enhanced Voice Over Translation`。它以官方 Voice over translation 为研究起点，但采用独立名称、命名空间和发布来源。

## 成功标准

- Morphe Manager 能从公开 GitHub Source 发现并下载 CometDash Patch Bundle。
- `main` 只包含用户可消费的产品投影；`dev` 保存完整工程、研究和 Agent 能力资产。
- 每项架构事实可追溯到固定上游 revision、反编译证据或运行记录。
- 执行 Agent 不得自我放行；独立 Reviewer 复核后由用户最终确认。
- 只对实际通过目标 APK 构建和人工冒烟测试的版本声明支持。

## 当前阶段

阶段一至阶段三已经通过独立复核并由用户验收。阶段四《可观察状态》已获用户授权，可在 `dev` 实现独立 EVOT Patch、播放器状态面板、隔离 Translation Run、真实 Caption 获取和可操作的脱敏失败恢复。

阶段四不授权 Provider/模型请求、生成上下文、翻译、TTS、Audio Ducking、原生译文字幕、物理设备 Agent 操作、`main` 变更、稳定发布或 YouTube 版本支持声明。阶段五必须等待阶段四独立复核和用户最终验收。

## 资产边界

提交：源码、构建配置、规范、ADR、证据索引、脱敏测试记录、官方文档快照和同步工具。

禁止提交：APK、拆包/反编译输出、DEX、签名材料、API Key、敏感 provider headers、完整字幕请求正文和私有服务凭据。

## 目标环境

- Agent 运行环境以 Codex 项目为先，文档保持平台无关可读。
- 用户提供合法取得的测试 APK；Agent 不负责下载 YouTube APK。
- 首个验证基线为 YouTube `21.04.223`，其他官方稳定版本仅是未来扩展目标。
- 用户最终通过 Morphe App 添加 Source、修补 APK，并执行不超过五项的人工冒烟检查。

## Decision Authority Map

本表只定位决定的权威文本，不复述决定内容。

| Decision ID | Authority |
| --- | --- |
| `CHAR-001` | [目标](#目标) |
| `CHAR-002` | [成功标准](#成功标准) |
| `CHAR-003` | [当前阶段](#当前阶段) |
| `CHAR-004` | [资产边界](#资产边界) |
| `CHAR-005` | [目标环境](#目标环境) |
| `LEARN-000` | [培养路线：原则](./agent-learning-program.md#原则) |
| `LEARN-001` | [培养路线：阶段 0](./agent-learning-program.md#0-决策与记忆基线) |
| `LEARN-002` | [培养路线：阶段 1](./agent-learning-program.md#1-morphe-生态) |
| `LEARN-003` | [培养路线：阶段 2](./agent-learning-program.md#2-官方-voice-over-translation) |
| `LEARN-004` | [培养路线：阶段 3](./agent-learning-program.md#3-开发与构建基线) |
| `LEARN-005` | [培养路线：阶段 4](./agent-learning-program.md#4-可观察状态) |
| `LEARN-006` | [培养路线：阶段 5](./agent-learning-program.md#5-provider-与模型) |
| `LEARN-007` | [培养路线：阶段 6](./agent-learning-program.md#6-调度上下文与音频) |
| `LEARN-008` | [培养路线：阶段 7](./agent-learning-program.md#7-原生字幕技术探针) |
| `LEARN-009` | [培养路线：阶段 8](./agent-learning-program.md#8-source-发布) |
| `EVOT-001` | [EVOT：产品目标](./enhanced-voice-over-translation.md#产品目标) |
| `EVOT-002` | [EVOT：交互](./enhanced-voice-over-translation.md#交互) |
| `EVOT-003` | [EVOT：Translation Run](./enhanced-voice-over-translation.md#translation-run) |
| `EVOT-004` | [EVOT：Provider Profile](./enhanced-voice-over-translation.md#provider-profile) |
| `EVOT-005` | [EVOT：模型发现与配置](./enhanced-voice-over-translation.md#模型发现与配置) |
| `EVOT-006` | [EVOT：Provider 诊断](./enhanced-voice-over-translation.md#provider-诊断) |
| `EVOT-007` | [EVOT：翻译调度](./enhanced-voice-over-translation.md#翻译调度) |
| `EVOT-008` | [EVOT：三层上下文](./enhanced-voice-over-translation.md#三层上下文) |
| `EVOT-009` | [EVOT：TTS 与原声](./enhanced-voice-over-translation.md#tts-与原声) |
| `EVOT-010` | [EVOT：AI 字幕](./enhanced-voice-over-translation.md#ai-字幕) |
| `EVOT-011` | [EVOT：明确不做](./enhanced-voice-over-translation.md#明确不做) |
| `ADR-001` | [Separate development and release trees](../adr/0001-separate-development-and-release-trees.md) |
| `ADR-002` | [Publish Enhanced Voice Over Translation independently](../adr/0002-publish-evot-as-an-independent-patch.md) |
| `ADR-003` | [Use capability-aware OpenAI-compatible Provider Profiles](../adr/0003-openai-compatible-provider-profiles.md) |
| `ADR-004` | [Freeze per-video runs and use timeline context](../adr/0004-freeze-per-video-runs-and-use-timeline-context.md) |
| `ADR-005` | [Probe native captions without an overlay fallback](../adr/0005-probe-native-captions-without-overlay-fallback.md) |
| `ADR-006` | [Do not track upstream Voice Over Translation after derivation](../adr/0006-do-not-track-upstream-vot-after-derivation.md) |
