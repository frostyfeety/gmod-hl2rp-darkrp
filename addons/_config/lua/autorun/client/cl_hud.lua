---------------[[
-- FIXES
---------------]]

local elements = {
	CHudHealth = true,
	CHudBattery = true,
	CHudPoisonDamageIndicator = true,
	CHudSuitPower = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudSquadStatus = true,
	CHudDamageIndicator = true,
    --["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    --["DarkRP_ChatReceivers"] = true,
}

local icon = Material("icon16/lock.png")

hook.Add("HUDShouldDraw", "rp_hide_hud", function(name)
	if elements[name] then
		return false
	else
		return true
	end
end)

hook.Add('HUDDrawTargetID', 'rp_hud_draw_target_return', function()
	return false
end)

hook.Add("HUDPaint", "rp_lock", function()
	local ply = LocalPlayer()
	local ent = ply:GetEyeTraceNoCursor().Entity
	local w, h = ScrW(), ScrH()
	
	if IsValid(ent) and ent:GetNWBool("fading") and (ply:GetPos():DistToSqr(ent:GetPos()) < (100 * 100)) then
		surface.SetMaterial(icon)
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawTexturedRect(w * 0.5 - 8, h * 0.53, 16, 16)
	end

end)

local hud_colors = {
	b = Color(0, 0, 0),
	ba = Color(20, 20, 20, 220), 
	baw = Color(50, 25, 25, 200),
	w = Color(255, 255, 255),
	wa = Color(255, 255, 255, 10),
	wk = Color(255, 255, 255, 150),
	wka = Color(255, 255, 255, 50),
	o = Color(200,200,255),
	oa = Color(255, 100, 80, 5),
	r = Color(255,0,0),
	ra = Color(255,0,0,100),
	g = Color(0, 135, 105),
	ga = Color(0, 230, 200, 5)
}

col = hud_colors

---------------[[
-- OVERHEAD
---------------]]

local playercache = {}
surface.CreateFont("rp_24s", {font = "Roboto", extended = true, size = 32, blursize = 0, antialias = true, wight = 500})

timer.Create("DarkRP_RefreshPlayerCache", 0.5, 0, function()

	if IsValid(LocalPlayer()) then
		local playercount = 0
		playercache = {}

		for _, ent in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 256)) do
			if IsValid(ent) and ent:IsPlayer() and ent ~= LocalPlayer() and ent:Alive() then
				playercount = playercount + 1
				playercache[playercount] = ent
			end
		end
	end

end)

hook.Add("PostDrawTranslucentRenderables", "rp_overhead", function()
	for _, ply in pairs(playercache) do
		if not IsValid(ply) then continue end
		if not ply:Alive() then return end

		local pos = ply:LocalToWorld(Vector(0, 0, 85))

		local ang = LocalPlayer():GetAngles()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, ang, 0.15)
			local name = ply:Nick()
			draw.SimpleText(name, "rp_24s", 0, 30, Color(200, 200, 200, 155), 1, 1)

			local job = ply:getDarkRPVar("job")
			
			if ply:Team() == TEAM_ZOMBIE then
				job = "Зомбированный"
			end

			draw.SimpleText(job, "rp_24s", 0, 60, Color(200, 200, 200, 155), 1, 1)
		cam.End3D2D()
	end

end)

---------------[[
-- NOTIFY
---------------]]

local notifications = {}
surface.CreateFont("rp_22s", {font = "Roboto", extended = true, size = 22, blursize = 0, antialias = true, wight = 500})

function notification.AddLegacy(text, type, time)

	local x, y = ScrW(), ScrH()

	surface.SetFont("rp_22s")
	local w, h = surface.GetTextSize(text)

	table.insert(notifications, 1, {x = x, y = y, w = w + 30, h = h + 12, text = text, time = CurTime() + time})

end

function notification.Kill(id)

	for _, v in pairs(notifications) do
		if v.id == id then
			v.time = 0
		end
	end

end

local function DrawNotifications()

	local scrw = ScrW()
	local scrh = ScrH()

	for k, v in pairs(notifications) do
		local x = math.floor(v.x)
		local y = math.floor(v.y)
		local w = v.w
		local h = v.h

		draw.RoundedBox(4, x, y, w, h, Color(45,45,45,200))
		draw.SimpleText(v.text, "rp_22s", x + 15, y + 5, Color(255,255,255))

		v.x = Lerp(FrameTime() * 33, v.x, v.time > CurTime() and scrw - v.w - 20 or scrw + 1)
		v.y = Lerp(FrameTime() * 33, v.y, scrh - 14 - (k * (v.h + 6)))
	end

	for k, v in pairs(notifications) do
		if v.x >= scrw and v.time < CurTime() then
			table.remove(notifications, k)
		end
	end

end

hook.Add("HUDPaint", "rp_draw_hud_notify", function()
	DrawNotifications()
end)

---------------[[
-- HUD
---------------]]

surface.CreateFont("rp_base_hud_font", {
    font = "Roboto",
    extended = true,
    size = 18,
    weight = 500,
    antialias = true
})

surface.CreateFont("rp_base_hud_font4", {
    font = "Roboto",
    extended = true,
    size = 18,
    weight = 500,
    antialias = true
})

local blur = Material("pp/blurscreen")

local function drawBlur(x, y, w, h, layers, density, alpha)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(blur)

    for i = 1, layers do
        blur:SetFloat("$blur", (i / layers) * density)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end

function formatNumberPrisel(n)
    if not n then return "" end
    if n >= 1e14 then return tostring(n) end
    n = tostring(n)

    local sep = sep or "."
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i + 1)
    end

    return n
end

local function drawRectOutline(x, y, w, h, color)
    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(x, y, w, h)
end

hook.Add("HUDPaint", "rp_base_hud", function()
	if rp_esc_opened then return end
    if not IsValid(LocalPlayer()) then return end
	if not LocalPlayer():Alive() then return end
	local job = LocalPlayer():getDarkRPVar("job")

	if LocalPlayer():Team() == TEAM_CITIZEN then job = "Прибывший" end
	
    draw.RoundedBox(0, 40, ScrH() - 50, 200, 30, Color(30, 30, 30, 240))
    draw.RoundedBox(0, 40, ScrH() - 50, math.Clamp(LocalPlayer():Health() * 2, 0, 100 * 2), 20, Color(120, 22, 22, 240))
    draw.RoundedBox(0, 40, ScrH() - 30, LocalPlayer():getDarkRPVar(("Energy") or 0) * 2, 5, Color(200, 170, 0, 240))
    draw.RoundedBox(0, 40, ScrH() - 25, math.Clamp(LocalPlayer():Armor() * 2, 0, 200), 5, Color(20, 55, 120, 240))
    draw.WordBox(2, 40, ScrH() - 125, "" .. LocalPlayer():GetName() .. " | #" .. LocalPlayer():GetRP_ID(), "rp_base_hud_font", Color(30, 30, 30, 240), Color(255, 255, 255, 255))
    draw.WordBox(2, 40, ScrH() - 100, "" .. "₮"..formatNumberPrisel(LocalPlayer():getDarkRPVar("money")), "rp_base_hud_font", Color(30, 30, 30, 240), Color(255, 255, 255, 255))
    draw.WordBox(2, 40, ScrH() - 75, "" .. job, "rp_base_hud_font", Color(30, 30, 30, 240), Color(255, 255, 255, 255))
    draw.SimpleText(LocalPlayer():Health(), "rp_base_hud_font", 40, ScrH() - 49, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    surface.SetDrawColor(255, 255, 255, 200)
    draw.WordBox(0, ScrW() - 165, 20, os.date("%H:%M:%S - %d/%m/%Y"), "rp_base_hud_font", Color(30, 30, 30, 240), Color(255, 255, 255, 155))
    local wep, total, clip, ArmedName
    ply = LocalPlayer()
    if not IsValid(ply:GetActiveWeapon()) then return end
    wep = ply:GetActiveWeapon()
    ArmedName = wep:GetPrintName()
    draw.SimpleText(ArmedName, "rp_base_hud_font4", ScrW() - 20, ScrH() - 20, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
end)

hook.Add("PreGamemodeLoaded", "disable_playervoicechat_base", function()
    hook.Remove("InitPostEntity", "CreateVoiceVGUI")
end)

---------------[[
-- Chat Open/Close
---------------]]

hook.Add( "StartChat", "rp_HasStartedTyping", function( isTeamChat )
	if ( IsValid(LocalPlayer()) and LocalPlayer():isOTA() and LocalPlayer():Alive() and LocalPlayer():GetModel() ~= "models/player/soldier_stripped.mdl") then
		LocalPlayer():EmitSound("common/on"..math.random(1,6)..".mp3", 50)
	elseif ( IsValid(LocalPlayer()) and LocalPlayer():isMPF() and LocalPlayer():Alive()) then
		LocalPlayer():EmitSound("npc/metropolice/vo/on"..math.random(1,2)..".wav", 50)
	end
end )

hook.Add( "FinishChat", "rp_ClientFinishTyping", function()
	if ( IsValid(LocalPlayer()) and LocalPlayer():isOTA() and LocalPlayer():Alive() and LocalPlayer():GetModel() ~= "models/player/soldier_stripped.mdl") then
		LocalPlayer():EmitSound("common/off"..math.random(1,9)..".mp3", 50)
	elseif ( IsValid(LocalPlayer()) and LocalPlayer():isMPF() and LocalPlayer():Alive() ) then
		LocalPlayer():EmitSound("npc/metropolice/vo/off"..math.random(1,4)..".wav", 50)
	end
end)

---------------[[
-- Combine Lines
---------------]]

hook.Add("HUDPaint", "rp_DrawCombineOverlay", function()
	local ply = LocalPlayer()
	local x, y = 5, 5
	local blackFadeAlpha = 0
	local colorWhite = Color(255,255,255)
	local curTime = CurTime()
	local isCP = isCP or false
	
	if (ply:Alive() and ply:isMPF() and ply:Team() ~= TEAM_MAYOR and combineDisplayLines or ply:Alive() and ply:isOTA() and combineDisplayLines and ply:GetModel() ~= "models/player/soldier_stripped.mdl") then
		local height = draw.GetFontHeight("rp_base_hud_font")
		
		for k, v in ipairs(combineDisplayLines) do
			if (curTime >= v[2]) then
				table.remove(combineDisplayLines, k)
			else
				local color = v[4] or colorWhite
				local textColor = Color(color.r, color.g, color.b, 255 - blackFadeAlpha)
				
				draw.SimpleText(string.sub(v[1], 1, v[3]), "rp_base_hud_font", x, y, textColor)
				
				if (v[3] < string.len(v[1])) then
					v[3] = v[3] + 1
				end
				
				y = y + height
			end
		end
	end
end)

function AddCombineDisplayLine(text, color)
	local ply = LocalPlayer()
	if (ply:Alive()) then
		if (!combineDisplayLines) then
			combineDisplayLines = {}
		end
		table.insert(combineDisplayLines, {"< : : "..(text), CurTime() + 8, 5, color})
	end
end

local randomDisplayLines = {
	"Получение новых директив...",
	"Отправка местоположения юнита центру...",
	"Отслеживание прибывших...",
	"Обновление координат юнита...",
	"Обновление приватного репозитория...",
	"Диспетчер сообщает...",
	"Новые прибывшие на подходе..."
}

local curTime,health,armor
local nextHealthWarning = CurTime() + 2
local nextRandomLine = CurTime() + 1
local lastRandomDisplayLine = ""

hook.Add("Think", "rp_DisplayLine_Tick", function()
 	local ply = LocalPlayer()
 	local isCP = isCP or false
	if (IsValid(ply)) then
		if ( IsValid(ply) and ply:isMPF() and ply:Team() ~= TEAM_MAYOR or IsValid(ply) and ply:isOTA() and ply:GetModel() ~= "models/player/soldier_stripped.mdl") then
			curTime = CurTime()
			health = ply:Health()
			armor = ply:Armor()
			if (nextHealthWarning <= curTime) then
				if (ply.lastHealth) then
					if (health < ply.lastHealth) then
						if (health == 0) then
							AddCombineDisplayLine("!ERROR! ОТКАЗ СИСТЕМ ЖИЗНЕОБЕСПЕЧЕНИЯ!", Color(255, 0, 0, 255))
							else
							AddCombineDisplayLine("!WARNING! Обнаружено физическое повреждение!", Color(255, 0, 0, 255))
						end
					elseif (health > ply.lastHealth) then
						if (health >= (ply:GetMaxHealth())) then
							AddCombineDisplayLine("Физические показатели восстановлены.", Color(0, 255, 0, 255))
						else
							AddCombineDisplayLine("Физические показатели восстанавливаются.", Color(0, 0, 255, 255))
						end
					end
				end
				
				if (ply.lastArmor) then
					if (armor < ply.lastArmor) then
						if (armor == 0) then
							AddCombineDisplayLine("!ERROR! Внешняя защита исчерпана!", Color(255, 0, 0, 255))
							else
							AddCombineDisplayLine("!WARNING! Обнаружено повреждение внешней защиты!", Color(255, 0, 0, 255))
						end
					elseif (armor > ply.lastArmor) then
						if (armor >= (ply:getJobTable().armor or 100)) then
							AddCombineDisplayLine("Внешняя защита восстановлена.", Color(0, 255, 0, 255))
						else
							AddCombineDisplayLine("Внешняя защита восстанавливается.", Color(0, 0, 255, 255))
						end
					end
				end
				nextHealthWarning = curTime + 2
				ply.lastHealth = health
				ply.lastArmor = armor
			end
			
 			if (nextRandomLine <= curTime) then
				local text = randomDisplayLines[ math.random(1, #randomDisplayLines) ]
				
				if (text and lastRandomDisplayLine != text) then
					AddCombineDisplayLine(text)
					
					lastRandomDisplayLine = text
				end
				nextRandomLine = CurTime() + 1.9
			end
		end
	end
end)

---------------[[
-- C menu
---------------]]

local function fnFilter (f, xs)
    local res = {}
    for k,v in pairs(xs) do
        if f(v) then res[k] = v end
    end
    return res
end

local function fnHead (xs)
    return table.GetFirstValue(xs)
end

local context_menu_pos = "bot" --available bot,right,left
local Menu = {}

local function Option(title, icon, cmd, check)
	table.insert(Menu, {title = title, icon = icon, cmd = cmd, check = check})
end

local function SubMenu(title, icon, func, check)
	table.insert(Menu, {title = title, icon = icon, func = func, check = check})
end


local function Spacer(check)
	table.insert(Menu, {check = check})
end

local function Request(title, text, func)
	return function()
		local painter = Derma_StringRequest(title, text, '', function(s)
				
			func(s)
			
		end)
		painter.Paint = function(s, w, h) Derma_DrawBackgroundBlur(s, s.start) surface.SetDrawColor(col.ba) surface.DrawRect(0,0,w,h) end
	end
end

local function isCP()
	return LocalPlayer():isCP()
end


local function add(t)
	table.insert(Menu, t)
end

Option("Вызов администратора", "icon16/flag_red.png", Request('Вызов администратора', 'Опишите жалобу', function(s)
	LocalPlayer():ConCommand("say @ "..s)
end))

Option("Объявление", "icon16/flag_yellow.png", Request('Подача объявления', 'Напишите объявление ниже.', function(s)
	LocalPlayer():ConCommand("say /ad "..s)
end))

Spacer()

Option("Донат", "icon16/coins_add.png", function()
	RunConsoleCommand("say", "/donate")
end)

Option("Остановить звуки", "icon16/sound_delete.png", function()
	RunConsoleCommand("stopsound")
end)

SubMenu("OOC", "icon16/book_open.png", function(self)
	self:AddOption('Сайт-форум', function() 
		gui.OpenURL("https://minerva.pw")
	end):SetIcon("icon16/comment.png")

	self:AddOption("Discord", function() 
		gui.OpenURL("https://discordapp.com/invite/Nnt9rxy")
	end):SetIcon("icon16/bullet_feed.png")

	self:AddOption("Steam", function() 
		gui.OpenURL("https://steamcommunity.com/groups/metarex_group")
	end):SetIcon("icon16/attach.png")

	self:AddOption("Очистить чат", function() 
		LocalPlayer():ConCommand("lounge_chat_clear")
	end):SetIcon("icon16/attach.png")
end)

Spacer()

SubMenu("Токены", "icon16/money.png", function(self)
	self:AddOption("Выкинуть токены", Request("Выкинуть токены", "Сколько вы хотите выкинуть токенов?", function(s) 
		RunConsoleCommand('darkrp', 'dropmoney', tostring(s))
	end)):SetIcon("icon16/money.png")

	self:AddOption("Дать токены", Request("Дать токены", "Сколько вы хотите передать токенов?", function(s) 
		RunConsoleCommand('darkrp', 'give', tostring(s))
	end)):SetIcon("icon16/money_add.png")
end)

SubMenu("Действия", "icon16/plugin_go.png", function(self)
	self:AddOption('Сменить имя', Request('Смена имени', 'Какое имя вы себе хотите установить?', function(s) 
		RunConsoleCommand('darkrp', 'rpname', s)
	end)):SetIcon("icon16/asterisk_orange.png")

	self:AddOption('Бросить кубик', function() 
		RunConsoleCommand('say','/roll 6')
	end):SetIcon("icon16/box.png")

	self:AddOption("Продать все двери", function() 
		RunConsoleCommand('darkrp','sellalldoors')
	end):SetIcon("icon16/door.png")
	
	self:AddOption("Выкинуть оружие", function() 
		RunConsoleCommand('darkrp','drop')
	end):SetIcon("icon16/gun.png")

	self:AddOption('Случайное число', function() 
		RunConsoleCommand('say','/roll 100')
	end):SetIcon("icon16/calculator_link.png")
end)

SubMenu("Администрирование", "icon16/note_edit.png", function(self)
	self:AddOption("Логи", function() 
		RunConsoleCommand("say", "!logs")
	end):SetIcon( "icon16/report.png" )
end, function() return LocalPlayer():IsAdmin() end)

local fsdfdsfsd = "icon16/cup_go.png"

SubMenu("Кулинария", "icon16/cup.png", function(self)
	self:AddOption("Купить Банан - ₮10", function() 
		LocalPlayer():ConCommand("say /buyfood Банан")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Бананы - ₮20", function() 
		LocalPlayer():ConCommand("say /buyfood Бананы")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Арбуз - ₮20", function() 
		LocalPlayer():ConCommand("say /buyfood Арбуз")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Бутылка воды - ₮20", function() 
		LocalPlayer():ConCommand("say /buyfood Бутылка воды")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Газировка - ₮5", function() 
		LocalPlayer():ConCommand("say /buyfood Газировка")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Молоко - ₮20", function() 
		LocalPlayer():ConCommand("say /buyfood Молоко")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Апельсин - ₮20", function() 
		LocalPlayer():ConCommand("say /buyfood Апельсин")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Сардины - ₮30", function() 
		LocalPlayer():ConCommand("say /buyfood Сардины")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Арахисовая паста - ₮15", function() 
		LocalPlayer():ConCommand("say /buyfood Арахисовая паста")
	end):SetIcon( fsdfdsfsd )

	self:AddOption("Купить Сыр - ₮50", function() 
		LocalPlayer():ConCommand("say /buyfood Сыр")
	end):SetIcon( fsdfdsfsd )
end, function() return LocalPlayer():Team() == TEAM_CWU4 end)

--[[SubMenu("Альянс", "icon16/bullet_wrench.png", function(self)
	if LocalPlayer():GetBodygroup(2) ~= 0 and ply:isMPF() then
		self:AddOption("Снять маску", function() 
			RunConsoleCommand("rp_unclaim_mask_cp", "yes")
		end):SetIcon( "icon16/cog_delete.png" )
	end
	if LocalPlayer():GetBodygroup(2) == 0 and ply:isMPF() then
		self:AddOption("Одеть маску", function() 
			RunConsoleCommand("rp_unclaim_mask_cp", "no")
		end):SetIcon( "icon16/cog_add.png" )
	end

end, function() return LocalPlayer():isCP() end)]]

local menu
hook.Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
	local lpe = LocalPlayer():GetEyeTraceNoCursor().Entity
	if not lpe:GetClass():find("mediaplayer") then
		if not g_ContextMenu:IsVisible() then
			local orig = g_ContextMenu.Open
			g_ContextMenu.Open = function(self, ...)
				self.Open = orig
				orig(self, ...)

				menu = vgui.Create("CMenuExtension")
				menu:SetDrawOnTop(false)

				for k, v in pairs(Menu) do
					if not v.check or v.check() then
						if v.cmd then
							menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
						elseif v.func then
							local m, s = menu:AddSubMenu(v.title)
							s:SetImage(v.icon)
							v.func(m)
						else
							menu:AddSpacer()
						end
					end
				end

				menu:Open()
				if context_menu_pos == "bot" then
					menu:CenterHorizontal()
					menu.y = ScrH()
					menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
				elseif context_menu_pos == "right" then
					menu:CenterVertical()
					menu.x = ScrW()
					menu:MoveTo(ScrW() - menu:GetWide() - 8, menu.y, .1, 0)
				elseif context_menu_pos == "left" then
					menu:CenterVertical()
					menu.x = - menu:GetWide()
					menu:MoveTo(8, menu.y, .1, 0)
				else
					menu:CenterHorizontal()
					menu.y = - menu:GetTall()
					menu:MoveTo(menu.x, 30 + 8, .1, 0)
				end


				menu:MakePopup()
			end
		end
	end
end)

hook.Add( "CloseDermaMenus", "CMenuCloseDermaMenus", function()
	if menu && menu:IsValid() then
		menu:MakePopup()
	end
end)

hook.Add("OnContextMenuClose", "CMenuOnContextMenuClose", function()
 if menu && menu:IsValid() then
	menu:Remove()
 end
end)



local f = RegisterDermaMenuForClose

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" )
AccessorFunc( PANEL, "m_bDeleteSelf", 		"DeleteSelf" )
AccessorFunc( PANEL, "m_iMinimumWidth", 	"MinimumWidth" )
AccessorFunc( PANEL, "m_bDrawColumn", 		"DrawColumn" )
AccessorFunc( PANEL, "m_iMaxHeight", 		"MaxHeight" )

AccessorFunc( PANEL, "m_pOpenSubMenu", 		"OpenSubMenu" )


--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetIsMenu( true )
	self:SetDrawBorder( true )
	self:SetDrawBackground( true )
	self:SetMinimumWidth( 100 )
	self:SetDrawOnTop( true )
	self:SetMaxHeight( ScrH() * 0.9 )
	self:SetDeleteSelf( true )
		
	self:SetPadding( 0 )
	
end

--[[---------------------------------------------------------
	AddPanel
-----------------------------------------------------------]]
function PANEL:AddPanel( pnl )

	self:AddItem( pnl )
	pnl.ParentMenu = self
	
end

--[[---------------------------------------------------------
	AddOption
-----------------------------------------------------------]]
function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "CMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	pnl:SetTextColor( col.w )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddCVar
-----------------------------------------------------------]]
function PANEL:AddCVar( strText, convar, on, off, funcFunction )

	local pnl = vgui.Create( "DMenuOptionCVar", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	pnl:SetTextColor( col.w )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	pnl:SetConVar( convar )
	pnl:SetValueOn( on )
	pnl:SetValueOff( off )
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSpacer
-----------------------------------------------------------]]
function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		surface.SetDrawColor( col.o )
		surface.DrawRect( 0, 0, w, h )
	end
	
	pnl:SetTall( 1 )	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSubMenu
-----------------------------------------------------------]]
function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "CMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	pnl:SetTextColor( col.w )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return SubMenu, pnl

end

--[[---------------------------------------------------------
	Hide
-----------------------------------------------------------]]
function PANEL:Hide()

	local openmenu = self:GetOpenSubMenu()
	if ( openmenu ) then
		openmenu:Hide()
	end
	
	self:SetVisible( false )
	self:SetOpenSubMenu( nil )
	
end

--[[---------------------------------------------------------
	OpenSubMenu
-----------------------------------------------------------]]
function PANEL:OpenSubMenu( item, menu )

	-- Do we already have a menu open?
	local openmenu = self:GetOpenSubMenu()
	if ( IsValid( openmenu ) ) then
	
		-- Don't open it again!
		if ( menu && openmenu == menu ) then return end
	
		-- Close it!
		self:CloseSubMenu( openmenu )
	
	end
	
	if ( !IsValid( menu ) ) then return end

	local x, y = item:LocalToScreen( self:GetWide(), 0 )
	menu:Open( x-3, y, false, item )
	
	self:SetOpenSubMenu( menu )

end


--[[---------------------------------------------------------
	CloseSubMenu
-----------------------------------------------------------]]
function PANEL:CloseSubMenu( menu )

	menu:Hide()
	self:SetOpenSubMenu( nil )

end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( !self:GetDrawBackground() ) then return end
	
	draw.RoundedBox(0,0,0,w,h,col.ba)
end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[ num ]
end

--[[---------------------------------------------------------
	PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local w = self:GetMinimumWidth()
	
	-- Find the widest one
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	
	end

	self:SetWide( w )
	
	local y = 0 -- for padding
	
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )
	
	DScrollPanel.PerformLayout( self )

end


--[[---------------------------------------------------------
	Open - Opens the menu. 
	x and y are optional, if they're not provided the menu 
		will appear at the cursor.
-----------------------------------------------------------]]
function PANEL:Open( x, y, skipanimation, ownerpanel )

	local maunal = x and y

	x = x or gui.MouseX()
	y = y or gui.MouseY()
	
	local OwnerHeight = 0
	local OwnerWidth = 0
	
	if ( ownerpanel ) then
		OwnerWidth, OwnerHeight = ownerpanel:GetSize()
	end
		
	self:PerformLayout()
		
	local w = self:GetWide()
	local h = self:GetTall()
	
	self:SetSize( w, h )
	
	
	if ( y + h > ScrH() ) then y = ((maunal and ScrH()) or (y + OwnerHeight)) - h end
	if ( x + w > ScrW() ) then x = ((maunal and ScrW()) or x) - w end
	if ( y < 1 ) then y = 1 end
	if ( x < 1 ) then x = 1 end
	
	self:SetPos( x, y )
	self:MakePopup()
	self:SetVisible( true )
	
	-- Keep the mouse active while the menu is visible.
	self:SetKeyboardInputEnabled( false )
	
end

--
-- Called by CMenuOption
--
function PANEL:OptionSelectedInternal( option )

	self:OptionSelected( option, option:GetText() )

end

function PANEL:OptionSelected( option, text )

	-- For override

end

function PANEL:ClearHighlights()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl.Highlight = nil
	end

end

function PANEL:HighlightItem( item )

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		if ( pnl == item ) then
			pnl.Highlight = true
		end
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )


end

derma.DefineControl( "CMenuExtension", "ContxtMenuC", PANEL, "DScrollPanel" )

--=======================================================================================================--

local PANEL = {}

AccessorFunc( PANEL, "m_pMenu", "Menu" )
AccessorFunc( PANEL, "m_bChecked", "Checked" )
AccessorFunc( PANEL, "m_bCheckable", "IsCheckable" )

function PANEL:Init()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 30, 0 )			-- Room for icon on left
	self:SetTextColor( col.w )
	self:SetChecked( false )

end

function PANEL:SetSubMenu( menu )

	self.SubMenu = menu

	if ( !self.SubMenuArrow ) then

		self.SubMenuArrow = vgui.Create( "DPanel", self )
		self.SubMenuArrow.Paint = function( panel, w, h ) 
			local rightarrow = {
				{ x = 5, y = 3 },
				{ x = w-5, y = h/2 },
				{ x = 5, y = h-3 }
			}
			surface.SetDrawColor( col.w )
			draw.NoTexture()
			surface.DrawPoly( rightarrow )
		end

	end

end

function PANEL:AddSubMenu()
	if ( !self ) then CloseDermaMenus() end
	local SubMenu = vgui.Create( "CMenuExtension", self )
		SubMenu:SetVisible( false )
		SubMenu:SetParent( self )
		SubMenu.Paint = function(p,w,h)
			draw.RoundedBox(0,0,0,w,h,col.ba)
		end

	self:SetSubMenu( SubMenu )

	return SubMenu

end

function PANEL:OnCursorEntered()

	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )
		return
	end
	//self:GetParent():OpenSubMenu( self, self.SubMenu )

end

function PANEL:OnCursorExited()
end

function PANEL:Paint( w, h )

	--derma.SkinHook( "Paint", "MenuOption", self, w, h )
	if self:IsHovered() then
		draw.RoundedBox(0,0,0,w,h,col.baw)	
	end
	--
	-- Draw the button text
	--
	return false

end

function PANEL:OnMousePressed( mousecode )

	self.m_MenuClicking = true

	DButton.OnMousePressed( self, mousecode )

end

function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_MenuClicking && mousecode == MOUSE_LEFT ) then

		self.m_MenuClicking = false
		CloseDermaMenus()

	end

end

function PANEL:DoRightClick()

	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end

end

function PANEL:DoClickInternal()

	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end

	if ( self.m_pMenu ) then

		self.m_pMenu:OptionSelectedInternal( self )

	end

end

function PANEL:ToggleCheck()

	self:SetChecked( !self:GetChecked() )
	self:OnChecked( self:GetChecked() )

end

function PANEL:OnChecked( b )
end

function PANEL:PerformLayout()

	self:SizeToContents()
	self:SetWide( self:GetWide() + 30 )

	local w = math.max( self:GetParent():GetWide(), self:GetWide() )

	self:SetSize( w, 22 )

	if ( self.SubMenuArrow ) then

		self.SubMenuArrow:SetSize( 15, 15 )
		self.SubMenuArrow:CenterVertical()
		self.SubMenuArrow:AlignRight( 4 )

	end

	DButton.PerformLayout( self )

end

function PANEL:GenerateExample()
end

derma.DefineControl( "CMenuOption", "ContxtMenuD", PANEL, "DButton" )

cl_PProtect = {}

function cl_PProtect.cs_menu( p )

	-- clear Panel
	if !p then return end
	p:ClearControls()
	
	p:addchk( "Ноги", "Отображение ног в виде от 1-го лица", GetConVar("cl_legs"):GetBool() or false, function(c) 
		RunConsoleCommand("cl_legs", GetConVar("cl_legs"):GetBool() and 0 or 1) 
	end)
	p:addchk( "Вид 3-го лица", "Активация третьего вида", GetConVar("rp_toggle_thirdperson"):GetBool() or false, function(c) 
		RunConsoleCommand("rp_toggle_thirdperson", GetConVar("rp_toggle_thirdperson"):GetBool() and 0 or 1) 
	end)
end

hook.Add( "PopulateToolMenu", "pprotect_make_menus", function()
	spawnmenu.AddToolMenuOption( "Minerva", "Настройки", "PPClientSettings", "Интерфейс", "", "", function( p ) cl_PProtect.UpdateMenus( "cs", p ) end )
end )


local function showErrorMessage( p, msg )
	p:ClearControls()
	p:addlbl( msg )
end

local pans = {}

function cl_PProtect.UpdateMenus( p_type, panel )

	-- add Panel
	if p_type and !pans[ p_type ] then pans[ p_type ] = panel end

	-- load Panel
	for t, p in pairs(pans) do
		
		if t == "as" or t == "pp" then
			if LocalPlayer():IsSuperAdmin() then RunConsoleCommand( "pprotect_request_new_settings", t )
			else showErrorMessage( pans[ t ], "Вам нужно быть основателем для смены\nнастроек" ) end
		elseif t == "cu" then
			if LocalPlayer():IsNabor() then RunConsoleCommand( "pprotect_request_new_counts" )
			else showErrorMessage( pans[ t ], "Вам нужно быть основателем для\nизменения настроек" ) end
		else
			cl_PProtect[ t .. "_menu" ]( pans[ t ] )
		end

	end

end
hook.Add( "SpawnMenuOpen", "pprotect_update_menus", cl_PProtect.UpdateMenus )

local pan = FindMetaTable( "Panel" )

function pan:addlbl( text, header )

	if header then header = 750 else header = 0 end
	local lbl = vgui.Create( "DLabel" )
	lbl:SetText( text )
	lbl:SetDark( true )
	lbl:SetFont( cl_PProtect.setFont( "roboto", 14, header, true ) )
	lbl:SizeToContents()

	self:AddItem( lbl )

	return lbl

end

local fonts = {}
function cl_PProtect.setFont( f, s, b, a, sh, sy )

	b, a, sh, sy = b or 500, a or false, sh or false, sy or false
	local fstr = "pprotect_" .. f .. "_" .. tostring( s ) .. "_" .. tostring( b ) .. "_" .. string.sub( tostring( a ), 1, 1 ) .. "_" .. string.sub( tostring( sh ), 1, 1 )

	if table.HasValue( fonts, fstr ) then return fstr end

	surface.CreateFont( fstr, {
		font = f,
		size = s,
		weight = b,
		antialias = a,
		shadow = sh,
		symbol = sy
	} )

	table.insert( fonts, fstr )

	return fstr

end

function pan:addchk( text, tip, check, cb )

	local chk = vgui.Create( "DCheckBoxLabel" )
	chk:SetText( text )
	chk:SetDark( true )
	chk:SetChecked( check )
	if tip then chk:SetTooltip( tip ) end
	chk.Label:SetFont( cl_PProtect.setFont( "roboto", 14, 500, true ) )

	function chk:OnChange() cb( chk:GetChecked() ) end

	function chk:PerformLayout()
		local x = self.m_iIndent or 0
		self:SetHeight( 20 )
		self.Button:SetSize( 36, 20 )
		self.Button:SetPos( x, 0 )
		if self.Label then
			self.Label:SizeToContents()
			self.Label:SetPos( x + 35 + 10, self.Button:GetTall() / 2 - 7 )
		end
	end

	local curx = 0
	if !chk:GetChecked() then curx = 2 else curx = 18 end
	local function smooth( goal )
		local speed = math.abs( goal - curx ) / 3
		if curx > goal then curx = curx - speed
		elseif curx < goal then curx = curx + speed
		end
		return curx
	end

	function chk:PaintOver()
		--draw.RoundedBox( 0, 0, 0, 36, 20, Color("#3f3f3f") )
		if !chk:GetChecked() then
			draw.RoundedBox( 8, 0, 0, 36, 20, Color( 100, 100, 100 ) )
			draw.RoundedBox( 8, smooth( 2 ), 2, 16, 16, Color( 255, 255, 255 ) )
		else
			draw.RoundedBox( 8, 0, 0, 36, 20, Color( 55, 155, 0 ) )
			draw.RoundedBox( 8, smooth( 18 ), 2, 16, 16, Color( 255, 255, 255 ) )
		end
	end

	self:AddItem( chk )

	return chk

end

function pan:addbtn( text, nettext, args )

	local btn = vgui.Create( "DButton" )
	btn:Center()
	btn:SetTall( 25 )
	btn:SetText( text )
	btn:SetDark( true )
	btn:SetFont( cl_PProtect.setFont( "roboto", 14, 500, true ) )
	btn:SetColor( Color( 50, 50, 50 ) )

	function btn:DoClick()

		if btn:GetDisabled() then return end

		if type( args ) == "function" then

			args()

		else

			net.Start( nettext )
				if args != nil and cl_PProtect.Settings[ args[1] ] then
					net.WriteTable( { args[1], cl_PProtect.Settings[ args[1] ] } )
				else
					net.WriteTable( args or {} )
				end
			net.SendToServer()

		end

		if nettext == "pprotect_save" then cl_PProtect.UpdateMenus() end

	end

	function btn:Paint( w, h )
		if btn:GetDisabled() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240 ) )
			btn:SetCursor( "arrow" )
		elseif btn.Depressed then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 250, 150, 0 ) )
		elseif btn.Hovered then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 220, 220, 220 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
		end
	end

	self:AddItem( btn )

	return btn

end


--[[
	Some Shit
--]]


local gasdfg45 = 52

local function NiceDist(vec1, vec2, str)
	if not isvector(vec1) or not isvector(vec2) then return end

	local str = str and " " .. str or " м."
	local pos = math.sqrt(vec1:DistToSqr(vec2))
	local nice_pos = math.floor(pos / gasdfg45)

	return nice_pos .. str
end

local function NiceDraw(pos, text1, text2, icon, col1, col2)
	local position = pos + Vector(0, 0, 40)
	position = position:ToScreen()

	surface.SetMaterial(Material(icon))
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(position.x - 8, position.y - 50, 16, 16)

	draw.DrawText(text1, "Trebuchet24", position.x, position.y - 30, col1, TEXT_ALIGN_CENTER)
	draw.DrawText(text2, "Trebuchet24", position.x, position.y - 10, col2, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "rp_ShowMeBoxes", function()
	local ply = LocalPlayer()
	local pos = ply:GetPos()

	if ply:Team() == TEAM_CITIZEN and not ply:HasWeapon("rp_cid") then
		for _, ent in ipairs(ents.FindByClass("rp_baggage")) do
			local ent_pos = ent:GetPos()
			local dist = NiceDist(pos, ent_pos)

			NiceDraw(ent_pos, "CID-Карта", dist, "icon16/briefcase.png", Color(155, 155, 155, 255), Color(155, 155, 155))
		end
	end

	if ply:Team() == TEAM_CWU5 and ply:HasWeapon("rp_box") then
		for _, ent in ipairs(ents.FindByClass("rp_courier_got")) do
			local ent_pos = ent:GetPos()
			local dist = NiceDist(pos, ent_pos)

			NiceDraw(ent_pos, "Сдача посылки", dist, "icon16/coins.png", Color(155, 155, 155, 255), Color(155, 155, 155))
		end
	end

	if ply:isMPF() and not ply:HasWeapon("rp_cid") then
		for _, ent in ipairs(ents.FindByClass("rp_arsenal_cp")) do
			local ent_pos = ent:GetPos()
			local dist = NiceDist(pos, ent_pos)

			NiceDraw(ent_pos, "Оружейная", dist, "icon16/flag_blue.png", Color(155, 155, 155, 255), Color(155, 155, 155))
		end
	end

	if ply:isOTA() and ply:GetModel() == "models/player/soldier_stripped.mdl" then
		for _, ent in ipairs(ents.FindByClass("rp_otachip")) do
			local ent_pos = ent:GetPos()
			local dist = NiceDist(pos, ent_pos)

			NiceDraw(ent_pos, "Перечипировка", dist, "icon16/information.png", Color(155, 155, 155, 255), Color(155, 155, 155))
		end
	end
end)

hook.Add("RenderScreenspaceEffects", "rp_RenderScreenspaceEffects_health", function()
	if LocalPlayer():Health() < 50 then
		DrawMotionBlur(0.4, 0.8, 0.01)
	elseif LocalPlayer():Health() < 25 then 
		DrawMotionBlur(0.5, 0.9, 0.02)
	elseif LocalPlayer():Health() < 10 then
		DrawMotionBlur(0.7, 1, 0.04)
	end
end)
