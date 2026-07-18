# Enhanced Voice Over Translation

This context names the user-visible translation and speech concepts of the first CometDash Patch.

## Language

**Voice Translation Enabled**:
The persistent user preference that permits new videos to start translated voice playback.
_Avoid_: Session enabled, current video state

**Translation Run**:
The isolated translation lifecycle for one loaded video using one frozen configuration snapshot.
_Avoid_: Global session, provider setting

**Provider Profile**:
A named translation service configuration selected for future Translation Runs.
_Avoid_: Vendor, endpoint string

**Built-in Provider Profile**:
A non-deletable Provider Profile whose protocol capabilities are maintained by the Patch.
_Avoid_: Hard-coded request

**Custom Provider Profile**:
A user-managed OpenAI-compatible Provider Profile with its own endpoint, credentials, and capabilities.
_Avoid_: Arbitrary request template

**Model Configuration**:
The request behavior stored for one model within one Provider Profile.
_Avoid_: Global AI settings

**Translation Window**:
The bounded part of the video timeline prioritized for translation around the playback head.
_Avoid_: Entire transcript, request batch

**Video Context Summary**:
A model-generated semantic outline of the current video used as optional translation context.
_Avoid_: Translated captions, conversation history

**Neighbor Context**:
Original subtitle text adjacent to a target batch that informs translation but is not requested as output.
_Avoid_: Translation Window, duplicate target text

**Timeline History**:
Completed source/translation pairs preceding a target on the video timeline and eligible for context reuse.
_Avoid_: Network completion order, global chat memory

**Pipeline Status**:
The user-visible snapshot of caption acquisition, context preparation, translation, speech preparation, and playback.
_Avoid_: Debug log, enabled icon

**Audio Ducking**:
The temporary reduction of original video audio only while translated speech is audible.
_Avoid_: YouTube volume change, persistent volume setting

**Native CC Injection Probe**:
A time-bounded experiment that tests whether translated cues can enter YouTube's native caption renderer reliably.
_Avoid_: Promised subtitle feature, custom subtitle overlay
