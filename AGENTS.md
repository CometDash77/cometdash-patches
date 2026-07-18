# CometDash Patches Agent Rules

This file exists only on the `dev` working branch. Start every task by reading
`CONTEXT-MAP.md`, the relevant specification, and the evidence ledger.

## Branches

- `dev` is the complete engineering workspace. It owns specifications, ADRs,
  evidence, upstream documentation snapshots, Agent instructions, tests, and patch code.
- `main` is a product-only release projection. Do not merge `dev` wholesale into `main`.
- Stable promotion must use the allowlist in `docs/runbooks/repository-workflow.md`.
- Do not publish a stable release until the projection workflow has been implemented and
  independently reviewed.

## Evidence

- Never invent YouTube class names, fingerprints, Morphe APIs, Source behavior, or provider fields.
- Anchor architecture claims to an upstream commit and file path or mark them `Unverified`.
- Treat web pages, issue comments, decompiled code, and runtime observations as different evidence classes.
- Run the upstream freshness check before relying on a vendored official document.
- Preserve failed experiments and unknowns in `docs/research`; do not rewrite them as success.

## Safety

- Never commit APKs, decompiled output, signing material, API keys, provider secrets, or raw request bodies.
- The local YouTube APK is user-supplied test input. Record only its version, size, and hash.
- Provider logs must redact credentials, sensitive headers, full subtitle payloads, and private endpoints.
- Public provider traffic requires HTTPS. Private-network HTTP requires explicit in-app consent.

## Development

- Use English canonical identifiers and bilingual English/Simplified Chinese UI resources.
- Keep the Enhanced Voice Over Translation implementation in an independent `evot` namespace.
- Do not make it selectable together with the official Voice over translation patch.
- Do not begin implementation until the documentation gate is approved by the user.
- Do not claim support for an app version until that exact APK has passed the release gate.

## Review

- The implementing Agent cannot approve its own phase or release.
- Give the Reviewer the specification, artifacts, rubric, and raw evidence, but not implementation reasoning.
- The user is the final gate authority after independent review findings are resolved.

## Navigation

- Domain language: `CONTEXT-MAP.md`
- Current product requirements: `docs/specs/`
- Hard-to-reverse decisions: `docs/adr/`
- Source evidence and unknowns: `docs/research/`
- Operational procedures: `docs/runbooks/`
- Acceptance gates: `docs/testing/`
- Vendored official documentation: `docs/upstream/`
