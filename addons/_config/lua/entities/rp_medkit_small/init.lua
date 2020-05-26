AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:IsPlayer() then return end 
    local max_hp = activator:Health()
	if activator:Health() >= activator:GetMaxHealth() then
		return
	end
    self:EmitSound("items/medshot4.wav", 60, 100)
    activator:SetHealth(max_hp + 30)
    self:Remove()
end