AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )
if ( !tr.Hit ) then return end

local SpawnPos = tr.HitPose + tr.HitNormal * 6
self.Spawn_angles = ply:GetAngles()
self.Spawn_angles.pitch = 0
self.Spawn_angles.roll = 0
self.Spawn_angles.yaw = self.Spawn_angles.yaw + 180

local ent = ents.Create( "npc_male_1_marcus" )
ent:SetKeyValue( "disableshadows", "1" )
ent:SetPos( SpawnPos )
ent:SetAngles( self.Spawn_angles )
ent:Spawn()
ent:Activate()

return ent
end

function ENT:Initialize()
self:SetModel("models/props_lab/huladoll.mdl")
self:SetNoDraw(true)
self:DrawShadow(false)
self:SetCollisionGroup(COLLISION_GROUP_NONE)
self:SetName(self.PrintName)
self:SetOwner(self.Owner)
self:DropToFloor()
	
Weapon1 = "weapon_smg1"
Weapon2 = "weapon_ar2"
Weapon3 = "weapon_shotgun"
Weapon4 = "weapon_smg1"
	
local Weapon = {}
	Weapon[1] = (Weapon1)
	Weapon[2] = (Weapon2)
	Weapon[3] = (Weapon3)
	Weapon[4] = (Weapon4)
	
	
TacoNBananaMale1 = "models/tnb/citizens/male_01.mdl"
TacoNBananaMale2 = "models/tnb/citizens/male_02.mdl"
TacoNBananaMale3 = "models/tnb/citizens/male_03.mdl"
TacoNBananaMale4 = "models/tnb/citizens/male_04.mdl"
TacoNBananaMale5 = "models/tnb/citizens/male_05.mdl"
TacoNBananaMale6 = "models/tnb/citizens/male_06.mdl"
TacoNBananaMale7 = "models/tnb/citizens/male_07.mdl"
TacoNBananaMale8 = "models/tnb/citizens/male_08.mdl"
TacoNBananaMale9 = "models/tnb/citizens/male_09.mdl"
TacoNBananaMale10 = "models/tnb/citizens/male_10.mdl"
TacoNBananaMale11 = "models/tnb/citizens/male_11.mdl"
TacoNBananaMale12 = "models/tnb/citizens/male_12.mdl"
TacoNBananaMale13 = "models/tnb/citizens/male_13.mdl"
TacoNBananaMale14 = "models/tnb/citizens/male_14.mdl"
TacoNBananaMale15 = "models/tnb/citizens/male_15.mdl"
TacoNBananaMale16 = "models/tnb/citizens/male_16.mdl"
TacoNBananaMale17 = "models/tnb/citizens/male_17.mdl"
TacoNBananaMale18 = "models/tnb/citizens/male_18.mdl"

local TacoNBananaMale = {}
	TacoNBananaMale[1] = (TacoNBananaMale1)
	TacoNBananaMale[2] = (TacoNBananaMale2)
	TacoNBananaMale[3] = (TacoNBananaMale3)
	TacoNBananaMale[4] = (TacoNBananaMale4)
	TacoNBananaMale[5] = (TacoNBananaMale5)
	TacoNBananaMale[6] = (TacoNBananaMale6)
	TacoNBananaMale[7] = (TacoNBananaMale7)
	TacoNBananaMale[8] = (TacoNBananaMale8)
	TacoNBananaMale[9] = (TacoNBananaMale9)
	TacoNBananaMale[10] = (TacoNBananaMale10)
	TacoNBananaMale[11] = (TacoNBananaMale11)
	TacoNBananaMale[12] = (TacoNBananaMale12)
	TacoNBananaMale[13] = (TacoNBananaMale13)
	TacoNBananaMale[14] = (TacoNBananaMale14)
	TacoNBananaMale[15] = (TacoNBananaMale15)
	TacoNBananaMale[16] = (TacoNBananaMale16)
	TacoNBananaMale[17] = (TacoNBananaMale17)
	TacoNBananaMale[18] = (TacoNBananaMale18)

self.npc = ents.Create( "npc_citizen" )
self.npc:SetPos(self:GetPos())
self.npc:SetAngles(self:GetAngles())
self.npc:SetKeyValue( "spawnflags", "256" )

self.npc:SetKeyValue( "additionalequipment", GetConVarString("gmod_npcweapon") )
if GetConVarString("gmod_npcweapon") == "" then
self.npc:SetKeyValue( "additionalequipment", Weapon[math.random(1,4)] )
end
self.npc:SetSpawnEffect(false)
self.npc:Spawn()
self.npc:Activate()
self:SetParent(self.npc)
self.npc:SetNWFloat("ThrowDelay", 10)
self.npc:SetNWFloat("ThrowingSpeed", 5)
self.npc:SetBloodColor(0)
self.npc:CapabilitiesAdd(CAP_AIM_GUN)
self.npc:CapabilitiesAdd(CAP_AUTO_DOORS)
self.npc:CapabilitiesAdd(CAP_DUCK)
self.npc:CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE)
self.npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
self.npc:CapabilitiesAdd(CAP_OPEN_DOORS)
self.npc:CapabilitiesAdd(CAP_SQUAD)
self.npc:CapabilitiesAdd(CAP_USE)
if IsValid(self.npc) and IsValid(self) then self.npc:DeleteOnRemove(self) end
self:DeleteOnRemove(self.npc)
if( IsValid(self.npc))then

local min,max = self.npc:GetCollisionBounds()
local hull = self.npc:GetHullType()
self.npc:SetModel(TacoNBananaMale[math.random(1,18)])
self.npc:SetSolid(SOLID_BBOX)
self.npc:SetPos(self.npc:GetPos()+self.npc:GetUp()*16)
self.npc:SetHullType(hull)
self.npc:SetHullSizeNormal()
self.npc:SetCollisionBounds(min,max)
self.npc:DropToFloor()
self.npc:SetModelScale(1)
if self.npc:GetModel() == "models/tnb/citizens/male_12.mdl" then
self.npc:SetSkin(0)
end
if self.npc:GetModel() == "models/tnb/citizens/male_13.mdl" or self.npc:GetModel() == "models/tnb/citizens/male_16.mdl" then
self.npc:SetSkin(math.random(0,2))
end
if self.npc:GetModel() ~= "models/tnb/citizens/male_12.mdl" and self.npc:GetModel() ~= "models/tnb/citizens/male_13.mdl" and self.npc:GetModel() ~= "models/tnb/citizens/male_16.mdl" then
self.npc:SetSkin(math.random(0,3))
end
self.npc:SetBodygroup( 1, math.random(0,16))
self.npc:SetBodygroup( 2, math.random(0,6))
self.npc:SetBodygroup( 3, math.random(0,1))
self.npc:SetBodygroup( 4, math.random(0,4))
if self.npc:GetBodygroup(1) == 10 or self.npc:GetBodygroup(1) == 11 then
self.npc:Fire( "SetMedicOn" )
self.npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_AVERAGE)
self.npc:SetHealth(45)
self.npc:SetMaxHealth(45)
self.npc:SetNWFloat( "GrenadeCount", 1 )
end
if self.npc:GetBodygroup(1) == 0 or self.npc:GetBodygroup(1) == 1 or self.npc:GetBodygroup(1) == 16 or self.npc:GetBodygroup(1) == 6 or self.npc:GetBodygroup(1) == 7 or self.npc:GetBodygroup(1) == 3 or self.npc:GetBodygroup(1) == 4 then
self.npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_POOR )
self.npc:SetHealth(40)
self.npc:SetMaxHealth(40)
elseif self.npc:GetBodygroup(1) == 8 or self.npc:GetBodygroup(1) == 9 or self.npc:GetBodygroup(1) == 14 then
self.npc:SetHealth(60)
self.npc:SetMaxHealth(60)
self.npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_GOOD )
self.npc:SetNWFloat( "GrenadeCount", 2 )
elseif self.npc:GetBodygroup(1) == 12 then
self.npc:SetHealth(50)
self.npc:SetMaxHealth(50)
self.npc:Fire("SetAmmoResupplierOn")
self.npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
self.npc:SetNWFloat( "GrenadeCount", 1 )
elseif self.npc:GetBodygroup(1) == 15 or self.npc:GetBodygroup(1) == 13 then
self.npc:SetHealth(80)
self.npc:SetMaxHealth(80)
self.npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_GOOD )
self.npc:SetNWFloat( "GrenadeCount", 4 )
self.npc:SetNWFloat( "NumberOfMines", 3 )
self.npc:SetNWFloat( "DropDelay", 2 )
self.npc:SetNWFloat( "DeploySpeed", 3.5 )
end
end
end


hook.Add("Think", "ThrowingGrenade", function()
for _, npc in pairs( ents.GetAll() ) do
if npc:IsNPC() then
local Pos = npc:GetPos()
if IsValid(npc:GetEnemy()) and npc:Visible(npc:GetEnemy()) and npc:GetPos():Distance(npc:GetEnemy():GetPos()) > 150 and npc:GetPos():Distance(npc:GetEnemy():GetPos()) <= 1500 and CantThrowHere(Pos) and npc:GetNWFloat("GrenadeCount") > 0 then
if (npc:GetNWFloat("ThrowDelay") > CurTime()) then return false end
npc:SetNWFloat("ThrowDelay", CurTime() + npc:GetNWFloat("ThrowingSpeed"))
if math.random(1,3) != 2 then return end
npc:SetNWFloat("ThrowDelay", CurTime() + npc:GetNWFloat("ThrowingSpeed") + npc:GetNWFloat("ThrowingSpeed")*0.5)
GrenadeThrow(npc, npc:GetEnemy(), "throw1")
npc:SetTarget(npc:GetEnemy())
if IsValid(npc:GetTarget()) and !npc:IsCurrentSchedule(SCHED_TARGET_FACE) then
npc:SetSchedule(SCHED_TARGET_FACE)
end
end
end
end
end)

function CantThrowHere(Pos)
local tracedata_up = {}
tracedata_up.start = Pos
tracedata_up.endpos = Pos + Vector(0,0,999999)
tracedata_up.mask = MASK_SOLID_BRUSHONLY + MASK_WATER 
local trace_up = util.TraceLine(tracedata_up)	--Can the entity see the sky?
if trace_up.HitSky then
local Pos_up = trace_up.HitPos
local tracedata_down = {}
tracedata_down.start = Pos_up
tracedata_down.endpos = Pos
tracedata_down.mask = MASK_SOLID_BRUSHONLY + MASK_WATER 
local trace_down = util.TraceLine(tracedata_down) -- Can the sky see the entity? (excludes entities that are below displacements or inside brushes)		
if !trace_down.Hit then
return true
end		
return false
end
return false
end

function GrenadeThrow(npc, npcenemy, name)
if npc:GetPos():Distance(npc:GetEnemy():GetPos()) < 150 then return end
if npc:GetPos():Distance(npc:GetEnemy():GetPos()) > 1500 then return end
npc:RestartGesture(npc:GetSequenceInfo(npc:LookupSequence(name)).activity)
npc:SetNWBool("PlayAnim", true)
local time = npc:SequenceDuration()
timer.Create("ThrowGrenade"..npc:EntIndex(),0.8,1,function()
if IsValid(npc) then
npc:SetNWBool("PlayAnim", false)
end
if !IsValid(npc) or !IsValid(npcenemy) then return end

local shoot_angle = Vector(0,0,0)
local Dist=(npcenemy:GetPos()-npc:GetPos()):Length() 
if npc:IsNPC() then
if npcenemy != NULL and npcenemy != nil then
shoot_angle = npcenemy:GetPos() - npc:GetPos()
shoot_angle = shoot_angle + Vector(math.random(-30,30),math.random(-30,30),85)*(shoot_angle:Distance(Vector(0,0,0))/math.random(1800,1000))
shoot_angle:Normalize()
else
return
end
end
local shoot_pos = npc:GetShootPos() + npc:GetRight() * 0 + npc:GetUp() * -10 + shoot_angle * 30
local grenade = ents.Create( "npc_grenade_frag" )
local bone = npc:LookupBone("ValveBiped.Bip01_R_Hand")
local pos, ang = npc:GetBonePosition(bone)
if (IsValid(grenade)) then	
grenade:SetPos(pos + ang:Right() + ang:Forward() + ang:Up())
grenade:SetAngles(shoot_angle:Angle())
grenade:SetOwner(npc)
grenade:Spawn()
grenade:Activate()
grenade:Fire("SetTimer", "3", 0)
npc:SetNWFloat("GrenadeCount", npc:GetNWFloat("GrenadeCount") - 1)
local phys = grenade:GetPhysicsObject()
if IsValid(phys) then
phys:SetVelocity( (npc:GetAimVector() * Dist*0.88) )
phys:AddAngleVelocity(Vector(math.random(-800,800),math.random(-800,800),math.random(-800,800)))
end
end

end)
if(stationary)then
npc:StopMoving()
timer.Create("PlayThrowAnim"..npc:EntIndex(),.1,math.Round(1*10),function()
if IsValid(npc) and IsValid(npcenemy) then
npc:StopMoving()
npc:SetTarget(npcenemy)
if IsValid(npc:GetTarget()) and !npc:IsCurrentSchedule(SCHED_TARGET_FACE) then
npc:SetSchedule(SCHED_TARGET_FACE)
end
end
end)
end
end

hook.Add("EntityTakeDamage", "Turretdamage", function(ent, dmginfo)
local attacker = dmginfo:GetAttacker()
local entity = dmginfo:GetInflictor()
if attacker:GetClass() == "npc_grenade_frag" and IsValid(attacker:GetOwner()) then
dmginfo:SetAttacker(attacker:GetOwner())
end
if attacker:GetClass() == "npc_grenade_frag" and IsValid(attacker:GetOwner()) and (attacker:GetOwner():Disposition(ent) == D_LI or attacker:GetOwner():Disposition(ent) == D_NU) then
dmginfo:ScaleDamage(0)
end
end)

function ENT:MeleeAttacks(npc)
if IsValid(npc) then
local enemy = npc:GetEnemy()
local anim = npc:GetSequenceName(self.npc:GetSequence())
local act = npc:GetActivity()

if IsValid(enemy) and npc:Visible(enemy) and enemy:GetPos():Distance(npc:GetPos()) <= 50 then
if (!IsValid(npc)) or (!IsValid(enemy)) then return end
if IsValid(enemy) and enemy:GetPos():Distance(npc:GetPos()) > 50 then return end
if (npc:GetNWFloat("HL2S_MeleeAttack") > CurTime()) then return false end

self:ActNPC(npc, "swing", false, true, nil, nil, nil )
local pos = npc:GetShootPos()
local ang = npc:GetAimVector()
local damagedice = (5)
local primdamage = (1)
local pain = primdamage * damagedice

local slash = {}
slash.start = pos
slash.endpos = pos+(ang*50)
slash.filter = npc
slash.mins = Vector(5,5,1)
slash.maxs = Vector(50,50,50)
local slashtrace = util.TraceHull(slash)
if slashtrace.Hit then
local targ = slashtrace.Entity
if npc:Disposition(targ) == D_LI or npc:Disposition(targ) == D_NU then return end
local paininfo = DamageInfo()
paininfo:SetDamage(pain)
paininfo:SetDamageType(DMG_CLUB)
paininfo:SetAttacker(npc)
if IsValid(npc:GetActiveWeapon()) then
paininfo:SetInflictor(npc:GetActiveWeapon())
else
paininfo:SetInflictor(npc)
end
local RandomForce = math.random(100,200)
paininfo:SetDamageForce(slashtrace.Normal * RandomForce)
targ:SetVelocity(npc:GetForward()*500+npc:GetUp()*150)
if targ:IsNPC() then
targ:StopMoving()
end
if targ:IsPlayer() then
targ:ViewPunch(Angle(-20,math.random(-50,50),math.random(-15,15)))
end
if targ:IsPlayer() or targ:IsNPC() then
local blood = targ:GetBloodColor()	
local fleshimpact = EffectData()
fleshimpact:SetEntity(self.Weapon)
fleshimpact:SetOrigin(slashtrace.HitPos)
fleshimpact:SetNormal(slashtrace.HitPos)
if blood >= 0 then
fleshimpact:SetColor(blood)
util.Effect("BloodImpact", fleshimpact)
end
end
targ:TakeDamageInfo(paininfo)
else
end
npc:SetNWFloat("HL2S_MeleeAttack", CurTime() + 1)
end
end
end

function ENT:Think()
if IsValid(self) and IsValid(self.npc) then
local npc = self.npc
local enemy = self.npc:GetEnemy()
local anim = self.npc:GetSequenceName(self.npc:GetSequence())
local act = self.npc:GetActivity()

self:MeleeAttacks(npc)
self:IsAmmoSupplier(npc)
self:StopFollowingPlayerIfBeingCommanded(npc)
self:DoISeeAnEnemyOrNot(npc)
self:AmIscared(npc)
self:IFScaredDropWeapon(npc)
self:DeployMine(npc)
self:DropGrenadesOnDeath(npc)

end
end

function ENT:StopFollowingPlayerIfBeingCommanded(npc)
local npc = self.npc
if GetConVarNumber( "npc_citizen_auto_player_squad") == 1 and GetConVarNumber("ai_ignoreplayers") == 1 then
npc:Fire( "RemoveFromPlayerSquad" )
end
if GetConVarNumber( "npc_citizen_auto_player_squad" ) == 0 and ( GetConVarNumber( "ai_ignoreplayers" ) == 0 or GetConVarNumber( "ai_ignoreplayers" ) == 1 ) then
npc:Fire( "RemoveFromPlayerSquad" )
end
end

function ENT:DoISeeAnEnemyOrNot(npc)
local npc = self.npc
if IsValid(npc:GetEnemy()) and npc:GetEnemy() then
self.Enemy = true
else
self.Enemy = false
end
if (GetConVarNumber( "npc_citizen_auto_player_squad" ) == 0 or GetConVarNumber( "ai_ignoreplayers" ) == 1) and self.Enemy == false and !npc:IsCurrentSchedule( SCHED_IDLE_WANDER ) then
npc:SetSchedule( SCHED_IDLE_WANDER )
end
end

function ENT:IsAmmoSupplier(npc)
local npc = self.npc
if IsValid(npc) then
if GetConVarNumber( "ai_ignoreplayers" ) == 1 then return end
if math.random(1,5) == 1 then
npc:SetKeyValue("ammosupply","Pistol")
npc:SetKeyValue("ammoamount","18")
elseif math.random(1,5) == 2 then
npc:SetKeyValue("ammosupply","SMG1")
npc:SetKeyValue("ammoamount","45")
elseif math.random(1,5) == 3 then
npc:SetKeyValue("ammosupply","SMG1_Grenade")
npc:SetKeyValue("ammoamount","1")
elseif math.random(1,5) == 4 then
npc:SetKeyValue("ammosupply","AR2")
npc:SetKeyValue("ammoamount","30")
else 
npc:SetKeyValue("ammosupply","Buckshot")
npc:SetKeyValue("ammoamount","6")
end
end
end

function ENT:DeployMine(npc)
local npc = self.npc
if GetConVarNumber( "ai_disabled" ) == 1 then return false end
if math.random(1,37) == 37 and self.Enemy == false then
if npc:GetNWFloat("NumberOfMines") > 0 then
if (npc:GetNWFloat("DropDelay") > CurTime()) then return false end
npc:SetNWFloat("DropDelay", CurTime() + npc:GetNWFloat("DeploySpeed"))
self:ActNPC(npc, "Stand_to_crouch", false, true, nil, nil, nil )
local mine = ents.Create( "combine_mine" )
mine:SetPos( npc:GetPos() + npc:GetForward()*20 )
mine:SetKeyValue( "Modification", "1" )
mine:SetSkin( math.random(1,2))
mine:SetAngles( npc:GetAngles())
mine:Spawn()
mine:Activate()
npc:SetNWFloat("NumberOfMines", npc:GetNWFloat("NumberOfMines") - 1)
end
end
end

function ENT:AmIscared(npc)
local npc = self.npc
if npc:Health() < 10 and self.Enemy == true then
self.Iamscared = true 
end
if npc:Health() < 10 and self.Enemy == false then
self.Iamscared = false
end
if npc:Health() >= 10 then
self.Iamscared = false
end
end

function ENT:IFScaredDropWeapon(npc)
if npc:GetActiveWeapon() == NULL then return end
local NPCWeapon = npc:GetActiveWeapon():GetModel()
local NPCWeaponClass = npc:GetActiveWeapon():GetClass()
if self.Iamscared == true and math.random(1,10) == 2 and (npc:GetBodygroup(1) == 4 or npc:GetBodygroup(1) == 5 or npc:GetBodygroup(1) == 5 ) then
if NPCWeaponClass == "weapon_pistol" then
self.droppistol = ents.Create( "weapon_pistol" )
self.droppistol:SetModel( NPCWeapon )
self.droppistol:SetPos( npc:GetPos() )
self.droppistol:SetNotSolid(false)
self.droppistol:SetNoDraw(false)
self.droppistol:Spawn()
self.droppistol:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_357" then
self.drop357 = ents.Create( "weapon_357" )
self.drop357:SetModel( NPCWeapon )
self.drop357:SetPos( npc:GetPos() )
self.drop357:SetNotSolid(false)
self.drop357:SetNoDraw(false)
self.drop357:Spawn()
self.drop357:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_smg1" then
self.dropsmg = ents.Create( "weapon_smg1" )
self.dropsmg:SetModel( NPCWeapon )
self.dropsmg:SetPos( npc:GetPos() )
self.dropsmg:SetNotSolid(false)
self.dropsmg:SetNoDraw(false)
self.dropsmg:Spawn()
self.dropsmg:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_shotgun" then
self.dropshotgun = ents.Create( "weapon_shotgun" )
self.dropshotgun:SetModel( NPCWeapon )
self.dropshotgun:SetPos( npc:GetPos() )
self.dropshotgun:SetNotSolid(false)
self.dropshotgun:SetNoDraw(false)
self.dropshotgun:Spawn()
self.dropshotgun:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_ar2" then
self.dropar2 = ents.Create( "weapon_ar2" )
self.dropar2:SetModel( NPCWeapon )
self.dropar2:SetPos( npc:GetPos() )
self.dropar2:SetNotSolid(false)
self.dropar2:SetNoDraw(false)
self.dropar2:Spawn()
self.dropar2:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_crossbow" then
self.dropcrossbow = ents.Create( "weapon_crossbow" )
self.dropcrossbow:SetModel( NPCWeapon )
self.dropcrossbow:SetPos( npc:GetPos() )
self.dropcrossbow:SetNotSolid(false)
self.dropcrossbow:SetNoDraw(false)
self.dropcrossbow:Spawn()
self.dropcrossbow:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_rpg" then
self.dropRPG = ents.Create( "weapon_rpg" )
self.dropRPG:SetModel( NPCWeapon )
self.dropRPG:SetPos( npc:GetPos() )
self.dropRPG:SetNotSolid(false)
self.dropRPG:SetNoDraw(false)
self.dropRPG:Spawn()
self.dropRPG:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_crowbar" then
self.dropcrowbar = ents.Create( "weapon_crowbar" )
self.dropcrowbar:SetModel( NPCWeapon )
self.dropcrowbar:SetPos( npc:GetPos() )
self.dropcrowbar:SetNotSolid(false)
self.dropcrowbar:SetNoDraw(false)
self.dropcrowbar:Spawn()
self.dropcrowbar:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass == "weapon_stunstick" then
self.dropstunstick = ents.Create( "weapon_stunstick" )
self.dropstunstick:SetModel( NPCWeapon )
self.dropstunstick:SetPos( npc:GetPos() )
self.dropstunstick:SetNotSolid(false)
self.dropstunstick:SetNoDraw(false)
self.dropstunstick:Spawn()
self.dropstunstick:Activate()
npc:GetActiveWeapon():Remove()
end
if NPCWeaponClass ~= "weapon_crossbow" and NPCWeaponClass ~= "weapon_ar2" and NPCWeaponClass ~= "weapon_pistol" and NPCWeaponClass ~= "weapon_shotgun" and NPCWeaponClass ~= "weapon_smg1" and NPCWeaponClass ~= "weapon_crowbar" and NPCWeaponClass ~= "weapon_stunstick" and NPCWeaponClass ~= "weapon_357" and NPCWeaponClass ~= "weapon_rpg" then
self.dropcustomnpcweapon = ents.Create( "prop_physics")
self.dropcustomnpcweapon:SetModel( NPCWeapon )
self.dropcustomnpcweapon:SetPos( npc:GetPos() )
self.dropcustomnpcweapon:SetNotSolid(false)
self.dropcustomnpcweapon:SetNoDraw(false)
self.dropcustomnpcweapon:Spawn()
self.dropcustomnpcweapon:Activate()
npc:GetActiveWeapon():Remove()
end
end
end

function ENT:DropGrenadesOnDeath(npc)
local npc = self.npc
if ( npc:Health() <= 0 or npc:Health() == 0 ) and npc:GetNWFloat( "GrenadeCount" ) > 0 then
if npc:GetNWFloat( "GrenadeCount") == 1 then
grenade1 = ents.Create( "weapon_frag" )
grenade1:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade1:SetNotSolid(false)
grenade1:SetNoDraw(false)
grenade1:Spawn()
grenade1:Activate()
end
if npc:GetNWFloat( "GrenadeCount" ) == 2 then
grenade2 = ents.Create( "weapon_frag" )
grenade2:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade2:SetNotSolid(false)
grenade2:SetNoDraw(false)
grenade2:Spawn()
grenade2:Activate()
grenade3 = ents.Create( "weapon_frag" )
grenade3:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade3:SetNotSolid(false)
grenade3:SetNoDraw(false)
grenade3:Spawn()
grenade3:Activate()
end
if npc:GetNWFloat( "GrenadeCount" ) == 3 then
grenade4 = ents.Create( "weapon_frag" )
grenade4:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade4:SetNotSolid(false)
grenade4:SetNoDraw(false)
grenade4:Spawn()
grenade4:Activate()
grenade5 = ents.Create( "weapon_frag" )
grenade5:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade5:SetNotSolid(false)
grenade5:SetNoDraw(false)
grenade5:Spawn()
grenade5:Activate()
grenade6 = ents.Create( "weapon_frag" )
grenade6:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade6:SetNotSolid(false)
grenade6:SetNoDraw(false)
grenade6:Spawn()
grenade6:Activate()
end
if npc:GetNWFloat( "GrenadeCount" ) == 4 then
grenade7 = ents.Create( "weapon_frag" )
grenade7:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade7:SetNotSolid(false)
grenade7:SetNoDraw(false)
grenade7:Spawn()
grenade7:Activate()
grenade8 = ents.Create( "weapon_frag" )
grenade8:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade8:SetNotSolid(false)
grenade8:SetNoDraw(false)
grenade8:Spawn()
grenade8:Activate()
grenade9 = ents.Create( "weapon_frag" )
grenade9:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade9:SetNotSolid(false)
grenade9:SetNoDraw(false)
grenade9:Spawn()
grenade9:Activate()
grenade10 = ents.Create( "weapon_frag" )
grenade10:SetPos( npc:GetPos() + npc:GetForward()*2.5 )
grenade10:SetNotSolid(false)
grenade10:SetNoDraw(false)
grenade10:Spawn()
grenade10:Activate()
end
end
end

function ENT:ActNPC(npc, name, override, stationary, time, kill, killer, killerwep, faceent, sound1, sound2, sound3)
if(!IsValid(npc))or(IsValid(npc) and npc:GetNWBool("ActSequencePlay") and !override)then return end
if npc.ActDelay==nil then npc.ActDelay=0 end
local seq, dur = npc:LookupSequence(name)
if time==nil or time<=0 then time=dur end
if (npc.ActDelay > CurTime()) then return false end
npc.ActDelay = CurTime() + dur
local act=npc:GetSequenceInfo(seq).activity
npc:RestartGesture(act)
if(sound1)then npc:EmitSound(sound1) end
if(sound2)then npc:EmitSound(sound2) end
if(sound3)then npc:EmitSound(sound3) end
timer.Simple(dur,function()
if IsValid(npc) and kill then
npc:SetHealth(1)
npc:TakeDamage(npc:Health(),killer,killerwep)
end
end)
if(stationary)then
npc:StopMoving()
npc:SetNWBool("ActSequencePlay", true)
npc:ClearCondition(68)
npc:SetCondition(67)
timer.Create("ActSequenceFaceTarget"..npc:EntIndex(),0.1,math.Round(time*10),function()
if(IsValid(npc))and(IsValid(faceent))then
local ang = (faceent:GetPos()-npc:GetPos()):Angle()
local ang2 = npc:GetAngles()
npc:SetAngles(Angle(ang2.p,ang.y,ang2.r))
end
end)
timer.Create("ActSequenceForceStop"..npc:EntIndex(),0.1,math.Round(time*10),function()
if(IsValid(npc))then
npc:StopMoving()
end
end)
timer.Create("ActSequenceForceMove"..npc:EntIndex(),time,1,function()
if(IsValid(npc))then
npc:SetNWBool("ActSequencePlay", false)
npc:ClearCondition(67)
npc:SetCondition(68)
end
end)
end
end

function ENT:OnRemove()
if IsValid(self.npc) then
self.npc:Remove()
end
end