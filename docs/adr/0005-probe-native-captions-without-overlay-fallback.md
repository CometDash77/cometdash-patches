---
status: accepted
---

# Probe native captions without an overlay fallback

LLM-translated captions will first be attempted through a bounded Native CC Injection Probe on a fixed YouTube version. If the native cue/renderer path cannot be hooked reliably, the subtitle feature is deferred; a custom overlay is explicitly rejected because it would create a separate styling, accessibility, gesture, picture-in-picture, and compatibility product surface.
