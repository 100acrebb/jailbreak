

local reregister = {};
local function reregisterWeapon(old,new)
	reregister[old] = new;
end

local function ReplaceSingle(ent, newname)
	-- Ammo that has been mapper-placed will not have a pos yet at this point for
	-- reasons that have to do with being really annoying. So don't touch those
	-- so we can replace them later. Grumble grumble.
	--if ent:GetPos() == vector_origin then
	--	return
	--end
	ent:SetSolid(SOLID_NONE)
	local rent = ents.Create(newname)
	rent:SetPos(Vector(-1530,-470,54))
	rent:SetAngles(Vector(-90,90,0))
	rent:Spawn()
	rent:Activate()
	rent:PhysWake()
	ent:Remove()
end

reregisterWeapon("weapon_ak47","weapon_jb_ak47");
reregisterWeapon("weapon_aug","weapon_jb_m4a1");
reregisterWeapon("weapon_awp","weapon_jb_awp");
reregisterWeapon("weapon_deagle","weapon_jb_deagle");
reregisterWeapon("weapon_elite","weapon_jb_usp");
reregisterWeapon("weapon_famas","weapon_jb_famas");
reregisterWeapon("weapon_fiveseven","weapon_jb_fiveseven");
reregisterWeapon("weapon_g3sg1","weapon_jb_m4a1");
reregisterWeapon("weapon_galil","weapon_jb_galil");
reregisterWeapon("weapon_glock","weapon_jb_glock");
reregisterWeapon("weapon_m249","weapon_jb_scout");
--reregisterWeapon("weapon_m3","weapon_jb_scout");
reregisterWeapon("weapon_m3","weapon_jb_m3");
reregisterWeapon("weapon_m4a1","weapon_jb_m4a1");
reregisterWeapon("weapon_mac10","weapon_jb_mac10");
reregisterWeapon("weapon_mp5navy","weapon_jb_mp5navy");
reregisterWeapon("weapon_p228","weapon_jb_fiveseven");
reregisterWeapon("weapon_p90","weapon_jb_p90");
reregisterWeapon("weapon_scout","weapon_jb_scout");
reregisterWeapon("weapon_sg550","weapon_jb_scout");
reregisterWeapon("weapon_sg552","weapon_jb_sg552");
reregisterWeapon("weapon_tmp","weapon_jb_tmp");
reregisterWeapon("weapon_ump45","weapon_jb_ump");
reregisterWeapon("weapon_usp","weapon_jb_usp");
--reregisterWeapon("weapon_xm1014","weapon_jb_scout");
reregisterWeapon("weapon_xm1014","weapon_jb_xm1014");
reregisterWeapon("weapon_knife","weapon_jb_knife");
reregisterWeapon("weapon_hegrenade","weapon_jb_knife");
reregisterWeapon("weapon_smokegrenade","weapon_jb_knife");
reregisterWeapon("weapon_flashbang","weapon_jb_knife");

hook.Add("Initialize","JB.Initialize.ReplaceCSSWeapons",function()
	for k,v in pairs(reregister)do
		weapons.Register( {Base = v, IsDropped = true}, string.lower(k), false);
	end
	
	--local ak = ents.FindByClass("weapon_jb_ak47")
	--ReplaceSingle(ak[1], "weapon_jb_xm1014")
	--ReplaceSingle(ak[2], "weapon_jb_xm1014")
end);



if SERVER then
	function JB:CheckWeaponReplacements(ply,entity)
		if reregister[entity:GetClass()] then
			ply:Give(reregister[entity:GetClass()])
			return true;
		end
		return false;
	end
end

