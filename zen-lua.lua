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

function zen.new()

end

return zen