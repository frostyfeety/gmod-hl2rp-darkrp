IGS.ITEMS.SB = IGS.ITEMS.SB or {
	TOOLS = {},
	SENTS = {},
	SWEPS = {},
	VEHS  = {}
}


local STORE_ITEM = FindMetaTable("IGSItem")

-- Тулы
function STORE_ITEM:SetTool(sToolName)
	self:SetCategory("Инструменты")
	self:SetDescription("Разрешает использовать инструмент " .. sToolName)

	self.tool = self:Insert(IGS.ITEMS.SB.TOOLS, sToolName)
	return self
end

-- Энтити
function STORE_ITEM:SetEntity(sEntClass)
	self:SetCategory("Энтити (Предметы)")

	self.entity = self:Insert(IGS.ITEMS.SB.SENTS, sEntClass)
	return self
end

-- Пушки
function STORE_ITEM:SetWeapon(sWepClass,tAmmo)
	self:SetCategory("Оружие")
	self:SetDescription("Разрешает спавнить " .. sWepClass .. " через спавн меню в любое время")

	self:SetNetworked() -- для HasPurchase и отображения галочки

	self.ammo = tAmmo
	self.swep = self:Insert(IGS.ITEMS.SB.SWEPS, sWepClass)
	return self
end

if CLIENT then -- :SetWeapon only
hook.Add("IGS.OnItemInfoOpen","CheckGiveWeaponOnSpawn",function(ITEM, fr)
	if !(ITEM.swep and LocalPlayer():HasPurchase(ITEM:UID())) then return end

	uigs.Create("DCheckBoxLabel", function(self)
		self:Dock(TOP)
		self:DockMargin(0,5,0,0)
		self:SetTall(20)

		local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
		self:SetValue(should_give)

		self:SetText("Выдавать при спавне")
		self.Label:SetTextColor(IGS.col.TEXT_SOFT)
		self.Label:SetFont("igs.15")

		function self:OnChange(give)
			net.Start("IGS.GiveOnSpawnWep")
				net.WriteIGSItem(ITEM)
				net.WriteBool(give)
			net.SendToServer()
		end
	end, fr.act)
end)

-- IGS.CloseUI()
-- IGS.UI()
-- IGS.WIN.Item("wep_weapon_ar2")

else -- SV
	util.AddNetworkString("IGS.GiveOnSpawnWep")

	local function bibuid(pl, ITEM)
		return "igs:gos:" .. pl:UniqueID() .. ":" .. ITEM:UID()
	end

	local function SetShouldPlayerReceiveWep(pl, ITEM, bGive)
		pl:SetNWBool("igs.gos." .. ITEM:ID(), bGive) -- gos GiveOnSpawn
		bib.setBool(bibuid(pl, ITEM), bGive)
	end

	local function PlayerSetWantReceiveOnSpawn(pl, ITEM, bWant)
		SetShouldPlayerReceiveWep(pl, ITEM, bWant)
		IGS.Notify(pl, ITEM:Name() .. (bWant and " " or " не ") .. "будет выдаваться при спавне")
	end

	local function GetShouldPlayerReceiveWep(pl, ITEM)
		return bib.getBool(bibuid(pl, ITEM))
	end

	local function setActiveWeapon(pl, class)
		pl:SetActiveWeapon(pl:GetWeapon(class))
	end

	local function giveItemAmmo(pl, ITEM)
		for type,count in pairs(ITEM.ammo or {}) do
			pl:SetAmmo(count,type)
		end
	end

	-- Выдает купленное оружие, если установлена галочка
	-- https://trello.com/c/2KJQisfJ/488-оружие-выдается-и-в-тюрьме
	function IGS:IGS_PlayerLoadout(pl)
		for uid in pairs(IGS.PlayerPurchases(pl) or {}) do
			local ITEM = IGS.GetItemByUID(uid)
			if !ITEM.swep then continue end

			local give = GetShouldPlayerReceiveWep(pl, ITEM)
			if give then
				pl:Give(ITEM.swep)
				giveItemAmmo(pl, ITEM)
			end
		end
	end

	net.Receive("IGS.GiveOnSpawnWep",function(_, pl)
		local ITEM,bWant = net.ReadIGSItem(),net.ReadBool()
		if !pl:HasPurchase(ITEM:UID()) or !ITEM.swep then return end -- байпас

		PlayerSetWantReceiveOnSpawn(pl, ITEM, bWant)
	end)

	hook.Add("PlayerLoadout", "IGS.PlayerLoadout", function(pl)
		hook.Call("IGS_PlayerLoadout", IGS, pl)
	end)

	hook.Add("IGS.PlayerPurchasesLoaded", "IGS.PlayerLoadout", function(pl)
		hook.Call("IGS_PlayerLoadout", IGS, pl)
	end)

	hook.Add("IGS.PlayerActivatedItem","IGS.PlayerLoadout",function(pl, ITEM)
		if ITEM.swep then
			PlayerSetWantReceiveOnSpawn(pl, ITEM, true) -- default give on spawn
			hook.Call("IGS_PlayerLoadout", IGS, pl)

			local text = "%s теперь будет выдаваться при каждом респавне. " ..
			"Если вы хотите временно отключить выдачу, " ..
			"то снимите галочку в карточке предмета в /donate меню"

			pl:ChatPrint("▼")
			IGS.Notify(pl, text:format(ITEM:Name()))
			pl:ChatPrint("▲")

			setActiveWeapon(pl, ITEM.swep)
			giveItemAmmo(pl, ITEM)
		end
	end)
end


-- Машины
function STORE_ITEM:SetVehicle(sVehClass)
	self:SetCategory("Транспорт")

	self.vehicle = self:Insert(IGS.ITEMS.SB.VEHS, sVehClass)
	return self
end

-- /\ SHARED
if CLIENT then return end
-- \/ SERVER

-- print( hook.Run("CanTool", player.Find("hell"), AMD():GetEyeTrace(), "rope") )
hook.Add("CanTool","IGS",function(pl,_,tool)
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.TOOLS[tool])
	if ITEM ~= nil then -- donate
		local allow = hook.Run("IGS.CanTool", pl, tool)
		if allow ~= nil then return allow end
		return tobool(ITEM)
	end
end)

-- Ниже решение для машин, как сделать, чтобы не спавнили тучу. Сейчас реализовывать лень
hook.Add("PlayerSpawnSENT","IGS",function(pl, class)
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.SENTS[class])
	if ITEM ~= nil then -- donate
		local allow = hook.Run("IGS.PlayerSpawnSENT", pl, class)
		if allow ~= nil then return allow end
		return tobool(ITEM)
	end
end)


-- для HOOK_HIGH
-- выше 2018.11.15 вынес и немного переписал две функции
-- Если будет работать норм, то и с остальных снять
timer.Simple(0,function()

hook.Add("PlayerGiveSWEP","IGS",function(pl,class)
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.SWEPS[class]) -- hasAccess if ITEM returned
	if ITEM then
		timer.Simple(.1,function()
			for type,count in pairs(ITEM.ammo or {}) do
				pl:SetAmmo(count,type)
			end
		end)

		return true -- #todo не ретурнить true!!. false or nil only
	end
end, HOOK_HIGH)


--[[-------------------------------------------------------------------------
	Машины
---------------------------------------------------------------------------]]
local function getcount(pl, class)
	return pl:GetVar("vehicles_" .. class,0)
end

local function counter(pl, class, incr)
	pl:SetVar("vehicles_" .. class, getcount(pl,class) + incr)
end

-- разрешаем спавнить одну, но конструкция позволяет в будущем сделать поддержку спавна нескольких машин
local function canSpawn(pl, class)
	return getcount(pl,class) < 1
end

local function getVehClass(veh)
	-- https://trello.com/c/l1tw7YpR/623
	return veh.IsSimfphyscar and veh:GetSpawn_List() or veh:GetVehicleClass()
end

-- Считаем заспавненные и удаленные машины
hook.Add("PlayerSpawnedVehicle","IGS",function(pl,veh)
	if IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.VEHS[getVehClass(veh)]) then -- чел покупал эту тачку, а теперь спавнит
		counter(pl, getVehClass(veh), 1)

		veh:CallOnRemove("ChangeCounter",function(ent)
			if !IsValid(pl) then return end
			counter(pl, getVehClass(ent), -1)
		end)
	end
end)

hook.Add("PlayerSpawnVehicle","IGS",function(pl, _, class) -- model, class, table
	if IGS.PlayerHasOneOf(pl,IGS.ITEMS.SB.VEHS[class]) then -- покупал машину
		local can = canSpawn(pl,class)
		if !can then
			IGS.Notify(pl,"У вас есть заспавнена эта машина")
		end

		return can
	end
end, HOOK_HIGH)
--[[-------------------------------------------------------------------------
	/Машины
---------------------------------------------------------------------------]]



-- DARKRP ONLY
hook.Add("canDropWeapon","IGS",function(pl,wep)
	-- Пушка не продается
	if !IsValid(wep) or !IGS.ITEMS.SB.SWEPS[wep:GetClass()] then return end

	-- Пушка продается и чел купил ее
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.SWEPS[wep:GetClass()])
	if ITEM then
		return false
	end

	-- Пушка продается, но чел ее не покупал
	-- Т.е. по сути возможность дропа контроллируется другими хуками
end, HOOK_HIGH)
end)
