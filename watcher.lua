local watcher = require("watcher-lua")
local isWin = watcher.isWindows()

if (isWin and not watcher.windowsMatches()) then
	local function checkZipper()
		if not os.execute("unzip") then
			if os.execute("7z") then
				return "7z"
			else
				print("7z or unzip required.")
				return false
			end
		end

		return "unzip"
	end

	local zipper = checkZipper()
	watcher.clearConsole()
	if not zipper then return end

	local function unzip()
		local cmd

		if zipper == "unzip" then
			local path = watcher.capture("echo %CD%") .. "temp/nssm/nssm.zip/nssm-2.24/win" .. watcher.architecture() .. "/nssm.exe"
			cmd = string.format("unzip -j temp/nssm.zip %s -d C:\\Windows\\System32", path)
		elseif zipper == "7z" then
			local path = "nssm-2.24/win" .. watcher.architecture() .. "/nssm.exe"
			cmd = string.format("7z e temp/nssm.zip -oC:\\Windows\\System32 %s", path)
		end

		os.execute(cmd)
	end

	print("NSSM should be installed.")
	print("Install? (y/n)")

	local option = io.read()
	if option == "y" then
		watcher.clearConsole()

		os.execute("mkdir temp 2> NUL")

		print("Installing...")
		os.execute("powershell -command \"Invoke-WebRequest -Uri 'https://nssm.cc/release/nssm-2.24.zip' -OutFile 'temp/nssm.zip'\"")
		os.execute("exit")

		unzip()
		os.execute("rd /s /q temp")
		watcher.clearConsole()

		print("Watcher was successfuly installed.")
		return
	else
		return
	end
end

local command = arg[1]

if arg[1] == "new" then
	
end