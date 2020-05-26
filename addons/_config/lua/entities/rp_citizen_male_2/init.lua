AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/Female_02.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHullSizeNormal()
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
end

function ENT:Use(activator)
    if (activator.TalkCD or 0) > CurTime() then
        return 
    end
	if activator:IsCombine() then return end
    activator.TalkCD = CurTime() + 5

	self:EmitSound("vo/npc/female01/answer0"..math.random(1,9)..".wav", 70, 100)
	activator:SendLua('local phrases = {"Попей воды", "Жажда приходит раньше"} chat.AddText(Color(155,155,155), "Анна: ", Color(255,255,255), phrases[math.random(1,#phrases)] )')
end