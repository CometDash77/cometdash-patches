---
status: accepted
---

# Freeze per-video runs and use timeline context

Each video creates a Translation Run with a frozen provider/model configuration, a bounded window around the playback head, and context ordered by subtitle time rather than network completion. This deliberately delays configuration changes until the next video so concurrent translation, retries, and seeks cannot combine providers, prompts, or future subtitles within one run.
