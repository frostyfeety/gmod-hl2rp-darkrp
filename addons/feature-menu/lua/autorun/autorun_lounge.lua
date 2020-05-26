if (SERVER) then
	AddCSLuaFile("autorun/autorun_lounge.lua")
	AddCSLuaFile("f4menu/cl_f4menu.lua")
	AddCSLuaFile("f4_config.lua")
	AddCSLuaFile("f4_commands.lua")

	AddCSLuaFile("f4menu/pages/dashboard.lua")
	AddCSLuaFile("f4menu/pages/jobs.lua")
	AddCSLuaFile("f4menu/pages/purchase.lua")
	AddCSLuaFile("f4menu/pages/commands.lua")

	local USE_WORKSHOP = true

	if (USE_WORKSHOP) then
		resource.AddWorkshop("871894865")
	else
		resource.AddFile("resource/fonts/circular.ttf")
		resource.AddFile("resource/fonts/circular_bold.ttf")
	end
else
	LOUNGE_F4 = {}
	LOUNGE_F4.Tabs = {}
	
	include("f4menu/pages/dashboard.lua")
	include("f4menu/pages/jobs.lua")
	include("f4menu/pages/purchase.lua")
	include("f4menu/pages/commands.lua")

	include("f4_config.lua")
	include("f4_commands.lua")
	include("f4menu/cl_f4menu.lua")
end