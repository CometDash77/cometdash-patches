# Validate the release entry gate before phase work

A prerelease-only semantic-release branch list is invalid even when the workflow runs only on `dev`: retain stable `main` in `.releaserc` and keep stable publication blocked through the workflow/runbook boundary. Linux Actions also requires `gradlew` mode `100755`; a Windows-local wrapper invocation does not prove that metadata.

## Evidence

Phase 3 entry runs first failed with `ERELEASEBRANCHES`, then `spawn ./gradlew EACCES`; adding `main` beside prerelease `dev` and restoring the executable bit produced successful workflow `29676589428`.

## Implications

Push the accepted prior-phase SHA first, wait for its exact workflow, and repair/preserve entry failures before creating the next phase's first commit.
