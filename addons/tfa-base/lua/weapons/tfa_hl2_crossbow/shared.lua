
SWEP.Category				= "TFA HL2"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Crossbow"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 52			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "rpg"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_crossbow.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_scoped_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("Weapon_Crossbow.Single")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 25		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip			= 5	-- Bullets you start with
SWEP.Primary.KickUp			= 1				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 1		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.DisableChambering = true

SWEP.TracerName = "TubeTracer"
SWEP.TracerCount = 1

SWEP.EventTable = {
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0.25, ["type"] = "lua", ["value"] = function( wep ) if wep.Owner:GetAmmoCount( wep:GetPrimaryAmmoType() ) > 0 then wep:SendWeaponAnim(ACT_VM_RELOAD) end end, ["client"] = true, ["server"] = true },
		{ ["time"] = 1.15, ["type"] = "lua", ["value"] = function( wep ) if wep.Owner:GetAmmoCount( wep:GetPrimaryAmmoType() ) > 0 then wep.Owner:EmitSound("weapons/crossbow/bolt_load" .. math.random(1,2) .. ".wav") end end, ["client"] = false, ["server"] = true },
		{ ["time"] = 1.15, ["type"] = "lua", ["value"] = function( wep ) if wep.Owner:GetAmmoCount( wep:GetPrimaryAmmoType() ) > 0 then wep.Owner:RemoveAmmo(1, wep:GetPrimaryAmmoType()) wep:SetClip1(1) end end, ["client"] = true, ["server"] = true },
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function( wep ) wep.Owner:EmitSound("weapons/crossbow/bolt_fly4.wav") end, ["client"] = false, ["server"] = true }
	}
}

DEFINE_BASECLASS( SWEP.Base )

function SWEP:PrimaryAttack()
	if self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 and self:Clip1() == 0 then
		self.Owner:StripWeapon( "tfa_hl2_crossbow" )
	else
		BaseClass.PrimaryAttack(self)
	end
end

function SWEP:Reload()
return false end

SWEP.Secondary.ScopeZoom			= 9	
SWEP.Secondary.UseParabolic		= false	-- Choose your scope type, 
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= false		
SWEP.Secondary.UseSVD			= true	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.7

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 100	--base damage per bullet
SWEP.Primary.Spread		= .0001	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- ironsight accuracy, should be the same for shotguns
-- enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-7.722, 0.827, 2.079)
SWEP.IronSightsAng = Vector(0.892, -0.81, -2.309)
SWEP.SightsPos = Vector(-7.722, 0.827, 2.079)
SWEP.SightsAng = Vector(0.892, -0.81, -2.309)
SWEP.RunSightsPos = Vector(13.868, -12.744, -2.05)
SWEP.RunSightsAng = Vector(-4.435, 62.558, 0)