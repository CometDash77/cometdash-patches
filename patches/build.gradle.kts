group = "dev.cometdash.patches"

patches {
    about {
        name = "CometDash Patches"
        description = "Independent Android app patches compatible with Morphe"
        source = "https://github.com/CometDash77/cometdash-patches.git"
        author = "CometDash77"
        contact = "https://github.com/CometDash77/cometdash-patches/issues"
        website = "https://github.com/CometDash77/cometdash-patches"
        license = "GPLv3"
    }
}

kotlin {
    compilerOptions {
        freeCompilerArgs.add("-Xcontext-parameters")
    }
}

// Separate configuration so gson is available at runtime for the
// generatePatchesList task but never bundled into the APK.
val patchListGeneratorClasspath: Configuration by configurations.creating

dependencies {
    compileOnly(libs.gson)
    patchListGeneratorClasspath(libs.gson)
}

tasks {
    register<JavaExec>("generatePatchesList") {
        description = "Build patch with patch list"

        dependsOn(build)

        classpath = sourceSets["main"].runtimeClasspath + patchListGeneratorClasspath
        mainClass.set("util.PatchListGeneratorKt")
    }

    // Used by gradle-semantic-release-plugin.
    publish {
        dependsOn("generatePatchesList")
    }
}
