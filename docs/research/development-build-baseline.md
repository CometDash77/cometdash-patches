# Phase 3 Development and Build Baseline

## 1. Scope and status

This candidate records the Phase 3 development baseline for `dev` without implementing EVOT or claiming YouTube support. Runtime-input facts apply only to the user-supplied APK identified below. Decompiled output, APKs, generated bundles, signing material, emulator data, and raw logs remain outside Git.

- Phase 3 base: `13e08ab9251ab8a6787e1ac3e08c8709eb8dc52d`.
- Plan commit: `5ecc000558ed3fc69df5dd5a1b73d1021b98cc8d`.
- Status: candidate in progress; probe, patch/sign/install, review, and user gates remain open.

## 2. Entry and toolchain evidence

| Evidence | Result | Evidence class and limit |
| --- | --- | --- |
| Remote entry | Workflows `29676400093` and `29676512098` failed on branch topology and wrapper mode; prerequisite commits `d7b70a9...` and `13e08ab...` resolved them; workflow `29676589428` passed. | Git/GitHub workflow evidence; no release or product support implication. |
| JDK | Android Studio JBR `21.0.10`; Java and javac resolved by explicit path. | Local tool observation. |
| Gradle | Wrapper and executable `9.6.1`; official 140,682,664-byte distribution matched pinned SHA-256 `9c0f7faeeb306cb14e4279a3e084ca6b596894089a0638e68a07c945a32c9e14`. | Local tool observation; later builds prove dependency/configuration behavior. |
| JADX | Official `1.5.6` archive, 72,646,741 bytes, matched SHA-256 `545ea2be9c242511bc145755cf4bda2485ade42966e096f8b4d3da2a230e8974`. | Official release artifact plus local checksum. |
| Android | ADB `37.0.0`, accelerated emulator available, Android 35 `default/x86_64` pure AOSP image installed. | Local tool observation; no AVD/install claim yet. |
| Package credentials | One complete process-local GitHub credential pair passed presence checks without exposing values. | Presence only; build resolution remains the behavioral check. |

The first JADX transfer timed out and an interrupted resume left two writers on one partial file; both processes and the partial file were discarded. A single BITS transfer then produced the verified archive. Gradle wrapper downloads failed first at 10 seconds and later after four bounded attempts because of resets/timeouts; a single BITS transfer from the same official URL produced the wrapper-checksum-matching distribution. These are preserved local transport failures, not upstream artifact failures.

The first credential refresh attempts failed because GitHub's device-flow endpoint timed out. A token was then mistakenly entered into a non-secret username prompt and appeared in the interaction transcript. The resulting local credential file was deleted without being read, that token was treated as compromised, and a replacement token was entered only through a hidden prompt. The replacement returned HTTP `200` for the pinned Morphe plugin artifact. Explicit owner confirmation that the compromised token was revoked remains required before the Phase 3 gate can pass.

`tools/check_phase3_preflight.ps1` passed all JDK, Gradle, credential-presence, Android, AOSP, JADX, archive-hash, APK-hash, and repository custody checks after provisioning.

## 3. Exact APK custody

Evidence class: `Runtime input`. Metadata was read with Android Build Tools 37.0.0. The APK was not copied, unpacked, installed, or modified during custody collection.

| Field | Observed value |
| --- | --- |
| Filename | `com.google.android.youtube_21.04.223-1561052632_minAPI28(arm64-v8a,armeabi-v7a,x86,x86_64)(nodpi)_apkmirror.com.apk` |
| Size | `171814203` bytes |
| SHA-256 | `78571be679f586d11a4e56fb1ce6bf9dfd958ce6b8af786c4a3bd94792ce8c7c` |
| Package | `com.google.android.youtube` |
| Version | `21.04.223` (`1561052632`) |
| SDK | minimum `28`; target `36` |
| ABIs | `arm64-v8a`, `armeabi-v7a`, `x86`, `x86_64` |
| v3.1 signer certificate SHA-256 (SDK 33+) | `5aad2bee6db95d17e05a08d7d1e64c10a1511879154483916b6ae6c7fd9cb0c6` |
| v3.0 signer certificate SHA-256 (SDK 24-32) | `3d7a1223019aa39d9ea0e3436ab7c0896bfb4fb679f4de5fe7c23f326c8f994a` |
| Source Stamp certificate SHA-256 | `3257d599a49d2c961a471ca9843f59d341a405884583fc087df4237b733bbd6d` |
| Git custody | Ignored by root `*.apk`; untracked. |

A direct PowerShell `aapt` call split the comma-containing filename and failed. A per-argument process invocation succeeded. The SDK `apksigner.bat` wrapper also failed in the local environment; invoking its bundled JAR with the explicit accepted JBR succeeded. Neither command-transport failure is an APK parse or signature failure.

## 4. Static fingerprint recheck

JADX `1.5.6 --no-res` exited `1` with `198` decompilation errors. Temporary output contained 47,298 Java files, of which 101 contained a JADX error marker. The results are candidate static evidence only.

| Domain | Result | Limit |
| --- | --- | --- |
| Playback time | The documented literal occurred in one candidate. | Invoke/field structure, owner, callback, and runtime behavior remain unverified. |
| AudioSink volume | The documented failure literal occurred in one candidate with at least one documented parent anchor. | Child opcode/access match, owner, injection point, and audio behavior remain unverified. |
| Legacy controls | `ViewStub` occurred in 177 files and `inflate` in 107. | Required producer/result relation was not proven; this is not a fingerprint match. |
| AudioTrack wrapper | `AudioTimestamp` occurred in 8 files; 3 also contained `AudioTrack`. | Constructor/order/visibility/five-instruction constraints were not proven. |
| Video ID, modern overlay, player state | Phase 2 provides no stable literal/opcode/owner sufficient for an independent query. | No target owner or match claim. |

No obfuscated owner, exact fingerprint compatibility, Patch application, UI rendering, callback cadence, audio effect, runtime behavior, or YouTube support is established by this recheck.

## 5. Empty Patch Source reproducibility

The two successful builds used separate detached worktrees at `9f9506f86f50ef5f0a7c82c8c795e87c0faecd9b`, separate Gradle user homes, the same checksum-verified Gradle distribution, JBR 21.0.10, and process-local package credentials. Both worktrees were clean after their checks. Structured evidence is committed in [`empty-builds.json`](./phase3-evidence/empty-builds.json).

| Build | Command label | Result | Bundle |
| --- | --- | --- | --- |
| A | `empty-build-a2/clean-buildAndroid` | Exit `0`; 27 tasks executed and one up-to-date. | 654,811 bytes; SHA-256 `c0c7ece1c6e45eb231353a40d3973f46007a0d91a4e5d3c66be136f050100e65`. |
| B | `empty-build-b2/clean-buildAndroid` | Exit `0`; formal clean build passed after an isolated-cache prewarm. | 654,812 bytes; SHA-256 `634088096de4376f35da29b2f232646055f6135ed95f1bc5325e016a19afd164`. |

Both archives contained the same 13 entries in the same order. Twelve entries, including `classes.dex`, `extensions/extension.mpe`, the Kotlin module, and every class, had identical uncompressed and compressed content hashes. `META-INF/MANIFEST.MF` differed only in its generated millisecond `Timestamp`; that changed its CRC, compressed hash, and compressed length by one byte. The top-level bundles are therefore not bit-for-bit reproducible, but they meet the accepted structural-equivalence rule with fully attributed build-time metadata variance.

Static inspection found only the list generator/model classes and no Patch implementation class. A disposable-worktree run of `:patches:generatePatchesList` exercised `loadPatchesFromJar` and produced `patch_count=0`; the generated tracked metadata file was restored and the worktree returned clean. An initial offline loader attempt failed while applying the Gradle plugin with an unclassified `IllegalArgumentException`; the credentialed attempt passed, so the offline-cache behavior remains a non-gating failed check.

The earlier Build A attempt failed at Morphe plugin resolution before the replacement package credential existed. The earlier Build B attempt failed while downloading Gradle through the wrapper. A comparison worker produced entry-level CSV evidence but stalled during loader verification and was interrupted; the coordinator independently completed the loader proof. None of these failures is rewritten as a successful attempt.

## 6. Development-only no-op probe

The standalone project under `tools/probes/phase3-noop` declares exactly one non-default `resourcePatch` named `Phase 3 no-op Patch probe`. It has one compatibility record: `com.google.android.youtube`, APK required, version `21.04.223`, minimum SDK 28, and the two verified input signer digests. Its Patch body is empty and it declares no execute/finalize hook, extension, dependency, option, bytecode Patch, or raw-resource mechanism.

The build-time verifier loaded exactly one Patch and checked the complete compatibility contract. The integrated checker built a 9,821-byte bundle with SHA-256 `bcedfa996c53ef8f47216ba55f5b6553e4e1beca94cbeb35925dc9d358dc2779`. A fresh Terra review returned `PASS` with no Blocking findings; its one non-blocking finding about product-path comparison against `HEAD` was resolved by checking `PHASE3_BASE_SHA..HEAD`. The probe changes only `tools/` and is absent from product modules, generated Source metadata, README patch listings, and `main`.

## 7. Patch, sign, and disposable-emulator install

Structured results are committed in [`probe-install.json`](./phase3-evidence/probe-install.json).

### 7.1 Frozen Desktop host

GitHub's commit API resolved `morphe-desktop@2f5ce39adc26d4b3e7debe44445eddcaf887bffa` to tree `908c2ab5910a3adcd02b6e6dd48cc0d1d862ff5b`. Git clone, fixed-SHA fetch, direct codeload, and BITS attempts failed through timeout, connection reset, a shallow-lock race, or a zero-byte Game Mode transfer. The project owner supplied the official fixed-SHA archive; it contained 271 entries under the expected sole root, was 10,753,027 bytes, and had local SHA-256 `3fe0bc2c36876d579cb7c90f4a3fd8f7f78153dac946adb2b51e07301fec91ab`. It is source-equivalent fixed content without local Git metadata.

The first `shadowJar` continuation reached the task but did not exit; its observed 3,863,661-byte JAR lacked `Main-Class` and failed `java -jar --help`, so it was rejected as incomplete. After the dependency cache was populated, a coordinator-run `clean shadowJar` exited `0` in 44 seconds. The final `morphe-desktop-1.11.0-all.jar` was 117,967,075 bytes, SHA-256 `a21904e0793717b51bcbb8ccf0d22ee107793abec24863dfd2b0d5d11b998af7`, declared `app.morphe.MorpheLauncherKt`, and returned CLI help with exit `0`.

### 7.2 Patch and signing result

The first CLI attempt passed the Patch name through a process argument containing spaces; it was split and failed parsing with exit `2` before creating output, result, or key material. Because the bundle verifier proves cardinality one, the corrected attempt used Patch index zero with exclusive selection.

The corrected Desktop run exited `0` and reported package `com.google.android.youtube`, version `21.04.223`, one applied `Phase 3 no-op Patch probe`, zero failed Patches, and successful PATCHING, REBUILDING, and SIGNING steps. The signed output was 173,137,343 bytes with SHA-256 `8b75b93ec26de72da4a47b45b072b645e6e0d68487d3b7e2e7f03be9e405168c`; Android Build Tools re-read version code `1561052632` and version name `21.04.223`. APK signature verification passed v3 with certificate SHA-256 `9bb036dbd7cbeb756a2d42571d67995820be67f5ba9a2abe6624a5212cb4f1db`.

### 7.3 Emulator installation

A fresh Android 35 `default/x86_64` AOSP AVD ran headless with wipe-data and snapshots disabled. Before installation there was exactly one emulator transport, `ro.kernel.qemu=1`, no physical transport, and no `com.google.android.youtube` package. Evidence records only serial SHA-256 `603ebee38d02b4f605927ac562cc9b565b5ca83ba353f50d295dfe68a124d485`.

One explicit-target `adb install` without replace or uninstall behavior exited `0` and returned success. The harness then incorrectly treated the first non-success line in its output array as failure; no second install was attempted. A read-only package-manager postcheck found the package and verified version `21.04.223` / code `1561052632`. The app was not launched, so startup, Google service behavior, Patch runtime behavior, and YouTube support remain unverified.

Temporary signing material and patch scratch data are deleted after evidence capture. The signed APK and redacted raw logs remain outside Git only until independent review, then are deleted with the disposable AVD.
