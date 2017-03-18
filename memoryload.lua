--on memory load module

--interface

memoryload = {}

-- callback
memoryload.onprint = function(s)
	--log callback function
end

memoryload.onload = function(f)
	-- return customload(f)
	return nil
end

-- adittional convert function
memoryload.decodeutf16le = nil;
memoryload.decodeutf16be = nil;

-- functions

function memoryload.checkutf8bom(s)
	-- check utf 8 bom
	if string.len(s) < 3 then
		return false
	end
	-- 0xEF 0xBB 0xBF
	local c1,c2,c3 = string.byte(s,1,3)
	if c1 ~= 0xEF then return false end
	if c2 ~= 0xBB then return false end
	if c3 ~= 0xBF then return false end
	return true
end

function memoryload.checkutf16lebom(s)
	-- check utf 8 bom
	if string.len(s) < 2 then
		return false
	end
	-- 0xEF 0xBB 0xBF
	local c1,c2 = string.byte(s,1,2)
	if c1 ~= 0xFF then return false end
	if c2 ~= 0xFE then return false end
	return true
end

function memoryload.checkutf16bebom(s)
	-- check utf 8 bom
	if string.len(s)<2 then
		return false
	end
	-- 0xEF 0xBB 0xBF
	local c1,c2 = string.byte(s,1,2)
	if c1 ~= 0xFE then return false end
	if c2 ~= 0xFF then return false end
	return true
end

function memoryload.seacherfunc(modulename)
	local err = ""
	local modulepath = string.gsub( modulename , "%.","/" )
	for path in string.gmatch( memoryload.path , "([^;]+)" ) do	--can not load DLL
		local filename = string.gsub( path , "%?",modulepath )
		local data = memoryload.onload(filename)
		if data ~= nil then
			memoryload.onprint("memoryload.load:"..filename)
			--extract bom
			if memoryload.checkutf8bom(data)then
				memoryload.onprint("memoryload.utf8-bom exists")
				data = string.sub(data,1+3)
			elseif memoryload.checkutf16lebom(data)then
				memoryload.onprint("memoryload.utf16le-bom exists")
				if memoryload.decodeutf16le~=nil then data = memoryload.decodeutf16le(data) end
			elseif memoryload.checkutf16bebom(data)then
				memoryload.onprint("memoryload.utf16be-bom exists")
				if memoryload.decodeutf16be~=nil then data = memoryload.decodeutf16be(data) end
			end
			--load
			local chank,msg = load(data,filename)
			if chank ~= nil then
				memoryload.onprint("memoryload.load complete")
				return chank	--searchers function return code chank
			else
				memoryload.onprint("memoryload.load exception error")
				error(msg,2)
			end
		end
		err = err.."\n\tno file '"..filename.."' (checked with onmemory.lua loader)"	--lua error text format \n\t
	end
	return err
end

-- path setting
-- memoryload.path = package.path
memoryload.path = "?.lua;?.lc;?.moon"

-- initialization
if _VERSION == "Lua 5.1" then
	package.preload[1] = memoryload.seacherfunc	-- set load module
	--package.preload[2] = nil	-- load system/DLL
	--package.preload[3] = nil	-- cpath
end
if _VERSION == "Lua 5.2" or _VERSION=="Lua 5.3" then
	package.searchers[1] = memoryload.seacherfunc	-- set load module
	--package.searchers[2] = nil	-- load system/DLL
	--package.searchers[3] = nil	-- cpath
end
