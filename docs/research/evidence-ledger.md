# Evidence Ledger

核验日期：2026-07-19（Asia/Hong_Kong）

## Evidence classes

- `Source`: 固定 commit 的官方源码或仓库配置。
- `Official documentation`: 固定 commit 的官方说明；实现冲突时以源码和运行证据为准。
- `Maintainer discussion`: issue/PR 中的设计背景，不能单独证明当前实现。
- `Contributor discussion`: issue/PR 中贡献者提供的设计背景，记录 `author_association`，不能单独证明当前实现。
- `Reference implementation`: 非 Morphe 项目的可借鉴设计，不证明 Android Patch 可行。
- `Runtime input`: 本地 APK、日志或设备观察，仅对记录的版本和哈希成立。

## Gate records

### Accepted documentation decision baseline

- Confirmed by: Project owner.
- Confirmed at: 2026-07-19（Asia/Hong_Kong）。
- Baseline revision: `b1d6602981dff5bd466146eedecfa58dd4cc0944`.
- Scope: `CHAR-001..005`, `LEARN-000..009`, `EVOT-001..011`, and `ADR-001..006` in the [Decision Authority Map](../specs/project-charter.md#decision-authority-map).
- Decision: The mapped project charter, learning program, EVOT specification, and ADRs form the complete accepted decision baseline.
- Boundary: This confirmation did not authorize Phase 1.

### Phase 1 authorization

- Authorized by: Project owner.
- Authorized at: 2026-07-19（Asia/Hong_Kong）。
- Documentation Gate review: [`PASS`](./2026-07-18-documentation-gate-review.md) at `2cfccfbc4ab44b81e2b74da0140d01b25fe24f26`.
- Decision: Phase 1《Morphe 生态架构分析报告》may begin.
- Boundary: This authorization does not permit Phase 2 or Patch implementation.

### Phase 1 completion gate

- Approved by: Project owner.
- Approved at: `2026-07-19T12:28:51+08:00`（`Asia/Hong_Kong`）。
- Accepted candidate: [`Morphe 生态架构分析报告`](./morphe-ecosystem-architecture.md) at `f34f8c827801dfeb3d1bd0c3493e5aaf8de6e6ef`.
- Independent review: final [`PASS`](./2026-07-18-morphe-ecosystem-review.md#最终-verdict) at `aa6cec86a96c44bc232ef797d37d265568e7f129`.
- Finding status: `MORPHE-P1-001..005` are `Resolved`; the two earlier `BLOCKED` records remain audit history, not current gate state.
- Decision: Phase 1 is accepted and complete.

### Phase 2 research authorization and fresh-window entrypoint

- Authorized by: Project owner.
- Authorized at: `2026-07-19T12:28:51+08:00`（`Asia/Hong_Kong`）。
- Decision: A fresh-window Agent may begin Phase 2《官方 Voice Over Translation》research and planning with `mattpocock-skills:research`.
- Required startup input: `AGENTS.md`, `CONTEXT-MAP.md`, [Phase 2 in the learning program](../specs/agent-learning-program.md#2-官方-voice-over-translation), this ledger, the accepted [Phase 1 report](./morphe-ecosystem-architecture.md), and the final [Phase 1 review](./2026-07-18-morphe-ecosystem-review.md#最终-verdict).
- Context boundary: use the final Phase 1 artifacts and fixed sources as inputs; do not import prior chat reasoning by default. Read historical `BLOCKED` sections only for audit or regression analysis.
- Scope boundary: authorization covers Phase 2 source research and planning only. It does not authorize Patch implementation, APK inspection, Phase 3 work, release, or an APK support claim.

## Fixed upstream revisions

| Project | Revision | Evidence use |
| --- | --- | --- |
| [morphe-patches-template](https://github.com/MorpheApp/morphe-patches-template/tree/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe) | `93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe` | Source layout, `dev/main`, semantic release, bundle generation |
| [morphe-documentation](https://github.com/MorpheApp/morphe-documentation/tree/37b5eeb9c690ea169937fc2bac197bdcdb269014) | `37b5eeb9c690ea169937fc2bac197bdcdb269014` | Official setup and ecosystem documentation snapshot |
| [morphe-patches](https://github.com/MorpheApp/morphe-patches/tree/e12088c89942f5d637a824ce81643a28b86fb851) | `e12088c89942f5d637a824ce81643a28b86fb851` | Voice over translation v1.35.0 implementation |
| [morphe-manager](https://github.com/MorpheApp/morphe-manager/tree/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948) | `a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948` | Patch Source URL normalization and bundle download behavior |
| [morphe-patches-gradle-plugin](https://github.com/MorpheApp/morphe-patches-gradle-plugin/blob/52be641ed3b965a20c33bd43e0cbe9efd308bc64/src/main/kotlin/app/morphe/patches/gradle/PatchesPlugin.kt) | `52be641ed3b965a20c33bd43e0cbe9efd308bc64` | `.mpp` assembly, Android DEX generation, manifest metadata |
| [changelog](https://github.com/MorpheApp/changelog/blob/caa1e931730f097bb6c4dee636b01c2c24ccd72d/lib/prepare.js) | `caa1e931730f097bb6c4dee636b01c2c24ccd72d` | `patches-bundle.json` generation |
| [morphe-desktop](https://github.com/MorpheApp/morphe-desktop/blob/2f5ce39adc26d4b3e7debe44445eddcaf887bffa/src/main/kotlin/app/morphe/engine/PatchEngine.kt) | `2f5ce39adc26d4b3e7debe44445eddcaf887bffa` | Desktop Source, Patch loading, patch/sign/output orchestration |
| [morphe-patcher](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/src/main/kotlin/app/morphe/patcher/Patcher.kt) | `b69536fd33b69a1d1b2643068941f1052cf51708` | Patch model, dependency execution, resource/DEX mutation |
| [morphe-library](https://github.com/MorpheApp/morphe-library/blob/a5b1fb512306d497cad8a13c0399a5fb28553522/src/commonMain/kotlin/app/morphe/library/installation/installer/AdbInstaller.kt) | `a5b1fb512306d497cad8a13c0399a5fb28553522` | Desktop CLI installation result boundary |
| [morphe-patches-library](https://github.com/MorpheApp/morphe-patches-library/blob/9e555a2273533ef13e51db70a55d3fd544752756/patch-library/src/main/kotlin/app/morphe/util/PatchListGenerator.kt) | `9e555a2273533ef13e51db70a55d3fd544752756` | Shared Patch helpers and `patches-list.json` generation |
| [gradle-semantic-release-plugin](https://github.com/KengoTODA/gradle-semantic-release-plugin/blob/75037a67e3729787c38d2374bab528233ddddaec/src/publish.ts) | `75037a67e3729787c38d2374bab528233ddddaec` (`v1.10.3`) | Fixed direct release dependency: Gradle version prepare and publish-task execution |
| [morphe-website](https://github.com/MorpheApp/morphe-website/blob/57a6d8cb9541101d09fc73fef8c1e0c3304e7dc7/public/js/add-source.js) | `57a6d8cb9541101d09fc73fef8c1e0c3304e7dc7` | Supporting Source onboarding handoff consumed by Manager |
| [smali](https://github.com/MorpheApp/smali/tree/b6365a84f40c8355af14004dcf7b8324ee050b9f) | `b6365a84f40c8355af14004dcf7b8324ee050b9f` | Supporting DEX model and assembly API |
| [jadb](https://github.com/MorpheApp/jadb/tree/6fdaa5bec8369487e6c9d0460f02ac9970709d34) | `6fdaa5bec8369487e6c9d0460f02ac9970709d34` | Supporting ADB transport used by `morphe-library` |
| [kiss-translator](https://github.com/fishjar/kiss-translator/tree/8e20013ab2426dc278c98c89f4d51601261b5e25) | `8e20013ab2426dc278c98c89f4d51601261b5e25` | Reference implementation for video summary, neighbor context, and bounded history |

## Verified findings

### Morphe ecosystem lifecycle

- The [Phase 1 ecosystem report](./morphe-ecosystem-architecture.md) inventories all 21 unarchived MorpheApp repositories at fixed revisions and classifies them as `Direct=8`, `Supporting=4`, and `Excluded=9` from source/config edges.
- [`prepare.js`](https://github.com/MorpheApp/changelog/blob/caa1e931730f097bb6c4dee636b01c2c24ccd72d/lib/prepare.js) writes release discovery metadata during semantic-release prepare. The fixed Gradle release dependency [`prepare.ts`](https://github.com/KengoTODA/gradle-semantic-release-plugin/blob/75037a67e3729787c38d2374bab528233ddddaec/src/prepare.ts) updates/verifies version in prepare, while [`publish.ts`](https://github.com/KengoTODA/gradle-semantic-release-plugin/blob/75037a67e3729787c38d2374bab528233ddddaec/src/publish.ts) invokes Gradle `publish` only in the publish lifecycle; [`PatchesPlugin.kt`](https://github.com/MorpheApp/morphe-patches-gradle-plugin/blob/52be641ed3b965a20c33bd43e0cbe9efd308bc64/src/main/kotlin/app/morphe/patches/gradle/PatchesPlugin.kt) makes that task depend on `buildAndroid`, which adds DEX to the final `.mpp`.
- Patcher [`libs.versions.toml`](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/gradle/libs.versions.toml) declares the external `com.github.REAndroid:arsclib` coordinate, so the frozen `MorpheApp/ARSCLib` fork is Excluded rather than recorded as a participating revision.
- Website [`add-source.js`](https://github.com/MorpheApp/morphe-website/blob/57a6d8cb9541101d09fc73fef8c1e0c3304e7dc7/public/js/add-source.js) produces a Source onboarding intent consumed by Manager [`MainActivity.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/MainActivity.kt); the website is Supporting, while Manager retains Source normalization, metadata fetch, and bundle download ownership.
- Manager [`Session.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/patcher/Session.kt) and Desktop [`PatchEngine.kt`](https://github.com/MorpheApp/morphe-desktop/blob/2f5ce39adc26d4b3e7debe44445eddcaf887bffa/src/main/kotlin/app/morphe/engine/PatchEngine.kt) orchestrate Patch execution against a copied input APK; [`ApkUtils.applyTo`](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/src/main/kotlin/app/morphe/patcher/apk/ApkUtils.kt) owns the primitive that writes resource and DEX changes into that copy.
- Manager [`PatchBundleRepository.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/domain/repository/PatchBundleRepository.kt) and [`RemotePatchBundle.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/domain/bundles/RemotePatchBundle.kt) show why Patch Source exists: it separates versioned metadata and Patch Bundle download from the user-supplied APK and local patching operation.

### Patch Source template

- The pinned template [`README.md`](https://github.com/MorpheApp/morphe-patches-template/blob/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe/README.md) directs development to `dev`, pre-release testing through Morphe Manager, and stable release by merging `dev` to `main`.
- The pinned [release workflow](https://github.com/MorpheApp/morphe-patches-template/blob/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe/.github/workflows/release.yml) invokes semantic release. The pinned [`.releaserc`](https://github.com/MorpheApp/morphe-patches-template/blob/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe/.releaserc) declares `main` stable, `dev` prerelease, and a semantic-release backmerge from `main` to `dev`.

### Official documentation snapshot

- The pinned documentation [`README.md`](https://github.com/MorpheApp/morphe-documentation/blob/37b5eeb9c690ea169937fc2bac197bdcdb269014/README.md) indexes the Morphe user and development documentation. The pinned development [`1_setup.md`](https://github.com/MorpheApp/morphe-documentation/blob/37b5eeb9c690ea169937fc2bac197bdcdb269014/docs/morphe-development/1_setup.md) directs developers to clone the template's `dev` branch and build it with `./gradlew buildAndroid`.
- The immutable pinned [`troubleshooting.md:85`](https://github.com/MorpheApp/morphe-documentation/blob/37b5eeb9c690ea169937fc2bac197bdcdb269014/docs/morphe-resources/troubleshooting.md#L85) links to the nonexistent `questions.md#11-how-to-update-patched-apps` fragment. The correct target is [`questions.md#22-how-to-update-patched-apps`](https://github.com/MorpheApp/morphe-documentation/blob/37b5eeb9c690ea169937fc2bac197bdcdb269014/docs/morphe-resources/questions.md#22-how-to-update-patched-apps). This upstream defect is recorded here without modifying the vendored snapshot.

### Official Voice over translation

- The pinned [`README.md`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/README.md) lists Voice over translation as translated TTS synchronized with video playback.
- The Patch definition is under [`patches/.../voiceovertranslation`](https://github.com/MorpheApp/morphe-patches/tree/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation).
- Runtime orchestration is under [`extensions/.../voiceovertranslation`](https://github.com/MorpheApp/morphe-patches/tree/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation).
- [`VoiceOverTranslationButton.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/videoplayer/VoiceOverTranslationButton.java) uses short press to toggle and long press to open `VotBottomSheet`.
- [`TranscriptFetcher.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/TranscriptFetcher.java) retrieves YouTube timed text independently; [`TranscriptTranslator.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/TranscriptTranslator.java) supports Google, MyMemory, and an OpenRouter-specific streaming request.
- The pinned [`TranscriptTranslator.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/TranscriptTranslator.java) fixes OpenRouter `temperature` to zero and sends OpenRouter-specific routing; [`VoiceOverTranslationModelPreference.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/settings/preference/VoiceOverTranslationModelPreference.java) provides presets and manual model ID entry, not generic Provider Profiles.
- [`VoiceOverTranslationPatch.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/VoiceOverTranslationPatch.java) and [`VotOriginalVolumePatch.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/VotOriginalVolumePatch.java) implement runtime original-audio multiplier behavior. [`TtsCache.java`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/patches/voiceovertranslation/TtsCache.java) caches TTS data.

### Native translated captions

- [VoT PR #1685](https://github.com/MorpheApp/morphe-patches/pull/1685) introduced the official feature.
- In [contributor comment 4646409177](https://github.com/MorpheApp/morphe-patches/pull/1685#issuecomment-4646409177), the PR author states that obtaining native translated subtitles was not achieved and runtime translation was used instead. GitHub reports `author_association=CONTRIBUTOR`.
- [Issue #1880](https://github.com/MorpheApp/morphe-patches/issues/1880) requests auto-translated captions and remained open when checked.

### Patch Source hosting

- The pinned Manager [`README.md`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/README.md) documents adding compatible bundles by GitHub URL.
- [`PatchBundleRepository.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/domain/repository/PatchBundleRepository.kt) also accepts direct HTTPS JSON URLs from other hosts, while GitHub/GitLab receive first-class normalization.
- [`RemotePatchBundle.kt`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/domain/bundles/RemotePatchBundle.kt) recognizes only `main/dev` for prerelease switching. This led to the selected GitHub `dev/main` channel names.

### Context reference

- kiss-translator [`YouTubeCaptionProvider.js`](https://github.com/fishjar/kiss-translator/blob/8e20013ab2426dc278c98c89f4d51601261b5e25/src/subtitle/YouTubeCaptionProvider.js) builds a video summary from title, description, and a bounded transcript prefix through [`apiSummarizeContext`](https://github.com/fishjar/kiss-translator/blob/8e20013ab2426dc278c98c89f4d51601261b5e25/src/apis/index.js).
- [`trans.js`](https://github.com/fishjar/kiss-translator/blob/8e20013ab2426dc278c98c89f4d51601261b5e25/src/apis/trans.js) accepts previous/next read-only subtitle context.
- [`history.js`](https://github.com/fishjar/kiss-translator/blob/8e20013ab2426dc278c98c89f4d51601261b5e25/src/apis/history.js) implements bounded message history. CometDash adopts the three concepts but orders history by video timeline to handle concurrent requests and seek.

## Runtime input

| Field | Value |
| --- | --- |
| App | YouTube |
| Version | `21.04.223` |
| File type | Single APK |
| Size | `171814203` bytes |
| SHA-256 | `78571BE679F586D11A4E56FB1CE6BF9DFD958CE6B8AF786C4A3BD94792CE8C7C` |
| Repository policy | File is local-only and matched by `*.apk` ignore rule |

## Unverified gates

- Exact Morphe API for declaring two Patches mutually incompatible.
- Keystore integration compatible with the extension's Android API and settings lifecycle.
- Current official DeepSeek China Base URL, model-list behavior, reasoning fields, and streaming differences.
- Stable YouTube `21.04.223` fingerprints after moving official logic to the independent `evot` namespace.
- A reliable native caption cue/renderer injection point.
- Product-only stable projection automation for `dev -> main`.

These items are not implementation assumptions. Each requires a dedicated evidence task before dependent code or release claims.
