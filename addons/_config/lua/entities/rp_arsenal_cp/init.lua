AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/lockers001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:isMPF() then return end
    if activator:HasWeapon("rp_cid") then return end

    if activator:Team() == TEAM_CP1 then
        activator:Give("rp_stunstick")
        activator:Give("rp_cid")
        activator:Give("weaponchecker")
    end

    if activator:Team() == TEAM_CP2 then
        activator:Give("rp_stunstick")
        activator:Give("weaponchecker")
        activator:Give("rp_cid")
        activator:Give("tfa_hl2_pistol")
    end

    if activator:Team() == TEAM_CP3 then
        activator:Give("rp_stunstick")
        activator:Give("weaponchecker")
        activator:Give("rp_cid")
        activator:Give("tfa_hl2_mp7")
        activator:Give("tfa_hl2_pistol")
    end

    if activator:Team() == TEAM_CP4 then
        activator:Give("rp_stunstick")
        activator:Give("weaponchecker")
        activator:Give("rp_cid")
        activator:Give("tfcss_mp5_alt")
        activator:Give("tfcss_usp_alt")
    end

    self:EmitSound("doors/latchunlocked1.wav")
    DarkRP.notify(activator, 2, 3, "Вы получили своё снаряжение")
end