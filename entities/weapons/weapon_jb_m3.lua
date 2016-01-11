-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################

AddCSLuaFile()

--if (CLIENT) then
	--scopeTex = surface.GetTextureID("scope/scope_normal")
--end

SWEP.PrintName			= "M3 Pump Shotgun"	

SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_jb_base"
SWEP.Category			= "Jailbreak Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M3.Single" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.95
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

SWEP.Positions = {};
--SWEP.Positions[1] = {pos = Vector(-2.08, -2.757, 2), ang = Vector(0,0,0)};
--SWEP.Positions[2] = {pos = Vector(-5.361, -2.757, 1.879), ang = Vector(1.2, 0, 0)};
--SWEP.Positions[3] = {pos = Vector(6.377, -13.938, 0.393), ang = Vector(0,70,0)};
SWEP.Positions[1] = {pos = Vector(-2.08, -2.757, 2), ang = Vector(0,0,0)};
SWEP.Positions[2] = {pos = Vector(-5.361, -2.757, 1.879), ang = Vector(1.2, 0, 0)};
SWEP.Positions[3] = {pos = Vector(6.377, -13.938, 0.393), ang = Vector(0,70,0)};  -- RUN

--SWEP.IronSightsPos 		= Vector( -15.19, 2.5, 6 );
--SWEP.IronSightsAng = Vector(-1, 0, 0);