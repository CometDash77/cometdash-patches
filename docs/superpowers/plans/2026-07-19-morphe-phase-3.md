# Phase 3 Development and Build Baseline Plan

> **For agentic workers:** Use `mattpocock-skills:implement`. Execution and research workers use `gpt-5.6-terra`; the final independent Reviewer uses `gpt-5.6-sol`.

**Goal:** Establish a reproducible empty Patch Source build and redacted hash, inspection, patching, signing, and disposable-emulator installation evidence for the user-supplied YouTube `21.04.223` APK.

**Architecture:** The primary coordinator integrates on `dev`. Fresh-context Terra workers operate in read-only or isolated temporary worktrees and return evidence packets. Product modules remain empty; a no-op probe lives under `tools/` and cannot enter the stable projection. A separate Sol Reviewer receives artifacts and raw evidence, but no implementation reasoning.

## Boundary

Phase 3 may install development tools, inspect the user-supplied APK, build the empty Source and dev-only probe, and install only on a disposable AOSP emulator. It does not authorize EVOT product code, official VoT installation, a physical-device install or uninstall, `main` changes, a stable release, or a YouTube support claim.

## Entry Gate

- Accepted Phase 2 candidate: `8a2469ae3fb36730fc9ebf2a9b7ace1b846b440b`.
- Initial push workflow `29676400093` failed because semantic-release had no stable release branch.
- Prerequisite commit `d7b70a9d92a0260a267ec37a01d6e785eca7fd86` restored the pinned `main` plus prerelease `dev` topology; workflow `29676512098` then exposed the non-executable Gradle wrapper.
- Prerequisite commit `13e08ab9251ab8a6787e1ac3e08c8709eb8dc52d` restored mode `100755` on `gradlew`.
- Workflow `29676589428` completed successfully for `13e08ab9251ab8a6787e1ac3e08c8709eb8dc52d`. This is `PHASE3_BASE_SHA`.

## Execution Waves

1. Freeze this plan and commit it as `docs: plan phase three build baseline`.
2. Dispatch `toolchain-auditor`, `android-tooling-auditor`, and `safety-auditor` in parallel. Integrate a reusable preflight checker, development runbook, and gate rubric; commit `chore: establish phase three preflight`.
3. Dispatch `apk-custodian` and `fingerprint-auditor`. Record only APK metadata, certificate digest, static match facts, evidence limits, and failed checks; commit `docs: record target apk baseline`.
4. Run two clean empty-source builds in isolated directories while `artifact-inspector` checks loadability, zero Patch objects, normalized structure, and forbidden content. Commit `docs: verify empty source builds`.
5. Have `noop-probe-builder` create the dev-only exact-version no-op Patch and `probe-reviewer` prove it is excluded from product modules and stable projection. Commit `chore: add phase three no-op patch probe`.
6. Prepare frozen Morphe Desktop and a disposable AOSP emulator in parallel. Patch and sign a copy of the exact APK, install it only on that emulator, and verify package metadata. Commit `docs: record phase three install evidence`.
7. Consolidate the report and candidate ledger entry; run all automated gates and commit `docs: complete phase three candidate`.
8. Give the candidate SHA, plan, rubric, artifacts, redacted raw evidence, and fixed sources to an independent Sol Reviewer. Commit its unmodified report as `docs: review phase three build baseline`.
9. Present the candidate and review findings to the user. Only after explicit approval record the gate as `docs: complete phase three gate`.

## Required Interfaces and Evidence

- `tools/check_phase3_preflight.ps1` returns nonzero for missing or mismatched JDK, Gradle, JADX, Android SDK/ADB, package credentials, build inputs, or repository safety checks. It prints versions and paths, never credential values.
- Pin JADX `1.5.6`; verify `jadx-1.5.6.zip` SHA-256 `545ea2be9c242511bc145755cf4bda2485ade42966e096f8b4d3da2a230e8974`.
- Record baseline commit, commands, tool versions, artifact hashes, normalized bundle inventories, APK metadata, a hashed emulator identifier, results, evidence class, and evidence limits.
- Two clean builds must both succeed and yield structurally equivalent loadable bundles with zero selectable Patches. Preserve both hashes and explain any timestamp-only archive differences.
- The no-op probe stays outside `patches/`, `extensions/`, generated release metadata, and the `main` allowlist.

## Acceptance

- JDK 21+, Gradle 9.6.1, Morphe dependencies, JADX 1.5.6, and ADB are executable through recorded paths.
- The APK remains ignored and untracked at 171,814,203 bytes and SHA-256 `78571be679f586d11a4e56fb1ce6bf9dfd958ce6b8af786c4a3bd94792ce8c7c`.
- Empty-source reproducibility, no-op probe build, patch/sign, and disposable-emulator installation checks pass.
- No APK, patched output, signing material, credential, DEX, JADX tree, private device identifier, or unredacted log enters Git.
- Documentation, upstream freshness, diff, build, safety, probe, and independent-review gates pass.

Any failed experiment remains failed evidence. Phase 4 stays blocked until all Reviewer findings are resolved and the project owner explicitly accepts Phase 3.
