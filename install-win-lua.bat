@setlocal enableextensions
@cd /d "%~dp0"

cmd /k "lua watcher.lua"
pause