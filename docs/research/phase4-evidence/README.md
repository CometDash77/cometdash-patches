# Phase 4 Evidence Packet Format

Phase 4 evidence is committed as structured JSON plus short Markdown conclusions. Raw logs, APKs, decompiled output, signing material, device identifiers, credentials, headers, subtitle payloads, request bodies, and private endpoints remain outside Git.

Each JSON packet uses these top-level fields:

| Field | Meaning |
| --- | --- |
| `schemaVersion` | Evidence format version; Phase 4 starts at `1`. |
| `phase4BaseSha` | Fixed Phase 4 base commit. |
| `candidateSha` | Candidate commit, or `null` before a candidate exists. |
| `evidenceClass` | `Source`, `Official documentation`, `Runtime input`, or `Automated test`. |
| `subject` | Stable evidence subject identifier, never a private path or device value. |
| `checks` | Ordered checks with stable ID, `PASS`/`FAIL`/`BLOCKED`, evidence reference, and limit. |
| `failedExperiments` | Preserved failed attempts and their evidence limits. |

Evidence references use fixed upstream commit and path, committed test output, or a redacted local command label. A `PASS` result cannot be inferred from a later success; each failed attempt remains in `failedExperiments`.
