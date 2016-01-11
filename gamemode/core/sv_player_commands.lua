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


local undroppableWeapons = {"weapon_physcannon", "weapon_physgun", "gmod_camera", "gmod_tool", "weapon_jb_fists","weapon_jb_guardfists"}
local drop = function( ply, cmd, args )
	if  (table.HasValue(JB.LastRequestPlayers,ply) and JB.LastRequestTypes[JB.LastRequest] and not JB.LastRequestTypes[JB.LastRequest]:GetCanDropWeapons() )  then return end

	JB:DebugPrint(ply:Nick().." dropped his/her weapon");

	local weapon = ply:GetActiveWeapon()

	for k, v in pairs(undroppableWeapons) do
		if IsValid(weapon) then
			if v == weapon:GetClass() then return false end
		end
	end
	
	if IsValid(weapon) then 
		JB:DamageLog_AddPlayerDrop( ply,weapon:GetClass() )

		weapon.IsDropped = true;
		weapon.BeingPickedUp = false;
		ply:DropWeapon(weapon)
	end
end
concommand.Add("jb_dropweapon", drop)
JB.Util.addChatCommand("drop",drop);

local pickup = function(p)
	local e = p:GetEyeTrace().Entity

	if (table.HasValue(JB.LastRequestPlayers,p) and JB.LastRequestTypes[JB.LastRequest] and not JB.LastRequestTypes[JB.LastRequest]:GetCanPickupWeapons() ) then
		return;
	end

	if IsValid(e) and p:Alive() and p:CanPickupWeapon( e )  then
		e.BeingPickedUp = p;
	end

	JB:DamageLog_AddPlayerPickup( p,e:GetClass() )
end
concommand.Add("jb_pickup",pickup)
JB.Util.addChatCommand("pickup",pickup);

local function teamSwitch(p,cmd)
	if !IsValid(p) then return end
	
	if cmd == "jb_team_select_guard" and JB:GetGuardsAllowed() > #team.GetPlayers(TEAM_GUARD) and p:Team() != TEAM_GUARD then
		p:SetTeam(TEAM_GUARD);
		p:KillSilent();
		p:SendNotification("Switched to guards");

		hook.Call("JailBreakPlayerSwitchTeam",JB.Gamemode,p,p:Team());
	elseif cmd == "jb_team_select_prisoner" and p:Team() != TEAM_PRISONER then
		p:SetTeam(TEAM_PRISONER);
		p:KillSilent();
		p:SendNotification("Switched to prisoners");

		hook.Call("JailBreakPlayerSwitchTeam",JB.Gamemode,p,p:Team());
	elseif cmd == "jb_team_select_spectator" and p:Team() != TEAM_SPECTATOR then
		p:SetTeam(TEAM_SPECTATOR);
		p:Spawn();
		p:SendNotification("Switched to spectator mode");

		hook.Call("JailBreakPlayerSwitchTeam",JB.Gamemode,p,p:Team());
	end


end
concommand.Add("jb_team_select_prisoner",teamSwitch);
concommand.Add("jb_team_select_guard",teamSwitch);
concommand.Add("jb_team_select_spectator",teamSwitch);
JB.Util.addChatCommand("guard",function(p)
	p:ConCommand("jb_team_select_guard");
end);
JB.Util.addChatCommand("prisoner",function(p)
	p:ConCommand("jb_team_select_prisoner");
end);
JB.Util.addChatCommand("spectator",function(p)
	p:ConCommand("jb_team_select_spectator");
end);

local teamswap = function(p)
	if p:Team() == TEAM_PRISONER then
		p:ConCommand("jb_team_select_guard");
	else
		p:ConCommand("jb_team_select_prisoner");
	end
end
JB.Util.addChatCommand("teamswap",teamswap);
JB.Util.addChatCommand("swap",teamswap);
JB.Util.addChatCommand("swapteam",teamswap);



local gangs = function(ply, cmd, t)
	
	
	local numgangs = 2;
	if (t[1] != nil) then numgangs = tonumber(t[1]) end
	if (!numgangs) then numgangs = 2 end
	if (numgangs > 4) then numgangs = 4 end
	if (numgangs < 2) then numgangs = 2 end
	
	
	if (not ply.GetWarden or not ply:GetWarden()) then
		ply:SendNotification("You are not the Warden");
		return
	end
	
	if (ply:GetMadeGangs() == false) then
		JB:BroadcastNotification(ply:Name().." has divided the prisoners into "..numgangs.." gangs.");

		local players = team.GetPlayers(TEAM_PRISONER);

		local gangcount = 0
		for k, v in RandomPairs(players) do
			if (v:Alive()) then
				gangcount = gangcount + 1
				if (gangcount > numgangs) then gangcount = 1 end
				
				v:SetGang(gangcount);
				if (gangcount == 4) then
					v:SetPlayerColor( Vector(1, 0.4, 0.6) );
					v:SetColor( Color( 255, 0, 255, 255 )) 
					--v:SetWeaponColor( Vector(1, 0.4, 0.6) );
					v:SendNotification("You have been placed in the pink gang.");
				elseif (gangcount == 1) then
					v:SetPlayerColor( Vector(0.3, 0.4, 1) );
					v:SetColor( Color( 0, 0, 255, 255 )) 
					--v:SetWeaponColor( Vector(0.3, 0.4, 1) );
					v:SendNotification("You have been placed in the blue gang.");
				elseif (gangcount == 2) then
					v:SetPlayerColor( Vector(0.3, 1, 0.4) );
					v:SetColor( Color( 0, 255, 0, 255 )) 
					--v:SetWeaponColor( Vector(0.3, 1, 0.4) );
					v:SendNotification("You have been placed in the green gang.");
				elseif (gangcount == 3) then
					v:SetPlayerColor( Vector(1, 1, 0.3) );
					v:SetColor( Color( 255, 255, 0, 255 )) 
					--v:SetWeaponColor( Vector(1, 1, 0.3) );
					v:SendNotification("You have been placed in the yellow gang.");
				end;
			end
		end;

		ply:SetMadeGangs(true);
	else
	
		JB:BroadcastNotification(ply:Name().." has dissolved the gangs.");

		for k, v in pairs( team.GetPlayers(TEAM_PRISONER) ) do
			v:SetPlayerColor( Vector(.9,.9,.9) );
			v:SetColor( Color( 255, 255, 255, 255 )) 
			v:SetGang(0);
		end;

		ply:SetMadeGangs(false);
	end;
	
	
end
JB.Util.addChatCommand("gangs",gangs);




local rebel = function(ply, cmd, t)
	
	if (not ply.GetWarden or not ply:GetWarden()) then
		ply:SendNotification("You are not the Warden");
		return
	end
	
	if (t[1] != nil) then
	
		for k,v in pairs(team.GetPlayers(TEAM_PRISONER))do
			if (string.find( string.lower(v:Nick()),  string.lower(t[1])) != nil and v:Alive()) then 
				v:AddRebelStatus();
			end
		end
	
	end
end
JB.Util.addChatCommand("rebel",rebel);

local unrebel = function(ply, cmd, t)
	
	if (not ply.GetWarden or not ply:GetWarden()) then
		ply:SendNotification("You are not the Warden");
		return
	end
	
	if (t[1] != nil) then
	
		for k,v in pairs(team.GetPlayers(TEAM_PRISONER))do
			if (string.find( string.lower(v:Nick()),  string.lower(t[1])) != nil and v:Alive()) then 
				v:RemoveRebelStatus();
			end
		end
	
	end
end
JB.Util.addChatCommand("unrebel",unrebel);