---
status: accepted
---

# Separate development and release trees

CometDash Patches uses GitHub and the official Morphe patches template, but `dev` is the complete engineering tree while `main` is a product-only release projection. We chose projection instead of merging `dev` wholesale because official documentation snapshots, Agent memory, research, ADRs, and local engineering tools must remain available for development without appearing in the stable Source tree.

## Consequences

The template's default merge-only and semantic-release backmerge assumptions cannot be used unchanged: its pinned [`.releaserc`](https://github.com/MorpheApp/morphe-patches-template/blob/93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe/.releaserc) configures a `main` to `dev` backmerge. Stable publication remains blocked until an allowlisted projection workflow is implemented and independently reviewed.
