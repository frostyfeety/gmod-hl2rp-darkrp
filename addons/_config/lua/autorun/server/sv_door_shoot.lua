hook.Add("EntityTakeDamage", "rp_EntityTakeDamage", function(entity, dmgInfo)
	if (entity:GetClass() == "prop_door_rotating" and (entity.nutNextBreach or 0) < CurTime()) then
		local handle = entity:LookupBone("handle")

		if (handle and dmgInfo:IsBulletDamage()) then
			local client = dmgInfo:GetAttacker()
			local position = dmgInfo:GetDamagePosition()

			if (client:GetEyeTrace().Entity != entity or client:GetPos():Distance(position) > 1000) then
				return
			end

			if (IsValid(client)) then
				if (hook.Run("CanPlayerBustLock", client, entity) == false) then
					return
				end
			end

			if (IsValid(client) and position:Distance(entity:GetBonePosition(handle)) <= 12) then
				if (hook.Run("CanPlayerBustLock", client, entity) == false) then
					return
				end

				local effect = EffectData()
					effect:SetStart(position)
					effect:SetOrigin(position)
					effect:SetScale(2)
				util.Effect("GlassImpact", effect)

				local name = client:UniqueID()..CurTime()
				client:SetName(name)

				entity.nutOldSpeed = entity.nutOldSpeed or entity:GetKeyValues().speed or 100

				entity:Fire("setspeed", entity.nutOldSpeed * 1.5)
				entity:Fire("unlock")
				entity:Fire("openawayfrom", name)
				entity:EmitSound("physics/wood/wood_plank_break"..math.random(1, 4)..".wav", 100, 120)

				entity.nutNextBreach = CurTime() + 1

				timer.Simple(0.5, function()
					if (IsValid(entity)) then
						entity:Fire("setspeed", entity.nutOldSpeed)
					end
				end)
			end
		end
	end
end)