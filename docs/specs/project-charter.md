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

当前阶段仅持久化已经确认的决策。完成文档门禁前禁止开始阶段一架构研究或功能实现。

文档门禁通过后的下一项工作是阶段一《Morphe 生态架构分析报告》。阶段一不得编写 Patch。

## 资产边界

提交：源码、构建配置、规范、ADR、证据索引、脱敏测试记录、官方文档快照和同步工具。

禁止提交：APK、拆包/反编译输出、DEX、签名材料、API Key、敏感 provider headers、完整字幕请求正文和私有服务凭据。

## 目标环境

- Agent 运行环境以 Codex 项目为先，文档保持平台无关可读。
- 用户提供合法取得的测试 APK；Agent 不负责下载 YouTube APK。
- 首个验证基线为 YouTube `21.04.223`，其他官方稳定版本仅是未来扩展目标。
- 用户最终通过 Morphe App 添加 Source、修补 APK，并执行不超过五项的人工冒烟检查。
