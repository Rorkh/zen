@setlocal enableextensions
@cd /d "%~dp0"

cmd /k "luajit watcher.lua"
pause