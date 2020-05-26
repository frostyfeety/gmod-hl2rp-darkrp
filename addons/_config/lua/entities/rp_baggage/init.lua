AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/SuitCase001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if activator:Team() ~= TEAM_CITIZEN then return end
    if activator:HasWeapon("rp_cid") then return end
    activator:Give("rp_cid")
    self:EmitSound("doors/latchunlocked1.wav")
    DarkRP.notify(activator, 2, 3, "Вы получили свою CID-карту")
end