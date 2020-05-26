util.AddNetworkString("ras_zombie_event_ambient")
util.AddNetworkString("ras_zombie_musics")
local ras_msg = "[RAS-EVENT] "
zombie_event_is_on = false
local is_on

local function start_zombie_event(ply)
    net.Start("ras_zombie_event_ambient")
    net.Send(ply)

    zombie_event_ambient = true
    is_on = true

    hook.Add("PlayerDeath", "ras_zombie_death", function(victim, inflictor, attacker)
        if attacker:GetClass() == "npc_zombie" or attacker:GetClass() == "npc_fastzombie" then
            victim:SetTeam(TEAM_ZOMBIE)
        end
    end)

    hook.Add("PlayerDeath", "ras_fix_zombies", function(victim, inflictor, attacker)
        if attacker:Team() == TEAM_ZOMBIE and victim ~= attacker then
            victim:SetTeam(TEAM_ZOMBIE)
        end

        if attacker:isZombie() and not victim:isZombie() then
            attacker:addMoney(120)
            attacker:SendLua("GAMEMODE:AddNotify(\"Вы получили 120 токенов за убийство!\", NOTIFY_GENERIC, 5)")
        end
    end)
end

local function off_zombie_event()
    for k, v in pairs(player.GetAll()) do
        v:SendLua("GAMEMODE:AddNotify(\"Спасибо за участие в ивенте!\", NOTIFY_GENERIC, 5)")
        v:addMoney(5000)
        v:KillSilent()
        v:SetTeam(1)
        v:ConCommand("stopsound")
    end

    zombie_event_ambient = false
    is_on = false
    hook.Remove("PlayerDeath", "ras_zombie_death")
    hook.Remove("PlayerDeath", "ras_fix_zombies")
end

concommand.Add("ras_zombie", function(ply, cmd, args)

    if !ply:IsSuperAdmin() or ply:GetUserGroup() ~= "founder" then
        print(ras_msg.."Вы не администратор")
        return
    end

	if ( !args[1] or string.Trim( args[1] ) == "") then
        print(ras_msg.."Ошибка в первом аргументе")
        return
    end

    if args[1] == "on" then
        if is_on then print(ras_msg.."Ивент уже идёт") return end
        start_zombie_event(ply)
    end

    if args[1] == "off" then
        if is_on == false then print(ras_msg.."Ивент не идёт") return end
        off_zombie_event()
    end
end)