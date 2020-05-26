hook.Add("InitPostEntity", "util_check_vars", function()
    if not IsValid(LocalPlayer()) then return end 
    timer.Create("util_allowcslua", 10, 0, function()
        local util_enabled = GetConVar("sv_allowcslua"):GetBool()
        net.Start("util_allowcslua")
            net.WriteBool(util_enabled)
        net.SendToServer()
    end)
end)