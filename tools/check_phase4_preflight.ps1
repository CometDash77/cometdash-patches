param(
    [string]$BaseSha = "b0a74a7fef5547d644c545ae742c9be8b799f54a"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-CheckError([string]$message) {
    $errors.Add($message)
}

$branch = git -C $repoRoot branch --show-current
if ($branch -ne "dev") {
    Add-CheckError "Phase 4 must run on dev."
}

git -C $repoRoot cat-file -e "$BaseSha^{commit}" 2>$null
if ($LASTEXITCODE -ne 0) {
    Add-CheckError "Phase 4 base commit is unavailable: $BaseSha"
} else {
    git -C $repoRoot merge-base --is-ancestor $BaseSha HEAD
    if ($LASTEXITCODE -ne 0) {
        Add-CheckError "Phase 4 base is not an ancestor of HEAD."
    }
}

$ledger = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs\research\evidence-ledger.md")
if ($ledger -notmatch 'Phase 4 authorization and entry gate') {
    Add-CheckError "The evidence ledger does not record Phase 4 authorization."
}

$productChanges = @(git -C $repoRoot diff --name-only "$BaseSha..HEAD" -- patches extensions)
if ($productChanges.Count -gt 0) {
    Add-CheckError "Product implementation started before the Phase 4 preflight: $($productChanges -join ', ')"
}

$apk = Get-ChildItem -LiteralPath $repoRoot -Filter "*.apk" -File
if ($apk.Count -ne 1) {
    Add-CheckError "Expected exactly one local APK input, found $($apk.Count)."
} else {
    if ($apk[0].Length -ne 171814203) {
        Add-CheckError "Local APK size does not match the accepted runtime input."
    }
    $hash = (Get-FileHash -LiteralPath $apk[0].FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($hash -ne "78571be679f586d11a4e56fb1ce6bf9dfd958ce6b8af786c4a3bd94792ce8c7c") {
        Add-CheckError "Local APK hash does not match the accepted runtime input."
    }
    git -C $repoRoot check-ignore --quiet -- $apk[0].Name
    if ($LASTEXITCODE -ne 0) {
        Add-CheckError "Local APK is not ignored."
    }
}

$sensitivePattern = '\.(apk|apkm|xapk|aab|apks|idsig|dex|smali|odex|vdex|oat|jks|keystore|p12|pfx|pk8|pem|key)$|(^|/)(decompiled|decompiled-output|jadx-output|upstream-cache)/'
$trackedSensitive = @(git -C $repoRoot ls-files | Where-Object { $_ -match $sensitivePattern })
if ($trackedSensitive.Count -gt 0) {
    Add-CheckError "Tracked sensitive artifacts: $($trackedSensitive -join ', ')"
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Output "Phase 4 preflight passed for base $BaseSha."
