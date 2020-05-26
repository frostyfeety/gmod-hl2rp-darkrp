local r = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

function r:isMPF()
	if self:Team() == 0 then 
        return false 
    end
    return (self:getJobTable().mpf) or false
end

function r:isOTA()
	if self:Team() == 0 then 
        return false 
    end
    return (self:getJobTable().ota) or false
end

function r:GetRP_ID()
	return self:GetNWInt("RP_ID")
end

function r:isVIP()
	return ( self:GetUserGroup() == "vip" ) or false
end

function r:armor_can()
    return (self:getJobTable().armor_can) or false
end

function r:MaxArmorCan()
    return tonumber(self:getJobTable().MaxArmorCan) or 0
end

function r:health_can()
    return (self:getJobTable().health_can) or false
end

function r:MaxHealthCan()
    return tonumber(self:getJobTable().MaxHealthCan) or 0
end

function r:isFemale()
	if self:Team() == 0 then return false end
	return (string.find(string.lower( self:GetModel() ), "female" )) or false
end

function r:isZombie()
	if self:Team() == 0 then 
        return false 
    end
    return (self:getJobTable().zombie) or false
end

function r:isRebel()
	if self:Team() == 0 then 
        return false 
    end
    return (self:getJobTable().rebel) or false
end

function r:LoyalNumber()
    return (self:getJobTable().loyalnumber) or 0
end

function r:GetMaskID()
    return (self:getJobTable().maskid) or 0
end

function r:isCitizen()
	if self:Team() == 0 then
        return false 
    end
    return (self:getJobTable().citizen) or false
end

function r:isGrid()
	if self:Team() == 0 then
        return false 
    end
    return (self:getJobTable().grid) or false
end

function r:isCWU()
	if self:Team() == 0 then 
        return false 
    end
    return (self:getJobTable().cwu) or false
end

function r:forVIP()
    return (self:getJobTable().vip) or false
end

local CHAIR_CACHE = {}

for k, v in pairs(list.Get("Vehicles")) do
	if (v.Category == "Chairs") then
		CHAIR_CACHE[v.Model] = true
	end
end

function entityMeta:isChair()
	-- Micro-optimization in-case this gets used a lot.
	return CHAIR_CACHE[self.GetModel(self)]
end
