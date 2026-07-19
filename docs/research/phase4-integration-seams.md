# Phase 4 Integration Seam Evidence

## Scope and verdict

This report evaluates the three evidence blockers that must close before Phase 4 product implementation: exact-APK hook uniqueness, mutual exclusion with official Voice over translation, and the final logging boundary.

**Verdict: BLOCKED.** Morphe's fixed Patch and Manager interfaces do not provide a mechanism for declaring two independently named Patches in separate Bundles mutually exclusive. The accepted EVOT requirement says the two Patches cannot be selectable together, so Phase 4 must stop before product code. An experimental label, duplicate name, warning, dependency, runtime self-disable, or expected patch failure would not satisfy that requirement.

## Fixed sources

| Source | Revision | Files used |
| --- | --- | --- |
| morphe-patcher | `b69536fd33b69a1d1b2643068941f1052cf51708` | `src/main/kotlin/app/morphe/patcher/patch/Patch.kt` |
| morphe-manager | `a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948` | `PatchSelectionRepository.kt`, `PatchBundleInfo.kt` |
| morphe-patches-library | `9e555a2273533ef13e51db70a55d3fd544752756` | `extension-library/.../Logger.java` |
| morphe-patches | `e12088c89942f5d637a824ce81643a28b86fb851` | official `VoiceOverTranslationPatch.kt` |

## Mutual exclusion

Fixed [`Patch.kt:45`](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/src/main/kotlin/app/morphe/patcher/patch/Patch.kt#L45) defines Patch metadata as name, description, default, dependencies, compatibility, options, and execute/finalize blocks. Its builder exposes compatibility at [`Patch.kt:463`](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/src/main/kotlin/app/morphe/patcher/patch/Patch.kt#L463) and dependencies at [`Patch.kt:499`](https://github.com/MorpheApp/morphe-patcher/blob/b69536fd33b69a1d1b2643068941f1052cf51708/src/main/kotlin/app/morphe/patcher/patch/Patch.kt#L499). There is no conflict, exclusion, alternative, or negative-dependency field or builder method.

Manager fixed [`PatchSelectionRepository.kt:26`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/domain/repository/PatchSelectionRepository.kt#L26) stores selections as `Map<BundleUid, Set<PatchName>>`. Fixed [`PatchBundleInfo.kt:134`](https://github.com/MorpheApp/morphe-manager/blob/a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948/app/src/main/java/app/morphe/manager/patcher/patch/PatchBundleInfo.kt#L134) independently maps every enabled Bundle to its selected Patch names. It does not compare Patch identity or constraints across Bundles.

The fixed official definition at [`VoiceOverTranslationPatch.kt:57`](https://github.com/MorpheApp/morphe-patches/blob/e12088c89942f5d637a824ce81643a28b86fb851/patches/src/main/kotlin/app/morphe/patches/youtube/video/voiceovertranslation/VoiceOverTranslationPatch.kt#L57) declares only positive dependencies and YouTube compatibility. It exports no conflict token that an independent EVOT Patch can reference.

The current CometDash toolchain resolves `morphe-patcher 1.6.0`, which is the fixed `b69536f` release inspected above. This is source evidence for the actual API available to the repository, not an inference from documentation.

## Logging boundary

Fixed [`Logger.java:149`](https://github.com/MorpheApp/morphe-patches-library/blob/9e555a2273533ef13e51db70a55d3fd544752756/extension-library/src/main/java/app/morphe/extension/shared/Logger.java#L149) accepts an arbitrary message supplier and optional throwable. It appends the throwable message at line 161, stores the complete result in an in-memory exportable buffer at line 179, sends it to Android log at lines 184-193, and may display it in a toast at line 198. The sink performs no credential, header, endpoint, subtitle, request-body, or exception-message redaction.

The logging boundary is therefore verified, but unsafe for untrusted free-form values. A later implementation must place a typed diagnostic adapter before this sink and must never pass a remote exception or arbitrary string. This finding does not itself block a safe implementation; the missing mutual-exclusion contract does.

## Exact-APK hook probe

No exact-hook probe was added or run. The mutual-exclusion check is an earlier mandatory blocker, and the accepted plan requires product work to stop when any required seam cannot be verified. Phase 3 static evidence remains the current limit: it did not prove the complete video/player/caption hook set on YouTube `21.04.223`.

This is recorded as `BLOCKED`, not as a failed fingerprint match and not as a success. If the product requirement or Morphe API changes, hook verification must restart from the fixed fingerprints and exact APK without relying on this report as runtime evidence.

## Required decision before resumption

One of these external conditions must change before Phase 4 can continue:

- Morphe adds and releases a cross-Bundle Patch-conflict contract consumed by Manager and the Patcher; or
- the project owner revises the accepted requirement and ADR to a different, explicitly weaker interaction contract after independent review.

Until then, Tickets 3-9 remain blocked and no EVOT product source, metadata, prerelease, or support claim may be created.
