local enabled_weaponselector = CreateClientConVar("rp_hud_weaponselector", "1", true)

function MinervaBackground(round, x, y, w, h, alpha)
	draw.RoundedBox( round, x, y, w, h, Color(83,104,200, 100) )
	draw.RoundedBox( round, x+1, y+1, w-2, h-2, Color(32,36,70, 100) )
end

function MinervaBackgroundColored(round, x, y, w, h, color)
	draw.RoundedBox( round, x, y, w, h, color )
	draw.RoundedBox( round, x+1, y+1, w-2, h-2, Color(32,36,70,100) )
end

local function MinervaWeaponSelector()

local scale = (ScrW() / 175 >= 6 and 1) or 0.8

surface.CreateFont("min_wepsel", {
    size = 20 * scale,
    weight = 300 * scale, 
    antialias = true,
    extended = true,
    font = "Roboto Bold"})

surface.CreateFont("min_wepsel_small", {
    size = 20 * 0.7 * scale,
    weight = 300 * scale,
    antialias = true,
    extended = true,
    font = "Roboto Bold"})

local curTab = 0
local curSlot = 1
local alpha = 0
local lastAction = -math.huge
local loadout = {}
local slide = {}

local WeaponHistory = {}
local ActiveWeapon 
hook.Add("Think", "min_wepsel", function()
    if not LocalPlayer():IsValid() then return end 

    local activeweapon = LocalPlayer():GetActiveWeapon()

    if not activeweapon:IsValid() or activeweapon == ActiveWeapon then return end
    ActiveWeapon = activeweapon

    activeweapon = activeweapon:GetClass()

    for k, wep in next, WeaponHistory do
        if wep == activeweapon then
            table.remove(WeaponHistory, k)
            break
        end
    end

    if #WeaponHistory >= 4 then
        table.remove(WeaponHistory)
    end

    table.insert(WeaponHistory, 1, activeweapon)
end)

local newinv
function SelectWeapon(class)
    newinv = class
end
hook.Add("CreateMove", "min_wepsel", function(cmd)
    if newinv then
        local wep = LocalPlayer():GetWeapon(newinv)
        if wep:IsValid() and LocalPlayer():GetActiveWeapon() ~= wep then
            cmd:SelectWeapon(wep)
        else
            newinv = nil
        end
    end
end)

local CWeapons = {}
for _, y in pairs(file.Find("scripts/weapon_*.txt", "MOD")) do
    local t = util.KeyValuesToTable(file.Read("scripts/" .. y, "MOD"))
    CWeapons[y:match("(.+)%.txt")] = {
        Slot = t.bucket,
        SlotPos = t.bucket_position,
        TextureData = t.texturedata
    }
end

local localization = {
    -- gmod_camera = DarkRP.getPhrase("gmod_camera"),
    -- gmod_tool = DarkRP.getPhrase("gmod_tool"),
    -- weapon_bugbait = DarkRP.getPhrase("weapon_bugbait"),
    -- weapon_physcannon = DarkRP.getPhrase("weapon_physcannon"),
    -- weapon_physgun = DarkRP.getPhrase("weapon_physgun"),
}

local function findcurrent()
    if alpha <= 0 then
        table.Empty(slide)
        local class = IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()
        for k1, v1 in pairs(loadout) do
            for k2, v2 in pairs(v1) do
                if v2.classname == class then
                    curTab = k1
                    curSlot = k2
                    return
                end
            end
        end
    end
end

local function update()
    table.Empty(loadout)

    for k, v in pairs(LocalPlayer():GetWeapons()) do
        local classname = v:GetClass()

        local Slot = CWeapons[classname] and CWeapons[classname].Slot or v.Slot or 1

        loadout[Slot] = loadout[Slot] or {}

        table.insert(loadout[Slot], {
            classname = classname,
            name = localization[classname] or v:GetPrintName(),
            new = (CurTime() - v:GetCreationTime()) < 60,
            slotpos = CWeapons[classname] and CWeapons[classname].SlotPos or v.SlotPos or 1
        })
    end

    for k, v in pairs(loadout) do
        table.sort(v, function(a, b) return a.slotpos < b.slotpos end)
    end
end

local FKeyBinds = {
    ["gm_showhelp"] = "ShowHelp",
    ["gm_showteam"] = "ShowTeam",
    ["gm_showspare1"] = "ShowSpare1",
    ["gm_showspare2"] = "ShowSpare2"
}

local function PlayerBindPress(self, ply, bind, pressed)
    self.BaseClass:PlayerBindPress(ply, bind, pressed)

    local bnd = bind:lower():match("gm_[a-z]+[12]?")
    if bnd and FKeyBinds[bnd] then
        hook.Run(FKeyBinds[bnd])
    end

    if not pressed then return end

    bind = bind:lower()

    if bind:sub(1, 4) == "slot" then
        local n = tonumber(bind:sub(5, 5) or 1) or 1

        if n < 1 or n > 6 then return true end

        n = n - 1

        update()

        if not loadout[n] then return true end

        findcurrent()
        
        if curTab == n and loadout[curTab] and (alpha > 0 or GetConVarNumber("hud_fastswitch") > 0) then
            curSlot = curSlot + 1

            if curSlot > #loadout[curTab] then
                curSlot = 1
            end
        else
            curTab = n
            curSlot = 1
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            SelectWeapon(loadout[curTab][curSlot].classname)
        else
            alpha = 1
            lastAction = RealTime()
        end

        return true
    elseif bind:find("invnext", nil, true) and not (ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) then
        update()

        if #loadout < 1 then
            return true
        end

        findcurrent()

        curSlot = curSlot + 1

        if curSlot > (loadout[curTab] and #loadout[curTab] or -1) then
            repeat
                curTab = curTab + 1
                if curTab > 5 then
                    curTab = 0
                end
            until loadout[curTab]
            curSlot = 1
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            SelectWeapon(loadout[curTab][curSlot].classname)
        else
            lastAction = RealTime()
            alpha = 1
        end

        return true
    elseif bind:find("invprev", nil, true) and not (ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) then
        update()

        if #loadout < 1 then
            return true
        end

        findcurrent()

        curSlot = curSlot - 1

        if curSlot < 1 then
            repeat
                curTab = curTab - 1
                if curTab < 0 then
                    curTab = 5
                end
            until loadout[curTab]
            curSlot = #loadout[curTab]
        end

        if GetConVarNumber("hud_fastswitch") > 0 then
            SelectWeapon(loadout[curTab][curSlot].classname)
        else
            lastAction = RealTime()
            alpha = 1
        end

        return true
    elseif bind:find("+attack", nil, true) and alpha > 0 then
        if loadout[curTab] and loadout[curTab][curSlot] and not bind:find("+attack2", nil, true) then
            SelectWeapon(loadout[curTab][curSlot].classname)
        end
        LocalPlayer():EmitSound('ui/buttonrollover.wav')
        alpha = 0

        return true
    elseif bind:find("lastinv", nil, true) then
        if #WeaponHistory >= 2 then
            SelectWeapon(WeaponHistory[2])
        end
    end
end

-- GAMEMODE.PlayerBindPress = PlayerBindPress
timer.Simple(0, function()
    GAMEMODE.PlayerBindPress = PlayerBindPress
end)

local width = 175 * scale
local height = 22 * scale
local margin = height / 4
local color_dark = Color(0, 0, 0, 127)
local color_bright = Color(83,104,112, 255)

hook.Add("HUDPaint", "min_wepsel", function()

    if enabled_weaponselector:GetInt() == 0 then return end

    if not IsValid(LocalPlayer()) then
        return
    end

    if alpha < 1e-02 then
        if alpha ~= 0 then
            alpha = 0
        end
        return
    end

    update()

    if RealTime() - lastAction > 2 then
        alpha = Lerp(FrameTime() * 4, alpha, 0)
    end

    surface.SetAlphaMultiplier(alpha)

    surface.SetDrawColor(color_dark)
    surface.SetTextColor(color_white)
    surface.SetFont("min_wepsel")

    local thisWidth = 0

    for i, v in pairs(loadout) do
        thisWidth = thisWidth + width + margin
    end

    local offx = (ScrW() - (thisWidth - margin))*0.5

    for i, v in pairs(loadout) do
        local offy = margin

        MinervaBackground(0, offx, offy, height, height)

        local w, h = surface.GetTextSize(i + 1)
        surface.SetTextPos(offx  + (height - w) / 2, offy + (height - h) / 2)
        surface.DrawText(i + 1)
        offy = offy + h + margin

        for j, wep in pairs(v) do
            local selected = curTab == i and curSlot == j

            local height = height + (height + margin) * (slide[wep.classname] or 0)

            slide[wep.classname] = Lerp(FrameTime() * 10, slide[wep.classname] or 0, selected and 1 or 0)

            MinervaBackgroundColored(0, offx, offy, width, height, selected and color_bright or color_dark)

            surface.SetFont("min_wepsel")
            local w, h = surface.GetTextSize(wep.name)
            if w > width then
                surface.SetFont("min_wepsel_small")
                w, h = surface.GetTextSize(wep.name)
            end
            surface.SetTextPos(offx + (width - w) / 2, offy + (height - h) / 2)
            surface.DrawText(wep.name)

            offy = offy + height + margin
        end
        
        surface.SetFont("min_wepsel")

        offx = offx + width + margin
    end

    surface.SetAlphaMultiplier(1)
end)

hook.Add("HUDShouldDraw", "min_wepsel", function(name)
    if name == "CHudWeaponSelection" then
        return false
    end
end)

end
hook.Add("PlayerIsLoaded", "Minerva_Weapon_Selector", MinervaWeaponSelector)
MinervaWeaponSelector()