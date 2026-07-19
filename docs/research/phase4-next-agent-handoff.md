# Phase 4 Fresh-Agent Handoff

## Current State

- Working branch: `dev`.
- Accepted Phase 4 base: `b0a74a7fef5547d644c545ae742c9be8b799f54a`.
- Entry commit: `fdcac803a9c32fbe6fd518bf81774a2a9e731634`; workflow `29685139734` passed.
- Integration-seam evidence commit: `72ac42acf3cd3135c2124524054997d8f84506a8`; workflow `29685682101` passed.
- Product modules remain unchanged from the Phase 4 base.
- Ticket 2 is Blocking because Morphe has no cross-Bundle selection-conflict API.
- The project owner requested a plan for fallback option 2. The proposal corrects the earlier conversational description: pre-patch blocking is unavailable; the feasible candidate is an EVOT runtime activation guard.

## Required Reading

Read these completely before acting:

1. `AGENTS.md` and `CONTEXT-MAP.md`.
2. `docs/specs/enhanced-voice-over-translation.md` and ADR 0002.
3. `docs/research/evidence-ledger.md`.
4. `docs/research/phase4-integration-seams.md` and its JSON evidence packet.
5. `docs/superpowers/plans/2026-07-19-morphe-phase-4.md`.
6. `docs/superpowers/plans/2026-07-19-phase4-coexistence-fallback.md`.
7. `docs/testing/observable-state-gate.md`.

## Next Task

Perform an independent documentation/design review of the coexistence fallback proposal. Receive the proposal, accepted specification, ADRs, fixed source revisions, evidence report, and rubric, but not the previous implementing Agent's reasoning.

The review must answer:

- Is a stable official-extension presence marker supported by fixed source?
- Can EVOT check it before every activation path without initializing official VoT?
- Does fail-closed EVOT activation adequately and honestly replace selection-time mutual exclusion?
- What exact specification, ADR, Agent rule, gate, and smoke-test wording must change?
- Is a non-install combined-patch probe necessary, and what explicit authorization would it require?

Do not modify product modules, run an official-VoT install, or mark the proposal accepted. After review, present findings and the corrected contract to the project owner. Only the owner can authorize the authority-document amendment and resume Phase 4 implementation.

## Verification Before Handoff Completion

Confirm `git status --short --branch` is clean, `dev` matches `origin/dev`, documentation checks pass, upstream freshness passes, and the remote workflow for the handoff commit succeeds.
