for i = 1, 21 do
	player_manager.AddValidModel("CP_Male_" .. i, "models/ggl/cp/cp_male_" .. i .. ".mdl")
	player_manager.AddValidHands("CP_Male_" .. i, "models/weapons/c_arms_combine.mdl", 0, "0000000")

	list.Set("PlayerOptionsModel", "CP_Male_" .. i, "models/ggl/cp/cp_male_" .. i .. ".mdl")
end