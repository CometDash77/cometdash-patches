# Phase 4 Observable State Gate

## Entry

- Phase 3 completion is recorded at `b0a74a7fef5547d644c545ae742c9be8b799f54a`.
- The project owner has accepted the Phase 4 plan and explicitly authorized implementation.
- The official-documentation snapshot passes the upstream freshness check.
- `tools/check_phase4_preflight.ps1` passes before any product-module change.

## Evidence Blockers

Before product implementation, fixed source or non-mutating exact-APK probes must prove:

- every required player/video/caption hook fingerprint resolves exactly once;
- the Morphe mechanism that prevents EVOT and official Voice over translation from being selected together;
- the final logging boundary and a diagnostic interface that cannot receive sensitive free-form values.

An unverified or non-unique result is Blocking. Do not substitute an inferred class name, runtime guess, duplicate Patch name, warning-only UI, or experimental label.

## Automated Acceptance

- Pure-Java contract tests cover all stage transitions, invalid progress, frozen snapshots, and recovery actions.
- Concurrent completed, partial, and failed callbacks from stale generations cannot update the current run.
- Preference persistence and new-video generation behavior pass.
- Diagnostic tests prove credentials, sensitive headers, private URLs, subtitle text, request bodies, and exception messages cannot reach the sink.
- The product bundle loads exactly one non-default experimental EVOT Patch with the exact package, version, SDK, and signer compatibility contract.
- The Patch applies to the exact local APK and no Provider, translation, TTS, Audio Ducking, or native-caption behavior is present.
- Documentation, upstream freshness, build, bundle loading, sensitive-content scanning, fixed-range postflight, and `git diff --check` pass.

## Project-Owner Smoke Gate

The project owner uses Morphe Manager's prerelease Source and records only structured PASS/FAIL observations:

1. Discover the experimental EVOT Patch and confirm it cannot be selected with official Voice over translation.
2. Patch, sign, install, and start the exact APK under the owner's control.
3. On a captioned public video, exercise the short-press toggle, long-press panel, and Caption state transitions.
4. Switch videos and restart the app; the preference persists while stale status does not.
5. Exercise no-caption or temporary-network failure, one-time presentation, retry/action enablement, and stop behavior.

The Agent does not connect to the physical device and does not collect its identifier, APK, signing material, or raw logs.

## Independent Review And Final Authority

Give the Reviewer the accepted plan, specification, rubric, candidate SHA, fixed sources, committed evidence, raw redacted check output, prerelease bundle identity, and structured smoke results, but no implementation reasoning. Blocking findings require a focused fix and a fresh candidate gate.

A Reviewer PASS is technical evidence only. The project owner must explicitly accept Phase 4 before the evidence ledger records completion or Phase 5 planning begins. This gate never creates a stable release or YouTube support claim.
