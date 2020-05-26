AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/suit_charger001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:armor_can() then return end
    local max = activator:MaxArmorCan()

    if (activator.ArmorCD or 0) > CurTime() then  
        return 
    end
    activator.ArmorCD= CurTime() + 120

    if activator:Armor() == max then
        return
    end

    if max > 0 then
        activator:SetArmor(max)
        self:EmitSound("buttons/combine_button7.wav", 100, 100)
    end
end