
AddCSLuaFile()

SWEP.PrintName			= "Famas"			

SWEP.Slot				= 1
SWEP.SlotPos			= 1
;
SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_jb_base"
SWEP.Category			= "Jailbreak Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel				= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Automatic 		= false;
SWEP.Primary.Sound			= Sound( "weapon_famas.Single" ) 
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 34
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.09 
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.ShootConeAdd	= 0.002;
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "smg1"

SWEP.FakeIronSights = true;

SWEP.Primary.Burst 			= 3; 

SWEP.Positions = {};
SWEP.Positions[1] = {pos = Vector(-1.969, 0, 1.72), ang = Vector(0,0,0)};
SWEP.Positions[2] = {pos = Vector(-6.2, -3.386, 1.36), ang = Vector(0,0,0)};
SWEP.Positions[3] = {pos = Vector(6.534, -14.094, 0.708), ang = Vector(0,70,0)};