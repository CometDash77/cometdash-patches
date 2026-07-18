# Context Map

## Contexts

- [Patch Source](./docs/contexts/patch-source/CONTEXT.md) - packages and publishes independently maintained patches for Morphe.
- [Enhanced Voice Over Translation](./docs/contexts/enhanced-voice-over-translation/CONTEXT.md) - translates timed video speech and coordinates translated speech playback.

## Relationships

- **Patch Source -> Enhanced Voice Over Translation**: the Source publishes Enhanced Voice Over Translation as its first Patch.
- **Enhanced Voice Over Translation -> Patch Source**: a releasable Patch supplies compatibility, metadata, extension code, and verification evidence to the Source release gate.
- **Morphe** is an external compatible platform, not a CometDash bounded context or project brand.
