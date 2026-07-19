# Static candidates are not fingerprint or runtime proof

An exact APK hash permits runtime-input claims only for that file. A unique literal in partial JADX output is a candidate, not proof of the complete opcode structure, target owner, injection point, callback behavior, UI, audio effect, or version support.

## Evidence

JADX 1.5.6 returned 198 decompilation errors. Playback-time and AudioSink literals each had one candidate, while legacy-control and AudioTrack structures remained many-to-many; no obfuscated owner was accepted.

## Implications

Record tool exit status, error counts, candidate counts, missing structural predicates, and every `Unverified` boundary. Never fill an unknown owner from a fingerprint name or decompiler guess.
