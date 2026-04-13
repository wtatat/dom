$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapScript = Join-Path $root 'bootstrap-dom.ps1'
$logsDir = Join-Path $root 'logs'
$logFile = Join-Path $logsDir 'build-dom-client.log'
$buildDrive = 'T:'
$buildRoot = "$buildDrive\"
$clientRoot = "${buildRoot}teamgram-tdesktop"
$prepareBat = "${clientRoot}\\Telegram\\build\\prepare\\win.bat"
$configureBat = "${clientRoot}\\Telegram\\configure.bat"
$vcvars = 'C:\BuildTools2022\VC\Auxiliary\Build\vcvars64.bat'
$cmakeBin = 'C:\Program Files\CMake\bin'
$ninjaBin = 'C:\BuildTools2022\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja'
$apiId = '17349'
$apiHash = '344583e45741c457fe1862106095a5eb'

& $bootstrapScript -ClientOnly

if (-not (Test-Path $vcvars)) {
    throw "Visual Studio Build Tools not found at $vcvars"
}

if (-not (Test-Path (Join-Path $cmakeBin 'cmake.exe'))) {
    throw "CMake not found at $cmakeBin"
}

if (-not (Test-Path (Join-Path $ninjaBin 'ninja.exe'))) {
    throw "Ninja not found at $ninjaBin"
}

New-Item -ItemType Directory -Force -Path $logsDir | Out-Null

$envPrefix = "set PATH=$cmakeBin;$ninjaBin;%PATH% && set CMAKE_BUILD_PARALLEL_LEVEL=%NUMBER_OF_PROCESSORS%"
$prepareCommand = "cd /d `"$buildRoot`" && call `"$prepareBat`" skip-release silent"
$configureCommand = "cd /d `"$clientRoot\\Telegram`" && call `"$configureBat`" x64 -D TDESKTOP_API_ID=$apiId -D TDESKTOP_API_HASH=$apiHash"
$buildCommand = "cd /d `"$clientRoot`" && cmake --build out --config Debug --target Telegram --parallel"
$fullCommand = "@echo on && call `"$vcvars`" && $envPrefix && $prepareCommand && $configureCommand && $buildCommand"

cmd /c "subst $buildDrive /d" | Out-Null
cmd /c "subst $buildDrive `"$root`""
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

try {
    cmd /c $fullCommand 2>&1 | Tee-Object -FilePath $logFile
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    cmd /c "subst $buildDrive /d" | Out-Null
}
