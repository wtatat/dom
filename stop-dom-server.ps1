$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$serverRoot = Join-Path $root 'teamgram-server'

if (-not (Test-Path $serverRoot)) {
    return
}

Push-Location $serverRoot
try {
    docker compose down
    docker compose -f docker-compose-env.yaml down
} finally {
    Pop-Location
}
