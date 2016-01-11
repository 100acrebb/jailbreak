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


DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

PLAYER.DisplayName			= "Guard"
PLAYER.WalkSpeed 			= 260
PLAYER.RunSpeed				= 325
PLAYER.CrouchedWalkSpeed 	= 0.4
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight     = true
PLAYER.MaxHealth			= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 50
PLAYER.DropWeaponOnDie		= true
PLAYER.AvoidPlayers			= true
PLAYER.TeammateNoCollide	= true

--PLAYER.MadeGangs			= false

function PLAYER:Spawn()
	--self.Player:SetPlayerColor(Vector(.6,.9,1));
	--self.Player:SetWeaponColor(Vector(.6,.9,1));
	
	self.Player:SetColor( Color( 255, 255, 255, 255 )) 
	self.Player.LastPrisonerKill =  os.time()
	self.Player.PrisonerKills		= 0
end

local randomGuardSidearms = {"weapon_jb_deagle","weapon_jb_usp","weapon_jb_fiveseven"};
local randomGuardPrimary = {"weapon_jb_ak47","weapon_jb_aug","weapon_jb_galil","weapon_jb_m4a1","weapon_jb_mac10","weapon_jb_mp5navy","weapon_jb_p90","weapon_jb_scout","weapon_jb_sg552","weapon_jb_ump","weapon_jb_m3","weapon_jb_xm1014"};
function PLAYER:Loadout()
	self.Player:Give("weapon_jb_guardfists");

	self.Player:Give( table.Random( randomGuardSidearms ) )
	self.Player:Give( table.Random( randomGuardPrimary ) );
	self.Player:GiveAmmo( 255, "Pistol", true )
	self.Player:GiveAmmo( 512, "SMG1", true )
	self.Player:GiveAmmo( 100, "buckshot", true )
end

function PLAYER:SetupDataTables() 
	self.Player:NetworkVar( "Bool", 0, "MadeGangs" );
	--self.Player:NetworkVar( "Vector", 0, "HaloColor");
end

--function PLAYER:GetHandsModel()
--	return { model = "models/DPFilms/weapons/v_arms_metropolice.mdl", skin = 0, body = "00000000" }
--end

local guardModels = {

	Model("models/dpfilms/metropolice/playermodels/pm_arctic_police.mdl"),
	--Model("models/dpfilms/metropolice/playermodels/pm_badass_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_biopolice.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_black_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_c08cop.mdl"),
	--Model("models/dpfilms/metropolice/playermodels/pm_civil_medic.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_elite_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_hdpolice.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_hl2beta_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_hl2concept.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_hunter_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_police_bt.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_police_fragger.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_policetrench.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_resistance_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_retrocop.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_rogue_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_rtb_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_skull_police.mdl"),
	--Model("models/dpfilms/metropolice/playermodels/pm_steampunk_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_tf2_metrocop_blu.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_tf2_metrocop_red.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_tribal_police.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_tron_police_cn.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_tron_police_or.mdl"),
	Model("models/dpfilms/metropolice/playermodels/pm_urban_police.mdl"),
	--Model("models/dpfilms/metropolice/playermodels/pm_zombie_police.mdl"),
}

--util.PrecacheModel( "models/player/police.mdl" )
function PLAYER:SetModel()
	self.Player:SetModel( "models/player/police.mdl" )
	self.Player._OldGuardModel = "models/player/police.mdl"
	
	--local mdl = string.lower(table.Random(guardModels))
	--self.Player:SetModel( mdl )
	--self._OldGuardModel = mdl
end


player_manager.RegisterClass( "player_guard", PLAYER, "player_default" )