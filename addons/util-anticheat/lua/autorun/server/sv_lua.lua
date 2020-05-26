util.AddNetworkString("util_allowcslua")

net.Receive("util_allowcslua", function(len, ply)
    local clientEnabled = net.ReadBool()
    local serverEnabled = GetConVar("sv_allowcslua"):GetBool()
    if serverEnabled ~= clientEnabled then
        ply:Kick("Попытка использования читов")
    end
end)