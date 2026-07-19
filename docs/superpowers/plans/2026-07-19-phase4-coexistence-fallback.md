# Phase 4 Official-VoT Coexistence Fallback Proposal

## Status

This is a proposal requested by the project owner after the Phase 4 integration-seam gate blocked. It does not yet replace the accepted EVOT specification, ADR 0002, `AGENTS.md`, or the Phase 4 gate. Product implementation remains blocked until independent review and explicit project-owner acceptance of the corrected contract.

## Problem

Fixed Morphe Patcher and Manager revisions expose no cross-Bundle Patch conflict contract. A CometDash Patch also has no callback into Manager's pre-patch confirmation UI and receives no complete selected-Patch set. Therefore EVOT cannot truthfully promise a warning that blocks patching before Manager starts.

## Proposed Contract

Morphe Manager may display and allow selection of both independently named Patches. The CometDash Source and Patch description warn users to patch with only EVOT selected.

EVOT adds a runtime activation guard before it creates a Translation Run, changes the persistent enabled preference, fetches captions, or starts any other pipeline work:

1. Detect whether the official Voice over translation extension class is present in the patched app.
2. If absent, continue with the ordinary Phase 4 flow.
3. If present, fail closed: keep `Voice Translation Enabled` false, create no active Translation Run, perform no network request, and open the Pipeline Status panel on the first attempted activation.
4. Show stable failure code `OFFICIAL_VOT_PRESENT`, a redacted correlation ID, and the recovery instruction to repatch without official Voice over translation. Retry and settings actions remain disabled because the conflict cannot be repaired inside the running app.
5. Do not disable, modify, or claim ownership of the official Patch. Only EVOT refuses activation.

This is a runtime activation-conflict contract, not selection-time mutual exclusion. User-facing text and documentation must not claim that Manager prevents the two Patches from being selected or applied together.

## Evidence Gate

Before accepting this fallback, an independent Reviewer must verify that:

- fixed official source identifies a stable extension class whose presence follows from selecting official Voice over translation;
- the class-presence check does not initialize the official implementation or catch/retain arbitrary exception text;
- the guard runs before every EVOT entry path, including short press, persisted startup, video load, retry, and future background callbacks;
- absence and presence are injectable in pure-Java tests;
- no Patch-order or resource-collision assumption is used;
- if class presence cannot be proven reliably on the exact candidate, the proposal remains Blocking.

Any combined-patch output probe requires a separately recorded authorization. It may patch a copy of the exact local APK outside Git but must not install or launch official Voice over translation, retain the output after evidence capture, or record APK contents and class names derived from decompilation.

## Required Authority Changes After Acceptance

Only after Reviewer PASS and explicit project-owner acceptance:

1. Replace the selection-time prohibition in the EVOT specification with the runtime activation-conflict contract.
2. Add a new ADR that supersedes only the mutual-exclusion consequence of ADR 0002; EVOT remains independently named and namespaced.
3. Update `AGENTS.md`, the Phase 4 plan, observable-state gate, integration-seam evidence status, and manual smoke rubric.
4. Record the accepted decision and exact review commit in the evidence ledger.
5. Resume Phase 4 at a revised Ticket 2: prove the runtime presence marker and exact hook uniqueness before Ticket 3 product code.

## Revised Atomic Sequence

1. Independently review this proposal against the fixed Patcher, Manager, official VoT, and extension-library sources.
2. Present review findings and the corrected runtime-only contract to the project owner.
3. If accepted, update authority documents in one documentation-gate candidate and obtain a focused independent re-review.
4. Run the authorized presence-marker and exact-hook evidence probes; stop on any unverified result.
5. Continue the original Phase 4 Tickets 3-9 with the activation guard included in every vertical slice and acceptance test.

## Non-Goals

- No Morphe Manager fork or modification.
- No duplicate Patch name, intentional patch failure, resource collision, or execution-order detection.
- No automatic unpatching or disabling of official Voice over translation.
- No physical-device work by the Agent, stable release, `main` change, or YouTube support claim.
