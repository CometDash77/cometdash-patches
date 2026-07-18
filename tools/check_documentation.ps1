$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-CheckError([string]$message) {
    $errors.Add($message)
}

$required = @(
    "AGENTS.md",
    "CONTEXT-MAP.md",
    "docs/contexts/patch-source/CONTEXT.md",
    "docs/contexts/enhanced-voice-over-translation/CONTEXT.md",
    "docs/specs/project-charter.md",
    "docs/specs/agent-learning-program.md",
    "docs/specs/enhanced-voice-over-translation.md",
    "docs/research/evidence-ledger.md",
    "docs/runbooks/repository-workflow.md",
    "docs/runbooks/upstream-documentation.md",
    "docs/upstream/manifest.json",
    "docs/upstream/README.md",
    "docs/testing/documentation-gate.md",
    "docs/testing/release-gate.md",
    "tools/sync_upstream_docs.ps1"
)

foreach ($relative in $required) {
    $fullPath = Join-Path $repoRoot $relative
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-CheckError "Missing required development asset: $relative"
    } elseif (-not (git -C $repoRoot ls-files --error-unmatch $relative 2>$null)) {
        Add-CheckError "Required development asset is not tracked: $relative"
    }
}

$agentsContent = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "AGENTS.md")
foreach ($navigationTarget in @(
    "CONTEXT-MAP.md", "docs/specs/", "docs/adr/", "docs/research/",
    "docs/runbooks/", "docs/testing/", "docs/upstream/"
)) {
    if (-not $agentsContent.Contains($navigationTarget)) {
        Add-CheckError "AGENTS.md navigation is missing: $navigationTarget"
    }
}

$contextFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot "docs\contexts") -Recurse -Filter "CONTEXT.md" -File
foreach ($contextFile in $contextFiles) {
    $contextContent = Get-Content -Raw -LiteralPath $contextFile.FullName
    $relativeContext = [System.IO.Path]::GetRelativePath($repoRoot, $contextFile.FullName)
    $secondaryHeadings = [regex]::Matches($contextContent, '(?m)^## (.+)$')
    if ($secondaryHeadings.Count -ne 1 -or $secondaryHeadings[0].Groups[1].Value -ne "Language") {
        Add-CheckError "CONTEXT file must contain only the Language section: $relativeContext"
    }
    $termCount = [regex]::Matches($contextContent, '(?m)^\*\*[^*]+\*\*:$').Count
    $avoidCount = [regex]::Matches($contextContent, '(?m)^_Avoid_: .+$').Count
    if ($termCount -eq 0 -or $termCount -ne $avoidCount) {
        Add-CheckError "CONTEXT terms must each have one Avoid line: $relativeContext"
    }
    if ($contextContent.Contains('```')) {
        Add-CheckError "CONTEXT file contains implementation/code content: $relativeContext"
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -Filter "*.md" -File |
    Where-Object { $_.FullName -notmatch "[\\/]build[\\/]" }
$linkPattern = [regex]'\[[^\]]*\]\(([^)]+)\)'

foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    if ($null -eq $content) {
        $content = ""
    }
    foreach ($match in $linkPattern.Matches($content)) {
        $target = $match.Groups[1].Value.Trim()
        if ($target -match '^(https?://|mailto:|#)' -or $target -eq "") {
            continue
        }
        $pathPart = [System.Uri]::UnescapeDataString($target.Split('#')[0])
        $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
        if (-not (Test-Path -LiteralPath $resolved)) {
            $relativeFile = [System.IO.Path]::GetRelativePath($repoRoot, $file.FullName)
            Add-CheckError "Broken relative link in ${relativeFile}: $target"
        }
    }
}

$adrFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot "docs\adr") -Filter "*.md" -File |
    Sort-Object Name
for ($i = 0; $i -lt $adrFiles.Count; $i++) {
    $expected = "{0:D4}" -f ($i + 1)
    if (-not $adrFiles[$i].Name.StartsWith("$expected-")) {
        Add-CheckError "ADR sequence error: expected prefix $expected, found $($adrFiles[$i].Name)"
    }
}

$mainPaths = git -C $repoRoot ls-tree -r --name-only main
$mainDenyPatterns = @(
    '^AGENTS\.md$',
    '^CONTEXT-MAP\.md$',
    '^docs/',
    '^tools/',
    '^reasonix\.toml$'
)
foreach ($path in $mainPaths) {
    foreach ($pattern in $mainDenyPatterns) {
        if ($path -match $pattern) {
            Add-CheckError "Development-only path exists on main: $path"
        }
    }
}

$tracked = git -C $repoRoot ls-files
$sensitivePatterns = @(
    '\.(apk|apkm|xapk|dex|jks|keystore|p12|pem|key)$',
    '(^|/)jadx-output/',
    '(^|/)upstream-cache/',
    'local-secrets\.properties$'
)
foreach ($path in $tracked) {
    foreach ($pattern in $sensitivePatterns) {
        if ($path -match $pattern) {
            Add-CheckError "Sensitive or generated file is tracked: $path"
        }
    }
}

$manifest = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs\upstream\manifest.json") |
    ConvertFrom-Json

function Get-SnapshotDigest([string]$root) {
    $lines = Get-ChildItem -LiteralPath $root -Recurse -File |
        Sort-Object FullName |
        ForEach-Object {
            $relative = [System.IO.Path]::GetRelativePath($root, $_.FullName).Replace('\', '/')
            $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
            "$relative`t$hash"
        }
    $payload = ($lines -join "`n") + "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [Convert]::ToHexString(
            $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($payload))
        ).ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

foreach ($source in $manifest.sources) {
    $snapshot = Join-Path $repoRoot $source.snapshotPath
    if (-not (Test-Path -LiteralPath $snapshot)) {
        Add-CheckError "Missing upstream snapshot for $($source.name): $($source.snapshotPath)"
    }
    if ([string]::IsNullOrWhiteSpace([string]$source.revision)) {
        Add-CheckError "Missing pinned revision for upstream source: $($source.name)"
    }
    if ([string]::IsNullOrWhiteSpace([string]$source.snapshotDigest)) {
        Add-CheckError "Missing snapshot digest for upstream source: $($source.name)"
    } elseif ((Get-SnapshotDigest $snapshot) -ne $source.snapshotDigest) {
        Add-CheckError "Snapshot content does not match manifest digest: $($source.name)"
    }
}

$ledger = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs\research\evidence-ledger.md")
$sourcePermalinks = [regex]::Matches($ledger, '/blob/[0-9a-f]{40}/').Count
if ($sourcePermalinks -lt 8) {
    Add-CheckError "Evidence ledger must contain at least eight commit-pinned source file permalinks."
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Documentation checks passed: $($markdownFiles.Count) Markdown files, $($adrFiles.Count) ADRs."
