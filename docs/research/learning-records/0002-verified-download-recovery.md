# Recover large official downloads without weakening provenance

Do not run multiple resumable writers against one partial file. Stop all stale writers, discard the ambiguous partial, transfer the fixed official URL once, and accept the result only after its pinned SHA-256 matches.

## Evidence

Concurrent interrupted `curl` writers made the JADX partial untrustworthy. A single BITS transfer completed the official JADX archive and matched its release digest; the same approach recovered the Gradle distribution after wrapper resets/timeouts and matched `distributionSha256Sum` before seeding the wrapper cache.

## Implications

Preserve every failed transfer as transport evidence, not an upstream artifact failure. A browser-downloaded fixed-SHA source archive is acceptable only with commit-API verification, local archive hash, layout checks, and an explicit no-Git-metadata evidence limit.
