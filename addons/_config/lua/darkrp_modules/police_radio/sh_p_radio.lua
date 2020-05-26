DarkRP.registerDarkRPVar("Police_Radio_Enabled",net.WriteBool,net.ReadBool)
DarkRP.registerDarkRPVar("Police_Radio_CanHear",net.WriteBool,net.ReadBool)

DarkRP.declareChatCommand{
	command = "giveradio",
	description = "Grant a player the ability to use their police radio.",
	delay = 1.5,
	condition = function(ply) if Police_Radio_Config["Require_Admin_Approval"] and ply:IsAdmin() then return true end end
}

DarkRP.declareChatCommand{
	command = "removeradio",
	description = "Remove a player's ability to use their police radio.",
	delay = 1.5,
	condition = function(ply) if Police_Radio_Config["Require_Admin_Approval"] and ply:IsAdmin() then return true end end
}


--Some people don't pay enough attention, and if they are still using the old variable config, we need to remind them not to
if Police_Radio_Config["HUD_Vehicle_Text_Off"] or Police_Radio_Config["Only_If_On"] then
	timer.Create("police_radio_changeyourconfigdamnit",90,0,function()
		print("[POLICE-RADIO]: The HUD_Vehicle_Text_Off and Only_If_On variables are no longer used, and should be removed from the config file.")
	end)
end