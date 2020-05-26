RunConsoleCommand("sv_setsteamaccount", "AB81C0E28F94446D3FD71E35977CB6A1")
RunConsoleCommand("dlib_donate_never", 1)

_G['NPC_HIDE_ON_DISTANCE'] = nil
_G['stunned_ply_fix'] = nil

resource.AddWorkshop("1190787379")
resource.AddWorkshop("1516708316")
resource.AddWorkshop("1348270094")
resource.AddWorkshop("2017459263")
resource.AddWorkshop("1932806962")
resource.AddWorkshop("1595332211")

hook.Add("hungerUpdate", "ras_zombie_hunger_off", function(ply, value)
    if ply:Team() == TEAM_ZOMBIE or ply:Team() == TEAM_ADMIN or ply:isOTA() then
        return true
    end
end)

local hooks = {
    "Effect",
    "NPC",
    "Ragdoll",
    "SENT",
    "Vehicle"
}

for _, v in pairs (hooks) do
    hook.Add("PlayerSpawn"..v, "minlib.disallowspawn_"..v, function(client)
        if (client:GetUserGroup() == 'founder' or client:GetUserGroup() == 'eventer') then
            return true
        end
        return false
    end)
end

hook.Add( "Think", "rp_HealthRegen.Think", function()
	for _, ply in pairs( player.GetAll() ) do
		if ( ply:Alive() ) then
			local health = ply:Health()
			if ( health < ( ply.LastHealth or 0 ) ) then
				ply.HealthRegenNext = CurTime() + 10
				ply:SetNWBool("rp_propspawnkd", false)
			end
				
			if ( CurTime() > ( ply.HealthRegenNext or 0 )) then
				ply.HealthRegen = ( ply.HealthRegen or 0 ) + FrameTime()
				 if ( ply.HealthRegen >= 1 ) then
					local add = math.floor( ply.HealthRegen / 1 )
					ply.HealthRegen = ply.HealthRegen - ( add * 1 )
					ply:SetNWBool("rp_propspawnkd", true)
				end
			end
			ply.LastHealth = ply:Health()
		end
	end
end )

hook.Add("PlayerSpawnProp", "rp_propspawnkd", function(client)
	if client:GetUserGroup() == "founder" then
		return true
	else
		if client:GetNWBool("rp_propspawnkd") == true then
			return true
		else
			client:SendLua("GAMEMODE:AddNotify(\"Вы недавно получили урон. Необходимо подождать "..math.Round(-(CurTime() - client.HealthRegenNext)).." секунд\", NOTIFY_GENERIC, 10)")
			return false
		end
	end
end)

hook.Add("PlayerSwitchFlashlight", "rp_PlayerSwitchFlashlight", function(ply,enabled)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_ZOMBIE or ply:isOTA() and ply:GetModel() == "models/player/soldier_stripped.mdl" then 
		return false 
	end
end)

local nodamage = {
	prop_fix		= true,
	prop_physics 	= true,
	prop_dynamic 	= true,
	gmod_winch_controller = true,
	gmod_poly 		= true,
	gmod_button 	= true,
	gmod_balloon 	= true,
	gmod_cameraprop = true,
	gmod_emitter 	= true,
	gmod_light 		= true,
	keypad          = true,
    gmod_poly       = true
}

local nocolide = {
	prop_fix		= true,
	prop_physics 		= true,
	prop_dynamic 		= true,
	func_door 			= true,
	func_door_rotating	= true,
	prop_door_rotating	= true,
	spawned_food		= true,
	func_movelinear 	= true
}


hook.Add('PlayerShouldTakeDamage', 'rp_AntiPK_PlayerShouldTakeDamage', function(victim, attacker)
	if nodamage[attacker:GetClass()] or victim:IsPlayer() and attacker:IsVehicle() then 
		return false
	end
end)

hook.Add('EntityTakeDamage', 'rp_AntiPK.EntityTakeDamage', function(pl, dmginfo)
	if (dmginfo:GetDamageType() == DMG_CRUSH) then
		return true
	end
end)

hook.Add('ShouldCollide', 'rp_AntiPK_NoColide', function(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) and nocolide[ent1:GetClass()] and nocolide[ent2:GetClass()] then
		return false
	end
end)

hook.Add('PlayerSpawnedProp', 'rp_AntiPk_OnEntityCreated', function(pl, mdl, ent)
	ent:SetCustomCollisionCheck(true)
end)

hook.Add("PlayerSpawnProp","rp_ShapkaAntiPropSpam",function (ply, model)
	if ply.NextSpawnPropTime == nil or ply.NextSpawnPropTime < CurTime() then
		ply.NextSpawnPropTime = CurTime() + 1
		return true
	else
		DarkRP.notify(ply,1,4,"Вы не можете так часто спавнить пропы")
		return false
	end
end)

hook.Add( "PlayerSpray", "rp_DisablePlayerSpray", function( ply )
	return false
end )

hook.Add("CanPlayerSuicide", "rp_CanPlayerSuicide", function(ply)
	return false
end)

hook.Add("CanPlayerEnterVehicle", "rp_CanPlayerEnterVehicle", function(ply, veh, role)
	if ply:IsAdmin() or ply:isGrid() then 
		return true
	else
		return false
	end
end)

local function up( ply, ent )
    return false
end
hook.Add( "AllowPlayerPickup", "rp_AllowPlayerPickup", up )

CreateConVar("antiexp_dupefix", "1", FCVAR_ARCHIVE, "0 to activate dupe tool")
if GetConVar("antiexp_dupefix"):GetBool() then
    timer.Simple(1, function()
        net.Receive("ArmDupe", function(_, ply)
			ply:ChatPrint("Use antiexp_dupefix 0 в консоль для использование Dupes")
    	end)
	end)
end

