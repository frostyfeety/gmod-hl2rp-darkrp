AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_upgrader.lua")
include("shared.lua")
include("sh_upgrader.lua")


function ENT:Initialize()

	self:SetModel("models/hunter/blocks/cube075x075x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self.IsMoneyPrinter = true
	
	self.Error = 0
	self.BreakDown = false
	self.MoneyCollected = 0
	
	self.CreatedTime = CurTime()
	
	self.LastBreakDown = CurTime() + self.BreakDownTimer
	self.V_Hull = self.Hull
	self:SetDTInt(2,self.V_Hull)
	
	
	self.TuneLevel = {}
	
	-- STAT --
	self.Stats = {}
	self.Stats["HullDecreSpeed"] = self.HullDecreSpeed or 1
	self.Stats["HP"] = self.PrinterHealth
	self.Stats["RPM"] = self.RPM
	self.Stats["MaxMoney"] = self.MaxMoney
	self.Stats["BreakDownRate"] = self.BreakDownRate
	
	self.Stats_Default = table.Copy(self.Stats)
	
	self:SetHealth(self.Stats["HP"])
end

function ENT:ErrorCheck()
	local ER = 0
	
	if self.Stats["MaxMoney"] != 0 and self.MoneyCollected >= self.Stats["MaxMoney"] then
		ER = 1
	end
	if self.BreakDown then
		ER = 2
	end
	if self.V_Hull <= 0 then
		ER = 3
	end
	
	self.Error = ER
	self:SetDTInt(1,ER)
end

function ENT:Money_Generator()
	if self:IsError() then return end
	if self.V_Hull <= 0 then return end
	
	if ( self.LastGenerated or 0 ) < CurTime() then
		self.LastGenerated = CurTime() + 1
		self.V_Hull = self.V_Hull - self.Stats["HullDecreSpeed"]
		self:SetDTInt(2,self.V_Hull)
		if self.Stats["MaxMoney"] != 0 then
			self.MoneyCollected = math.min(self.MoneyCollected+self.Stats["RPM"],self.Stats["MaxMoney"])
		else
			self.MoneyCollected = self.MoneyCollected+self.Stats["RPM"]
		end
		
		self:SetDTInt(0,self.MoneyCollected)
	end
end

function ENT:BreakDown_Thinker()
	if !self.BreakDown and ( self.LastBreakDown or 0 ) < CurTime() then
		self.LastBreakDown = CurTime() + self.BreakDownTimer
		if math.random(0,100) < self.Stats["BreakDownRate"] then
			self.BreakDown = true
			self.BreakDownActivatedTime = CurTime()
			
			if RXPrinters_Config.Notice_BreakDown then
				DarkRP.notify(self:GetPrinterOwner(), 1, 4, "Ваш принтер сломался! Подойдите и почините его нажав E!")
			end
		end
	end
	
	if self.BreakDown and self.BreakDownActivatedTime and (CurTime() - self.BreakDownActivatedTime > self.BreakDownDestoryTime ) then
		self:Destruct()
		return
	end
end

function ENT:GetPrinterOwner()
	return self.dt.owning_ent or self:Getowning_ent()
end

function ENT:OnTakeDamage(dmg)
	local attacker = dmg:GetAttacker()
	self.Stats["HP"] = self.Stats["HP"] - dmg:GetDamage()
	
	if self.Stats["HP"] <= 0 then
		self:Destruct()
	end
end

function ENT:Destruct()
	
	local ED = EffectData()
	ED:SetOrigin(self:GetPos())
	ED:SetStart(VectorRand()*100+Vector(0,0,300))
	util.Effect("rxprinter_explode", ED)
	
	self:Remove()
	
	if RXPrinters_Config.Notice_Explode then
		DarkRP.notify(self:GetPrinterOwner(), 1, 4, "Ваш принтер был взорван")
	end
end


function ENT:Use(activator, caller, ent)
	if ( self.LastPickupTime or 0 ) > CurTime() then return end
	self.LastPickupTime = CurTime() + 1
	
	if !RXPrinters_Config.CanStealMoney and activator != self:GetPrinterOwner() then
		return
	end
	
	if self.BreakDown then
		self.BreakDown = false
		self.BreakDownActivatedTime = false
		self:ErrorCheck()
		return
	end
	
	DarkRP.notify(activator, 1, 4, "Вы получили " .. self.MoneyCollected .. " токенов!")
	activator:addMoney(self.MoneyCollected)
	self.MoneyCollected = 0
	self:SetDTInt(0,self.MoneyCollected)
	
	if self.V_Hull <= 0 then
		self:Destruct()
	end

	if activator:isCP() then
		activator:addMoney(500)
		DarkRP.notify(activator, 1, 4, "Вы получили 500 токенов!")
		self:Destruct()
	end
end

function ENT:Think()
	self:Money_Generator()
	self:BreakDown_Thinker()
	self:ErrorCheck()
	
	self:NextThink(CurTime()+0.3)
	return true
end