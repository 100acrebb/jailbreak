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



SWEP.PrintName			= "XM1014"	

SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_jb_base"
SWEP.Category			= "Jailbreak Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 11
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.053
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.5
SWEP.Primary.DefaultClip	= 35
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

--SWEP.IronSightsPos 		= Vector( -14.125, 10, 5 )
--SWEP.IronSightsAng = Vector(-1.5, -0.795, 0);

SWEP.Positions = {};
SWEP.Positions[1] = {pos = Vector(-2.08, -2.757, 2), ang = Vector(0,0,0)};
SWEP.Positions[2] = {pos = Vector(-5.361, -2.757, 1.879), ang = Vector(1.2, 0, 0)};
SWEP.Positions[3] = {pos = Vector(6.377, -13.938, 0.393), ang = Vector(0,70,0)};

