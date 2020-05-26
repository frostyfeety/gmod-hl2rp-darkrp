local cus_key = CreateClientConVar("policeradio_tog_key","30")
local cus_key_r = CreateClientConVar("policeradio_tog_rec_key","18")

local chat_open = false
hook.Add("StartChat","pr_onchat_open",function() chat_open = true end)
hook.Add("FinishChat","pr_onchat_close",function() chat_open = false end)

local lply

local key_pressed = false
hook.Add("Think","pr_buttons",function()
	if not IsValid(lply) then return end
	if not lply:getJobTable() then return end
	if lply:isMPF() or Police_Radio_Config["Allow_Teams"][lply:getJobTable().command] or lply:isOTA() and lply:GetModel() ~= "models/player/soldier_stripped.mdl" then 
		if not key_pressed and not chat_open and not gui.IsGameUIVisible() then
			if input.IsKeyDown(cus_key:GetInt()) then
				key_pressed = true
				net.Start("police_radio_toggle")
					net.WriteBool(true)
				net.SendToServer()
			elseif input.IsKeyDown(cus_key_r:GetInt()) then
				key_pressed = true
				net.Start("police_radio_toggle")
				net.SendToServer()
			end
		else
			if not input.IsKeyDown(cus_key:GetInt()) and not input.IsKeyDown(cus_key_r:GetInt()) then
				key_pressed = false
			end
		end
	end
end)
net.Receive("police_radio_toggle",function()
	local onoroff = net.ReadBool()
	if onoroff then
		local soun = net.ReadString()
		if soun and soun ~= "" then
			surface.PlaySound(soun)
		else
			surface.PlaySound("npc/metropolice/vo/off1.wav")
		end
	else
		surface.PlaySound("npc/metropolice/vo/on1.wav")
	end
end)

local function P_Radio_LookUp_Bind(bind)
	return input.GetKeyName(bind)
end

local function formet(forma,ke)
	if not forma then return "" end
	return string.format(forma,P_Radio_LookUp_Bind(ke and ke:GetInt() or cus_key:GetInt()))
end

local texts = {} --I actually have no clue whether this works or not. If it does, the main purpose of it is to prevent FPS chewing
texts["off"] = formet(Police_Radio_Config["HUD_Text_Off"],cus_key)
texts["on"] = formet(Police_Radio_Config["HUD_Text_On"],cus_key)
texts["off_r"] = formet(Police_Radio_Config["HUD_Text_Off_Receive"],cus_key_r)
texts["on_r"] = formet(Police_Radio_Config["HUD_Text_On_Receive"],cus_key_r)
cvars.AddChangeCallback("policeradio_tog_key",function(conv,old,new)
	texts["off"] = formet(Police_Radio_Config["HUD_Text_Off"],cus_key)
	texts["on"] = formet(Police_Radio_Config["HUD_Text_On"],cus_key)
	texts["off_r"] = formet(Police_Radio_Config["HUD_Text_Off_Receive"],cus_key_r)
	texts["on_r"] = formet(Police_Radio_Config["HUD_Text_On_Receive"],cus_key_r)
end)

local scr_w = ScrW()
local scr_h = ScrH()
local hud_tex_on
local hud_tex_off
if Police_Radio_Config["Police_Radio_Enabled"] then
	hud_tex_on = surface.GetTextureID(Police_Radio_Config["HUD_Texture_On"])
	hud_tex_off = surface.GetTextureID(Police_Radio_Config["HUD_Texture_Off"])
else
	hud_tex_on = Material(Police_Radio_Config["HUD_Texture_On"]..".png")
	hud_tex_off = Material(Police_Radio_Config["HUD_Texture_Off"]..".png")
end

hook.Add("HUDPaint","Police_Radio_HUD",function()
	if not Police_Radio_Config then return end
	if not IsValid(lply) then
		lply = LocalPlayer()
		return
	end
	if not lply:getJobTable() then return end
	if Police_Radio_Config["Allow_Teams"][lply:getJobTable().command] or lply:isCP() or lply:isOTA() and lply:GetModel() ~= "models/player/soldier_stripped.mdl" then
		if lply:getDarkRPVar("Police_Radio_Enabled") then
			if Police_Radio_Config["HUD_Enable"] then
				surface.SetDrawColor(255,255,255,255)
				if Police_Radio_Config["HUD_Use_Textures"] then
					surface.SetTexture(hud_tex_on)
				else
					surface.SetMaterial(hud_tex_on)
				end
				surface.DrawTexturedRect(scr_w - 120, scr_h / 5, 128, 128)
			end

			draw.DrawText(texts["on"] or "","rp_base_hud_font",scr_w - 10,scr_h / 5,Color(222,222,222),TEXT_ALIGN_RIGHT)
		else
			if Police_Radio_Config["HUD_Enable"] then
				surface.SetDrawColor(255,255,255,255)
				if Police_Radio_Config["HUD_Use_Textures"] then
					surface.SetTexture(hud_tex_off)
				else
					surface.SetMaterial(hud_tex_off)
				end
				surface.DrawTexturedRect(scr_w - 120, scr_h / 4, 128, 128)
			end

			draw.DrawText(texts["off"] or "","rp_base_hud_font",scr_w - 10,scr_h / 5,Color(255,155,155),TEXT_ALIGN_RIGHT)
		end
		local ison = lply:getDarkRPVar("Police_Radio_CanHear")
		draw.DrawText((ison and texts["on_r"] or texts["off_r"] or ""),"rp_base_hud_font",scr_w - 10,scr_h / 5 - 15,(ison and Color(222,222,222) or Color(255,155,155)),TEXT_ALIGN_RIGHT)
	end
end)