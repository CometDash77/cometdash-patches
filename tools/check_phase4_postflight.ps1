param(
    [Parameter(Mandatory = $true)]
    [string]$BaseSha
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-CheckError([string]$message) {
    $errors.Add($message)
}

$sensitivePattern = '\.(apk|apkm|xapk|aab|apks|idsig|dex|smali|odex|vdex|oat|jks|keystore|p12|pfx|pk8|pem|key)$|(^|/)(decompiled|decompiled-output|jadx-output|upstream-cache)/'
$trackedSensitive = @(git -C $repoRoot ls-files | Where-Object { $_ -match $sensitivePattern })
if ($trackedSensitive.Count -gt 0) {
    Add-CheckError "Tracked sensitive artifacts: $($trackedSensitive -join ', ')"
}

$mainDenied = @(git -C $repoRoot ls-tree -r --name-only main -- tools docs AGENTS.md CONTEXT-MAP.md)
if ($mainDenied.Count -gt 0) {
    Add-CheckError "Development-only paths are present on main: $($mainDenied -join ', ')"
}

$probeLeaks = @(git -C $repoRoot ls-files patches extensions | Where-Object { $_ -match '(?i)phase4.*probe|phase-?4.*probe' })
if ($probeLeaks.Count -gt 0) {
    Add-CheckError "A Phase 4 evidence probe leaked into product modules: $($probeLeaks -join ', ')"
}

$productSources = @(git -C $repoRoot ls-files 'patches/src/**' 'extensions/**/src/**')
foreach ($path in $productSources) {
    if ($path -match '\.(java|kt)$' -and $path -notmatch '(^|/)evot(/|$)' -and $path -notmatch '^patches/src/main/kotlin/util/') {
        Add-CheckError "EVOT product source is outside the evot namespace: $path"
    }
}

$evidenceFiles = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot "docs\research") -Recurse -File |
    Where-Object { [System.IO.Path]::GetRelativePath($repoRoot, $_.FullName) -match '(?i)phase.?4|observable-state' })
$redactionPatterns = @(
    '(?i)Authorization:\s*\S+',
    '(?i)Cookie:\s*\S+',
    '(?i)Bearer\s+[A-Za-z0-9._-]+',
    '(?i)api[_-]?key\s*[:=]\s*\S+',
    '(?i)http://(?:10\.|192\.168\.|172\.(?:1[6-9]|2\d|3[01])\.)',
    '(?i)[A-Z]:\\[^\r\n]*\.apk'
)
foreach ($file in $evidenceFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    foreach ($pattern in $redactionPatterns) {
        if ($content -match $pattern) {
            Add-CheckError "Evidence redaction check failed: $([System.IO.Path]::GetRelativePath($repoRoot, $file.FullName))"
            break
        }
    }
}

git -C $repoRoot diff "$BaseSha..HEAD" --check
if ($LASTEXITCODE -ne 0) {
    Add-CheckError "git diff --check failed."
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Output "Phase 4 postflight passed."
