param(
    [string]$ApkPath,
    [string]$JadxHome = "C:\tmp\morphe-tools\jadx-1.5.6",
    [string]$JadxArchivePath = "C:\tmp\morphe-tools\jadx-1.5.6.zip"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-Error([string]$message) {
    $errors.Add($message)
}

function Add-Pass([string]$name, [string]$value) {
    Write-Output "PASS $name=$value"
}

function Get-MajorVersion([string]$text) {
    $match = [regex]::Match($text, '(?m)(?:version |javac )"?(?<major>\d+)')
    if (-not $match.Success) { return $null }
    return [int]$match.Groups['major'].Value
}

if ((git -C $repoRoot branch --show-current) -ne "dev") {
    Add-Error "Phase 3 must run on dev."
}

$unsafeStatus = @(git -C $repoRoot status --porcelain --untracked-files=no)
if ($unsafeStatus.Count -gt 0) {
    Add-Error "Tracked worktree changes are present."
}

$javaHome = if (-not [string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
    $env:JAVA_HOME
} else {
    "C:\Program Files\Android\Android Studio\jbr"
}
$java = Join-Path $javaHome "bin\java.exe"
$javac = Join-Path $javaHome "bin\javac.exe"
if (-not (Test-Path -LiteralPath $java) -or -not (Test-Path -LiteralPath $javac)) {
    Add-Error "JDK executables were not found through JAVA_HOME or Android Studio JBR."
} else {
    $javaVersion = (& $java -version 2>&1 | Out-String)
    $javacVersion = (& $javac -version 2>&1 | Out-String)
    $javaMajor = Get-MajorVersion $javaVersion
    $javacMajor = Get-MajorVersion $javacVersion
    if ($javaMajor -lt 21 -or $javacMajor -lt 21) {
        Add-Error "JDK 21 or newer is required."
    } else {
        Add-Pass "jdk_major" ([string]$javaMajor)
    }
}

$wrapperProperties = Join-Path $repoRoot "gradle\wrapper\gradle-wrapper.properties"
$wrapper = Get-Content -Raw -LiteralPath $wrapperProperties
if ($wrapper -notmatch 'gradle-9\.6\.1-bin\.zip') {
    Add-Error "Gradle wrapper is not pinned to 9.6.1."
}
if ($wrapper -notmatch 'distributionSha256Sum=9c0f7faeeb306cb14e4279a3e084ca6b596894089a0638e68a07c945a32c9e14') {
    Add-Error "Gradle wrapper checksum differs from the accepted pin."
}
$wrapperMode = git -C $repoRoot ls-files -s -- gradlew
if ($wrapperMode -notmatch '^100755 ') {
    Add-Error "gradlew is not tracked as executable."
} else {
    Add-Pass "gradle_wrapper" "9.6.1"
}

$gradleProperties = Join-Path $env:USERPROFILE ".gradle\gradle.properties"
$propertyUser = $false
$propertyKey = $false
if (Test-Path -LiteralPath $gradleProperties) {
    $propertyLines = Get-Content -LiteralPath $gradleProperties
    $propertyUser = [bool]($propertyLines -match '^\s*gpr\.user\s*=\s*\S+')
    $propertyKey = [bool]($propertyLines -match '^\s*gpr\.key\s*=\s*\S+')
}
$environmentPair = -not [string]::IsNullOrWhiteSpace($env:GITHUB_ACTOR) -and
    -not [string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)
if (-not (($propertyUser -and $propertyKey) -or $environmentPair)) {
    Add-Error "A complete GitHub Packages credential pair is not available."
} else {
    Add-Pass "package_credentials" "present"
}

$sdkRoot = if (-not [string]::IsNullOrWhiteSpace($env:ANDROID_SDK_ROOT)) {
    $env:ANDROID_SDK_ROOT
} else {
    $env:ANDROID_HOME
}
$adb = if ([string]::IsNullOrWhiteSpace($sdkRoot)) { "" } else { Join-Path $sdkRoot "platform-tools\adb.exe" }
$emulator = if ([string]::IsNullOrWhiteSpace($sdkRoot)) { "" } else { Join-Path $sdkRoot "emulator\emulator.exe" }
$sdkManager = if ([string]::IsNullOrWhiteSpace($sdkRoot)) { "" } else { Join-Path $sdkRoot "cmdline-tools\latest\bin\sdkmanager.bat" }
$avdManager = if ([string]::IsNullOrWhiteSpace($sdkRoot)) { "" } else { Join-Path $sdkRoot "cmdline-tools\latest\bin\avdmanager.bat" }
foreach ($tool in @($adb, $emulator, $sdkManager, $avdManager)) {
    if ([string]::IsNullOrWhiteSpace($tool) -or -not (Test-Path -LiteralPath $tool)) {
        Add-Error "Missing Android SDK tool: $([System.IO.Path]::GetFileName($tool))"
    }
}
if (Test-Path -LiteralPath $adb) {
    $adbVersion = (& $adb version 2>&1 | Out-String)
    if ($adbVersion -notmatch 'Version 37\.0\.0-') {
        Add-Error "ADB 37.0.0 is required for the accepted baseline."
    } else {
        Add-Pass "adb" "37.0.0"
    }
}
if (Test-Path -LiteralPath $emulator) {
    $acceleration = (& $emulator -accel-check 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0 -or $acceleration -notmatch '(?i)(usable|installed)') {
        Add-Error "Accelerated Android emulation is unavailable."
    } else {
        Add-Pass "emulator_acceleration" "available"
    }
}
$systemImagesRoot = if ([string]::IsNullOrWhiteSpace($sdkRoot)) { "" } else { Join-Path $sdkRoot "system-images" }
$aospImages = @(Get-ChildItem -LiteralPath $systemImagesRoot -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match '[\\/]default[\\/]' -and $_.FullName -notmatch '(?i)google|playstore' })
if ($aospImages.Count -eq 0) {
    Add-Error "No pure AOSP default system image is installed."
} else {
    Add-Pass "aosp_image" "present"
}

$jadx = Join-Path $JadxHome "bin\jadx.bat"
if (-not (Test-Path -LiteralPath $jadx)) {
    Add-Error "JADX 1.5.6 is not installed at the accepted tool path."
} else {
    $jadxVersion = (& $jadx --version 2>&1 | Out-String).Trim()
    if ($jadxVersion -notmatch '1\.5\.6') {
        Add-Error "JADX executable is not version 1.5.6."
    } else {
        Add-Pass "jadx" "1.5.6"
    }
}
if (-not (Test-Path -LiteralPath $JadxArchivePath)) {
    Add-Error "The pinned JADX archive is unavailable for checksum verification."
} else {
    $jadxHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $JadxArchivePath).Hash.ToLowerInvariant()
    if ($jadxHash -ne '545ea2be9c242511bc145755cf4bda2485ade42966e096f8b4d3da2a230e8974') {
        Add-Error "JADX archive checksum mismatch."
    } else {
        Add-Pass "jadx_archive_sha256" $jadxHash
    }
}

if ([string]::IsNullOrWhiteSpace($ApkPath)) {
    $apkCandidates = @(Get-ChildItem -LiteralPath $repoRoot -Filter "*.apk" -File)
    if ($apkCandidates.Count -eq 1) { $ApkPath = $apkCandidates[0].FullName }
}
if ([string]::IsNullOrWhiteSpace($ApkPath) -or -not (Test-Path -LiteralPath $ApkPath)) {
    Add-Error "Exactly one user-supplied APK must be available."
} else {
    $apk = Get-Item -LiteralPath $ApkPath
    $apkHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ApkPath).Hash.ToLowerInvariant()
    if ($apk.Length -ne 171814203 -or $apkHash -ne '78571be679f586d11a4e56fb1ce6bf9dfd958ce6b8af786c4a3bd94792ce8c7c') {
        Add-Error "User-supplied APK size or hash differs from the accepted baseline."
    } else {
        Add-Pass "apk_sha256" $apkHash
    }
    $relativeApkPath = [System.IO.Path]::GetRelativePath($repoRoot, $apk.FullName)
    if (git -C $repoRoot ls-files --error-unmatch -- $relativeApkPath 2>$null) {
        Add-Error "The user-supplied APK is tracked."
    }
    git -c core.excludesFile=NUL -C $repoRoot check-ignore --no-index --quiet -- $relativeApkPath
    if ($LASTEXITCODE -ne 0) {
        Add-Error "The user-supplied APK is not ignored by repository rules."
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Output "Phase 3 preflight passed."
