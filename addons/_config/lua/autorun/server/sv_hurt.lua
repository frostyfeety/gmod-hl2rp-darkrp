hook.Add("PlayerHurt", "rp_PlayerHurt", function(victim, attacker)
    if victim:isMPF() then
        victim:EmitSound("npc/metropolice/pain"..math.random(1,4)..".wav", 50, 100)
        victim:ViewPunch(Angle(math.random(5,-4), math.random(1,5), math.random(1,5)))
        victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
        return false
    elseif victim:isOTA() and victim:GetModel() ~= "models/player/soldier_stripped.mdl" then
        victim:EmitSound("npc/combine_soldier/pain"..math.random(1,3)..".wav", 50, 100)
        victim:ViewPunch(Angle(math.random(5,-2), math.random(1,3), math.random(1,3)))
        victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
        return false
    elseif victim:isFemale() then
        victim:EmitSound("vo/npc/female01/pain0"..math.random(1,6)..".wav", 50, 100)
        victim:ViewPunch(Angle(math.random(5,-10), math.random(1,15), math.random(1,15)))
        victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
        return false
    elseif victim:isZombie() then
        victim:EmitSound("npc/zombie/zombie_pain"..math.random(1,6)..".wav", 50, 100)
        victim:ViewPunch(Angle(math.random(5,-10), math.random(1,15), math.random(1,15)))
        victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
        return false
    else
        victim:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 50, 100)
        victim:ViewPunch(Angle(math.random(5,-10), math.random(1,15), math.random(1,15)))
        victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 )
        return false
    end
end)