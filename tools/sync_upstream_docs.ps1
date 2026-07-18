param(
    [switch]$Check
)

$ErrorActionPreference = "Stop"

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

function Assert-SnapshotMatchesGitTree($source, [string]$repoRoot) {
    $treeApi = "https://api.github.com/repos/MorpheApp/morphe-documentation/git/trees/$($source.revision)?recursive=1"
    $tree = Invoke-RestMethod -Uri $treeApi -Headers @{ Accept = "application/vnd.github+json" }
    if ($tree.truncated) {
        throw "GitHub returned a truncated documentation tree."
    }

    $remoteBlobs = @{}
    foreach ($item in $tree.tree) {
        if ($item.type -eq "blob") {
            $remoteBlobs[[string]$item.path] = [string]$item.sha
        }
    }

    $snapshotPath = ([string]$source.snapshotPath).Replace('\', '/')
    $status = @(git -C $repoRoot status --porcelain --untracked-files=all -- $snapshotPath)
    if ($LASTEXITCODE -ne 0) {
        throw "Could not inspect snapshot worktree status."
    }
    $unsafeStatus = @($status | Where-Object {
        $_.StartsWith("??") -or ($_.Length -gt 1 -and $_[1] -ne ' ')
    })
    if ($unsafeStatus.Count -gt 0) {
        throw "Snapshot contains unstaged or untracked changes: $($unsafeStatus -join ', ')"
    }

    $localBlobs = @{}
    $indexLines = @(git -C $repoRoot ls-files -s -- $snapshotPath)
    if ($LASTEXITCODE -ne 0) {
        throw "Could not inspect snapshot index blobs."
    }
    foreach ($line in $indexLines) {
        if ($line -notmatch '^\d+\s+([0-9a-f]{40})\s+\d+\t(.+)$') {
            throw "Unexpected git index record: $line"
        }
        $trackedPath = $Matches[2].Replace('\', '/')
        $relative = $trackedPath.Substring($snapshotPath.Length + 1)
        $localBlobs[$relative] = $Matches[1]
    }

    if ($localBlobs.Count -ne $remoteBlobs.Count) {
        throw "Snapshot file count differs from upstream tree: local=$($localBlobs.Count) remote=$($remoteBlobs.Count)"
    }
    foreach ($path in $remoteBlobs.Keys) {
        if (-not $localBlobs.ContainsKey($path)) {
            throw "Snapshot is missing upstream file: $path"
        }
        if ($localBlobs[$path] -ne $remoteBlobs[$path]) {
            throw "Snapshot blob differs from revision $($source.revision): $path"
        }
    }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$manifestPath = Join-Path $repoRoot "docs\upstream\manifest.json"
$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$source = $manifest.sources | Where-Object { $_.name -eq "morphe-documentation" }

if ($null -eq $source) {
    throw "morphe-documentation is missing from $manifestPath"
}

$commitApi = "https://api.github.com/repos/MorpheApp/morphe-documentation/commits/$($source.branch)"
$latest = Invoke-RestMethod -Uri $commitApi -Headers @{ Accept = "application/vnd.github+json" }
$latestRevision = [string]$latest.sha

if ($Check) {
    Write-Output "recorded=$($source.revision)"
    Write-Output "upstream=$latestRevision"
    if ($source.revision -ne $latestRevision) {
        Write-Error "Official documentation snapshot is stale."
        exit 2
    }
    Assert-SnapshotMatchesGitTree $source $repoRoot
    Write-Output "Official documentation snapshot is current."
    exit 0
}

$target = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $source.snapshotPath))
$allowedRoot = [System.IO.Path]::GetFullPath((Join-Path $repoRoot "docs\upstream"))
if (-not $target.StartsWith($allowedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to replace path outside docs/upstream: $target"
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("cometdash-docs-" + [guid]::NewGuid())
$archive = Join-Path $tempRoot "documentation.zip"
$expanded = Join-Path $tempRoot "expanded"

try {
    New-Item -ItemType Directory -Path $expanded -Force | Out-Null
    $archiveUrl = "https://codeload.github.com/MorpheApp/morphe-documentation/zip/$latestRevision"
    Invoke-WebRequest -Uri $archiveUrl -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $expanded

    $snapshotRoot = Get-ChildItem -LiteralPath $expanded -Directory | Select-Object -First 1
    if ($null -eq $snapshotRoot -or -not (Test-Path (Join-Path $snapshotRoot.FullName "README.md"))) {
        throw "Downloaded documentation archive has an unexpected layout."
    }

    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
    Move-Item -LiteralPath $snapshotRoot.FullName -Destination $target

    $source.revision = $latestRevision
    $source.commitDate = [string]$latest.commit.committer.date
    $source.snapshotDigest = Get-SnapshotDigest $target
    $source.syncedAt = (Get-Date).ToString("o")
    $manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding utf8

    Write-Output "Synchronized morphe-documentation at $latestRevision"
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
