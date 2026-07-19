group = "dev.cometdash.phase3.probe"

val externalBuildDir = System.getProperty("phase3.noop.buildDir")
if (!externalBuildDir.isNullOrBlank()) {
    layout.buildDirectory.set(file(externalBuildDir))
}

patches {
    about {
        name = "CometDash Phase 3 No-op Probe"
        description = "Development-only Morphe Patch loading probe"
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

tasks.register<JavaExec>("verifyNoopProbe") {
    description = "Verifies the standalone Phase 3 no-op Patch bundle."
    dependsOn("buildAndroid")
    classpath = sourceSets["main"].runtimeClasspath
    mainClass.set("dev.cometdash.phase3.probe.ProbeVerifierKt")
    args(layout.buildDirectory.dir("libs").get().asFile.absolutePath)
}
