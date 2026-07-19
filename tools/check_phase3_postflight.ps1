param(
    [Parameter(Mandatory = $true)]
    [string]$BaseSha
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-Error([string]$message) {
    $errors.Add($message)
}

$sensitivePattern = '\.(apk|apkm|xapk|aab|apks|idsig|dex|smali|odex|vdex|oat|jks|keystore|p12|pfx|pk8|pem|key)$|(^|/)(decompiled|decompiled-output|jadx-output|upstream-cache)/'
$trackedSensitive = @(git -C $repoRoot ls-files | Where-Object { $_ -match $sensitivePattern })
if ($trackedSensitive.Count -gt 0) {
    Add-Error "Tracked sensitive artifacts: $($trackedSensitive -join ', ')"
}

$productChanges = @(git -C $repoRoot diff --name-only "$BaseSha..HEAD" -- patches extensions)
if ($productChanges.Count -gt 0) {
    Add-Error "Phase 3 changed product modules: $($productChanges -join ', ')"
}

$mainDenied = @(git -C $repoRoot ls-tree -r --name-only main -- tools docs AGENTS.md CONTEXT-MAP.md)
if ($mainDenied.Count -gt 0) {
    Add-Error "Development-only paths are present on main: $($mainDenied -join ', ')"
}

foreach ($metadata in @("patches-bundle.json", "patches-list.json", "README.md")) {
    $path = Join-Path $repoRoot $metadata
    if ((Get-Content -Raw -LiteralPath $path) -match '(?i)phase[ -]?3|no-op probe') {
        Add-Error "Generated or product metadata references the Phase 3 probe: $metadata"
    }
}

$evidenceFiles = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot "docs\research") -Recurse -File |
    Where-Object { $_.Name -match '(?i)phase.?3|development-build-baseline' })
$redactionPatterns = @(
    'emulator-\d+',
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
            Add-Error "Evidence redaction check failed: $([System.IO.Path]::GetRelativePath($repoRoot, $file.FullName))"
            break
        }
    }
}

git -C $repoRoot diff --check
if ($LASTEXITCODE -ne 0) {
    Add-Error "git diff --check failed."
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Output "Phase 3 postflight passed."
