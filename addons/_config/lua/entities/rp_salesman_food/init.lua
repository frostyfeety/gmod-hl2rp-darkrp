AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("rp_salesman_food")
util.AddNetworkString("rp_buyfirst")
util.AddNetworkString("rp_buysecond")
util.AddNetworkString("rp_buythird")

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/Male_04.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
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
    activator.TalkCD = CurTime() + 5

	self:EmitSound("vo/npc/male01/answer0"..math.random(1,9)..".wav", 70, 100)

	net.Start("rp_salesman_food")
	net.Send(activator)
end

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("rp_salesman_food")
	entity:SetPos(Vector(201.728683, -1367.990723, 144.031250))
	entity:SetAngles(Angle(0.488176, 90.275421, 0.000000))
	entity:Spawn()
	entity:Activate()

	return entity
end

function ENT:Think()
	for k, v in ipairs(player.GetAll()) do
		if v:Team() == TEAM_CWU4 then
			self:Remove()
		end
	end

	self:NextThink( CurTime() + 60 )
	return true
end

net.Receive( "rp_buyfirst", function( len, ply )
	local weapon = "rp_popcorn"
	local test = net.ReadString()
	if ply:canAfford(test) && !ply:HasWeapon( weapon ) then
		ply:addMoney(-test)
		ply:Give(weapon)
	else
		DarkRP.notify(ply, 1, 3, "У вас не хватает денег на это или у вас это уже есть.")
	end
end)

net.Receive( "rp_buysecond", function( len, ply )
	local weapon = "rp_coko"
	local test = net.ReadString()
	if ply:canAfford(test) && !ply:HasWeapon( weapon ) then
		ply:addMoney(-test)
		ply:Give(weapon)
	else
		DarkRP.notify(ply, 1, 3, "У вас не хватает денег на это или у вас это уже есть.")
	end
end)

net.Receive( "rp_buythird", function( len, ply )
	local weapon = "rp_choco"
	local test = net.ReadString()
	if ply:canAfford(test) && !ply:HasWeapon( weapon ) then
		ply:addMoney(-test)
		ply:Give(weapon)
	else
		DarkRP.notify(ply, 1, 3, "У вас не хватает денег на это или у вас это уже есть.")
	end
end)
