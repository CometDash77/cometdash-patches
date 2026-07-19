package dev.cometdash.phase3.probe

import app.morphe.patcher.patch.ApkFileType
import app.morphe.patcher.patch.loadPatchesFromJar
import java.io.File

private const val patchName = "Phase 3 no-op Patch probe"
private val expectedSigners = setOf(
    "5aad2bee6db95d17e05a08d7d1e64c10a1511879154483916b6ae6c7fd9cb0c6",
    "3d7a1223019aa39d9ea0e3436ab7c0896bfb4fb679f4de5fe7c23f326c8f994a",
)

fun main(args: Array<String>) {
    require(args.size == 1) { "Expected the probe bundle directory." }
    val bundles = File(args.single()).listFiles { file -> file.extension == "mpp" }?.toSet().orEmpty()
    require(bundles.size == 1) { "Expected exactly one probe bundle, found ${bundles.size}." }

    val patches = loadPatchesFromJar(bundles)
    require(patches.size == 1) { "Expected exactly one loadable Patch, found ${patches.size}." }
    val patch = patches.single()
    require(patch.name == patchName) { "Unexpected Patch name: ${patch.name}" }
    require(!patch.default) { "The probe must not be selected by default." }
    require(patch.dependencies.isEmpty()) { "The probe must not have dependencies." }
    require(patch.options.isEmpty()) { "The probe must not have options." }

    val compatibility = patch.compatibility?.singleOrNull()
        ?: error("The probe must declare exactly one compatibility target.")
    require(compatibility.packageName == "com.google.android.youtube")
    require(compatibility.apkFileType == ApkFileType.APK_REQUIRED)
    require(compatibility.signatures == expectedSigners)
    val target = compatibility.targets.singleOrNull()
        ?: error("The probe must declare exactly one app target.")
    require(target.version == "21.04.223")
    require(target.minSdk == 28)

    println("PASS phase3_noop_probe=one_loadable_no_mutation_patch")
}
