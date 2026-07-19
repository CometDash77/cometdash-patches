# Do not let an invalid inherited token break public evidence checks

Environment token presence is not authentication proof. A public GitHub freshness check should validate a candidate token without exposing it and fall back to the unauthenticated public API on `401`, while preserving non-authentication network failures.

## Evidence

The upstream freshness script selected an inherited invalid `GITHUB_TOKEN` and failed with `401` even though the target repository was public. Token validation plus an authentication-only fallback restored the intended evidence path.

## Implications

Differentiate invalid credentials, network failure, rate limiting, stale upstream, and content mismatch. Never report one class as another or ask users to rotate a valid package token for an unrelated public API check.
