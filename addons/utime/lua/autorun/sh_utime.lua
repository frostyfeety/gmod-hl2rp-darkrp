module( "Utime", package.seeall )

local meta = FindMetaTable( "Player" )

function meta:GetUTime()
	return self:GetNWFloat( "TotalUTime" )
end

function meta:SetUTime( num )
	self:SetNWFloat( "TotalUTime", num )
end

function meta:GetUTimeStart()
	return self:GetNWFloat( "UTimeStart" )
end

function meta:SetUTimeStart( num )
	self:SetNWFloat( "UTimeStart", num )
end

function meta:GetUTimeSessionTime()
	return CurTime() - self:GetUTimeStart()
end

function meta:GetUTimeTotalTime()
	return self:GetUTime() + CurTime() - self:GetUTimeStart()
end