# Phase 4 Observable Pipeline Status Plan

**Goal:** Deliver the first real Enhanced Voice Over Translation increment on `dev`: an independent EVOT Patch, player controls, staged Pipeline Status, isolated Translation Runs, real caption acquisition, and actionable redacted failures.

**Phase 4 base:** `b0a74a7fef5547d644c545ae742c9be8b799f54a`.

## Boundary

Phase 4 may implement the exact-version experimental EVOT Patch and caption acquisition. It does not implement Provider Profiles, model requests, generated context, translation, TTS, Audio Ducking, native translated captions, stable publication, or a YouTube support claim. The Agent does not operate a physical device; the project owner performs the manual smoke gate through Morphe Manager's prerelease Source workflow.

## Atomic Tickets

1. Freeze this plan, establish the Phase 4 gate and evidence format, and record project-owner authorization.
2. Prove the exact-APK hook fingerprints, cross-bundle official-VoT exclusion mechanism, and final logging boundary. Stop if any required seam remains unverified.
3. Add the pure-Java immutable Pipeline Status core, run generation, classified failures, recovery actions, and structured diagnostics through contract-first tests.
4. Add the exact-version experimental EVOT Patch, bilingual resources, player button, and read-only Pipeline Status BottomSheet.
5. Persist Voice Translation Enabled and create a frozen, generation-isolated Translation Run for each video.
6. Connect real caption acquisition and expose waiting, fetching, available, no-caption, and failed states without calling a Provider or TTS engine.
7. Add one-time blocking-failure presentation, retry, stop, action enablement, and redacted correlation IDs.
8. Build the candidate, run the automated gate, publish only a `dev` prerelease, and collect the project owner's five structured smoke results.
9. Obtain an independent review. Only a Reviewer PASS followed by explicit project-owner acceptance completes Phase 4.

## Required Interfaces

- `PipelineSnapshot` contains generation, Run/Caption/Context/Translation/Speech states, progress, frozen configuration, last failure, actions, and correlation ID.
- `PipelineEventSink.publish(generation, event)` accepts only the current generation and reports whether the event was applied.
- `RunConfigSnapshot` represents unavailable Phase 5/6 settings explicitly as not configured.
- `PipelineFailure` contains a stable code, stage, category, and allowed recovery actions, never a remote body or exception message.
- `EvotDiagnosticEvent` accepts only fixed metadata fields and cannot carry arbitrary text, URLs, headers, subtitles, or request bodies.

## Acceptance

- State-transition, stale-generation, persistence, recovery, and diagnostic-redaction tests pass.
- The exact-APK integration seams are evidence-verified before product implementation.
- The bundle exposes one non-default experimental EVOT Patch for YouTube `21.04.223` and enforces incompatibility with official Voice over translation.
- The project owner completes at most five prerelease smoke checks before independent review.
- No APK, decompiled output, signing material, device identifier, credential, raw log, or private endpoint enters Git.

Any failed evidence check remains a failure. `main` and stable publication remain untouched.
