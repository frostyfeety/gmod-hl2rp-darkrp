util.AddNetworkString("rp_join_music")

hook.Add("PlayerInitialSpawn", "rp_join_music", function(player)
    timer.Simple(1, function()
        net.Start("rp_join_music")
        net.Send(player)
    end)
end)