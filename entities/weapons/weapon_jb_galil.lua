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

	SWEP.PrintName			= "Galil"			

SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_jb_base"
SWEP.Category			= "Jailbreak Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel				= "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_Galil.Single" )
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Positions = {};
SWEP.Positions[1] = {pos = Vector(-2.441, -4.803, 2.039), ang = Vector(0,0,0)};
SWEP.Positions[2] = {pos = Vector(-6.361, -12.801, 2.519), ang = Vector(0,0,0)};
SWEP.Positions[3] = {pos = Vector(6.534, -6, 0.708), ang = Vector(0,70,0)};