# Verify GitHub Packages behavior, not credential presence

A non-empty username/token pair does not prove Morphe package access. Preflight must make a redacted request for the pinned plugin artifact and require HTTP `200` before Gradle builds start.

## Evidence

The first isolated build failed to resolve `app.morphe.patches` while the old token lacked `read:packages`; the credential-safe package probe returned `401`. A replacement classic token with `read:packages` returned `200`, after which both independent empty builds passed.

## Implications

Store package credentials only in the user Gradle configuration or process environment. Never paste tokens into chat or a non-secret prompt. If a token appears in visible output, stop, delete the generated local credential file without reading it, revoke the token, create a replacement through hidden input, and keep revocation confirmation as a gate condition.
