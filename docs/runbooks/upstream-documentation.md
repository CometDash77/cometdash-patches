# Upstream Documentation Sync

Official Morphe documentation is vendored only on `dev` for reproducible research. It is not forked or edited locally.

## Check freshness

```powershell
pwsh -File tools/sync_upstream_docs.ps1 -Check
```

A nonzero exit means the upstream `main` revision differs from the manifest.

## Sync explicitly

```powershell
pwsh -File tools/sync_upstream_docs.ps1
```

After syncing:

1. Review every upstream diff.
2. Update evidence ledger conclusions affected by the change.
3. Run the documentation gate.
4. Commit the snapshot, manifest and interpretation changes together on `dev`.

Never copy the snapshot into `main` and never silently replace a pinned citation with a moving branch URL.
