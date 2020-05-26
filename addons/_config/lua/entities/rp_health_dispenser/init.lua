AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/health_charger001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:health_can() then return end
    local max = activator:MaxHealthCan()

    if (activator.HealthCD or 0) > CurTime() then  
        return 
    end
    activator.HealthCD = CurTime() + 120

    if activator:Health() == max then
        return
    end

    if max > 0 then
        activator:SetHealth(max)
        self:EmitSound("buttons/combine_button7.wav", 100, 100)
    end
end