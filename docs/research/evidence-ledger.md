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
- Boundary: This confirmation does not authorize Phase 1.

## Fixed upstream revisions

| Project | Revision | Evidence use |
| --- | --- | --- |
| [morphe-patches-template](https://github.com/MorpheApp/morphe-patches-template/tree/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe) | `93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe` | Source layout, `dev/main`, semantic release, bundle generation |
| [morphe-documentation](https://github.com/MorpheApp/morphe-documentation/tree/37b5eeb9c690ea169937fc2bac197bdcdb269014) | `37b5eeb9c690ea169937fc2bac197bdcdb269014` | Official setup and ecosystem documentation snapshot |
| [morphe-patches](https://github.com/MorpheApp/morphe-patches/tree/e12088c89942f5d637a824ce81643a28b86fb851) | `e12088c89942f5d637a824ce81643a28b86fb851` | Voice over translation v1.35.0 implementation |
| [morphe-manager](https://github.com/MorpheApp/morphe-manager/tree/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948) | `a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948` | Patch Source URL normalization and bundle download behavior |
| [kiss-translator](https://github.com/fishjar/kiss-translator/tree/8e20013ab2426dc278c98c89f4d51601261b5e25) | `8e20013ab2426dc278c98c89f4d51601261b5e25` | Reference implementation for video summary, neighbor context, and bounded history |

## Verified findings

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
