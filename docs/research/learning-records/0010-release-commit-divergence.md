# Learning Record 0010: Integrate generated release commits without rewriting reviewed history

## Context

Semantic release can push a generated prerelease commit to `origin/dev` after a successful workflow while local Phase work continues from the workflow input SHA.

## Failed signal

`git push origin dev` was rejected because local `dev` was ahead while `origin/dev` contained one generated release commit. After merging that commit, the no-op probe checker falsely attributed generated release metadata changes to the probe because it scanned `PHASE3_BASE_SHA..HEAD`.

## Recovery

1. Fetch and inspect both sides before choosing an integration strategy.
2. Preserve reviewed commit identities by merging the generated release commit instead of rebasing or force-pushing.
3. Scope component-isolation checks to the commits that introduced the component, while keeping independent current-tree and `main` projection checks.
4. Rerun the complete candidate gates after integration.

## Prevention

- Expect semantic release to advance `dev` independently after a workflow.
- Never force-push over a generated release commit.
- Do not use an ever-growing phase range to assign ownership of changes to one development probe.
