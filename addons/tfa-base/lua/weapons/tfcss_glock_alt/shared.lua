-- Variables that are used on both client and server
SWEP.Gun = ("tfcss_glock_alt")					-- must be the name of your swep
--redacted
SWEP.Category				= "TFA CS:S Alternates"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Glock 18"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 42			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/2_pist_glock18.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/3_pist_glock18.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("Alt_Weapon_Glock.1")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 825			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 17		-- Size of a clip
SWEP.Primary.DefaultClip		= 34		-- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 15	-- Base damage per bullet
SWEP.Primary.Spread		= .025	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .019 -- Ironsight accuracy, should be the same for shotguns
SWEP.SelectiveFire		= true

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(2.683, -5.336, 2.608)
SWEP.IronSightsAng = Vector(0.296, -0.105, 0)
SWEP.SightsPos = Vector(2.683, -5.336, 2.608)
SWEP.SightsAng = Vector(0.296, -0.105, 0)
SWEP.RunSightsPos = Vector(-2.76, -11.032, -4.137)
SWEP.RunSightsAng = Vector(59.402, 0, 0)


