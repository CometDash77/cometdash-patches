# Patch Release Gate

This gate is specified now but is not active until Patch implementation begins.

## Candidate evidence

- Exact source commit and generated bundle hashes.
- Exact YouTube APK version and SHA-256.
- Successful build, Patch application and installation logs with secrets removed.
- Automated unit/contract tests for state, provider requests, parsing, retry, context ordering and audio restoration.
- Independent Reviewer report.

## User smoke check

The user performs no more than five checks through the real Morphe App workflow:

1. Add/update the CometDash Source and discover the intended candidate.
2. Patch the declared YouTube APK without selecting official Voice over translation.
3. Start the patched app successfully.
4. Pass one Provider diagnostic using the selected provider/model.
5. On one real captioned video, confirm status visibility, translated TTS, controls and temporary Audio Ducking; export a redacted log on failure.

## Compatibility claim

Only versions completing this gate are listed as supported. The initial candidate is YouTube `21.04.223`; other official stable versions remain unsupported until their own APK evidence passes.
