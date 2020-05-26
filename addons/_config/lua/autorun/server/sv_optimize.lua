util.AddNetworkString("rp_optimize")

hook.Add("PlayerInitialSpawn", "rp_optimize", function(player)
    if IsValid(player) then
        net.Start("rp_optimize")
        net.Send(player)
    end
end)