hook.Add("PlayerFootstep", "rp_footstep_fix", function(ply, pos, foot, sound, volume, rf)
    if ( ply:IsSprinting() and ply:isMPF() ) then
        ply:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav", 45, 100)
        return true
    elseif( ply:IsSprinting() and ply:isOTA() ) then
        ply:EmitSound("npc/combine_soldier/gear"..math.random(1,6)..".wav", 45, 100)
        return true
    end
end)
