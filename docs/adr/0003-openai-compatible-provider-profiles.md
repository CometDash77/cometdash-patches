---
status: accepted
---

# Use capability-aware OpenAI-compatible Provider Profiles

AI translation is modeled as multiple built-in or user-managed Provider Profiles over an OpenAI-compatible core, with OpenRouter and DeepSeek China as built-ins. This avoids a free-form JSON request system and multiple unrelated protocol adapters while still supporting custom endpoints; credentials are Keystore-backed, never exported, and provider-specific fields are emitted only when declared capabilities support them.
