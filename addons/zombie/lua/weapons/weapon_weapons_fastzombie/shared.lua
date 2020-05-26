AddCSLuaFile( "shared.lua" );

if CLIENT then
	SWEP.PrintName = "Fast Zombie";
	SWEP.Category	= "Zombies"
	
	SWEP.Slot = 3;
	SWEP.SlotPos = 3;
	
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

end

SWEP.Author			= "Sean"
SWEP.Instructions	= "Left Click: Attack, Crouch + Right Click: Leap, Reload: Moan"
SWEP.Contact		= ""
SWEP.Purpose		= "AGHH!"

SWEP.ViewModelFOV	= 71
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "knife"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel      = "models/weapons/c_arms.mdl"
SWEP.WorldModel   	= ""
  
-- Stats
SWEP.Primary.Delay			= 0.6
SWEP.Secondary.Delay		= 1.2

SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 15
SWEP.Primary.Automatic   	= true
-- Stats


-- Misc
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Ammo = "none"

SWEP.NextStrike = 0;
-- Misc

function SWEP:Precache()
util.PrecacheModel(self.ViewModel)

util.PrecacheSound("npc/fast_zombie/zombie_alert1.wav")
util.PrecacheSound("npc/fast_zombie/zombie_alert2.wav")
util.PrecacheSound("npc/fast_zombie/zombie_alert3.wav")
util.PrecacheSound("npc/fast_zombie/claw_miss1.wav")
util.PrecacheSound("npc/fast_zombie/claw_miss2.wav")
util.PrecacheSound("npc/fast_zombie/claw_strike1.wav")
util.PrecacheSound("npc/fast_zombie/claw_strike2.wav")
util.PrecacheSound("npc/fast_zombie/claw_strike3.wav")
util.PrecacheSound("npc/fast_zombie/zo_attack1.wav")
util.PrecacheSound("npc/fast_zombie/zo_attack2.wav")
util.PrecacheSound("npc/fast_zombie/moan_loop1.wav")
util.PrecacheSound("npc/fast_zombie/fz_scream.wav")
end

function SWEP:Initialize()
	self:Precache()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1)
end

function SWEP:ZombieModel()
	if self.Owner:IsValid() then
	util.PrecacheModel("models/player/zombie_fast.mdl")
	self.Owner:SetModel("models/player/zombie_fast.mdl")
	end
end

function SWEP:Playermodel()
	if self.Owner:IsValid() then
	util.PrecacheModel("models/player/kleiner.mdl")
	self.Owner:SetModel("models/player/kleiner.mdl")
	end
end

function SWEP:CustomSpeed() -- New speed
	if self.Owner:IsValid() then
	self.Owner:SetRunSpeed(400)
	self.Owner:SetWalkSpeed(235)
	self.Owner:SetJumpPower(600)
	end
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
	self:CustomSpeed() -- call the custom speed funciton above
	self:ZombieModel() -- call the zombiemodel function
	
	self:SendWeaponAnim(ACT_VM_DEPLOY)
	timer.Simple(0.9, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
	end
	return true;
end

function SWEP:Holster()
	if self.Owner:IsValid() then
	self:Playermodel()
	end
	return true;
end

function SWEP:Think()
    if not self.NextHit or CurTime() < self.NextHit then return end
    self.NextHit = nil

    local pl = self.Owner

    local vStart = pl:EyePos() + Vector(0, 0, -10)
    local trace = util.TraceLine({start=vStart, endpos = vStart + pl:GetAimVector() * 72, filter = pl, mask = MASK_SHOT})

    local ent
    if trace.HitNonWorld then
        ent = trace.Entity
    elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(vStart) < 110 then
        ent = self.PreHit
        trace.Hit = true
    end

    if trace.Hit then
        pl:EmitSound("npc/fast_zombie/claw_strike"..math.random(1, 2)..".wav")
    end

    pl:EmitSound("npc/fast_zombie/claw_miss"..math.random(1, 2)..".wav")
    self.PreHit = nil

    if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
            local damage = 14
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
                local vel = damage * 323 * pl:GetAimVector()

                phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
				if ent.SetPhysicsAttacker then
	            	ent:SetPhysicsAttacker(pl)
				end
            end
			if SERVER and ent:isDoor() then
			    ent:keysUnLock()
			    ent:Fire('Open')
			end
			if not CLIENT and SERVER then
        end
    end
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
    if CurTime() < self.NextSwing then return end
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	
	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_FRENZY)
	
    self.Owner:EmitSound("npc/fast_zombie/zo_attack"..math.random(1, 2)..".wav")
	timer.Simple(1.2, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
    self.NextSwing = CurTime() + self.Primary.Delay
    self.NextHit = CurTime() + 0.4
    local vStart = self.Owner:EyePos() + Vector(0, 0, -10)
    local trace = util.TraceLine({start=vStart, endpos = vStart + self.Owner:GetAimVector() * 65, filter = self.Owner, mask = MASK_SHOT})
    if trace.HitNonWorld then
        self.PreHit = trace.Entity
    end
end

SWEP.Leap = 0
function SWEP:SecondaryAttack()
if CurTime() < self.Leap then return end

timer.Simple(1.4, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
        self.isflying = true
        self.islanding = false
		self:SetVelocity((self:GetUp() * 145) + (self:GetForward() * 555));
		
if self.isflying then

		local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetForward() * -160), self.Owner);
			if (tr.Hit) then
				self.Owner:ViewPunch(Angle(8, 0, 0));
				self.Owner:SetVelocity((self.Owner:GetForward() * 555) + (self.Owner:GetUp() * 145));
				
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
				self.Owner:DoAnimationEvent(ACT_ZOMBIE_LEAP_START)
				
				function Animations()
				self.Owner:DoAnimationEvent(ACT_ZOMBIE_LEAPING)
				end

				timer.Create("Animations", 0.5, 2, Animations ) -- plays the leaping animation 2 times
				
				self.Weapon:EmitSound("npc/fast_zombie/fz_scream.wav")
				
				self.Leap = CurTime() + 3
			end
		end
	end


SWEP.NextMoan = 0
function SWEP:Reload()
    if CurTime() < self.NextMoan then return end

	local sounds = {
		"npc/fast_zombie/fz_scream1.wav",
		"npc/fast_zombie/fz_frenzy1.wav",
		"npc/fast_zombie/fz_alert_far1.wav",
		"npc/fast_zombie/fz_alert_close1.wav",
		"npc/fast_zombie/leap1.wav",
		"npc/fast_zombie/wake1.wav"
	}

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
    self.Owner:EmitSound(sounds[math.random(1,#sounds)])
    self.NextMoan = CurTime() + 3
end