hook.Add("RenderScreenspaceEffects", "rp_combine_effect", function()
	local player = LocalPlayer()
	local overlay
	local isMPF = isMPF or false
	local isOTA = isOTA or false
	if (IsValid(player) && player:Alive() && player:isMPF()) then
		overlay = Material("effects/combine_binocoverlay")
		if overlay:GetFloat("$alpha") != 0.4 then
			overlay:SetFloat("$alpha", 0.4)
		end
		DrawMaterialOverlay("effects/combine_binocoverlay",0)
	elseif (IsValid(player) && player:Alive() && player:isOTA() && player:GetModel() ~= "models/player/soldier_stripped.mdl" ) then
		overlay = Material("effects/combine_binocoverlay")
		if overlay:GetFloat("$alpha") != 0.7 then
			overlay:SetFloat("$alpha", 0.7)
		end
		DrawMaterialOverlay("effects/combine_binocoverlay",0)
	end
end)