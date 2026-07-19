# Bound Windows tools and subagent retries

Use PowerShell 7 (`pwsh`) for Phase 3 scripts that depend on modern .NET APIs; Windows PowerShell 5 is not equivalent. A subagent that has produced partial evidence but stops making progress should be interrupted, its artifacts preserved, and the missing check independently rerun by the coordinator.

## Evidence

The postflight script failed under Windows PowerShell 5 because `System.IO.Path.GetRelativePath` was unavailable and passed under `pwsh` 7. The artifact-comparison worker wrote entry CSVs but stalled before loader verification; after interruption, the coordinator completed the loader proof in a disposable worktree.

## Implications

Prompts must name the executable, timeout, worktree, expected artifact, and stop condition. Do not silently retry network/build failures or let concurrent workers write the same file; preserve failed evidence and choose one owner for recovery.
