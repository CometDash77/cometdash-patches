# Phase 2 Official Voice Over Translation Independent Review

## Review identity and boundary

- Review date: `2026-07-19` (`Asia/Hong_Kong`).
- Candidate: `38192e17f86fd03c60e9d7545d292be49dee9ead` on `dev`.
- Phase 2 base: `bdfbffa87f9ce4de85ced65d3f07ec7a261b8af9`.
- Fixed official source: `MorpheApp/morphe-patches@e12088c89942f5d637a824ce81643a28b86fb851` from the read-only local archive at `C:\tmp\morphe-patches-e12088c\morphe-patches-e12088c89942f5d637a824ce81643a28b86fb851`.
- Evidence reviewed: the accepted Phase 2 plan, three listed specifications, documentation-gate rubric, ADRs 0001-0006, candidate report, evidence ledger, candidate Git diff, and the fixed official source. No implementation reasoning was requested or used.
- Prohibited work was not performed: no APK inspection, provider call, product-code change, `main` change, or YouTube `21.04.223` support claim.

## Findings

No Blocking or Non-blocking candidate findings.

## Independent source reconstruction

| Required chain or model | Independent evidence | Review result |
| --- | --- | --- |
| Patch definition, dependencies and injection | Candidate `docs/research/official-voice-over-translation.md:38-59`; fixed source `patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt:39-108`, `Fingerprints.kt:23-77`, and `VotOriginalVolumeBytecodePatch.kt:25-39`; shared hook implementations at `video/videoid/VideoIdPatch.kt:25-57,131-147`, `video/information/VideoInformationPatch.kt:219-225,715-726`, `layout/player/buttons/PlayerOverlayButtonsHookPatch.kt:24-51`, and `misc/playercontrols/LegacyPlayerControlsPatch.kt:198-230,255-281`. | Reconstructed. Fingerprint signals, saved insertion locations and extension descriptors agree with the candidate. The candidate does not invent an obfuscated YouTube owner or convert compatibility metadata into runtime evidence. |
| Captions and `TranscriptSegment` contract | Candidate report `:114-129`; fixed `TranscriptFetcher.java:48-215,230-312,315-470` and `TranscriptSegment.java:15-59`. | Reconstructed. The Innertube selection order, JSON3/timedtext fallback, cookie/header inputs, parsing/merging heuristics and immutable/source versus volatile/playback fields agree. Remote availability remains unverified. |
| Translation, providers and update semantics | Candidate report `:131-145`; fixed `TranscriptTranslator.java:50-170,190-353,422-469,473-497,530-610,610-715,783-940` and consumer `VoiceOverTranslationPatch.java:456-519`. | Reconstructed. Character budgets, playhead-first splitting, Google/MyMemory/OpenRouter contracts, SSE parsing, prefix requeue, same-shape snapshots and failure behavior agree. Completed publication has a `liveSession` check; streamed partial publication does not. Video/language checks do not constitute a frozen provider/config generation. |
| Voice, TTS, cache and prefetch | Candidate report `:147-159`; fixed `VoiceCatalog.java:497-520`, `VoiceOverTranslationPatch.java:522-735`, `TtsEngine.java:109-344,354-570,699-785`, `TtsCache.java:25-98`, and `TtsPrefetcher.java:29-296`. | Reconstructed. System versus Edge selection, generation-like playback ID, in-memory production cache, preview-only disk cache, serialized Edge synthesis, distance tiers and failure backoff agree. Device and service behavior remain runtime-unverified. |
| Playback, seek and original-audio multiplier | Candidate report `:161-168,219-233`; fixed `VoiceOverTranslationPatch.java:178-365,592-735,743-899` and `VotOriginalVolumePatch.java:22-100`. | Reconstructed. Pause/resume, speed, large and explicit seeks, video change, end behavior, predicted speech window and immediate 50 ms multiplier enforcement agree. The source implements neither a fade nor one audible-speech-owned ducking lifecycle. |
| State and thread ownership | Candidate report `:170-193`; fixed orchestrator `:139-216,456-519`, translator `:78-170,190-353,456-469`, `TtsPrefetcher.java:45-237`, `TtsEngine.java:78-344`, `TtsCache.java:25-98`, and volume runtime `:22-100`. | Reconstructed. Main/background/Handler/audio-thread handoffs, locks, volatile/atomic state and stale-result guards are distinguished. The candidate correctly refuses to treat the separate guards as a coherent per-video Translation Run. |
| Failures and data exposure | Candidate report `:195-217`; fixed fetcher `:79-107,196-215,450-470`, translator `:472-497,610-715,783-940`, TTS/prefetch/cache paths above, and `VoiceOverTranslationPatch.java:919-1083`. | Reconstructed. Detection, fallback/abort behavior, user effects, recovery limits and outbound fields are source-derived. Provider bodies and translated-text logging are identified as risks; final Logger sink behavior is left unverified. |
| Unknowns and Phase 2 boundary | Candidate report `:246-282`; evidence ledger `docs/research/evidence-ledger.md:142-155`; specifications and ADRs 0002, 0004, 0005 and 0006. | Reconstructed. Exact APK matches/runtime, provider behavior, System/Edge behavior, mutual-exclusion API, Keystore integration, logger behavior and native-caption injection remain later gates. No Phase 3 implementation or release authority is implied. |

## Fixed-corpus coverage

The candidate inventory at `docs/research/official-voice-over-translation.md:23-36` accounts for all three feature Patch files, all ten direct runtime-core files, the button/settings/preferences, all three button resources, the shared video-ID/time/player-type/button/legacy-control hook families and their fingerprints, and the direct caption/auth/request/player-state/video-information support files. Each entry is tied to the fixed revision by the report's corpus declaration and is either used in a fixed source citation or explicitly bounded:

- The two drawable XML files are accounted for as copied resources, and the legacy layout is cited directly (`:30,36,42,67`).
- The broad `video/information/Fingerprints.kt` set is explicitly excluded from the VoT injection ledger except for the separately cited shared playback-time fingerprint (`:36,51`).
- `PlayerControlsOverlayVisibilityPatch.kt` is explicitly classified as a transitive dependency rather than a separate VoT injection (`:36`).
- Direct support files are named in the fixed inventory and their relevant call sites are traced in the caption, state, thread and playback chains; no unrelated helper behavior is inferred.

The fixed-source URL/local-archive audit found `130` blob references, `0` wrong SHAs, `0` missing local paths and `0` out-of-range line anchors.

## Reproduced checks

| Check | Raw result summary |
| --- | --- |
| `git status --short --branch` | Clean `dev`; `## dev...origin/dev [ahead 5]`. HEAD independently resolved to candidate `38192e17f86fd03c60e9d7545d292be49dee9ead`. |
| `pwsh -NoProfile -File tools/check_documentation.ps1` | PASS: `Documentation checks passed: 34 Markdown files, 6 ADRs.` |
| Fixed-source blob/path/line audit | PASS: `blob_references=130`, `wrong_sha=0`, `missing_paths=0`, `out_of_range=0`. |
| Placeholder and affirmative support-claim review | PASS: no unresolved placeholder and no affirmative YouTube `21.04.223` support claim. The only matches in a broad text scan were checklist instructions and explicit negative/unverified statements. |
| `git diff --check bdfbffa87f9ce4de85ced65d3f07ec7a261b8af9..38192e17f86fd03c60e9d7545d292be49dee9ead` | PASS: no output. |
| Diff scope from Phase 2 base | PASS: only `docs/research/evidence-ledger.md`, `docs/research/official-voice-over-translation.md`, and `docs/superpowers/plans/2026-07-19-morphe-phase-2.md`. |
| Sensitive tracked-file scan for `*.apk`, `*.aab`, `*.jks`, `*.keystore`, `*.pem`, `*.p12`, `*.der` | PASS: `0` tracked matches. |
| `pwsh -NoProfile -File tools/sync_upstream_docs.ps1 -Check` | FAIL, preserved exactly: `tools/sync_upstream_docs.ps1:120` received HTTP `401 Bad credentials`. This is not reported as PASS. Candidate report `:14-21` and evidence ledger `:110-111` preserve the failure. No Phase 2 VoT claim relies on the vendored documentation snapshot; all such claims were independently checked against the same-SHA official source archive. |

## Verdict

PASS

All Phase 2 technical gates are met. The candidate is independently reconstructible, materially correct against the frozen official source, complete for the required chains/models, explicit about evidence classes and unknowns, and within the documentation-only boundary. The failed upstream-documentation freshness command remains a recorded infrastructure failure rather than a passing check; it does not invalidate the separately frozen VoT source evidence because that vendored documentation is not used for a Phase 2 VoT claim.

This verdict is a technical Phase 2 review only. It does not approve Phase 2 on the user's behalf, authorize Phase 3, validate an APK, or support YouTube `21.04.223`.
