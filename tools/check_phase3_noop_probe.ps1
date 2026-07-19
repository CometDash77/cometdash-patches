param(
    [string]$OutputRoot = "C:\tmp\phase3-noop-probe",
    [string]$ProbeBaseSha = "6b4229de38d1d42aab85a121d71a847f2a7ae615",
    [string]$ProbeTipSha = "b5988c5e6f37aa78a975370156593025783cc832"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$probeRoot = Join-Path $repoRoot "tools\probes\phase3-noop"
$patchSource = Join-Path $probeRoot "patches\src\main\kotlin\dev\cometdash\phase3\probe\PhaseThreeNoopProbePatch.kt"
$verifierSource = Join-Path $probeRoot "patches\src\main\kotlin\dev\cometdash\phase3\probe\ProbeVerifier.kt"
$buildRoot = Join-Path $OutputRoot "build"

function Require-Match([string]$content, [string]$pattern, [string]$message) {
    if ($content -notmatch $pattern) { throw $message }
}

$patchContent = Get-Content -Raw -LiteralPath $patchSource
$verifierContent = Get-Content -Raw -LiteralPath $verifierSource
Require-Match $patchContent 'val\s+phaseThreeNoopProbePatch\s*=\s*resourcePatch\(' "Probe must declare one resourcePatch."
if (($patchContent | Select-String -AllMatches -Pattern 'resourcePatch\(').Matches.Count -ne 1) {
    throw "Probe source must declare exactly one Patch."
}
Require-Match $patchContent 'ApkFileType\.APK_REQUIRED' "Probe must require an APK input."
Require-Match $patchContent 'version\s*=\s*"21\.04\.223"' "Probe must target only YouTube 21.04.223."
Require-Match $patchContent 'minSdk\s*=\s*28' "Probe must require minSdk 28."
Require-Match $patchContent '5aad2bee6db95d17e05a08d7d1e64c10a1511879154483916b6ae6c7fd9cb0c6' "Missing SDK 33+ signer."
Require-Match $patchContent '3d7a1223019aa39d9ea0e3436ab7c0896bfb4fb679f4de5fe7c23f326c8f994a' "Missing SDK 24-32 signer."
if ($patchContent -match 'extendWith|execute\s*\{|finalize\s*\{|BytecodePatch|RawResourcePatch') {
    throw "Probe source declares a mutation or extension mechanism."
}
Require-Match $verifierContent 'patches\.size == 1' "Runtime verifier must check Patch loader cardinality."

$forbidden = @("patches", "extensions", "patches-bundle.json", "patches-list.json", "README.md")
git -C $repoRoot merge-base --is-ancestor $ProbeBaseSha $ProbeTipSha
if ($LASTEXITCODE -ne 0) { throw "Probe commit range is missing or invalid." }
foreach ($path in $forbidden) {
    $changes = @(git -C $repoRoot diff --name-only "$ProbeBaseSha..$ProbeTipSha" -- $path)
    if ($changes.Count -gt 0) { throw "Probe changed forbidden product path: $($changes -join ', ')" }
}
$mainProbePaths = @(git -C $repoRoot ls-tree -r --name-only main -- tools/probes/phase3-noop)
if ($mainProbePaths.Count -gt 0) {
    throw "Probe must be excluded from main."
}

$javaHome = if ($env:JAVA_HOME) { $env:JAVA_HOME } else { "C:\Program Files\Android\Android Studio\jbr" }
$env:JAVA_HOME = $javaHome
& (Join-Path $repoRoot "gradlew.bat") --version --no-daemon | Select-String 'Gradle 9\.6\.1' | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Gradle 9.6.1 is required." }
& (Join-Path $repoRoot "gradlew.bat") -p $probeRoot ':patches:verifyNoopProbe' --no-daemon "-Dphase3.noop.buildDir=$buildRoot"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$artifacts = @(Get-ChildItem -LiteralPath (Join-Path $buildRoot "libs") -Filter '*.mpp' -File)
if ($artifacts.Count -ne 1) { throw "Expected exactly one probe artifact, found $($artifacts.Count)." }
$artifact = $artifacts[0]
$hash = (Get-FileHash -LiteralPath $artifact.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
Write-Output "PASS phase3_noop_artifact_bytes=$($artifact.Length)"
Write-Output "PASS phase3_noop_artifact_sha256=$hash"
