local icon = Material( 'icon16/exclamation.png' )

net.Receive("rp_cp_death", function()
    surface.PlaySound("npc/metropolice/vo/on2.wav")

    timer.Create("rp_cp_death_over", 1, 1, function()
        surface.PlaySound("npc/overwatch/radiovoice/suspectisnow187.wav")
    end)

    local player = net.ReadEntity()

    hook.Add("HUDPaint","rp_cp_death",function()
        if player:IsValid() and (player:GetPos():Distance(LocalPlayer():GetPos())) < 20000 then
            surface.SetMaterial( icon )
			surface.SetDrawColor( 255,255,255 )
			surface.DrawTexturedRect( player:GetPos():ToScreen().x,player:GetPos():ToScreen().y-30, 24, 24  )
            draw.DrawText("*187* "..player:GetName().. " #" ..player:GetRP_ID().." - "..math.Round(player:GetPos():Distance(LocalPlayer():GetPos())) .. "cm","Trebuchet24",player:GetPos():ToScreen().x,player:GetPos():ToScreen().y - 70,Color(200,50,50),TEXT_ALIGN_CENTER)
        end
    end)

    timer.Create("rp_cp_death",25, 1, function()
        hook.Remove("HUDPaint","rp_cp_death") 
    end)
end)