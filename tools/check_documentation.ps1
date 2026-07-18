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

$linkPattern = [regex]'\[[^\]]*\]\(([^)]+)\)'
$contextMapPath = Join-Path $repoRoot "CONTEXT-MAP.md"
$mappedContexts = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($match in $linkPattern.Matches((Get-Content -Raw -LiteralPath $contextMapPath))) {
    $target = $match.Groups[1].Value.Trim()
    if ($target -notmatch '^(https?://|mailto:|#)' -and $target -ne "") {
        $pathPart = [System.Uri]::UnescapeDataString($target.Split('#')[0])
        [void]$mappedContexts.Add([System.IO.Path]::GetFullPath((Join-Path $repoRoot $pathPart)))
    }
}

$contextFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot "docs\contexts") -Recurse -Filter "CONTEXT.md" -File
foreach ($contextFile in $contextFiles) {
    $contextContent = Get-Content -Raw -LiteralPath $contextFile.FullName
    $relativeContext = [System.IO.Path]::GetRelativePath($repoRoot, $contextFile.FullName)
    if (-not $mappedContexts.Contains($contextFile.FullName)) {
        Add-CheckError "CONTEXT-MAP.md is missing context: $relativeContext"
    }
    $secondaryHeadings = [regex]::Matches($contextContent, '(?m)^## (.+?)\r?$')
    if ($secondaryHeadings.Count -ne 1 -or $secondaryHeadings[0].Groups[1].Value.Trim() -ne "Language") {
        Add-CheckError "CONTEXT file must contain only the Language section: $relativeContext"
    }
    $termCount = [regex]::Matches($contextContent, '(?m)^\*\*[^*]+\*\*:\r?$').Count
    $avoidCount = [regex]::Matches($contextContent, '(?m)^_Avoid_: .+\r?$').Count
    if ($termCount -eq 0 -or $termCount -ne $avoidCount) {
        Add-CheckError "CONTEXT terms must each have one Avoid line: $relativeContext"
    }
    if ($contextContent.Contains('```')) {
        Add-CheckError "CONTEXT file contains implementation/code content: $relativeContext"
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -Filter "*.md" -File |
    Where-Object { $_.FullName -notmatch "[\\/]build[\\/]" }

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

$mainPaths = @(git -C $repoRoot ls-tree -r --name-only main 2>$null)
$mainTreeExit = $LASTEXITCODE
if ($mainTreeExit -ne 0) {
    Add-CheckError "Could not inspect the main product tree (git ls-tree exited $mainTreeExit)."
} elseif ($mainPaths.Count -eq 0) {
    Add-CheckError "The main product tree is empty."
}
$mainAllowPatterns = @(
    '^\.github/',
    '^extensions/',
    '^patches/',
    '^gradle/',
    '^\.editorconfig$',
    '^\.gitattributes$',
    '^\.gitignore$',
    '^\.releaserc$',
    '^gradlew$',
    '^gradlew\.bat$',
    '^settings\.gradle\.kts$',
    '^gradle\.properties$',
    '^package\.json$',
    '^package-lock\.json$',
    '^README\.md$',
    '^LICENSE$',
    '^NOTICE$',
    '^CHANGELOG\.md$',
    '^patches-bundle\.json$',
    '^patches-list\.json$'
)
foreach ($path in $mainPaths) {
    if (-not ($mainAllowPatterns | Where-Object { $path -cmatch $_ })) {
        Add-CheckError "Path is outside the main product allowlist: $path"
    }
}

$tracked = git -C $repoRoot ls-files
$sensitivePatterns = @(
    '\.(apk|apkm|xapk|dex|jks|keystore|p12|pfx|pk8|pem|key)$',
    '(^|/)\.env(?!\.example$)(?:\..+)?$',
    '(^|/)(?:[^/]+-)?credentials\.json$',
    '(^|/)(?:[^/]+-)?secrets\.properties$',
    '(^|/)(decompiled|decompiled-output)/',
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

foreach ($sentinel in @(
    ".env",
    "credentials.json",
    "provider-secrets.properties",
    "signing.pfx",
    "signing.pk8",
    "decompiled/classes.smali",
    "nested/decompiled-output/classes.smali"
)) {
    $ignoreOutput = @(git -c core.excludesFile=NUL -C $repoRoot check-ignore --no-index -v -- $sentinel 2>$null)
    $ignoreExit = $LASTEXITCODE
    $ignoreMatch = if ($ignoreOutput.Count -eq 1) {
        [regex]::Match($ignoreOutput[0], '^\.gitignore:\d+:(?<pattern>[^\t]+)\t')
    }
    if ($ignoreExit -ne 0) {
        Add-CheckError "Sensitive sentinel is not ignored: $sentinel"
    } elseif ($null -eq $ignoreMatch -or -not $ignoreMatch.Success -or $ignoreMatch.Groups['pattern'].Value.StartsWith('!')) {
        Add-CheckError "Sensitive sentinel must be ignored by a non-negated root .gitignore pattern: $sentinel"
    }
}
$exampleOutput = @(git -c core.excludesFile=NUL -C $repoRoot check-ignore --no-index -v -- ".env.example" 2>$null)
$exampleExit = $LASTEXITCODE
$exampleMatch = if ($exampleOutput.Count -eq 1) {
    [regex]::Match($exampleOutput[0], '^\.gitignore:\d+:(?<pattern>[^\t]+)\t')
}
if ($exampleExit -ne 0 -or $null -eq $exampleMatch -or -not $exampleMatch.Success -or $exampleMatch.Groups['pattern'].Value -cne '!.env.example') {
    Add-CheckError ".env.example must be explicitly unignored by root .gitignore pattern !.env.example."
}

$manifest = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs\upstream\manifest.json") |
    ConvertFrom-Json

function Get-SnapshotDigest([string]$repoRoot, [string]$snapshotPath) {
    $prefix = $snapshotPath.Replace('\', '/').TrimEnd('/')
    $lines = git -C $repoRoot ls-files -s -- $prefix |
        ForEach-Object {
            if ($_ -notmatch '^\d+\s+([0-9a-f]{40})\s+\d+\t(.+)$') {
                throw "Unexpected git index record: $_"
            }
            $trackedPath = $Matches[2].Replace('\', '/')
            $relative = $trackedPath.Substring($prefix.Length + 1)
            "$relative`t$($Matches[1])"
        } |
        Sort-Object
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
    } elseif ((Get-SnapshotDigest $repoRoot $source.snapshotPath) -ne $source.snapshotDigest) {
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
