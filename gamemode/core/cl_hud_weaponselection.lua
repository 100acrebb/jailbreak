

local selectedTab = 0;
local c = 0;
local slots = {}
local slotPos = 1;
local function ArrangeSlots()
	slots = {};
	c = 0;
	for k,v in pairs(LocalPlayer():GetWeapons())do
		--print(v:GetClass(), v.Slot)
		if v.Slot then
			if not slots[v.Slot+1] then
				slots[v.Slot+1] = {}
			end
			slots[v.Slot+1][#slots[v.Slot+1]+1] = v;
			if v.Slot == 5 then
				c = c+1;
			end
		end
	end
	if selectedTab == 6 then
		slotPos = (((slotPos-1)%c)+1);
	else
		slotPos = 1;
	end
end

surface.CreateFont("JBWeaponSelectionFont",{
	font = JB.Config.font,
	size = 28,
})
surface.CreateFont("JBWeaponSelectionFontBlur",{
	font = JB.Config.font,
	size = 28,
	blursize = 2
})
local tabX = {-256,-256,-256,-256, -256, -256};
local matTile = Material("materials/jailbreak_excl/weapon_selection_tile.png");
local mul;
hook.Add("Think","JB.Think.WeaponSelection.Animate",function()
	if selectedTab > 0 and LocalPlayer():Alive() and LocalPlayer():Team() <= TEAM_GUARD then
		mul=FrameTime()*40;
		tabX[1] = math.Clamp(Lerp(0.20 * mul,tabX[1],1),-256,0);
		tabX[2] = math.Clamp(Lerp(0.18 * mul,tabX[2],1),-256,0);
		tabX[3] = math.Clamp(Lerp(0.16 * mul,tabX[3],1),-256,0);
		tabX[4] = math.Clamp(Lerp(0.14 * mul,tabX[4],1),-256,0);
		tabX[5] = math.Clamp(Lerp(0.12 * mul,tabX[5],1),-256,0);
		tabX[6] = math.Clamp(Lerp(0.10 * mul,tabX[6],1),-256,0);
	else 
		mul=FrameTime()*40;
		tabX[1] = math.Clamp(Lerp(0.40 * mul,tabX[1],-256),-256,0);
		tabX[2] = math.Clamp(Lerp(0.39 * mul,tabX[2],-256),-256,0);
		tabX[3] = math.Clamp(Lerp(0.38 * mul,tabX[3],-256),-256,0);
		tabX[4] = math.Clamp(Lerp(0.37 * mul,tabX[4],-256),-256,0);
		tabX[5] = math.Clamp(Lerp(0.36 * mul,tabX[5],-256),-256,0);
		tabX[6] = math.Clamp(Lerp(0.35 * mul,tabX[6],-256),-256,0);
	end
end);
hook.Add("HUDPaint","JB.HUDPaint.WeaponSelection",function()
	if tabX[1] >= -256 and LocalPlayer():Alive() and LocalPlayer():Team() <= TEAM_GUARD then
		for i=1,6 do
			local y = 250 + ((i-1) * 54);
			local x = math.Round(tabX[i]);
		
			surface.SetDrawColor(selectedTab == i and JB.Color.white or JB.Color["#888"]);
			surface.SetMaterial(matTile);
			surface.DrawTexturedRect(x + 0,y,256,64);
				
			if slots[i] and slots[i][1] then
				draw.SimpleText(slots[i][1].PrintName or "Invalid","JBWeaponSelectionFontBlur",x + 210,y+(64-40)/2+40/2, JB.Color.black,2,1)
				draw.SimpleText(slots[i][1].PrintName or "Invalid","JBWeaponSelectionFont",x + 210,y+(64-40)/2+40/2, selectedTab == i and JB.Color.white or JB.Color["#888"],2,1)
			end

			draw.SimpleText(i == 1 and "UNARMED" or i == 2 and "PRIMARY" or i == 3 and "SECONDARY" or i == 4 and "OTHER" or i == 5 and "OTHER2" or i == 6 and "OTHER3","JBNormal",x + 4,y+(64-40)/2+3,Color(255,255,255,2));
		end
	end
end)

timer.Create("UpdateSWEPSelectthings",1,0,function()
	if selectedTab > 0 then
		ArrangeSlots();
	end
end)

local nScroll = 1;
hook.Add("PlayerBindPress","JB.PlayerBindPress.WeaponSelection", function(p, bind, pressed)

	if not pressed then return end

	if string.find(bind, "invnext") then
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		nScroll = nScroll + 1;
		if nScroll > 6 then
			nScroll = 1;
		end

		if selectedTab ~= nScroll then
			surface.PlaySound("common/wpn_moveselect.wav");
		end
		selectedTab = nScroll;
		ArrangeSlots();
		--RunConsoleCommand("use",slots[selectedTab][slotPos]:GetClass())
		return true;
	elseif string.find(bind, "invprev") then
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end

		nScroll = nScroll-1;
		if nScroll < 1 then
			nScroll = 6;
		end

		if selectedTab ~= nScroll then
			surface.PlaySound("common/wpn_moveselect.wav");
		end
		selectedTab = nScroll;
		ArrangeSlots();
		--RunConsoleCommand("use",slots[selectedTab][slotPos]:GetClass())
		return true;
	elseif string.find(bind, "slot0") then 
		selectedTab = 0;
		return true 
	elseif string.find(bind, "slot1") then 
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 1 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 1;
		ArrangeSlots();
		return true 
	elseif string.find(bind, "slot2") then
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 2 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 2;
		ArrangeSlots();
		return true 
	elseif string.find(bind, "slot3") then 
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 3 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 3;
		ArrangeSlots();
		return true 
	elseif string.find(bind, "slot4") then 
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 4 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 4;
		ArrangeSlots();
		return true
	elseif string.find(bind, "slot5") then 
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 5 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 5;
		ArrangeSlots();
		return true
	elseif string.find(bind, "slot6") then 
		if LocalPlayer():Team() > TEAM_GUARD or !LocalPlayer():Alive() then return true  end
		if selectedTab ~= 6 then
			surface.PlaySound("common/wpn_moveselect.wav");
		else
			selectedTab = 0;
			return true;
		end
		selectedTab = 6;
		ArrangeSlots();
		return true
	elseif string.find(bind, "slot7") then 
		selectedTab = 0;
		return true
	elseif string.find(bind, "slot8") then 
		selectedTab = 0;
		return true
	elseif string.find(bind, "slot9") then 
		selectedTab = 0;
		return true
	elseif string.find(bind, "+attack") then 
		if LocalPlayer():Team() > TEAM_GUARD then return true end
		if selectedTab > 0 and slots[selectedTab] then
			if not slots[selectedTab][slotPos] then return true end
			RunConsoleCommand("use",slots[selectedTab][slotPos]:GetClass())

			nScroll = selectedTab;
			selectedTab = 0;

			return true;
		end
	end
end,10)
