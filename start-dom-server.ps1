$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapScript = Join-Path $root 'bootstrap-dom.ps1'
$serverRoot = Join-Path $root 'teamgram-server'

& $bootstrapScript -ServerOnly

Push-Location $serverRoot
try {
    docker compose -f docker-compose-env.yaml up -d
    docker compose up -d
    docker compose ps
} finally {
    Pop-Location
}
