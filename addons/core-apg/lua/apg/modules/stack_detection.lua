

local mod = "stack_detection"

function APG.checkStack( ent, pcount )
    if not APG.isBadEnt( ent ) then return end

    local efound = ents.FindInSphere(ent:GetPos(), APG.cfg["stackArea"].value )
    local count = 0
    local max_count = APG.cfg["stackMax"].value
    for k, v in pairs (efound) do
        if APG.isBadEnt( v ) and APG.getOwner( v ) then
            count = count + 1
        end
    end
    if count >= (pcount or max_count) then
        local owner, _ = ent:CPPIGetOwner()
        ent:Remove()
        if not owner.APG_CantPickup then
            APG.blockPickup( owner )
            APG.log( "[APG] Do not try to crash the server !", ply )
            local msg = "[APG] Warning : " .. owner:Nick() .. " tried to unfreeze a stack of props !"
            for _, v in pairs( player.GetAll()) do
                if v:IsAdmin() then
                    APG.log( msg, v) -- Need a fancy notification system
                end
            end
        end
    end
end


--[[--------------------
    Stacker Exploit Quick Fix
]]----------------------
hook.Add( "InitPostEntity", "APG_InitStackFix", function()
    timer.Simple(60, function()
        local TOOL = weapons.GetStored("gmod_tool")["Tool"][ "stacker" ]
            or weapons.GetStored("gmod_tool")["Tool"][ "stacker_v2" ]
        if not TOOL then return end
        APG.dJobRegister( "weld", 0.3, 20, function( sents )
            if not IsValid( sents[1] ) or not IsValid( sents[2]) then return end
            constraint.Weld( sents[1], sents[2], 0, 0, 0 )
        end)
        function TOOL:ApplyWeld( lastEnt, newEnt )
            if ( not self:ShouldForceWeld() and not self:ShouldApplyWeld() ) then return end
            APG.startDJob( "weld", {lastEnt, newEnt} )
        end
    end)
end)

--[[------------------------------------------
        Load hooks and timers
]]--------------------------------------------
for k, v in next, APG[mod]["hooks"] do
    hook.Add( v.event, v.identifier, v.func )
end

for k, v in next, APG[mod]["timers"] do
    timer.Create( v.identifier, v.delay, v.repetitions, v.func )
end
