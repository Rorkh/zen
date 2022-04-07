local zen = {}

local separator = package.config:sub(1, 1)

function zen.isWindows()
	return separator == '\\'
end

function zen.isUnix()
	return separator == '/'
end

function zen.architecture()
	if (0xfffffffff==0xffffffff) then 
		return 32 
	else 
		return 64 
	end
end

function zen.clearConsole()
	os.execute(zen.isWindows() and "cls" or "clear")
end

local function fileExists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

function zen.windowsMatches()
	return fileExists("C:\\Windows\\System32\\nssm.exe")
end

function zen.capture(cmd)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()

	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')

	return s
end

function zen.matchExtension(ext)
	if ext == "python" then
		local _, _, code = os.execute("python --version")

		if code == 1 then
			print("python is not installed to run this service.")
			return false
		end

		return "python"
	elseif ext == "lua" then
		local _, _, code = os.execute("lua -v")
		local _, _, code_jit = os.execute("luajit -v")

		if (code == 1) and (code_jit == 1) then
			print("lua is not installed to run this service")
			return false
		end

		return (code_jit == 0) and "luajit" or "lua"
	end
end

function zen.createStarter(service, command)
	os.execute("mkdir C:\\zen 2> NUL")

	local f = io.open("C:\\zen\\" .. service .. "_start.bat", "w")
		f:write("start " .. command)
	f:close()
end

function zen.new(service, command)
	local runner = zen.matchExtension(command:match("^.+%.(.+)$"))
	if runner == false then return false end

	if zen.isWindows() then
		local cmd = runner .. " " .. command
		zen.createStarter(service, cmd)
		os.execute("nssm install " .. service .. " C:\\zen\\" .. service .. "_start.bat")
		os.execute("nssm start " .. service)
	else

	end
end

return zen