local include_sv = (SERVER) and include or function() end
local include_cl = (SERVER) and AddCSLuaFile or include
local include_sh = function(path) include_sv(path) include_cl(path) end

local files = file.Find("lib/*.lua", "LUA")
for _, v in ipairs(files) do
	local path = "lib/"..v
	include_sh(path)
end