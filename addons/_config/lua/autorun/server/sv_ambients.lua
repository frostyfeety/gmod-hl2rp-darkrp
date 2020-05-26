zombie_event_ambient = false

local sounds = {
    "ambient/alarms/scanner_alert_pass1.wav",
    "ambient/alarms/manhack_alert_pass1.wav",
    "ambient/alarms/apc_alarm_pass1.wav",
    "ambient/machines/heli_pass1.wav",
    "ambient/machines/heli_pass2.wav",
    "ambient/machines/heli_pass_distant1.wav"
}

timer.Create("rp_ambients", 180, 0, function()
    if zombie_event_ambient == false then return end
    local sound, pt = table.Random(sounds), player.GetAll()

    for k = 1, #pt do
        pt[k]:SendLua("surface.PlaySound(\"".. sound .."\")")
    end
end)