AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:isRebel() then return end
    if activator:HasWeapon("tfcss_usp_alt") then return end
	if activator:Team() == TEAM_REBEL1 then
		activator:Give("tfcss_usp_alt")
	elseif activator:Team() == TEAM_REBEL2 then
		activator:Give("tfcss_usp_alt")
		activator:Give("tfcss_famas_alt")
	elseif activator:Team() == TEAM_REBEL3 then
		activator:Give("tfcss_usp_alt")
		activator:Give("tfcss_galil_alt")
	end
    self:EmitSound("doors/latchunlocked1.wav")
    DarkRP.notify(activator, 2, 3, "Вы получили своё снаряжение")
end