-- Variables that are used on both client and server
SWEP.Gun = ("tfcss_tmp_alt")					-- must be the name of your swep
--redacted
SWEP.Category				= "TFA CS:S Alternates"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "TMP"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 77			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/2_smg_tmp.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/3_smg_tmp.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("Alt_Weapon_TMP.1")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 875			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.SelectiveFire		= true

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 20	-- Base damage per bullet
SWEP.Primary.Spread		= .022	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .012 -- Ironsight accuracy, should be the same for shotguns

SWEP.SightsPos = Vector(2.62, -2.385, 2.026)
SWEP.SightsAng = Vector(-0.05, 0, 0.291)
SWEP.RunSightsPos = Vector(-6.693, -6.378, 2.282)
SWEP.RunSightsAng = Vector(-17.914, -49.882, 0)

SWEP.DisableIdleAnimations = false

SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackBoneMods = {
	["L_Index_Base"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.802, 4.454, 0) },
	["L_Index_Middle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.149, 0, 0) },
	["Trigger"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -13.367, 0) },
	["Bolt"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.296, 0), angle = Angle(0, 0, 0) }
}





--redacted