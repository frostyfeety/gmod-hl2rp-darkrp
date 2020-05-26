--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

DarkRP.createEntity("Аптечка (Большая)", {
    ent = "rp_medkit",
    model = "models/props_lab/jar01a.mdl",
    price = 2500,
    max = 2,
    cmd = "buymedkit",
    category = "Энтити",
    allowed = {TEAM_CWU3}
})

DarkRP.createEntity("Аптечка (Маленькая)", {
    ent = "rp_medkit_small",
    model = "models/props_lab/jar01b.mdl",
    price = 760,
    max = 2,
    cmd = "buymedkitsmall",
    category = "Энтити",
    allowed = {TEAM_CWU3}
})

DarkRP.createEntity("Бронзовый Принтер", {
    ent = "rx_printer_1",
    model = "models/props_c17/consolebox01a.mdl",
    price = 1200,
    max = 1,
    cmd = "buybronzeprinter",
    category = "Энтити",
    allowed = {TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3, TEAM_CITIZEN4, TEAM_REBEL1, TEAM_REBEL2, TEAM_REBEL3}
})

DarkRP.createEntity("Серебрянный Принтер", {
    ent = "rx_printer_2",
    model = "models/props_c17/consolebox01a.mdl",
    price = 2700,
    max = 1,
    cmd = "buysilverprinter",
    category = "Энтити",
    allowed = {TEAM_CITIZEN3, TEAM_CITIZEN4, TEAM_REBEL1, TEAM_REBEL2, TEAM_REBEL3}
})

DarkRP.createEntity("Золотой Принтер", {
    ent = "rx_printer_3",
    model = "models/props_c17/consolebox01a.mdl",
    price = 5400,
    max = 1,
    cmd = "buydiamondprinter",
    category = "Энтити",
    allowed = {TEAM_CITIZEN4, TEAM_REBEL1, TEAM_REBEL2, TEAM_REBEL3}
})