@echo off
REM set NODE_OPTIONS=--openssl-legacy-provider
where node.exe >nul 2>nul
if %errorlevel% == 0 (
	echo | set /p printed_str="Using system-wide Node "
	call node.exe --version
	call node.exe %*
	goto exit_with_last_error_level
)
call powershell -NoLogo -ExecutionPolicy Bypass -File "%~dp0\node_.ps1" Download-Node
for /f "tokens=* USEBACKQ" %%s in (`
	call powershell -NoLogo -ExecutionPolicy Bypass -File "%~dp0\node_.ps1" Get-Path
`) do (
	set "PATH=%%s;%PATH%"
)
where node.exe >nul 2>nul
if %errorlevel% == 0 (
	echo | set /p printed_str="Using vendored Node "
	call node.exe --version
	call node.exe %*
	goto exit_with_last_error_level
)
echo "build.bat: Failed to bootstrap Node!"
%COMSPEC% /c exit 1

:exit_with_last_error_level
if not %errorlevel% == 0 %COMSPEC% /c exit %errorlevel% >nul
