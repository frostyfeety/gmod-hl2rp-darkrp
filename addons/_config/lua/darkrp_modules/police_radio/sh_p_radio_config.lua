Police_Radio_Config = {}

Police_Radio_Config["Allow_Teams"] = { --The script will normally use the jobs set by GAMEMODE.CivilProtection. If it doesnt work add the remaining team here
	["cp01"] = true,
	["cp02"] = true,
	["cp03"] = true,
	["cp1"] = true
}
--^^ These are CHAT COMMANDS!! Not teamnames

Police_Radio_Config["Require_Admin_Approval"] = false --Whether or not its required for admins to approve users first before they can use their radio
-- ^^ /giveradio <Name> /removeradio <Name>

Police_Radio_Config["CanHear_Default"] = true --The default state of whether or not people can hear one another over the radio

if CLIENT then

Police_Radio_Config["HUD_Text_On"] = "Микрофон включен [%s, чтобы отключить]" --The text that appears above the radio icon if enabled (Set to "" to disable text)
Police_Radio_Config["HUD_Text_Off"] = "Микрофон отключен [%s, чтобы включить]" --If the radio is disabled this text will appear (choose "" to disable text)
Police_Radio_Config["HUD_Text_On_Receive"] = "Динамик включен [%s, чтобы отключить]" --The text that appears above the radio icon if their received audio is disabled (Set to "" to disable text)
Police_Radio_Config["HUD_Text_Off_Receive"] = "Динамик отключен [%s, чтобы включить]" --If the received audio is disabled this text will appear (choose "" to disable text)

-- %s will be replaced with the key bound by the player that needs to be pressed
end

Police_Radio_Config["HUD_Enable"] = false --Set to true to enable the HUD icons
Police_Radio_Config["HUD_Use_Textures"] = false --If enabled. The HUD will use texture files (vtf) instead of a png file
Police_Radio_Config["HUD_Texture_On"] = "vgui/lordi/darkrp/police_radio_on" --If enabled. The HUD will use texture files (vtf) instead of a png file
Police_Radio_Config["HUD_Texture_Off"] = "vgui/lordi/darkrp/police_radio_off" --Texture that appears if the radio is currently off

--When selecting a texture, MAKE SURE THE EXTENSION ISNT INCLUDED (.png/.vmt)
--The script does this by itself