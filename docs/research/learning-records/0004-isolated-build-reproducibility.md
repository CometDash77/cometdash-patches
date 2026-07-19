# Compare build semantics below the archive hash

Independent builds can be structurally reproducible without being byte-identical. Compare ordered ZIP entries, uncompressed content hashes, compressed content hashes, manifests, DEX, and extension artifacts before deciding whether a top-level hash difference is meaningful.

## Evidence

The two empty Source bundles differed by one byte and had different top-level hashes. All non-manifest entries were identical; the only semantic input difference was the generated millisecond `Timestamp` in `META-INF/MANIFEST.MF`. A disposable-worktree `generatePatchesList` run exercised `loadPatchesFromJar` and returned zero Patches.

## Implications

Give independent builds separate worktrees and caches preseeded from the same verified distribution. Run loader tasks only in a disposable worktree when they rewrite tracked generated metadata, restore the file afterward, and prove the worktree clean.
