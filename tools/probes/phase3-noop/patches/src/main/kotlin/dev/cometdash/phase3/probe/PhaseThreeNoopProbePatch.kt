package dev.cometdash.phase3.probe

import app.morphe.patcher.patch.ApkFileType
import app.morphe.patcher.patch.AppTarget
import app.morphe.patcher.patch.Compatibility
import app.morphe.patcher.patch.resourcePatch

/** Development-only loader probe. Its empty Patch body intentionally mutates nothing. */
val phaseThreeNoopProbePatch = resourcePatch(
    name = "Phase 3 no-op Patch probe",
    description = "Development-only exact-APK Patch loading probe; performs no mutation.",
    default = false,
) {
    compatibleWith(
        Compatibility(
            packageName = "com.google.android.youtube",
            name = "YouTube",
            apkFileType = ApkFileType.APK_REQUIRED,
            signatures = setOf(
                "5aad2bee6db95d17e05a08d7d1e64c10a1511879154483916b6ae6c7fd9cb0c6",
                "3d7a1223019aa39d9ea0e3436ab7c0896bfb4fb679f4de5fe7c23f326c8f994a",
            ),
            targets = listOf(AppTarget(version = "21.04.223", minSdk = 28)),
        ),
    )
}
