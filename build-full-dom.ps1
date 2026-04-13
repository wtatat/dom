$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $root 'start-dom-server.ps1')
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

powershell -ExecutionPolicy Bypass -File (Join-Path $root 'build-dom-client.ps1')
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
