AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )
if ( !tr.Hit ) then return end

local SpawnPos = tr.HitPose + tr.HitNormal * 6
self.Spawn_angles = ply:GetAngles()
self.Spawn_angles.pitch = 0
self.Spawn_angles.roll = 0
self.Spawn_angles.yaw = self.Spawn_angles.yaw + 180

local ent = ents.Create( "npc_tnb_metrocop_captain" )
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

self.npc = ents.Create( "npc_metropolice" )
self.npc:SetPos(self:GetPos())
self.npc:SetAngles(self:GetAngles())

Weapon1 = "weapon_stunstick"
Weapon2 = "weapon_smg1"
Weapon3 = "weapon_pistol"
Weapon4 = "weapon_smg1"
Weapon5 = "weapon_pistol"

local Weapon = {}
	Weapon[1] = (Weapon1)
	Weapon[2] = (Weapon2)
	Weapon[3] = (Weapon3)
	Weapon[4] = (Weapon4)
	Weapon[5] = (Weapon5)
	
	self.npc:SetKeyValue( "additionalequipment", GetConVarString("gmod_npcweapon") )
if GetConVarString("gmod_npcweapon") == "" then
self.npc:SetKeyValue( "additionalequipment", Weapon[math.random(1,5)] )
end
self.npc:SetSpawnEffect(false)
self.npc:Spawn()
self.npc:Activate()
self:SetParent(self.npc)
self.npc:SetHealth(80)
self.npc:SetMaxHealth(80)
self.npc:SetBloodColor(0)
if self.npc:GetActiveWeapon() == NULL or self.npc:GetActiveWeapon():GetClass() == "weapon_crowbar" or self.npc:GetActiveWeapon():GetClass() == "weapon_stunstick" then
self.npc.Commandable = false
else
self.npc.Commandable = true
end
self.npc.Commander = false
self.npc.Iambeingcommanded = false
self.npc.IHaveaCommander = false
self.npc:SetNWFloat("ThrowDelay", 10)
self.npc:SetNWFloat("ThrowingSpeed", 5)
self.npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
self.npc:CapabilitiesAdd(CAP_USE)
self.npc:CapabilitiesAdd(CAP_AUTO_DOORS)
self.npc:CapabilitiesAdd(CAP_OPEN_DOORS)
self.npc:CapabilitiesAdd(CAP_FRIENDLY_DMG_IMMUNE)
self.npc:CapabilitiesAdd(CAP_DUCK)
self.npc:CapabilitiesAdd(CAP_SQUAD)
if IsValid(self.npc) and IsValid(self) then self.npc:DeleteOnRemove(self) end
self:DeleteOnRemove(self.npc)
if( IsValid(self.npc))then

local min,max = self.npc:GetCollisionBounds()
local hull = self.npc:GetHullType()
self.npc:SetModel("models/tnb/combine/metrocop.mdl")
self.npc:SetSolid(SOLID_BBOX)
self.npc:SetPos(self.npc:GetPos()+self.npc:GetUp()*16)
self.npc:SetHullType(hull)
self.npc:SetHullSizeNormal()
self.npc:SetCollisionBounds(min,max)
self.npc:DropToFloor()
self.npc:SetModelScale(1)
self.npc:SetSkin( 5 )
self.npc:SetBodygroup( 1, math.random(0,1))
self.npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
self.npc:SetNWFloat("GrenadeCount", 3)
end
end

hook.Add("Think", "ThrowingGrenade", function()
for _, npc in pairs( ents.GetAll() ) do
if npc:IsNPC() then
local Pos = npc:GetPos()
if IsValid(npc:GetEnemy()) and npc:Visible(npc:GetEnemy()) and npc:GetPos():Distance(npc:GetEnemy():GetPos()) > 150 and npc:GetPos():Distance(npc:GetEnemy():GetPos()) <= 1500 and CantThrowHere(Pos) and npc:GetNWFloat("GrenadeCount") > 0 then
if (npc:GetNWFloat("ThrowDelay") > CurTime()) then return false end
if npc:GetActiveWeapon() == NULL then return false end
if npc:GetActiveWeapon():GetClass() == "weapon_stunstick" or npc:GetActiveWeapon():GetClass() == "weapon_crowbar" then return false end
npc:SetNWFloat("ThrowDelay", CurTime() + npc:GetNWFloat("ThrowingSpeed"))
if math.random(1,3) != 2 then return end
npc:SetNWFloat("ThrowDelay", CurTime() + npc:GetNWFloat("ThrowingSpeed") + npc:GetNWFloat("ThrowingSpeed")*0.5)
GrenadeThrow(npc, npc:GetEnemy(), "grenadethrow")
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
local shoot_pos = npc:GetShootPos() + npc:GetRight() * -5 + npc:GetUp() * 50
local grenade = ents.Create( "npc_grenade_frag" )
local bone = npc:LookupBone("ValveBiped.Bip01_L_Hand")
local pos, ang = npc:GetBonePosition(bone)
if (IsValid(grenade)) then	
grenade:SetPos(pos + ang:Right() + ang:Forward() + ang:Up())
grenade:SetAngles(shoot_angle:Angle())
grenade:SetOwner(npc)
grenade:Spawn()
grenade:Activate()
grenade:Fire("SetTimer", "4", 0)
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

hook.Add("EntityTakeDamage", "GreandeDMG", function(ent, dmginfo)
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
if (npc:GetNWFloat("CSO2_MeleeAttack") > CurTime()) then return false end
if npc:GetActiveWeapon() == NULL then return end
if npc:GetActiveWeapon():GetClass() == "weapon_stunstick" or npc:GetActiveWeapon():GetClass() == "weapon_crowbar" then return end
if math.random(1,6) == 1 then
self:ActNPC(npc, "pushplayer", false, true, nil, nil, nil )
elseif math.random(1,6) == 2 then
self:ActNPC(npc, "thrust", false, true, nil, nil, nil )
elseif math.random(1,6) == 3 then
self:ActNPC(npc, "thrust", false, true, nil, nil, nil )
elseif math.random(1,6) == 4 then
self:ActNPC(npc, "lugaggepush", false, true, nil, nil, nil )
elseif math.random(1,6) == 5 then
self:ActNPC(npc, "pushplayer", false, true, nil, nil, nil )
else
self:ActNPC(npc, "swing", false, true, nil, nil, nil )
local pos = npc:GetShootPos()
local ang = npc:GetAimVector()
local damagedice = (math.random(5,9))
local primdamage = (1)
local pain = primdamage * damagedice

local slash = {}
slash.start = pos
slash.endpos = pos+(ang*50)
slash.filter = npc
slash.mins = Vector(1,1,1)
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
npc:SetNWFloat("CSO2_MeleeAttack", CurTime() + 1)
end
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
self:DoISeeAnEnemyOrNot(npc)
self:PointToEnemy(npc)
self:DropGrenadesOnDeath(npc)

end
end

function ENT:DoISeeAnEnemyOrNot(npc)
local npc = self.npc
if IsValid(npc:GetEnemy()) and npc:GetEnemy() then
self.NoEnemy = false
else
self.NoEnemy = true
end
if npc:GetActiveWeapon() == NULL then return false end
if self.npc.Iambeingcommanded == false and npc:GetActiveWeapon():GetClass() == "weapon_pistol" then
npc:SetMovementActivity( 371 )
end
if self.npc.Iambeingcommanded == true and npc:GetActiveWeapon():GetClass() == "weapon_pistol" then
npc:SetMovementActivity( 372 )
end
if self.NoEnemy == true and npc:GetActiveWeapon():GetClass() == "weapon_stunstick" or npc:GetActiveWeapon():GetClass() == "weapon_crowbar" then
self:ActNPC(npc, "plazathreat2", false, true, nil, nil )
elseif self.NoEnemy == true and npc:GetActiveWeapon():GetClass() == "weapon_smg1" and self.npc.Iambeingcommanded == false and !npc:IsCurrentSchedule( SCHED_IDLE_WANDER ) then
npc:SetSchedule( SCHED_IDLE_WANDER )
elseif self.NoEnemy == true and npc:GetActiveWeapon():GetClass() == "weapon_pistol" and self.npc.Iambeingcommanded == false and !npc:IsCurrentSchedule( SCHED_IDLE_WANDER ) then
npc:SetSchedule( SCHED_IDLE_WANDER )
end
end

function ENT:PointToEnemy(npc)
local npc = self.npc
if npc:GetActiveWeapon() == NULL then return false end
if math.random(1,50) == 40 and IsValid(npc:GetEnemy()) and npc:GetEnemy() and self.npc:GetEnemy():GetPos():Distance(self.npc:GetPos()) > 150 and npc:GetActiveWeapon():GetClass() == "weapon_pistol" then
self:ActNPC(npc, "point", false, true, nil, nil, nil )
elseif math.random(1,50) ~= 40 then
return false end
end
	
function ENT:ScriptedSequencePlay(npc, parent, npc_name, moveto, pos, ang, replay, pre_anim, main_anim, post_anim, sound1, sound2, sound3)
self.seq = ents.Create("scripted_sequence")
if(parent)then
self.seq:SetParent(parent)
end
self.seq:SetPos(pos)		
self.seq:SetAngles(ang)
if(pre_anim)then
self.seq:SetKeyValue("m_iszIdle", pre_anim) -- Pre Anim
end
if(main_anim)then
self.seq:SetKeyValue("m_iszPlay", main_anim) -- Anim
end
if(post_anim)then
self.seq:SetKeyValue("m_iszPostIdle", post_anim) -- Post Anim
end
self.seq:SetKeyValue("m_iszEntity", npc_name)
self.seq:SetKeyValue("spawnflags", "16" + "32" + "64" + "128")
self.seq:SetKeyValue("m_fMoveTo", moveto)
self.seq:SetKeyValue("m_flRepeat", replay)
self.seq:Spawn()
self.seq:Fire("beginsequence")
if(sound1)then npc:EmitSound(sound1) end
if(sound2)then npc:EmitSound(sound2) end
if(sound3)then npc:EmitSound(sound3) end
if IsValid(self.seq) and IsValid(self) then self:DeleteOnRemove(self.seq) end
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
end
end

function ENT:OnRemove()
if IsValid(self.npc) then
self.npc:Remove()
end
end