# Phase 2 官方 Voice Over Translation 源码研究

## 1. 身份、范围与证据方法

- 采集日期：`2026-07-19`（`Asia/Hong_Kong`）。
- Phase 2 base：`bdfbffa87f9ce4de85ced65d3f07ec7a261b8af9`；计划归档 commit：`fbc8df2`。
- 固定上游：[`MorpheApp/morphe-patches@e12088c89942f5d637a824ce81643a28b86fb851`](https://github.com/MorpheApp/morphe-patches/tree/e12088c89942f5d637a824ce81643a28b86fb851)，即 v1.35.0。
- 采集时 `main` 仍等于固定 revision；recursive tree 返回 `entries=2654`、`truncated=false`。
- 证据等级：本文实现结论仅使用 `Source`，即固定 commit 的官方源码。没有把计划、现有 ledger、Agent 输出或本文自身当作事实证明。
- 安全边界：没有读取、检查、反编译或复制本地 APK，没有编写 Patch/product code，没有修改 `main`，没有调用翻译/TTS provider，也没有声明 YouTube `21.04.223` 已通过 release gate。

上游源码通过固定 GitHub contents/raw URL读取；网络不稳定后，又从同一 SHA 的 GitHub codeload archive 解压到 `C:\tmp` 进行只读逐行复核。临时 archive 和解压源码均不在 repository 内，不会提交、vendor 或进入 release projection。

### Failed evidence calls

| Check | Result | Resolution / evidence limit |
| --- | --- | --- |
| 已配置认证的 `gh api` | HTTP 401 `Bad credentials`。 | 未修改认证；不把该失败解释为 upstream 不可访问。 |
| 未认证 GitHub REST API | 完成 HEAD/tree 和第一批 contents 后达到匿名 rate limit。 | 已成功结果保留；后续改用同一 SHA 的 raw/codeload source。 |
| 个别 raw/blob 请求 | 间歇性 connection reset/timeout；一个 Research Agent 初次无法取得 source。 | Agent 重试固定 raw URL 后成功；主 Agent再以 codeload archive 逐行复核。失败记录没有被删除。 |
| Web search/open | 服务返回 404。 | 没有使用搜索结果或二手摘要支持本文结论。 |

## 2. 固定源码语料

| Domain | Complete fixed-source inventory |
| --- | --- |
| Patch definition | `patches/.../voiceovertranslation/Fingerprints.kt`, `VoiceOverTranslationPatch.kt`, `VotOriginalVolumeBytecodePatch.kt` |
| Runtime core | `extensions/youtube/.../voiceovertranslation/TranscriptFetcher.java`, `TranscriptSegment.java`, `TranscriptTranslator.java`, `TtsCache.java`, `TtsEngine.java`, `TtsPrefetcher.java`, `VoiceCatalog.java`, `VoiceOverTranslationPatch.java`, `VotBottomSheet.java`, `VotOriginalVolumePatch.java` |
| Entry/settings | `VoiceOverTranslationButton.java`, `Settings.java`, `VoiceOverTranslationModelPreference.java`, `VoiceOverTranslationMyMemoryInfoPreference.java`, `VoiceOverTranslationOpenRouterInfoPreference.java` |
| Resources | `morphe_yt_vot.xml`, `morphe_yt_vot_bold.xml`, `youtube_controls_bottom_ui_container.xml` under `patches/src/main/resources/voiceovertranslationbutton` |
| Shared hooks | `video/videoid/{Fingerprints.kt,VideoIdPatch.kt}`, `video/information/{Fingerprints.kt,VideoInformationPatch.kt}`, `misc/playertype/{Fingerprints.kt,PlayerTypeHookPatch.kt}`, `layout/player/buttons/{Fingerprints.kt,PlayerOverlayButtonsHookPatch.kt}`, `misc/playercontrols/{Fingerprints.kt,LegacyPlayerControlsPatch.kt,PlayerControlsOverlayVisibilityPatch.kt}` |
| Direct runtime support | `CaptionCookiesPatch.java`, shared `AuthUtils`/`Requester` code located from imports, shared `PlayerType`/`VideoState`/`VideoInformation`, and shared settings/thread helpers where a claim crosses that boundary |

The three Patch files and ten runtime-core files are exactly the direct `voiceovertranslation` directory contents in the fixed tree. UI/settings/resources and shared hooks are included because the Patch imports or injects them; the research boundary therefore does not stop at the feature directory.

## 3. Patch definition、dependencies 与 resources

[`VoiceOverTranslationPatch.kt:57-71`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L57-L71) declares the named Patch `Voice over translation`, describes synchronized TTS, depends on the shared extension, video information, player type, overlay/legacy controls, its resource Patch and original-volume Patch, and applies `COMPATIBILITY_YOUTUBE`. The fixed [`Constants.kt:8-56`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/shared/Constants.kt#L8-L56) catalog lists `com.google.android.youtube` and version `21.04.223`, but this is metadata rather than runtime or release-gate evidence; exact compatibility remains unverified.

The private resource Patch depends on legacy controls, copies the normal/bold button drawables, and passes `voiceovertranslationbutton` to the legacy-control resource merger ([`VoiceOverTranslationPatch.kt:39-53`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L39-L53)). The bundled layout defines `morphe_vot_button` and places it beside existing controls, but source-level XML copying does not prove successful rendering on a target APK.

The Patch registers enable, target language, maximum speech rate, translation service, OpenRouter API key/model and MyMemory information/email preferences in the Video settings screen ([`VoiceOverTranslationPatch.kt:73-100`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L73-L100)). This is the frozen official configuration surface; it is not a generic Provider Profile design.

## 4. Fingerprint 与 injection ledger

| Hook | Source-proven match / saved location | Injected call | Evidence limit |
| --- | --- | --- | --- |
| Video ID | Shared `VideoIdFingerprint` derives a String register from its second instruction match; `VideoIdPatch` saves the matched method and inserts after that match. | `VoiceOverTranslationPatch.newVideoLoaded(Ljava/lang/String;)V` from [`VoiceOverTranslationPatch.kt:102`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L102), through [`VideoIdPatch.kt:36-41,131-138`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/videoid/VideoIdPatch.kt#L36-L41). | The shared hook can be called repeatedly and does not cover invisible background playback. Exact target class/method and APK match are not claimed. |
| Playback time | `VideoInformationPatch` resolves the called method referenced by `PlayerControllerSetTimeReferenceFingerprint`, stores a mutable-method reference and inserts a wide `J` callback at its managed index. | `VoiceOverTranslationPatch.videoTimeChanged(J)V` from [`VoiceOverTranslationPatch.kt:103`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L103), through [`VideoInformationPatch.kt:220-225,722-726`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/information/VideoInformationPatch.kt#L722-L726). | Source documents an approximately once-per-second callback, not frame-accurate timing. Underlying target name/match remains unverified on the APK. |
| Modern overlay button | `ExploderUIFullscreenButtonFingerprint` anchors the fullscreen resource/view register; the hook saves insertion immediately after the selected register. | `VoiceOverTranslationButton.initializeButton(View)` via [`PlayerOverlayButtonsHookPatch.kt:24-28,38-51`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/layout/player/buttons/PlayerOverlayButtonsHookPatch.kt#L24-L28). | Fingerprint-selected target; no obfuscated target class is invented. |
| Legacy control init | `PlayerBottomControlsInflateFingerprint` provides the `ViewStub.inflate()` result and the hook inserts after it. | `VoiceOverTranslationButton.initializeLegacyButton(View)` via [`LegacyPlayerControlsPatch.kt:198-202,274-281`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/misc/playercontrols/LegacyPlayerControlsPatch.kt#L198-L202). | XML/fingerprint application to a target APK is unverified. |
| Legacy visibility | Shared legacy-control state stores three matched callback locations. | `setVisibility(ZZ)`, `setVisibilityImmediate(Z)` and `setVisibilityNegatedImmediate()` through [`LegacyPlayerControlsPatch.kt:209-230`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/misc/playercontrols/LegacyPlayerControlsPatch.kt#L209-L230). | These delegate to the legacy button only; they do not form a pipeline-status model. |
| Player type/state | Shared fingerprints derive player/control/video enum types and inject at matched methods. | `PlayerTypeHookPatch.setPlayerType(Enum)`, `onShortsCreate(View)` and `setVideoState(Enum)` in [`PlayerTypeHookPatch.kt:17-80`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/misc/playertype/PlayerTypeHookPatch.kt#L17-L80). | VoT depends on this shared Patch and observes its extension state; it does not own the shared target hooks. |
| AudioSink volume | A parent fingerprint requires `PlaybackParams.setSpeed`, `AudioTrackAudioOutput` or `DefaultAudioSink`, and `Failed to set playback params`; the child requires a public-final `(F)V` with float get/compare/put/return sequence ([`Fingerprints.kt:23-62`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/Fingerprints.kt#L23-L62)). | Method-entry call `VotOriginalVolumePatch.getAudioMultiplier(F)F`, then result replaces `p1` ([`VotOriginalVolumeBytecodePatch.kt:25-33`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VotOriginalVolumeBytecodePatch.kt#L25-L33)). | Strings and opcode patterns are not target class names; actual fingerprint match/runtime audio effect is unverified. |
| AudioTrack wrapper | Public constructor receives `AudioTrack`, creates `AudioTimestamp`, and writes that object within five instructions ([`Fingerprints.kt:64-77`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/Fingerprints.kt#L64-L77)). | Method-entry call `VotOriginalVolumePatch.setAudioTrack(AudioTrack)` ([`VotOriginalVolumeBytecodePatch.kt:35-39`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VotOriginalVolumeBytecodePatch.kt#L35-L39)). | The constructor owner and match result remain unverified. |

The safe canonical names in this ledger are the Morphe extension descriptors and Morphe fingerprint objects. The fingerprint evidence does not disclose the obfuscated YouTube owner names, so this report does not manufacture them.

## 5. UI 与 settings entrypoints

Both modern and legacy buttons register the same actions: short press calls `toggleTranslation`; long press opens `VotBottomSheet` ([`VoiceOverTranslationButton.java:34-86`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/videoplayer/VoiceOverTranslationButton.java#L34-L86)). Their alpha reflects `isSessionEnabled`, not global feature enable ([`VoiceOverTranslationButton.java:88-104`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/videoplayer/VoiceOverTranslationButton.java#L88-L104)).

The settings model distinguishes global `VOT_ENABLED` from separately saved `VOT_SESSION_ENABLED`; it also declares caption language, voice, original/translated volume, maximum rate, service, OpenRouter key/model, MyMemory email, native-TTS selection and error-dialog flags ([`Settings.java:527-541`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/extensions/youtube/src/main/java/app/morphe/extension/youtube/settings/Settings.java#L527-L541)). These are plain source-level setting declarations; encryption or Android Keystore protection is not established by this evidence.

## 6. Research entry：Patch 与 hooks

| Required field | Finding |
| --- | --- |
| Purpose | Insert official VoT entry, video lifecycle/time callbacks and original-audio control into the patched YouTube process, while packaging the extension UI/runtime. |
| Problem solved | Supplies lifecycle signals and audio primitives that an out-of-process caption/translation/TTS pipeline could not obtain or apply by itself. |
| Files | Three feature Patch files, feature button/resources/settings, and five shared hook families listed in the source corpus. |
| Revision | `MorpheApp/morphe-patches@e12088c89942f5d637a824ce81643a28b86fb851`. |
| Minimal source example | `hookVideoId("...->newVideoLoaded(Ljava/lang/String;)V")`; `videoTimeHook(..., "videoTimeChanged")`; AudioSink entry replaces its float argument with `getAudioMultiplier` output. |
| Common mistakes | Treating `VOT_ENABLED` as the short-press state; treating compatibility metadata as an APK PASS; reading fingerprint strings as target class names; assuming copied XML proves rendering. |
| EVOT application | Reuse only evidence-validated lifecycle/audio mechanisms after Phase 3 target-APK verification; retain an independent `evot` namespace and separately resolve the still-unverified mutual-exclusion API. |

## 7. Injection-layer unknown gates

- Exact `21.04.223` fingerprint matches and behavior require the Phase 3 APK/build workflow; source definitions alone cannot close that gate.
- The exact Morphe API for making EVOT mutually incompatible with official VoT remains unverified.
- Shared hook stability across future YouTube versions remains per-version evidence work.
- Resource copying, button initialization and AudioTrack calls are source-proven injection intent, not runtime observations.
