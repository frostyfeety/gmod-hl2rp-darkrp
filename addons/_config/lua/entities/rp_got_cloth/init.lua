AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

local hulled = false

function ENT:StartTouch( hitEnt )
	local moneyForWork = math.floor(math.random(100,350))

	if hitEnt:GetClass() == "rp_clothnew" and hulled == false then
		hitEnt:Remove()
		self.moneycollected = moneyForWork
		hulled = true
	end
end

function ENT:Use(activator)
	if IsValid(activator) and activator:Alive() and self.moneycollected >= 100 and activator:Team() == TEAM_CWU2 then
		activator:addMoney(self.moneycollected)
		activator:SendLua("GAMEMODE:AddNotify(\"Награда за выполненную работу "..self.moneycollected.." токенов\", NOTIFY_GENERIC, 10)")
		hulled = false
		self.moneycollected = 0
	end
end