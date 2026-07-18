# Patch Source

This context names the artifacts and gates used to distribute CometDash patches through Morphe.

## Language

**Patch Source**:
A versioned catalog from which Morphe discovers and downloads CometDash Patch Bundles.
_Avoid_: Plugin market, APK repository

**Patch**:
A declared Android application modification distributed inside a Patch Bundle.
_Avoid_: Plugin, modified APK

**Patch Bundle**:
The released executable collection of Patches and its discovery metadata.
_Avoid_: Source repository, patched app

**Development Channel**:
The pre-release Source channel produced from the `dev` branch for engineering validation.
_Avoid_: Production branch, stable channel

**Stable Channel**:
The user-facing Source channel projected into the `main` branch after all release gates pass.
_Avoid_: Development channel, working tree

**Release Projection**:
The product-only representation promoted from the complete Development Channel into the Stable Channel.
_Avoid_: Full branch merge

**Release Gate**:
The evidence threshold that a candidate must satisfy before entering the Stable Channel.
_Avoid_: Build success, self-approval

**Evidence Ledger**:
The versioned register of sources, revisions, observations, and unresolved claims supporting project decisions.
_Avoid_: Notes dump, model memory

**Upstream Documentation Snapshot**:
A revision-pinned local copy of official documentation used for reproducible research.
_Avoid_: Current upstream truth, forked documentation
