
--
--
--   You might want to use the following functions as well if you're writing a 
--   custom mapvote:
--
--   JB:Mapvote_ExtendCurrentMap()
--   JB:Mapvote_StartMapVote()
--
--
--------------------------------------------------------------------------------------


local defaulthp = 700		-- Vehicle health
local smokepoint = 400	-- Point at which vehicles begin to smoke

local timemin = 5			-- Minimum time between the vehicle's health reaching 0 and detonation
local timemax = 20		-- Maximum time between the vehicle's health reaching 0 and detonation

local smokeeffect = "smoke_burning_engine_01"		-- Vehicle smoke effect
local explodeeffect = "explosion_huge_f"				-- Explosion effect


function JB:MakeChoppaAndJeep()

	
	local fly1 = ents.Create("sent_sakariashelicopter")
	fly1:SetPos(Vector(-1714,175,580))
	fly1:SetAngles(Angle(0,90,0))
	fly1:Spawn()
	fly1:Activate()
	
	
	
	local car1 = ents.Create("prop_vehicle_jeep")
	car1:SetModel("models/LoneWolfie/chev_tahoe.mdl")
	car1.VehicleTable = list.Get( "Vehicles" )[ "Chevy Tahoe Police"] -- this is the only important line
	car1:SetKeyValue("vehiclescript","scripts/vehicles/lwcars/chev_tahoe.txt")  
	car1:SetPos(Vector(273,1875,-122))
	car1:SetAngles(Angle(0,90,-0))
	car1:SetHealth(defaulthp)
	car1.Screwed = false
	car1.Hurt = false
	car1:Spawn()
	car1:Activate()
		
		
	if (timer.Exists("Photon.RunScan")) then
		timer.Remove("Photon.RunScan")
		timer.Create("Photon.RunScan", 1.0, 0, function()
			Photon:RunningScan()
		end)	
	end

end

function JB:MakeSomeZombies()
	print("Zombies staged")
	
	for i=1,10 do
		local ent1 = ents.Create( "npc_zombie" )
		ent1:SetPos( Vector(0,2800 + (i * 30), -140 ))
		ent1:Spawn()
		ent1:Activate()
	end

	for i=1,10 do
		local ent1 = ents.Create( "npc_fastzombie" )
		ent1:SetPos( Vector(30,2800 + (i * 30), -140 ))
		ent1:Spawn()
		ent1:Activate()
	end

	for i=1,5 do
		local ent1 = ents.Create( "npc_zombie_torso" )
		ent1:SetPos( Vector(60,2800 + (i * 30), -140 ))
		ent1:Spawn()
		ent1:Activate()
	end

	for i=6,10 do
		local ent1 = ents.Create( "npc_fastzombie_torso" )
		ent1:SetPos( Vector(60,2800 + (i * 30), -140 ))
		ent1:Spawn()
		ent1:Activate()
	end
	
	

	
end



// Make cars take damage and blow up if they are damaged too much.
hook.Add("EntityTakeDamage", "VehicleHPHook", function( ent, dmginfo ) 
	if not ent:IsVehicle() then return end
	
		local damage = dmginfo:GetDamage()
		
		// Compensate for weird vehicle damage system, make explosives do more damage.
		if dmginfo:IsBulletDamage() then ent:SetHealth(ent:Health() - (10000 * damage)) 
			elseif dmginfo:IsExplosionDamage() then ent:SetHealth(ent:Health() - (8 * damage))
			else ent:SetHealth(ent:Health() - damage) 
		end
		
	
		// This was used for testing purposes, spits out a bunch of damage info to the console.
		// print(ent:GetAttachments(), dmginfo:GetDamageType(), dmginfo:GetAmmoType(), damage, dmginfo:IsBulletDamage())
		 
		// Make the vehicle smoke if health gets low.
		if ent:IsValid() and ent:Health() <= smokepoint and ent.Hurt == false then
			local id = ent:LookupAttachment("vehicle_engine")
			ent.Hurt = true // Let it know that the car is hurt so it doesn't add the effect the next time it gets damaged.
			ParticleEffectAttach( smokeeffect, PATTACH_POINT_FOLLOW, ent, id )
		end 
			
		// Once health drops to 0 or below, light the car on fire, kick everyone out, and blow it up.
		if ent:IsValid() and ent:Health() <= 0 and ent.Screwed == false then
				
			ent.Screwed = true // Let it know that the car is going to blow up and the timer is started (so it doesn't keep on restarting)
			
			local randomtime = math.random(timemin,timemax)
			
			ent:Ignite( randomtime, 100 )
			
			// Boot the driver out
			--if ent:GetDriver():IsValid() then ent:GetDriver():ExitVehicle(ent) end 
			
			// Blow it up after a set time.
			timer.Create("CarExplode", randomtime, 1, function() 
				if not ent:IsValid() then return end
				local explosion = ents.Create("env_explosion")
				ParticleEffect(explodeeffect,ent:GetPos(),Angle(0,0,0),nil) 
				explosion:SetPos(ent:GetPos())
				explosion:SetOwner(attacker)
				explosion:Spawn()
				explosion:SetKeyValue("iMagnitude", "250")
				explosion:Fire("Explode", 0, 0)
				ent:Remove()
			end)
		end 
end)



/* 

Compatability hooks - implement these in your admin mods

*/

function JB.Gamemode.JailBreakStartMapvote(rounds_passed,extentions_passed) // hook.Add("JailBreakStartMapvote",...) to implement your own mapvote. NOTE: Remember to return true!
	return false // return true in your own mapvote function, else there won't be a pause between rounds!
end

/* 

State chaining

*/
local timerSequence = 1
local function chainState(state,stateTime,stateCallback)
	JB.State = state;
	local oldTimerName = "JB.StateTimerNew" -- .. tostring(timerSequence)
	--timerSequence = timerSequence + 1
	local newTimerName = "JB.StateTimerNew" -- .. tostring(timerSequence)
	
	if timer.Exists(oldTimerName) then
		timer.Remove(oldTimerName);
	end
	
	timer.Create(newTimerName,stateTime,1,stateCallback);
	
	
	
	-- Map / state specific stuff
	
	if (JB.State == STATE_SETUP and game.GetMap() == "jb_new_summer_v2") then
		timer.Create("JB.StateTimer.Zombies",300,1,JB.MakeSomeZombies)
		timer.Create("JB.StateTimer.Choppa",120,1,JB.MakeChoppaAndJeep)
	end
		
end




/*

Utility functions

*/
local ententionsDone = 0;
function JB:Mapvote_ExtendCurrentMap() 		// You can call this from your own admin mod/mapvote if you want to extend the current map.
	JB.RoundsPassed = 0;
	ententionsDone = ententionsDone+1;
	chainState(STATE_ENDED,5,function()
		JB:NewRound();
	end);
end
function JB:Mapvote_StartMapVote()			// You can call this from your admin mod/mapvote to initiate a mapvote.
	if hook.Call("JailBreakStartMapvote",JB.Gamemode,JB.RoundsPassed,ententionsDone) then
		JB.State = STATE_MAPVOTE;
		return true;
	end
	return false;
end

/* 

Enums 

*/
STATE_IDLE = 1; -- when the map loads, we wait for everyone to join
STATE_SETUP = 2; -- first few seconds of the round, when everyone can still spawn and damage is disabled
STATE_PLAYING = 3; -- normal playing
STATE_LASTREQUEST = 4; -- last request taking place, special rules apply
STATE_ENDED = 5; -- round ended, waiting for next round to start
STATE_MAPVOTE = 6; -- voting for a map, will result in either a new map loading or restarting the current without reloading

/* 

Network strings

*/
if SERVER then
	util.AddNetworkString("JB.LR.GetReady");
	util.AddNetworkString("JB.SendRoundUpdate");
end

/*

Round System

*/
JB.ThisRound = {};
local wantStartup = false;
function JB:NewRound(rounds_passed)
	rounds_passed = rounds_passed or JB.RoundsPassed;
	collectgarbage("collect");

	JB.ThisRound = {};
	
	if SERVER then
		game.CleanUpMap();	
		
		if timer.Exists("JB.StateTimer.Zombies") then
			timer.Stop("JB.StateTimer.Zombies");
			timer.Destroy("JB.StateTimer.Zombies");
			
		end
		
		if timer.Exists("JB.StateTimer.Choppa") then
			timer.Remove("JB.StateTimer.Choppa");
		end
	
		rounds_passed = rounds_passed + 1;
		JB.RoundsPassed = rounds_passed;
		JB.RoundStartTime = CurTime();
		
		
		-- Deagle Day!
		if math.random(1,15) == 1 then
			timer.Simple(10,function()
				
				for k,v in pairs(team.GetPlayers(TEAM_PRISONER))do
					v:Give("weapon_jb_deagle"); -- give the player a rando waeapon from our table.
					v:SendNotification("Pssst!  Today is a Deagle Day!")
				end
					
			end);
		end
		
		-- Low Grav Day!
		if math.random(1,15) == 1 then
			JB:BroadcastNotification("Low-Gravity Day!!")
			RunConsoleCommand("sv_gravity", "60");
		else
			RunConsoleCommand("sv_gravity", "600");
		end
		
		chainState(STATE_SETUP,tonumber(JB.Config.setupTime),function()
			JB:DebugPrint("Setup finished, round started.")
			chainState(STATE_PLAYING,(10*60) - tonumber(JB.Config.setupTime),function()
				JB:EndRound();
			end);

			if not IsValid(JB:GetWarden()) then
				JB:DebugPrint("No warden after setup time; Freeday!")
				JB:BroadcastNotification("Today is a freeday");
			end
		end);
		
		if IsValid(JB.TRANSMITTER) then
			JB.TRANSMITTER:SetJBWarden_PVPDamage(false);
			JB.TRANSMITTER:SetJBWarden_ItemPickup(false);
			JB.TRANSMITTER:SetJBWarden_PointerType("0");
			JB.TRANSMITTER:SetJBWarden(NULL);
		end
		
		JB:BalanceTeams()
		
		JB.Util.iterate(player.GetAll()):SetRebel(false):SetGang(0):SetMadeGangs(false):Spawn();
		
		net.Start("JB.SendRoundUpdate"); net.WriteInt(STATE_SETUP,8); net.WriteInt(rounds_passed,32); net.Broadcast();
	elseif CLIENT and IsValid(LocalPlayer()) then
		notification.AddLegacy("Round "..rounds_passed,NOTIFY_GENERIC);

		LocalPlayer():ConCommand("-voicerecord");
	end

	hook.Call("JailBreakRoundStart",JB.Gamemode,JB.RoundsPassed);
end
function JB:EndRound(winner)
	if SERVER then
		if JB.RoundsPassed >= tonumber(JB.Config.roundsPerMap) and JB:Mapvote_StartMapVote() then
			return; // Halt the round system; we're running a custom mapvote!
		end

		chainState(STATE_ENDED,5,function()
			JB:NewRound();
		end);
			
		net.Start("JB.SendRoundUpdate"); net.WriteInt(STATE_ENDED,8); net.WriteInt(winner or 0, 8); net.Broadcast();
	elseif CLIENT then
		notification.AddLegacy(winner == TEAM_PRISONER and "Prisoners win" or winner == TEAM_GUARD and "Guards win" or "Draw",NOTIFY_GENERIC);
	end

	hook.Call("JailBreakRoundEnd",JB.Gamemode,JB.RoundsPassed);
end

if CLIENT then
	net.Receive("JB.SendRoundUpdate",function()
		local state = net.ReadInt(8);
		if state == STATE_ENDED then
			JB:EndRound(net.ReadInt(8));
		elseif state == STATE_SETUP then
			JB:NewRound(net.ReadInt(32));
		end
	end);
elseif SERVER then
	timer.Create("JB.Time.RoundEndLogic",1,0,function()
		if JB.State == STATE_IDLE and wantStartup then
			if #team.GetPlayers(TEAM_GUARD) >= 1 and #team.GetPlayers(TEAM_PRISONER) >= 1 then
				JB:DebugPrint("State is currently idle, but people have joined; Starting round 1.")
				JB:NewRound();
			end
		end
	
		if (JB.State != STATE_PLAYING and JB.State != STATE_SETUP and JB.State != STATE_LASTREQUEST) or #team.GetPlayers(TEAM_GUARD) < 1 or #team.GetPlayers(TEAM_PRISONER) < 1 then return end
		
		local count_guard = JB:AliveGuards();
		local count_prisoner = JB:AlivePrisoners();

		if count_prisoner < 1 and count_guard < 1 then
			JB:EndRound(0); -- both win!
		elseif count_prisoner < 1 then
			JB:EndRound(TEAM_GUARD);
		elseif count_guard < 1 then
			JB:EndRound(TEAM_PRISONER);
		end
	end);
end

/*

Transmission Entity

*/
JB.TRANSMITTER = JB.TRANSMITTER or NULL;
hook.Add("InitPostEntity","JB.InitPostEntity.SpawnStateTransmit",function()
	if SERVER and not IsValid(JB.TRANSMITTER) then
		JB.TRANSMITTER = ents.Create("jb_transmitter_state");
		JB.TRANSMITTER:Spawn();
		JB.TRANSMITTER:Activate();
		
		chainState(STATE_IDLE,tonumber(JB.Config.joinTime),function()
			wantStartup = true; -- request a startup.
		end);
	elseif CLIENT then
		timer.Simple(0,function()
			notification.AddLegacy("Welcome to Jail Break 7",NOTIFY_GENERIC);
			if JB.State == STATE_IDLE then
				notification.AddLegacy("The round will start once everyone had a chance to join",NOTIFY_GENERIC);
			elseif JB.State == STATE_PLAYING or JB.State == STATE_LASTREQUEST then
				notification.AddLegacy("A round is currently in progress",NOTIFY_GENERIC);
				notification.AddLegacy("You will spawn when the current ends",NOTIFY_GENERIC);
			elseif JB.State == STATE_MAPVOTE then
				notification.AddLegacy("A mapvote is currently in progress",NOTIFY_GENERIC);
			end
		end);
	end
end);

if CLIENT then
	hook.Add("OnEntityCreated","JB.OnEntityCreated.SelectTransmitter",function(ent)
		if ent:GetClass() == "jb_transmitter_state" and not IsValid(JB.TRANSMITTER) then
			JB.TRANSMITTER = ent;
			JB:DebugPrint("Transmitter found (OnEntityCreated)");
		end
	end)

	timer.Create("JB.CheckOnStateTransmitter",10,0,function()
		if not IsValid(JB.TRANSMITTER) then
			JB:DebugPrint("Panic! State Transmitter not found!");
			local trans=ents.FindByClass("jb_transmitter_state");
			if trans and trans[1] and IsValid(trans[1]) then
				JB.TRANSMITTER=trans[1];
				JB:DebugPrint("Automatically resolved; Transmitter relocated.");
			else
				JB:DebugPrint("Failed to locate transmitter - contact a developer!");
			end
		end
	end);
end

/*

Index Callback methods

*/


// State
JB._IndexCallback.State = {
	get = function()
		return IsValid(JB.TRANSMITTER) and JB.TRANSMITTER.GetJBState and JB.TRANSMITTER:GetJBState() or STATE_IDLE;
	end,
	set = function(state)
		if SERVER and IsValid(JB.TRANSMITTER) then
			JB.TRANSMITTER:SetJBState(state or STATE_IDLE);
			JB:DebugPrint("State changed to: "..state)
		else
			Error("Can not set state!")
		end
	end 
}

// Round-related methods.
JB._IndexCallback.RoundsPassed = {
	get = function()
		return IsValid(JB.TRANSMITTER) and JB.TRANSMITTER.GetJBRoundsPassed and JB.TRANSMITTER:GetJBRoundsPassed() or 0;
	end,
	set = function(amount)
		if SERVER and IsValid(JB.TRANSMITTER) then
			JB.TRANSMITTER:SetJBRoundsPassed(amount > 0 and amount or 0);
		else
			Error("Can not set rounds passed!");
		end
	end
} 
JB._IndexCallback.RoundStartTime = {
	get = function()
		return IsValid(JB.TRANSMITTER) and JB.TRANSMITTER.GetJBRoundStartTime and  JB.TRANSMITTER:GetJBRoundStartTime() or 0;
	end,
	set = function(amount)
		if SERVER and IsValid(JB.TRANSMITTER) then
			JB.TRANSMITTER:SetJBRoundStartTime(amount > 0 and amount or 0);
		else
			Error("Can not set round start time!");
		end
	end
}

// Last Request-related methods.
JB._IndexCallback.LastRequest = {
	get = function()
		return (JB.State == STATE_LASTREQUEST) and JB.TRANSMITTER:GetJBLastRequestPicked() or "0";
	end,
	set = function(tab)
		if not IsValid(JB.TRANSMITTER) or not SERVER then return end

		if not tab or type(tab) != "table" or not tab.type or not JB.ValidLR(JB.LastRequestTypes[tab.type]) or not IsValid(tab.prisoner) or not IsValid(tab.guard) then 
			JB.TRANSMITTER:SetJBLastRequestPicked("0");
			if not pcall(function() JB:DebugPrint("Attempted to select invalid LR: ",tab.type," ",tab.prisoner," ",tab.guard," ",type(tab)); end) then JB:DebugPrint("Unexptected LR sequence abortion!"); end
			return 
		end
		
		JB.TRANSMITTER:SetJBLastRequestPrisoner(tab.prisoner);
		JB.TRANSMITTER:SetJBLastRequestGuard(tab.guard);
		JB.TRANSMITTER:SetJBLastRequestPicked(tab.type);
		
		chainState(STATE_LASTREQUEST,180,function() JB:EndRound() end)
		
		JB.RoundStartTime = CurTime();

		JB:BroadcastNotification(tab.prisoner:Nick().." requested a "..JB.LastRequestTypes[tab.type]:GetName(),{tab.prisoner,tab.guard})

		JB:DebugPrint("LR Initiated! ",tab.prisoner," vs ",tab.guard);

		local players={tab.guard,tab.prisoner};
		JB.Util.iterate (players) : Freeze(true) : StripWeapons() : GodEnable() : SetHealth(100) : SetArmor(0);

		if not JB.LastRequestTypes[tab.type].setupCallback(tab.prisoner,tab.guard) then
			net.Start("JB.LR.GetReady");
			net.WriteString(tab.type);
			net.Send(players);

			timer.Simple(7,function()
				if not JB.Util.isValid(tab.prisoner,tab.guard) then return end
				JB.Util.iterate (players) : Freeze(false) : GodDisable();
				timer.Simple(.5,function()
					if not JB.Util.isValid(tab.prisoner,tab.guard) then return end
					JB.LastRequestTypes[tab.type].startCallback(tab.prisoner,tab.guard);
				end);
			end)
		end
	end
}
JB._IndexCallback.LastRequestPlayers = {
	get = function()
		return JB.State == STATE_LASTREQUEST and {JB.TRANSMITTER:GetJBLastRequestGuard() or NULL, JB.TRANSMITTER:GetJBLastRequestPrisoner() or NULL} or {NULL,NULL};
	end,
	set = function()
		Error("Tried to set LR players through invalid methods!");
	end
}

/* 

Prevent Cleanup

*/
local old_cleanup = game.CleanUpMap;
function game.CleanUpMap(send,tab)
	if not tab then tab = {} end
	table.insert(tab,"jb_transmitter_state");
	old_cleanup(send,tab);
end