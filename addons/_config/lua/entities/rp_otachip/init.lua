AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/breenpod.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
    if not activator:isOTA() then return end
    if activator:GetModel() ~= "models/player/soldier_stripped.mdl" then return end

    if activator:Team() == TEAM_OTA1 then
        activator:SetPos(table.Random({[1] = Vector(6199.920410, -2734.388428, 2309.907959), [2] = Vector(5720.033691, -2744.647949, 2419.116699)}))
        activator:SetEyeAngles(Angle(14.651999, 90.851746, 0.000000))
        activator:Freeze(true)
        activator:SetNoDraw(true)
        activator:Flashlight(false)
        timer.Simple(1, function()
            activator:EmitSound("ambient/energy/weld1.wav", 75, 100)
        end)
        timer.Simple(3, function()
            activator:EmitSound("ambient/energy/zap8.wav", 75, 100)
        end)
        timer.Simple(4.5, function()
            activator:EmitSound("ambient/energy/zap9.wav", 75, 100)
        end)
        timer.Simple(math.random(5,8), function()
            activator:Spawn()
            activator:SetModel("models/player/combine_soldier.mdl")
            activator:Freeze(false)
            activator:SetNoDraw(false)
            activator:SetArmor(activator:MaxArmorCan())
            activator:SetHealth(activator:MaxHealthCan())

            -- Giving Weapon

            activator:Give("tfcss_mp5_alt")
        end)
    end

    if activator:Team() == TEAM_OTA2 then
        activator:SetPos(table.Random({[1] = Vector(6199.920410, -2734.388428, 2309.907959), [2] = Vector(5720.033691, -2744.647949, 2419.116699)}))
        activator:SetEyeAngles(Angle(14.651999, 90.851746, 0.000000))
        activator:Freeze(true)
        activator:SetNoDraw(true)
        activator:Flashlight(false)
        timer.Simple(1, function()
            activator:EmitSound("ambient/energy/weld1.wav", 75, 100)
        end)
        timer.Simple(3, function()
            activator:EmitSound("ambient/energy/zap8.wav", 75, 100)
        end)
        timer.Simple(4.5, function()
            activator:EmitSound("ambient/energy/zap9.wav", 75, 100)
        end)
        timer.Simple(math.random(5,8), function()
            activator:Spawn()
            activator:SetModel("models/player/combine_soldier_prisonguard.mdl")
            activator:Freeze(false)
            activator:SetNoDraw(false)
            activator:SetArmor(activator:MaxArmorCan())
            activator:SetHealth(activator:MaxHealthCan())
            
            -- Giving Weapon

            activator:Give("tfcss_m4a1_alt")
            activator:Give("weapon_cuff_rope")
        end)
    end
end