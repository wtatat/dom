@echo OFF
if exist msys64 rmdir /Q /S msys64
if %errorlevel% neq 0 exit /b %errorlevel%
if exist msys64 exit /b 1
if %errorlevel% neq 0 exit /b %errorlevel%
call SET PATH=%THIRDPARTY_DIR%\msys64\usr\bin;%PATH%
if %errorlevel% neq 0 exit /b %errorlevel%
call SET CHERE_INVOKING=enabled_from_arguments
if %errorlevel% neq 0 exit /b %errorlevel%
call SET MSYS2_PATH_TYPE=inherit
if %errorlevel% neq 0 exit /b %errorlevel%
call powershell -Command "iwr -OutFile ./msys64.exe https://github.com/msys2/msys2-installer/releases/download/2025-08-30/msys2-base-x86_64-20250830.sfx.exe"
if %errorlevel% neq 0 exit /b %errorlevel%
call msys64.exe
if %errorlevel% neq 0 exit /b %errorlevel%
call del msys64.exe
if %errorlevel% neq 0 exit /b %errorlevel%
call bash -c "pacman-key --init; pacman-key --populate; pacman -Syu --noconfirm"
if %errorlevel% neq 0 exit /b %errorlevel%
call pacman -Syu --noconfirm ^make ^mingw-w64-x86_64-diffutils ^mingw-w64-x86_64-gperf ^mingw-w64-x86_64-nasm ^mingw-w64-x86_64-perl ^mingw-w64-x86_64-pkgconf
if %errorlevel% neq 0 exit /b %errorlevel%
call 
if %errorlevel% neq 0 exit /b %errorlevel%
