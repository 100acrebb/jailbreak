
AddCSLuaFile()

SWEP.PrintName			= "Desert Eagle"			

SWEP.Slot				= 2
SWEP.SlotPos			= 1

SWEP.HoldType			= "revolver"
SWEP.Base				= "weapon_jb_base"
SWEP.Category			= "Jailbreak Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 1
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Deagle.Single")
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 24
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Positions = {};
SWEP.Positions[1] = {pos = Vector(-1.321, -2.283, 0.2), ang = Vector(0,0,0)};
SWEP.Positions[2] = {pos = Vector(-6.378, -7.954, 2.039), ang = Vector(0.4, 0, 0)};
SWEP.Positions[3] = {pos = Vector(2.44, -14.882, -20), ang = Vector(70, 0.827, 0)};
