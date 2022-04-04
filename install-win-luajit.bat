@setlocal enableextensions
@cd /d "%~dp0"

cmd /k "luajit zen.lua"
pause