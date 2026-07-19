# Phase 2 Official Voice Over Translation Research Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `mattpocock-skills:research` for primary-source research and `superpowers:dispatching-parallel-agents` for independent evidence domains. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Trace the official Voice over translation v1.35.0 Patch injection, captions, translation, TTS, playback synchronization, and original-audio multiplier into independently reviewable research assets.

**Architecture:** Work only on `dev`. Three isolated Terra research agents return source evidence packets without editing; the primary Agent rechecks every claim and writes one candidate report. A separate main-grade Reviewer independently verifies the candidate before the user decides whether Phase 2 is complete.

**Tech Stack:** Markdown, PowerShell, Git, GitHub REST API, Kotlin/Java source inspection.

---

## Boundary

This plan authorizes source research and documentation only. It does not authorize APK inspection, Patch implementation, Phase 3, changes to `main`, release, or a support claim for YouTube `21.04.223`.

## Fixed Artifacts

- Plan: `docs/superpowers/plans/2026-07-19-morphe-phase-2.md`
- Candidate report: `docs/research/official-voice-over-translation.md`
- Evidence updates: `docs/research/evidence-ledger.md`
- Independent review: `docs/research/2026-07-19-official-voice-over-translation-review.md`
- No product API, Patch namespace, Gradle artifact, or release metadata changes.

## Atomic Steps

### Task 1: Freeze And Archive The Plan

- [ ] Confirm a clean `dev` worktree with `git status --short --branch`.
- [ ] Record `PHASE2_BASE_SHA` with `git rev-parse HEAD`; the approved planning baseline is `bdfbffa87f9ce4de85ced65d3f07ec7a261b8af9`.
- [ ] Save this approved plan without implementation reasoning.
- [ ] Scan the plan for placeholders, contradictions, and unresolved choices.
- [ ] Run the documentation checker and `git diff --check`.
- [ ] Commit as `docs: plan phase two research`.

### Task 2: Freeze The Upstream Source Corpus

- [ ] Query the current `MorpheApp/morphe-patches` `main` HEAD; keep `e12088c89942f5d637a824ce81643a28b86fb851` (v1.35.0) as the research baseline.
- [ ] If upstream changes, record the divergence without silently re-anchoring or mixing revisions.
- [ ] Verify the recursive tree is complete and `truncated=false`.
- [ ] Inventory the three VoT Patch files, ten core runtime files, button/settings/preference/resource files, and direct dependencies.
- [ ] Include the shared VideoId, VideoInformation, PlayerType, overlay-button, and legacy-controls hooks plus their fingerprint definitions.
- [ ] Do not clone, vendor, checkout, or commit upstream source.

### Task 3: Dispatch Independent Evidence Domains

- [ ] Dispatch three isolated `gpt-5.6-terra` medium-reasoning research agents with `fork_turns=none`.
- [ ] Agent A researches Patch metadata, dependencies, resources, settings, buttons, local fingerprints, and shared hooks.
- [ ] Agent B researches TranscriptFetcher, TranscriptSegment, batching, Google/MyMemory/OpenRouter, SSE, seek, and abort behavior.
- [ ] Agent C researches VoiceCatalog, System/Edge TTS, cache, prefetch, playback synchronization, and original-audio multiplier behavior.
- [ ] Agents do not edit the repository; they return Claim / frozen path+line / evidence class / evidence limit / failed-check packets.
- [ ] The primary Agent rereads every cited source and deletes or marks unsupported claims `Unverified`.

### Task 4: Build The Patch And Injection Model

- [ ] Record Patch compatibility, dependencies, resource copying, settings registration, and button initialization.
- [ ] Build a fingerprint ledger containing match signals, source-proven target semantics, injection location, and extension descriptor.
- [ ] Trace `hookVideoId -> newVideoLoaded` and `videoTimeHook -> videoTimeChanged`.
- [ ] Trace player-type, button-initialization, and legacy-visibility shared hooks.
- [ ] Do not infer obfuscated class names from fingerprints; unsupported names remain `Unverified`.
- [ ] Commit as `docs: trace voice translation hooks`.

### Task 5: Build The Runtime Data Flow

- [ ] Trace caption acquisition, caption URL selection, authentication inputs, JSON3 parsing, and segment merging.
- [ ] Trace batch construction, target selection, streaming updates, output parsing, and all three translation services.
- [ ] Trace the TranscriptSegment update contract across original, partial, and completed translation states.
- [ ] Trace voice selection, System/Edge synthesis, memory cache, test-sample disk cache, and prefetch.
- [ ] Trace playback clock, pause/resume, speed, seek, video change, end, and TTS completion behavior.
- [ ] Trace AudioSink/AudioTrack injection through multiplier setting, periodic enforcement, and restoration.
- [ ] Commit as `docs: trace voice translation runtime`.

### Task 6: Model State, Threads, And Failures

- [ ] Draw the video ID/time -> captions -> translation -> cache/prefetch -> speech -> multiplier data flow.
- [ ] Build a state-ownership table for session, video, loading, translator session, batch, TTS, prefetch, and multiplier state.
- [ ] Build a thread table for hook/main work, background work, main Handler callbacks, locks, volatile/atomic state, and stale-callback guards.
- [ ] Build a failure table with trigger, detection, current handling, user-visible behavior, recovery, and data-exposure boundary.
- [ ] Cover normal playback, same/cross-segment seek, pause/resume, video change, partial stream, provider, TTS, and cache failures.
- [ ] Label every scenario as source-derived rather than APK runtime observation.

### Task 7: Complete Research Entries And Unknown Gates

- [ ] For every research domain record purpose, problem, files, revision, minimal code example, common mistakes, and EVOT application.
- [ ] Separate reusable mechanisms, official limitations that must be replaced, and risk-only observations.
- [ ] Keep exact APK fingerprint matches, System/Edge runtime, remote service behavior, and shared-hook stability unverified without runtime evidence.
- [ ] Preserve the existing mutually incompatible Patch API, keystore, and native-caption injection unknowns.
- [ ] Update the evidence ledger with verified findings, failed checks, and later-phase gates.
- [ ] Commit as `docs: complete voice translation research`.

### Task 8: Self-Review And Automated Acceptance

- [ ] Map all seven Phase 2 call-chain requirements to report sections.
- [ ] Verify every GitHub source link uses a resolvable 40-character SHA URL.
- [ ] Ensure every inventoried source file is cited or explicitly excluded.
- [ ] Scan for placeholders, unsupported class names, runtime support claims, and internal contradictions.
- [ ] Run `tools/check_documentation.ps1`, the upstream freshness check, and `git diff --check`.
- [ ] If freshness is blocked by infrastructure, preserve the failure, do not cite the vendored snapshot, and do not claim PASS.
- [ ] Confirm the Phase 2 diff contains only the plan and `docs/research`, with no APK, decompiled output, or product code.

### Task 9: Independent Main-Grade Review

- [ ] Start a fresh-context `gpt-5.6-sol` high-reasoning Reviewer.
- [ ] Give it only the plan, candidate SHA, specifications, report, ledger, rubric, frozen sources, and raw check outputs.
- [ ] Have it independently recheck injection, data flow, state, threads, failures, unknowns, and phase boundaries.
- [ ] The Reviewer writes only its review report and does not modify candidate artifacts.
- [ ] Stop on any Blocking finding; create a finding-specific micro-plan, resolve it, and request another independent review.
- [ ] Treat Reviewer PASS as a technical gate only, not Phase 3 authorization.

### Task 10: User Final Gate

- [ ] Present the candidate SHA, Reviewer verdict, finding status, and raw check results to the user.
- [ ] Stop unless the user explicitly approves Phase 2 completion.
- [ ] After approval, record the candidate, review commit, time, and decision in the evidence ledger.
- [ ] Commit as `docs: complete phase two gate`.
- [ ] Stop; Phase 3 requires separate explicit authorization and a new plan.

## Completion Standard

An independent Reviewer must be able to reconstruct every critical call chain from frozen source and confirm that the report distinguishes Source evidence, runtime observation, and `Unverified` claims. Phase 2 requires Reviewer PASS, resolution of every Blocking finding, and explicit user approval.
