# Repository Workflow

## Branch roles

- `dev`: complete engineering tree, pre-release code, Agent memory, official documentation snapshots, specs, ADRs, research, runbooks and tests.
- `main`: product-only stable Source projection. It must not contain `AGENTS.md`, `CONTEXT-MAP.md`, `docs/`, `tools/`, `reasonix.toml`, APKs, caches or reverse-engineering output.

## Main product allowlist

Stable projection may copy only reviewed product paths:

- `.github/`, `.editorconfig`, `.gitattributes`, `.gitignore`, `.releaserc`
- `extensions/`, `patches/`, `gradle/`, `gradlew`, `gradlew.bat`
- `settings.gradle.kts`, `gradle.properties`, `package.json`, `package-lock.json`
- `README.md`, `LICENSE`, `NOTICE`, `CHANGELOG.md`
- generated `patches-bundle.json` and `patches-list.json`

An allowlisted path is not automatically safe: generated metadata, URLs and user documentation still require review.

## Development commits

1. Work only on `dev`.
2. Use `feat:`, `fix:` and `chore:` semantic commit types expected by the template.
3. Do not manually edit generated release files unless the release workflow explicitly requires it.
4. Run applicable automated gates and request independent review.
5. Use Morphe Manager's pre-release Source option for candidate testing.

## Stable promotion

Stable promotion is currently **blocked**. Do not merge `dev` wholesale into `main`: that violates the branch content boundary and the template's default semantic-release backmerge can remove development assets from `dev`.

Before the first stable release, implement and review a projection workflow that:

1. Starts from `main`.
2. Copies the reviewed allowlist from the approved `dev` commit.
3. Proves every denylisted development path is absent.
4. Builds the exact projected tree.
5. Creates a reviewable promotion commit without rewriting either branch.
6. Runs semantic release without backmerging the product-only tree over `dev`.

Until this exists, `main` remains the clean template baseline and no stable release is authorized.
