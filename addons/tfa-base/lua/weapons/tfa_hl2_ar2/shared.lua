
SWEP.Category				= "TFA HL2"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "AR2"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 58			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false --should have left it as original, and let everybody do as little change to the coding as necessary. 
	--But no, you just had to go and screw with the viewmodel.
	--goddammit, you're making me spend a lot of time fixing this mess.
SWEP.ViewModel				= "models/weapons/c_irifle.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_irifle.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("^weapons/ar1/ar1_dist" .. math.random(1,2) .. ".wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 652			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.2		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.2		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.2		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"

SWEP.TracerName = "AR2Tracer"
SWEP.TracerCount = 1

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 11	-- Base damage per bullet
SWEP.Primary.Spread		= .005	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- Ironsight accuracy, should be the same for shotguns

SWEP.Secondary.Ammo = "AR2AltFire"
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 1.5

SWEP.data 				= {}
SWEP.data.ironsights			= 0
SWEP.ScopeScale 			= 0.7

SWEP.SelectiveFire		= true

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.441, 0, 2.88)
SWEP.IronSightsAng = Vector(-1.8, -2.401, 0)
SWEP.SightsPos = Vector(-6.441, 0, 2.88)
SWEP.SightsAng = Vector(-1.8, -2.401, 0)
SWEP.RunSightsPos = Vector(9.369, -17.244, -3.689)
SWEP.RunSightsAng = Vector(6.446, 62.852, 0)

function SWEP:SecondaryAttack()
	
	if !self:CanPrimaryAttack() then return end
	if self.Owner:GetAmmoCount( self.Secondary.Ammo ) <= 0 then return end
	self:EmitSound( "weapons/cguard/charging.wav" )
	timer.Simple( 0.5, function()
		if !IsValid(self.Owner) then return end
		self.Owner:ViewPunch( Angle( -20, 0, 0 ) )
		self:EmitSound( "weapons/irifle/irifle_fire2.wav" )
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		if SERVER then
		local cball = ents.Create("point_combine_ball_launcher")
			cball:SetPos(self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 64)
			cball:Spawn()
			cball:Activate()
			cball:SetKeyValue("ballcount", "10")  
			cball:SetKeyValue("ballrespawntime", "-1")  
			cball:SetKeyValue("maxballbounces","16")
			cball:SetKeyValue("maxspeed", "1000")
			cball:SetKeyValue("minspeed", "1000")
			cball:SetKeyValue("angles", tostring(self.Owner:EyeAngles()))
			cball:SetKeyValue("launchconenoise", "5")
			cball:SetKeyValue("spawnflags", "2")
			cball:Fire( "launchBall", "", 0 )
		end
	end)
	self:TakeSecondaryAmmo(1)
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end
