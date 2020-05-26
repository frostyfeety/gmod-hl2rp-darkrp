--[[---------------------------------------------------------------------------
DarkRP custom food
---------------------------------------------------------------------------

This file contains your custom food.
This file should also contain food from DarkRP that you edited.

THIS WILL ONLY LOAD IF HUNGERMOD IS ENABLED IN darkrp_config/disabled_defaults.lua.
IT IS DISABLED BY DEFAULT.

Note: If you want to edit a default DarkRP food, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the food item to this file and edit it.

The default food can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/hungermod/sh_init.lua#L33

Add food under the following line:
---------------------------------------------------------------------------]]


DarkRP.createFood("Банан", {
    model = "models/bioshockinfinite/hext_banana.mdl",
    energy = 10,
    price = 10
})
DarkRP.createFood("Бананы", {
    model = "models/props/cs_italy/bananna_bunch.mdl",
    energy = 20,
    price = 20
})
DarkRP.createFood("Арбуз", {
    model = "models/props_junk/watermelon01.mdl",
    energy = 20,
    price = 20
})
DarkRP.createFood("Бутылка воды", {
    model = "models/props_junk/GlassBottle01a.mdl",
    energy = 20,
    price = 20
})
DarkRP.createFood("Газировка", {
    model = "models/props_lunk/popcan01a.mdl",
    energy = 5,
    price = 5
})
DarkRP.createFood("Молоко", {
    model = "models/props_junk/garbage_milkcarton002a.mdl",
    energy = 20,
    price = 20
})
DarkRP.createFood("Апельсин", {
    model = "models/bioshockinfinite/hext_orange.mdl",
    energy = 20,
    price = 20
})
DarkRP.createFood("Сардины", {
    model = "models/bioshockinfinite/cardine_can_open.mdl",
    energy = 25,
    price = 30
})
DarkRP.createFood("Арахисовая паста", {
    model = "models/probs_misc/tobdcco_box-1.mdl",
    energy = 15,
    price = 15
})
DarkRP.createFood("Сыр", {
    model = "models/bioshockinfinite/pound_cheese.mdl",
    energy = 50,
    price = 50
})