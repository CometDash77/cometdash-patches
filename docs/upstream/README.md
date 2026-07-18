# Upstream Documentation Snapshots

此目录保存只存在于 `dev` 的官方文档快照。快照用于离线复核和固定证据，不代表上游当前状态，也不接受本项目解释性修改。

- 来源与 revision：`manifest.json`
- 新鲜度检查：`pwsh -File tools/sync_upstream_docs.ps1 -Check`
- 显式同步：`pwsh -File tools/sync_upstream_docs.ps1`

同步后必须审阅完整 diff，并更新 `docs/research/evidence-ledger.md` 中受影响的结论。不得把该目录投影到 `main`。
