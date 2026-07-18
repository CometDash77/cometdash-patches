# Morphe Phase 0-1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the documentation gate, then produce and independently review the Phase 1 Morphe ecosystem architecture report without implementing a Patch.

**Architecture:** Work only on `dev`. Treat documentation, evidence, automated gates, independent review, and explicit user authorization as sequential gates; no later phase begins until the preceding gate is approved.

**Tech Stack:** Markdown, PowerShell, Git, GitHub REST API via `gh`.

---

## Summary

目标是先关闭文档门禁，再完成阶段一《Morphe 生态架构分析报告》。全程只修改 `dev` 的文档与门禁工具，不编写 Patch、不修改 `main`、不声明任何 APK 已受支持。

当前规划快照发现 21 个未归档 MorpheApp 仓库；阶段一开始时必须重新查询并冻结 revision。

## Atomic Steps

### Task 1：冻结执行基线

- [ ] 运行 `git status --short --branch`，确认当前分支为 `dev` 且工作树为空。
- [ ] 运行 `git rev-parse HEAD`，记录为 `PHASE0_BASE_SHA`。
- [ ] 运行 `pwsh -NoProfile -File tools/check_documentation.ps1`，保存完整输出。
- [ ] 运行 `pwsh -NoProfile -File tools/sync_upstream_docs.ps1 -Check`，确认 recorded 与 upstream revision 相同。
- [ ] 将本计划原文保存到指定计划文件，不加入额外实施推理。

### Task 2：修正文档矛盾与证据缺口

- [ ] 在 `project-charter.md` 增加 Decision Authority Map，只映射、不重复决定内容。
- [ ] 使用 `CHAR-001..005` 映射章程五个现有章节。
- [ ] 使用 `LEARN-000` 映射培养路线原则，`LEARN-001..009` 映射阶段 0-8。
- [ ] 使用 `EVOT-001..011` 映射 EVOT 规范的十一个现有产品章节。
- [ ] 使用 `ADR-001..006` 映射六份 ADR。
- [ ] 将 EVOT 版本表述改为首个验证候选；只有 exact APK 通过 release gate 后才声明支持。
- [ ] 将 Markdown 门禁明确为所有相对文件目标必须存在；不可修改的上游 snapshot fragment 由 evidence ledger 记录。
- [ ] 在 evidence ledger 记录上游 `troubleshooting.md:85` 指向 `questions.md#11-...` 的 fragment 错误及正确目标，不修改 vendored snapshot。
- [ ] 将 PR #1685 评论证据改为 Contributor discussion，并记录 `author_association=CONTRIBUTOR`。
- [ ] 删除不可复现的 native CC 全局缺失断言，只保留 injection point 为 `Unverified`。
- [ ] 删除 persistent translation-result cache 的目录级缺失断言，保留 `TtsCache.java` 正面事实。
- [ ] 为 template 的 `.releaserc`、release workflow、README 添加 commit 与 exact file path 永久链接。
- [ ] 在 ADR 0001 和 repository workflow 的 backmerge 断言旁加入 pinned `.releaserc` 引用。
- [ ] 为 vendored official documentation 的结论补具体 pinned README/文档路径。
- [ ] 运行文档检查、新鲜度检查和 `git diff --check`。
- [ ] 提交为 `docs: close documentation evidence gaps`。

### Task 3：补强自动门禁

- [ ] 在 `.gitignore` 增加 environment、credential、secret、signing 和 decompiled-output ignore 规则。
- [ ] 扩展 `check_documentation.ps1` 的 tracked-sensitive patterns。
- [ ] 增加 `git check-ignore --no-index` sentinel 检查。
- [ ] 反向比较全部 CONTEXT 文件与 `CONTEXT-MAP.md`。
- [ ] 按 repository workflow 的 allowlist 验证 `main` 每个路径。
- [ ] 用临时未映射 context 验证失败路径，再删除 sentinel。
- [ ] 运行 sensitive sentinel、freshness check 与 `git diff --check`。
- [ ] 提交为 `chore: harden documentation gate`。

### Task 4：冻结用户接受的决策基线

- [ ] 向用户展示 Decision Authority Map、两个修复提交及完整 diff 摘要。
- [ ] 请求用户明确确认映射到的现有章程、路线、EVOT 规范和 ADR 构成完整决策基线。
- [ ] 用户未明确确认时停止，不派发 Reviewer。
- [ ] 用户确认后，在 evidence ledger 记录确认时间、确认对象和被确认的 commit SHA。
- [ ] 运行文档检查并提交为 `docs: record accepted decision baseline`。

### Task 5：独立文档门禁审查

- [ ] 启动一个没有本会话推理历史的独立 Reviewer。
- [ ] 仅提供 accepted plan、固定 commit、仓库树、Decision Authority Map、文档 artifacts、rubric、raw sources 和检查原始输出。
- [ ] Reviewer 检查 decision ID 唯一性、文档一致性、证据锚点、安全和分支边界。
- [ ] Reviewer 输出 `docs/research/2026-07-18-documentation-gate-review.md`，包含 baseline SHA、输入、命令、findings 和 verdict。
- [ ] Blocking finding 出现时停止并制定 finding-specific 微型计划。
- [ ] PASS 后由 Reviewer 提交审查报告并交用户授权 Phase 1。
- [ ] 用户授权 Phase 1 后，在 ledger 记录授权及 review commit。
- [ ] 运行文档检查与 freshness check，提交为 `chore: authorize phase one`。

### Task 6：冻结 Morphe 官方仓库清单

- [ ] 记录 `PHASE1_BASE_SHA`。
- [ ] 查询 MorpheApp 的 `public_repos` 数量和全部仓库 metadata。
- [ ] 冻结每个未归档仓库的 default branch HEAD SHA。
- [ ] 在 architecture report 建立完整 inventory。
- [ ] 将每个仓库恰好归为 `Direct`、`Supporting` 或 `Excluded`，并给出源码级理由。
- [ ] 不 clone、vendor 或提交上游源码。

### Task 7：追踪 Patch 生命周期

- [ ] 追踪 `.mpp` 构建、metadata 生成与发布。
- [ ] 追踪 official Patch 定义进入 Patch Bundle。
- [ ] 追踪 Manager 和 Desktop 的 Source、download、load 与 selection 路径。
- [ ] 追踪 morphe-patcher 的 APK resource/DEX mutation、repackage、sign 与 install 边界。
- [ ] 每条调用边记录 producer、input、consumer、output 和 `repo@SHA:path`。
- [ ] 区分 Manager orchestration 与 Patcher APK mutation，不根据名称推测行为。

### Task 8：完成阶段一报告

- [ ] 写明范围、采集时间、分类与排除规则。
- [ ] 加入 repository inventory、责任矩阵、Mermaid 生命周期图和 artifact 输入输出表。
- [ ] 用固定源码回答三个阶段一必答问题。
- [ ] 单列 Unverified facts 及其后续阻断影响。
- [ ] 更新 evidence ledger 的核心 revisions 和具体文件。
- [ ] 验证所有源码链接固定 SHA、inventory 完整、文档检查和 freshness check 通过。
- [ ] 确认 Phase 1 仅修改计划与 `docs/research`，提交 architecture report。

### Task 9：阶段一独立门禁

- [ ] 启动新的无推理历史 Reviewer。
- [ ] Reviewer 复核 inventory、生命周期边、三个必答问题和阶段边界。
- [ ] Reviewer 输出 `docs/research/2026-07-18-morphe-ecosystem-review.md`。
- [ ] Blocking finding 出现时停止并制定微型计划。
- [ ] PASS 后交用户作最终阶段一决定。
- [ ] 用户批准后在 ledger 记录授权并提交。
- [ ] 到此停止；Phase 2 必须另行研究和规划。

## Interfaces And Tests

不改变任何产品 API、Patch namespace、Gradle artifact 或 release metadata。新增接口仅是文档契约：Decision ID 映射、Reviewer 报告格式、repository inventory 字段和 evidence classification。

验收覆盖正常文档树、未映射 context、敏感 sentinel、`main` allowlist、immutable upstream snapshot、固定 SHA 引用、完整 repository inventory，以及 Reviewer 与用户两级门禁。

## Assumptions

- 计划终点是阶段一用户门禁，不包含官方 VoT 研究或 Patch 实现。
- 报告正文使用中文，canonical identifiers、类名和 artifact 名保持英文。
- 上游 snapshot 的错误 fragment 只记录，不本地修补。
- Reference-style Markdown link parser 暂不新增；当前本地文档没有使用该格式。
- 任一 Reviewer 返回 `BLOCKED` 或用户未明确授权时，执行立即停止。
