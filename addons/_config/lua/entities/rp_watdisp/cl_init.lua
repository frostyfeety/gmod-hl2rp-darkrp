include("shared.lua")

local glowMaterial = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()

	local r, g, b, a = self:GetColor()
	local flashTime = self:GetDTFloat(0)
	local glowColor = Color(0, 255, 0, a)
	local position = self:GetPos()
	local forward = self:GetForward() * 18
	local curTime = CurTime()
	local right = self:GetRight() * -24.5
	local up = self:GetUp() * 5.5

	if (0 == 0) then
		glowColor = Color(255, 150, 0, a)
	end

	if (flashTime and flashTime >= curTime) then
		if (self:GetDTBool(0)) then
			glowColor = Color(0, 0, 255, a)
		else
			glowColor = Color(255, 0, 0, a)
		end
	end

	cam.Start3D(EyePos(), EyeAngles())
		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + forward + right + up, 3, 3, glowColor)

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + self:GetForward() * 18 + self:GetRight() * -24.5 + self:GetUp() * 3.5, 3, 3, Color(155,200,155))
	cam.End3D()
end