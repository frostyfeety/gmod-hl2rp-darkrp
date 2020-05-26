





local mod = "lag_detection"

--[[--------------------
    Lag fixing functions
]]----------------------
-- cleanup_all
-- cleanup_unfrozen
-- ghost_unfrozen
-- freeze_unfrozen
-- custom_function
local lagFix = {}
lagFix.cleanup_all = function( notify ) APG.cleanUp( "all", notify ) end
lagFix.cleanup_unfrozen = function( notify ) APG.cleanUp( "unfrozen", notify ) end
lagFix.ghost_unfrozen = APG.ghostThemAll
lagFix.freeze_unfrozen = APG.freezeProps
lagFix.custom_function = APG.customFunc

--[[--------------------
        Utils
]]----------------------
function APG.process( tab )
    local sum = 0
    local max = 0
    for k, v in pairs( tab ) do
        sum = sum + v
        if v > max then
            max = v
        end
    end
    return sum / (#tab) , max
end

hook.Add("APG_lagDetected", "APG_lagDetected_id", function()
    if not APG then return end
    local func = APG.cfg["lagFunc"].value
    local notify = APG.cfg["lagFuncNotify"].value
    if not lagFix[ func ] then return end
    lagFix[ func ]( notify )
end)

--[[--------------------
        To replace in UI
]]----------------------
concommand.Add( "APG_showLag", function(ply, cmd, arg)
    if IsValid(ply) and not ply:IsAdmin() then return end
    local lastShow = SysTime()
    local values = {}
    local time = arg[1] or 30
    APG.log("[APG] Processing : please wait " .. time .. " seconds", ply )
    hook.Add("Think","APG_showLag",function()
        local curTime = SysTime()
        local diff = curTime - lastShow
        table.insert(values, diff)
        lastShow = curTime
    end)
    timer.Simple( time , function()
        hook.Remove("Think","APG_showLag")
        local avg, max = APG.process( values )
        values = {}
        APG.log("[APG] Avg : " .. avg .. " | Max : " .. max, ply )
    end)
end)

--[[------------------------------------------
        Load hooks and timers
]]--------------------------------------------
if APG.resetLag then APG.resetLag() end
for k, v in next, APG[mod]["hooks"] do
    hook.Add( v.event, v.identifier, v.func )
end

for k, v in next, APG[mod]["timers"] do
    timer.Create( v.identifier, v.delay, v.repetitions, v.func )
end
