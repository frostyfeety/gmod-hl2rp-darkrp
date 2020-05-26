AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Ration Dispenser"
ENT.Author = "Bilwin"
ENT.Category = "HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
ENT.NextTime = 3600

local COLOR_RED = 1
local COLOR_ORANGE = 2
local COLOR_BLUE = 3
local COLOR_GREEN = 4

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

local function Combine(ply)
    if ply:isMPF() then 
        return true
    end
end

local function Citizen(ply)
	if ply:isCitizen() or ply:isCWU() then
		return true
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "DispColor")
	self:NetworkVar("String", 1, "Text")
	self:NetworkVar("Bool", 0, "Disabled")
end

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("rp_ration_dispenser")
	entity:SetPos(trace.HitPos)
	entity:SetAngles(trace.HitNormal:Angle())
	entity:Spawn()
	entity:Activate()

	return entity
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/props_junk/gascan001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetText("ОЖИДАЮ")
		self:DrawShadow(false)
		self:SetDispColor(COLOR_GREEN)
		self.canUse = true
		-- Use prop_dynamic so we can use entity:Fire("SetAnimation")
		self.dummy = ents.Create("prop_dynamic")
		self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
		self.dummy:SetPos(self:GetPos())
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:SetParent(self)
		self.dummy:Spawn()
		self.dummy:Activate()

		self:DeleteOnRemove(self.dummy)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

if (CLIENT) then
	function ENT:Draw()
		local position, angles = self:GetPos(), self:GetAngles()

		angles:RotateAroundAxis(angles:Forward(), 90)
		angles:RotateAroundAxis(angles:Right(), 270)
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local color = Color(155, 255, 64)

		ang:RotateAroundAxis(ang:Forward(), 45)

		if (LocalPlayer():GetPos():Distance(self:GetPos()) < 1000) then
			render.SetMaterial(Material("sprites/glow04_noz"))
			render.DrawSprite(self:GetPos()+self:GetForward()*7.9+self:GetUp()*9+self:GetRight()*6, 8, 8, colors[self:GetDisabled() and COLOR_RED or self:GetDispColor()] or color_white)
		end
	end
else
	function ENT:setUseAllowed(state)
		self.canUse = state
	end

	function ENT:error(text)
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetText(text)
		self:SetDispColor(COLOR_RED)

		timer.Create("ligyh_DispenserError"..self:EntIndex(), 1.5, 1, function()
			if (IsValid(self)) then
				self:SetText("ОЖИДАЮ")
				self:SetDispColor(COLOR_GREEN)

				timer.Simple(0.5, function()
					if (!IsValid(self)) then return end

					self:setUseAllowed(true)
				end)
			end
		end)
	end

	function ENT:createRation(activator)
		local entity = ents.Create("prop_physics")
		entity:SetAngles(self:GetAngles())
		entity:SetModel("models/weapons/w_packatc.mdl")
		entity:SetPos(self:GetPos())
		entity:Spawn()
		entity:SetNotSolid(true)
		entity:SetParent(self.dummy)
		entity:Fire("SetParentAttachment", "package_attachment")

		timer.Simple(1.2, function()
			if (IsValid(self) and IsValid(entity)) then
				entity:Remove()
                activator:Give("rp_ration")
                activator:SelectWeapon("rp_ration")
				self:SetNWBool(activator:SteamID().."_Gived", true)
				timer.Create(activator:SteamID().."_ligyh_DispenserTimeOut_"..self:EntIndex(), self.NextTime, 1, function()
					if (activator:IsValid()) then
						self:SetNWBool(activator:SteamID().."_Gived", false)
					end
				end)
			end
		end)
	end

	function ENT:dispense(amount, activator)

		self:setUseAllowed(false)
		self:SetText("ВЫДАЧА")
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
		self:createRation(activator)
		self.dummy:Fire("SetAnimation", "dispense_package", 0)

		timer.Simple(3.5, function()
			if (IsValid(self)) then
				
					self:SetText("ЗАРЯД")
					self:SetDispColor(COLOR_ORANGE)
					self:EmitSound("buttons/combine_button7.wav")

					timer.Simple(7, function()
						if (!IsValid(self)) then return end

						self:SetText("РАЦИОН")
						self:SetDispColor(COLOR_GREEN)
						self:EmitSound("buttons/combine_button1.wav")

						timer.Simple(0.75, function()
							if (!IsValid(self)) then return end

							self:setUseAllowed(true)
						end)
					end)
				
			end
		end)
	end

	function ENT:Use(activator)
		if ((self.nextUse or 0) >= CurTime()) then
			return
		end
	if (Citizen(activator)) then
			if (!self.canUse or self:GetDisabled()) then
				return
			end

			self:setUseAllowed(false)
			self:SetText("ПРОВЕРКА")
			self:SetDispColor(COLOR_BLUE)
			self:EmitSound("ambient/machines/combine_terminal_idle2.wav")

			timer.Simple(1, function()
				if (!IsValid(self) or !IsValid(activator)) then return self:setUseAllowed(true) end

				if (self:GetNWBool(activator:SteamID().."_Gived", false)) then
					return self:error("ОТКАЗАНО")
				else
					self:SetText("Подготовка")
					self:EmitSound("hl1/fvox/boop.wav", 100, 50)

					timer.Simple(1, function()
						if (IsValid(self)) then
							self:dispense(amount, activator)
						end
					end)
				end
			end)
		elseif (Combine(activator)) then
			self:SetDisabled(!self:GetDisabled())
			self:EmitSound(self:GetDisabled() and "buttons/combine_button1.wav" or "buttons/combine_button2.wav")
			self.nextUse = CurTime() + 1
		end
	end

	function ENT:OnRemove()
	end
end