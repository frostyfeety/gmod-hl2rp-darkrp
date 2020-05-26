



local mod = "ghosting"

if not APG.isTrap then
    function APG.isTrap( ent )
        return false
    end
end

function APG.entGhost( ent, enforce, noCollide )
    if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end

    if not ent.APG_Ghosted then
        ent.FPPAntiSpamIsGhosted = nil -- Override FPP Ghosting.

        ent.APG_oColGroup = ent:GetCollisionGroup()

        if not enforce then
            -- If and old collision group was set get it.
            if ent.OldCollisionGroup then ent.APG_oColGroup = ent.OldCollisionGroup end -- For FPP
            if ent.DPP_oldCollision then ent.APG_oColGroup = ent.DPP_oldCollision end -- For DPP

            ent.OldCollisionGroup = nil
            ent.DPP_oldCollision = nil
        end

        ent.APG_Ghosted = true

        if not ent.APG_oldColor then
            ent.APG_oldColor = ent:GetColor()
            if not enforce then
                if ent.OldColor then ent.APG_oldColor = ent.OldColor end -- For FPP
                if ent.__DPPColor then ent.APG_oldColor = ent.__DPPColor end -- For DPP

                ent.OldColor = nil
                ent.__DPPColor = nil
            end
        end

        ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:DrawShadow(false)
        ent:SetColor( APG.cfg["ghost_color"].value )
        if noCollide then
            ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
        else
            ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
        end
    end
end

function APG.entUnGhost( ent, ply )
    if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
    if ent.APG_HeldBy and #ent.APG_HeldBy > 1 then return end

    if ent.APG_Ghosted and not ent.APG_Picked then
        ent.APG_isTrap = APG.isTrap(ent)
        if not ent.APG_isTrap then
            ent.APG_Ghosted  = false
            ent:DrawShadow(true)
            ent:SetColor( ent.APG_oldColor or Color(255,255,255,255))
            ent.APG_oldColor = false

            local newColGroup = COLLISION_GROUP_INTERACTIVE
            if ent.APG_oColGroup == COLLISION_GROUP_WORLD then
                newColGroup = ent.APG_oColGroup
            elseif ent.APG_Frozen then
                newColGroup = COLLISION_GROUP_NONE
            end
            ent:SetCollisionGroup( newColGroup )
        else
            ent:SetCollisionGroup( COLLISION_GROUP_WORLD  )
        end
    end
end

function APG.ConstrainApply( ent, callback )
    local constrained = constraint.GetAllConstrainedEntities(ent)
    for _,v in next, constrained do
        if IsValid(v) and v != ent then
            callback( v )
        end
    end
end

--[[------------------------------------------
        Load hooks and timers
]]--------------------------------------------
for k, v in next, APG[mod]["hooks"] do
    hook.Add( v.event, v.identifier, v.func )
end

for k, v in next, APG[mod]["timers"] do
    timer.Create( v.identifier, v.delay, v.repetitions, v.func )
end
