# Documentation Gate

This gate must pass before phase one begins.

## Automated checks

- Every relative Markdown file target exists. Fragment defects in immutable upstream snapshots are recorded in the evidence ledger instead of editing the snapshot.
- `AGENTS.md` links to every documentation class.
- `CONTEXT-MAP.md` resolves all contexts and every CONTEXT file follows the glossary-only structure.
- ADR numbers are unique and sequential.
- APKs, credentials, decompiled files and signing material are ignored and untracked.
- `main` contains only the product paths allowlisted by the repository workflow; `dev` contains the required knowledge assets.
- The local snapshot digest matches `manifest.json`.
- `tools/sync_upstream_docs.ps1 -Check` compares every staged snapshot blob with the fixed GitHub revision and verifies that revision is still upstream `main`.

## Independent review

Give the Reviewer only the accepted plan, repository tree, documentation artifacts, rubric and cited raw sources. Do not provide the implementing Agent's reasoning transcript.

The Reviewer checks:

- Every confirmed interview decision appears once in an authoritative spec.
- Specs, ADRs, glossary and evidence do not contradict each other.
- Every architecture claim has a fixed revision and file path or is explicitly marked unverified.
- Unknown technical facts are gates rather than hidden assumptions.
- ADRs are limited to hard-to-reverse decisions with real alternatives.
- `main/dev` boundaries are implementable and stable publication is correctly blocked.

## Final authority

Resolve all blocking review findings, then present the documentation set to the user. Only the user can authorize phase one.
