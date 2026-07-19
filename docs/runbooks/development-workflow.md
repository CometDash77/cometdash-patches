# Development and Build Workflow

## Purpose

This runbook establishes the Phase 3 development baseline without adding an EVOT product Patch or claiming support for a YouTube version. Run all commands on `dev`; keep APKs, generated bundles, patched outputs, JADX trees, signing material, emulator data, and raw logs outside the repository under a fresh `C:\tmp\phase3-*` directory.

## Preflight

1. Confirm the accepted Phase 3 base and a clean tracked worktree.
2. Supply GitHub Packages credentials as one complete pair: `gpr.user` plus `gpr.key` in the user Gradle properties file, or `GITHUB_ACTOR` plus `GITHUB_TOKEN` in the process environment. Never print either value.
3. Run `tools/check_phase3_preflight.ps1`. It resolves JDK and Android tools by explicit path because they need not be on `PATH`.
4. Stop on any missing tool, credential half, APK mismatch, unsafe repository state, or non-AOSP emulator input.

## Tool Pins

- JDK: 21 or newer; the accepted local observation is Android Studio JBR 21.0.10.
- Gradle wrapper: 9.6.1 with the checksum in `gradle-wrapper.properties`.
- JADX: 1.5.6 from the official release archive, verified before extraction against SHA-256 `545ea2be9c242511bc145755cf4bda2485ade42966e096f8b4d3da2a230e8974`.
- Android tooling: SDK command-line tools, ADB 37.0.0, emulator acceleration, and a `default` x86_64 AOSP image. Google APIs and Play Store images are not accepted.

## Empty Source Builds

Create two isolated worktrees or clean source copies from the same candidate SHA. Give each its own build directory and run `:patches:buildAndroid`. Record command labels, exit codes, tool versions, artifact SHA-256 values, and normalized archive inventories. Both bundles must load with zero selectable Patches. If hashes differ, attribute every normalized difference; unexplained differences block the gate.

## APK Custody and Inspection

Record only the supplied filename, version, byte size, SHA-256, package metadata, ABI set, minimum SDK, and signer certificate digest. JADX output stays in the temporary work area. Evidence may state verified match signals and limits, but must not copy decompiled source, obfuscated class names inferred without evidence, raw manifest payloads, or APK content into Git.

## No-op Probe

The exact-version no-op Patch is a development probe under `tools/`, not a product Patch. It performs no bytecode or resource mutation and must not appear in `patches/`, `extensions/`, generated Source metadata, README patch listings, or `main`. Use it only to prove build, Patch loading, output signing, and installation orchestration.

## Disposable Emulator Installation

1. Provision a new uniquely named AVD from a pure `default` AOSP image; never reuse an existing AVD.
2. Launch with wipe-data and snapshots disabled. Require exactly one selected transport whose serial begins with `emulator-` and whose `ro.kernel.qemu` value is `1`.
3. Confirm `com.google.android.youtube` is absent before installation. Stop rather than using replace or uninstall behavior.
4. Address every ADB call with `-s`. Install without `-r`; verify only package/version metadata afterward.
5. Persist only SHA-256 of the emulator serial, then stop and delete the disposable AVD data.

## Evidence and Postflight

Commit structured redacted evidence, not raw logs. Never include raw serials, credentials, sensitive headers, private endpoints, full APK paths, signing keys, or request bodies. Run `tools/check_phase3_postflight.ps1 -BaseSha <PHASE3_BASE_SHA>`, the documentation checks, upstream freshness, build checks, and `git diff --check`. Preserve failed experiments as failures and stop before Phase 4.
