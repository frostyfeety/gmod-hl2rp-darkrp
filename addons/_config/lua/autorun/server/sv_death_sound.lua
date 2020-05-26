hook.Add("PlayerDeathSound", "rp_death_sound", function(ply)
    if ply:isMPF() and ply:GetBodygroup(2) ~= 0 then
        ply:EmitSound("npc/metropolice/die"..math.random(1,4)..".wav", 50, 100)
        return true
    elseif ply:isOTA() and ply:GetModel() ~= "models/player/soldier_stripped.mdl" then
        ply:EmitSound("npc/combine_soldier/die"..math.random(1,3)..".wav", 50, 100)
        return true
    elseif ply:isFemale() then
        ply:EmitSound("vo/npc/female01/pain0"..math.random(1,6)..".wav", 50, 100)
        return true
    elseif ply:isZombie() then
        ply:EmitSound("npc/zombie/zombie_die"..math.random(1,3)..".wav", 50, 100)
        return true
    else
        ply:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 50, 100)
        return true
    end
end)