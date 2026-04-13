param(
    [switch]$ClientOnly,
    [switch]$ServerOnly
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$sources = Get-Content (Join-Path $root 'dom.sources.json') | ConvertFrom-Json

function Ensure-Repository {
    param(
        [string]$Name,
        [string]$Repo,
        [string]$Commit
    )

    $path = Join-Path $root $Name
    if (-not (Test-Path $path)) {
        git clone $Repo $path
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone $Repo"
        }
    }

    $origin = git -C $path remote get-url origin
    if ($origin.Trim() -ne $Repo) {
        throw "$Name origin is $origin, expected $Repo"
    }

    git -C $path -c fetch.recurseSubmodules=false fetch --tags origin
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to fetch $Name"
    }

    git -C $path reset --hard $Commit
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to reset $Name to $Commit"
    }
}

function Ensure-ClientPatch {
    $clientPath = Join-Path $root 'teamgram-tdesktop'
    $patchPath = Join-Path $root $sources.client.patch

    git -C $clientPath submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) {
        throw 'Failed to update client submodules'
    }

    git -C $clientPath apply --check $patchPath 2>$null
    if ($LASTEXITCODE -eq 0) {
        git -C $clientPath apply $patchPath
        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to apply DOM patch'
        }
        return
    }

    git -C $clientPath apply --reverse --check $patchPath 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw 'Client patch state is inconsistent'
    }
}

if (-not $ServerOnly) {
    Ensure-Repository -Name 'teamgram-tdesktop' -Repo $sources.client.repo -Commit $sources.client.commit
    Ensure-ClientPatch
}

if (-not $ClientOnly) {
    Ensure-Repository -Name 'teamgram-server' -Repo $sources.server.repo -Commit $sources.server.commit
}
