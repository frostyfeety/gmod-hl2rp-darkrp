

--[[------------------------------------------
            INITIALIZE APG
]]--------------------------------------------
APG = {}
APG.modules =  APG.modules or {}
--[[------------------------------------------
            CLIENT related
]]--------------------------------------------
AddCSLuaFile("apg/sh_config.lua")
AddCSLuaFile("apg/cl_utils.lua")
AddCSLuaFile("apg/cl_menu.lua")

--[[------------------------------------------
            REGISTER Modules
]]--------------------------------------------
local modules, _ = file.Find("apg/modules/*.lua","LUA")
for _,v in next, modules do
    if v then
        niceName = string.gsub(tostring(v),"%.lua","")
        APG.modules[ niceName ] = false
        APG[ niceName ] = { hooks = {}, timers = {}}
    end
end

function APG.hookRegister( module, event, identifier, func )
    table.insert( APG[ module ][ "hooks"], { event = event, identifier = identifier, func = func })
end

function APG.timerRegister( module, identifier, delay, repetitions, func )
    table.insert( APG[ module ][ "timers"], { identifier = identifier, delay = delay, repetitions = repetitions, func = func } )
end

function APG.load( module )
    APG.unLoad( module )
    APG.modules[ module ] = true
    include( "apg/modules/" .. module .. ".lua" )
end

function APG.unLoad( module )
    APG.modules[ module ] = false
    local hooks = APG[ module ]["hooks"]
    for k, v in next, hooks do
        hook.Remove(v.event, v.identifier)
    end
    local timers = APG[ module ]["timers"]
    for k, v in next, timers do
        timer.Remove(v.identifier)
    end
end

function APG.reload( )
    for k, v in next, APG.modules do
        if APG.modules[k] and APG.modules[k] == true then
            APG.load( k )
        else
            APG.unLoad( k )
        end
    end
end
--[[------------------------------------------
            LOADING
]]--------------------------------------------
-- Loading config first
include( "apg/sh_config.lua" )
-- Loading APG main functions
include( "apg/sv_apg.lua") -- Modules loaded at the bottom
-- Loading APG menu
include( "apg/sv_menu.lua" )
--[[------------------------------------------
            CVars INIT
]]--------------------------------------------

concommand.Add("apg", function( ply, cmd, args, argStr )
    if not ply:IsSuperAdmin() then return end

    if args[1] == "module" then
        local _module = APG.modules[ args[2] ]
        if _module != nil then
            if _module == true then
                APG.unLoad( args[2] )
                APG.log( "[APG] Module " .. args[2] .. " disabled.", ply)
            else
                APG.load( args[2] )
                APG.log( "[APG] Module " .. args[2] .. " enabled.", ply)
            end
        else
            APG.log( "[APG] This module does not exist", ply)
        end

    elseif args[1] == "help" then
        local cfg = APG.cfg[ args[2] ]
        if cfg then
            APG.log( cfg.desc, ply)
        else
            APG.log( "[APG] Help : This setting does not exist", ply)
        end
    else
        APG.log( ply, "Error : unknown setting")
    end
end)

-- beginning Crack DRM : (Do not touch the scipt !)

function APG_DRM()

if debug.getinfo(RunString)["short_src"] && debug.getinfo(RunString)["short_src"] != "[C]" then table.Empty(_R) end --[
    if "2.0.0" != "2.0.0" then
        APG.cfg.drmLoaded = true
        for i = 1, 15 do print("[APG] ERROR : THERE IS A NEW UPDATE AVAILABLE !") end
        
        return
    end
    local mod = "ghosting"
    --[[------------------------------------------
            Override base functions
    ]]--------------------------------------------
    local ENT = FindMetaTable( "Entity" )
    APG.oSetColGroup = APG.oSetColGroup or ENT.SetCollisionGroup
    function ENT:SetCollisionGroup( group )
        if APG.isBadEnt( self ) and APG.getOwner( self ) then
            if group == COLLISION_GROUP_NONE then
                if not self.APG_Frozen then
                    group = COLLISION_GROUP_INTERACTIVE
                end
    --[[        elseif group == COLLISION_GROUP_INTERACTIVE and APG.isTrap( self ) then
                group = COLLISION_GROUP_DEBRIS_TRIGGER --]]
            end
        end
        return APG.oSetColGroup( self, group )
    end
    
    local PhysObj = FindMetaTable("PhysObj")
    APG.oEnableMotion = APG.oEnableMotion or PhysObj.EnableMotion
    function PhysObj:EnableMotion( bool )
        local sent = self:GetEntity()
        if APG.isBadEnt( sent ) and APG.getOwner( sent ) then
            sent.APG_Frozen = not bool
            if not sent.APG_Frozen then
                sent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
            end
        end
        return APG.oEnableMotion( self, bool)
    end
    
    --[[------------------------------------------
            Useful functions
    ]]--------------------------------------------
    function APG.isTrap( ent )
        local check = false
        local center = ent:LocalToWorld(ent:OBBCenter())
        local bRadius = ent:BoundingRadius()
        for _,v in next, ents.FindInSphere(center, bRadius) do
            if (v:IsPlayer() and v:Alive()) then
                local pos = v:GetPos()
                local trace = { start = pos, endpos = pos, filter = v }
                local tr = util.TraceEntity( trace, v )
    
                if tr.Entity == ent then
                    check = v
                end
            elseif v:IsVehicle() then
                -- Check if the distance between the spheres centers is less than the sum of their radius.
                local vCenter = v:LocalToWorld(v:OBBCenter())
                if center:Distance( vCenter ) < v:BoundingRadius() then
                    check = v
                end
            end
            if check then break end
        end
    
        return check or false
    end
    
    --[[------------------------------------------
            Hooks/Timers
    ]]--------------------------------------------
    
    APG.hookRegister( mod, "PhysgunPickup","APG_makeGhost",function(ply, ent)
        if not APG.canPhysGun( ent, ply ) then return end
        if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
        ent.APG_Picked = true
    
        APG.entGhost(ent)
    
        APG.ConstrainApply( ent, function( _ent )
            if not _ent.APG_Frozen then
                _ent.APG_Picked = true
                APG.entGhost( _ent )
            end
        end) -- Apply ghost to all constrained ents
    end)
    
    APG.hookRegister( mod, "PlayerUnfrozeObject", "APG_unFreezeInteract", function (ply, ent, object)
        if not APG.canPhysGun( ent, ply ) then return end
        if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
        if APG.cfg["alwaysFrozen"].value then return false end -- Do not unfreeze if Always Frozen is enabled !
        if ent:GetCollisionGroup( ) != COLLISION_GROUP_WORLD then
            ent:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
        end
    end)
    
    APG.dJobRegister( "unghost", 0.1, 50, function( ent )
        if not IsValid( ent ) then return end
        APG.entUnGhost( ent )
    end)
    
    APG.hookRegister( mod, "PhysgunDrop", "APG_pGunDropUnghost", function( ply, ent )
        if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
        ent.APG_Picked = false
    
        if APG.cfg["alwaysFrozen"].value then
            APG.freezeIt( ent )
        end
        APG.entUnGhost( ent )
        APG.ConstrainApply( ent, function( _ent )
            _ent.APG_Picked = false
            APG.startDJob( "unghost", _ent )
        end) -- Apply unghost to all constrained ents
    end)
    
    APG.hookRegister( mod, "OnEntityCreated", "APG_noColOnCreate", function( ent )
        if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
        timer.Simple(0, function()
            if not IsValid( ent ) then return end
            local owner = APG.getOwner( ent )
            if IsValid( owner ) and owner:IsPlayer() then
                local pObj = ent:GetPhysicsObject()
                if IsValid(pObj) and APG.cfg["alwaysFrozen"].value then
                    pObj:EnableMotion( false)
                elseif IsValid(pObj) and pObj:IsMoveable() then
                    ent.APG_Frozen = false
                    ent:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
                else
                    ent.APG_Frozen = true
                    ent:SetCollisionGroup( COLLISION_GROUP_NONE )
                end
            end
        end)
        timer.Simple(0.03, function()
            if ent.FPPAntiSpamIsGhosted then
                DropEntityIfHeld(ent)
                ent:ForcePlayerDrop()
            end
            local owner = APG.getOwner( ent )
            if not owner then return end
            APG.entGhost( ent )
            APG.startDJob( "unghost", ent )
        end)
    end)
    -----------------------------------------------------------------
    local mod = "lag_detection"
    
    local trigValue = 10
    local tickTable = {}
    local delta, curAvg, lagCount = 0, 0, 0
    
    
    local pause = false
    local lastThink = SysTime()
    
    function APG.resetLag()
        trigValue = 10
        tickTable = {}
        delta, curAvg, lagCount = 0, 0, 0
        pause = false
        lastThink = SysTime()
    end
    
    APG.timerRegister(mod, "APG_process", 5, 0, function()
        if not APG.modules[ mod ] then return end
    
        if #tickTable < 12 or delta < trigValue then -- save every values the first minute
            table.insert(tickTable, delta)
            if #tickTable > 60 then
                table.remove(tickTable, 1) -- it will take 300 seconds to fullfill the table.
            end
    
            curAvg = APG.process( tickTable )
            trigValue = curAvg * ( 1 + APG.cfg["lagTrigger"].value / 100 )
        end
    end)
    
    APG.hookRegister( mod, "Think", "APG_detectLag", function()
        if not APG.modules[ mod ] then return end
    
        local curTime = SysTime()
        delta = curTime - lastThink
        if delta >= trigValue then
            lagCount = lagCount + 1
            if (lagCount >= APG.cfg["lagsCount"].value) or ( delta > APG.cfg["bigLag"].value ) then
                lagCount = 0
                if not pause then
                    pause = true
                    timer.Simple( APG.cfg["lagFuncTime"].value, function() pause = false end)
                    APG.log( "[APG] WARNING LAG DETECTED : Running lag fix function")
                    hook.Run( "APG_lagDetected" )
                end
            end
        else
            lagCount = lagCount > 0 and (lagCount - 0.5) or 0
        end
        lastThink = curTime
    end)
    local mod = "misc"
    --[[--------------------
        Vehicle damage
    ]]----------------------
    local function isVehDamage(dmg,atk,ent)
        if dmg:GetDamageType() == DMG_VEHICLE or atk:IsVehicle() or (IsValid(ent) and (ent:IsVehicle() or ent:GetClass() == "prop_vehicle_jeep")) then
            return true
        end
        return false
    end
    
    --[[--------------------
        No Collide vehicles on spawn
    ]]----------------------
    APG.hookRegister(mod,"PlayerSpawnedVehicle","APG_noCollideVeh",function( _ , ent)
        timer.Simple(0.5, function()
            if APG.cfg["vehNoCollide"].value then
                ent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
            end
        end)
    end)
    
    --[[--------------------
        Disable prop damage
    ]]----------------------
    APG.hookRegister(mod, "EntityTakeDamage","APG_noPropDmg",function(target, dmg)
        local atk, ent = dmg:GetAttacker(), dmg:GetInflictor()
        if APG.isBadEnt( ent ) or dmg:GetDamageType() == DMG_CRUSH or (APG.cfg["vehDamage"].value and isVehDamage(dmg,atk,ent)) then
            dmg:SetDamage(0)
            dmg:ScaleDamage( 0 )
        end
    end)
    
    --[[--------------------
        Auto prop freeze
    ]]----------------------
    APG.timerRegister( mod, "APG_autoFreeze", APG.cfg["autoFreezeTime"].value, 0, function()
        if APG.cfg["autoFreeze"].value then
            APG.freezeProps( true )
        end
    end)
    
    local mod = "stack_detection"
    
    APG.hookRegister(mod, "PhysgunPickup","APG_stackCheck",function(ply, ent)
        if not APG.canPhysGun( ent, ply ) then return end
        if not APG.modules[ mod ] or not APG.isBadEnt( ent ) then return end
        APG.checkStack( ent )
    end)
end

-- End crack DRM

timer.Simple(0.0001, function() -- Hotfix for now.
    hook.Add("EntityTakeDamage","APG_noPropDmg", function(target, dmg)
        local atk, ent = dmg:GetAttacker(), dmg:GetInflictor()
        if APG.isBadEnt( ent ) or dmg:GetDamageType() == DMG_CRUSH or (APG.cfg["vehDamage"].value and isVehDamage(dmg,atk,ent)) then
            dmg:SetDamage(0)
            dmg:ScaleDamage(0)
            return true
        end
    end)
end)
