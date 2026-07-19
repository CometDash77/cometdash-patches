# Phase 3 Development and Build Baseline Independent Review

## Review identity and boundary

- Review date: `2026-07-19` (`Asia/Tokyo`).
- Final candidate: `fea2ceeae89097705fdc950db7d67d800a44250a`.
- Phase 3 base: `13e08ab9251ab8a6787e1ac3e08c8709eb8dc52d`.
- Review worktree: isolated `codex/phase3-final-review` worktree; the candidate and `dev` worktree were not edited by the Reviewer.
- Reviewer input: accepted specifications, Phase 1 and Phase 2 reports/reviews, evidence ledger, Phase 3 plan and gate, committed evidence packets, fixed upstream source, and surviving outside-Git artifacts. Implementation reasoning was not requested or used.
- Review boundary: no EVOT product implementation, official Voice over translation installation, physical-device mutation, `main` change, release, provider call, or YouTube support claim. No APK, DEX, key, credential, raw device identifier, decompiled content, or raw log was copied into Git.

## Findings

### Blocking

No Blocking findings.

### Non-blocking

No Non-blocking findings.

## Resolved during review

The initial candidate recorded `compromisedTokenRevocationConfirmed=false`. This was a Blocking security gate because replacement package access cannot revoke a credential exposed in an earlier interaction. The project owner then explicitly confirmed revocation without disclosing a credential value. Candidate `063427f4aec363d16e5aab568e081117fbe76a47` recorded the confirmation in structured evidence, the candidate report, and the ledger. Candidate `fea2ceeae89097705fdc950db7d67d800a44250a` removed one stale sentence that still described confirmation as outstanding. The final candidate consistently records the gate as closed.

## Independent reconstruction

### Scope and Git custody

- The merge base of the Phase 3 base and final candidate is exactly `13e08ab9251ab8a6787e1ac3e08c8709eb8dc52d`.
- The Phase 3 range changes 31 paths. Product modules `patches/` and `extensions/` have zero changed paths.
- The no-op probe is absent from `main`, product metadata, generated Source metadata, and README patch listings.
- Current-tree and per-commit history scans found zero prohibited APK, bundle, DEX, decompiled-output, signing-key, or credential paths. Content scans found no credential value, raw emulator serial, private HTTP endpoint, or user APK absolute path in candidate evidence.
- `git diff --check` passes for the complete base-to-candidate range.

### Toolchain and exact APK

- Independent preflight passed JBR/JDK 21, Gradle 9.6.1, executable wrapper mode, Morphe package access, ADB 37.0.0, emulator acceleration, a pure AOSP image, JADX 1.5.6 plus its pinned archive checksum, and the exact APK checksum.
- The ignored and untracked input APK is 171,814,203 bytes with SHA-256 `78571be679f586d11a4e56fb1ce6bf9dfd958ce6b8af786c4a3bd94792ce8c7c`.
- Android Build Tools independently re-read package `com.google.android.youtube`, version `21.04.223` / `1561052632`, minimum SDK 28, target SDK 36, and the four recorded ABIs.
- Independent signature verification found the two recorded input signer certificate digests and Source Stamp digest and passed the v3 scheme check.
- Static JADX results remain bounded evidence: exit `1`, decompilation failures, literal candidates, and unresolved structural predicates are preserved as failed/partial evidence. The candidate does not claim an obfuscated owner, exact fingerprint match, callback behavior, runtime behavior, or support.

### Empty Source reproducibility

- Build A artifact: 654,811 bytes, SHA-256 `c0c7ece1c6e45eb231353a40d3973f46007a0d91a4e5d3c66be136f050100e65`; raw build-log SHA-256 `66115be121c865b3ce47695bdf6836700b8d32833945198acf4461c2e3c73e06`.
- Build B artifact: 654,812 bytes, SHA-256 `634088096de4376f35da29b2f232646055f6135ed95f1bc5325e016a19afd164`; raw build-log SHA-256 `5204945ce5d58ef1357c09ef09a08c740d292c5d4889eb409825d39418a132a7`.
- Independent ZIP comparison found 13 entries in identical order. Twelve entry contents and compressed sizes match, including `classes.dex` and `extensions/extension.mpe`. Only `META-INF/MANIFEST.MF` differs, solely in the generated millisecond `Timestamp`; its compressed length differs by one byte.
- A fresh isolated `:patches:generatePatchesList` run completed successfully and returned zero loaded Patches. The top-level bundles are therefore not bit-identical, but their accepted structural equivalence and zero-Patch behavior are reproduced.
- The failed package-resolution build, failed Gradle download, offline loader failure, and interrupted comparison worker remain recorded as failures rather than rewritten as successes.

### Development-only no-op probe

- Source inspection confirms one non-default empty `resourcePatch`, one exact YouTube `21.04.223` compatibility target, minimum SDK 28, the two input signer digests, no dependencies/options, and no execute, finalize, extension, bytecode, or raw-resource mechanism.
- A fresh independent checker run built a 9,821-byte bundle and loaded exactly one Patch with the full expected compatibility contract.
- The fresh top-level bundle hash differs from the recorded build hash, as expected from generated archive timestamps; cardinality and loaded Patch semantics, not the unstable archive hash, are the identity check.
- Base-to-candidate product diff count and `main` probe-path count are both zero.

### Frozen Desktop, patching, signing, and installation

- GitHub commit evidence resolves `morphe-desktop@2f5ce39adc26d4b3e7debe44445eddcaf887bffa` to tree `908c2ab5910a3adcd02b6e6dd48cc0d1d862ff5b`.
- The verified owner-supplied archive is 10,753,027 bytes with SHA-256 `3fe0bc2c36876d579cb7c90f4a3fd8f7f78153dac946adb2b51e07301fec91ab`. It opens with 271 entries under the single expected fixed-SHA root.
- A same-named failed transfer under `C:\tmp\phase3-morphe-desktop` is a distinct 7,368,809-byte partial with SHA-256 `67b2ae80d1dfa7e2065b4a2e36528db1176944ec6a025126a07f08f996d763e4`; it does not open as a ZIP and was correctly retained only as failed transport evidence.
- The completed Desktop JAR is 117,967,075 bytes with SHA-256 `a21904e0793717b51bcbb8ccf0d22ee107793abec24863dfd2b0d5d11b998af7`, declares `app.morphe.MorpheLauncherKt`, and returns CLI help with exit `0`. The earlier incomplete JAR remains explicitly rejected evidence.
- The signed output is 173,137,343 bytes with SHA-256 `8b75b93ec26de72da4a47b45b072b645e6e0d68487d3b7e2e7f03be9e405168c`. Independent Android metadata and v3 signature checks match version `21.04.223` / `1561052632` and signer SHA-256 `9bb036dbd7cbeb756a2d42571d67995820be67f5ba9a2abe6624a5212cb4f1db`.
- The patch-result artifact hash `6fbb433a7f061c50bd469b0edcdb5c7a0d03609176cc8a4eb38ab64a409195b4` records one applied no-op Patch, zero failed Patches, and successful patching, rebuilding, and signing stages.
- The install log is 38 bytes with SHA-256 `c4aa470acafcf8576c15b0f0b5ae7e852d1ec5413372d0e6a9272e788e1306d3`, matching the committed evidence packet. The packet records one explicit-target install, no replace/uninstall, AOSP/QEMU verification, no physical transport, package absence before installation, install success, and the correct package version afterward.

### Safety and evidence handling

- Thirty-three surviving raw evidence text files were scanned without printing their contents. No credential value, authorization/cookie value, raw emulator serial, private HTTP endpoint, or token-shaped value was found.
- No signing material, DEX, or decompiled output is present in the patch/install evidence directory. The signed APK and raw evidence remain outside Git.
- Learning records preserve the failed release workflows, download races/timeouts, package-authentication failure, Windows/tool transport failures, incomplete Desktop build, CLI parse failure, and the post-install harness false negative.
- The credential revocation confirmation is recorded as an owner statement, which is the available evidence class; no credential value or provider-side secret record was requested or retained.

## Reproduced checks

| Check | Result |
| --- | --- |
| `tools/check_phase3_preflight.ps1` | PASS: JDK/Gradle/package access/ADB/AOSP/JADX/archive/APK custody. |
| `tools/check_phase3_noop_probe.ps1` | PASS: fresh 9,821-byte bundle; one loadable non-mutating Patch. |
| `:patches:generatePatchesList` in a disposable worktree | PASS: build succeeded; loaded Patch count `0`. |
| Independent ZIP inventory and entry hashing | PASS: 13 ordered entries; only generated manifest timestamp differs. |
| Independent `aapt` and `apksigner` checks | PASS for exact input and signed output metadata/signatures. |
| `tools/check_documentation.ps1` | PASS: 48 Markdown files, 6 ADRs. |
| `tools/sync_upstream_docs.ps1 -Check` | PASS: recorded/current revision `37b5eeb9c690ea169937fc2bac197bdcdb269014`. |
| `tools/check_phase3_postflight.ps1 -BaseSha 13e08ab...` | PASS on the final candidate. |
| `git diff --check 13e08ab...fea2cee` | PASS. |
| Final credential-status consistency check | PASS: structured boolean is `true`; no stale open-revocation statement remains. |

## Residual limits

- The disposable AVD had already been deleted before final review completion, so the Reviewer could not perform a live package-manager postcheck. The review relies on the hashed install log, structured packet, signed artifact, and preserved redacted outputs; no AVD was recreated.
- The app was not launched. Startup, Google service behavior, no-op runtime behavior, official Voice over translation behavior, fingerprint execution, UI, audio, and YouTube support remain unverified.
- The Desktop archive has verified fixed-SHA content/layout provenance but no local Git metadata.
- Empty and probe bundle top-level hashes are timestamp-sensitive; only the documented normalized structure and loaded contracts are reproducibility claims.
- This review validates only the exact APK hash and recorded toolchain. It does not establish a release gate or compatibility for any other APK.

## Verdict

**PASS**

The Phase 3 development/build baseline is independently reconstructible and satisfies the technical gate: exact-APK custody, two structurally equivalent zero-Patch builds, isolated no-op loading, frozen Desktop provenance, patch/sign output, disposable-emulator install evidence, safety controls, failed-experiment preservation, and scope boundaries all pass. The previously open credential-revocation gate is resolved in the final candidate.

This PASS is technical review evidence only. Phase 3 is not accepted on the project owner's behalf. **Phase 4 remains locked until the project owner explicitly accepts Phase 3 and that acceptance is recorded in the evidence ledger.** This review does not authorize EVOT implementation, release, physical-device work, or a YouTube support claim.
