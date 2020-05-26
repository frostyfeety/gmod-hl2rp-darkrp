-- Written by Team Ulysses, http://ulyssesmod.net/
module( "Utime", package.seeall )
if not SERVER then return end

if not sql.TableExists( "utime" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS utime ( steamid VARCHAR(255) PRIMARY KEY, totaltime INTEGER NOT NULL );" )
end

hook.Add( "PlayerInitialSpawn", "UTime.PlayerInitialSpawn", function( ply )
	local steamid = ply:SteamID()
	local row = sql.QueryRow( "SELECT totaltime FROM utime WHERE steamid = '"..steamid.."';" )
	local time = 0
	if row then
		time = row.totaltime
	else
		sql.Query( "INSERT into utime ( steamid, totaltime ) VALUES ( '"..steamid.."', 0 );" )
	end
	ply:SetUTime( time )
	ply:SetUTimeStart( CurTime() )
end)

function updatePlayer( ply )
	sql.Query( "UPDATE utime SET totaltime = "..math.floor(ply:GetUTimeTotalTime()).." WHERE steamid = '"..ply:SteamID().."';" )
end
hook.Add( "PlayerDisconnected", "UTimeDisconnect", updatePlayer )

timer.Create( "UTime.Timer", 67, 0, function()
	local players = player.GetAll()

	for _, ply in ipairs( players ) do
		if ply and ply:IsConnected() then
			updatePlayer( ply )
		end
	end
end)
