ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "RXPrinter Base"
ENT.Author = "RocketMania"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.RXPrinter = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
end

function ENT:GetHull()
	return self:GetDTInt(2) , self.Hull
end
function ENT:GetStoredMoney()
	if SERVER then
		return self.MoneyCollected
	else
		return self:GetDTInt(0)
	end
end
function ENT:IsError()
	local EC = 0
	if SERVER then
		EC = self.Error
	else
		EC = self:GetDTInt(1)
	end
	
	if EC != 0 then
		return true,EC
	else
		return false,EC
	end
end

-- Sounds
-- if you dont want to play sound, set true to false. the number is repeat time
ENT.ErrorSound = {true,1,"Resource/warning.wav"}
ENT.RuningSound = {true,5,"ambient/machines/machine6.wav"}
ENT.RuningSoundVolume = 0.03 -- 0 to 1. 0.5 is half volume

-- Main
ENT.PrinterMasterColor = Color(255,100,0,255)
ENT.PrinterName = "Бронзовый принтер"
ENT.PrinterHealth = 100
ENT.MaxMoney = 10000 -- How much money printer can hold?

-- Speed
ENT.SequenceMultiple = 20 -- More Higher, More faster printing animations. Just for animation.
ENT.RPM = 10 -- More Higher, More faster money creating. So generates 10 money for 1 second.
ENT.Hull = 100 -- This printer can make money 100 times. after that, will be exploded. So 10 RPM x 100 Hull = Make 1000 $
ENT.HullDecreSpeed = 1


-- Random BreakDown : Owner Should press E on printer to fix it. If not, printer will stop so no money. and will be exploded.
ENT.BreakDownTimer = 100 -- for every 100 seconds,
ENT.BreakDownRate = 30 -- BreakDown. for 30% chance. if you dont want it, set to 0
ENT.BreakDownDestoryTime = 40 -- Printer will be exploded if owner ignore the printer for 100 seconds.