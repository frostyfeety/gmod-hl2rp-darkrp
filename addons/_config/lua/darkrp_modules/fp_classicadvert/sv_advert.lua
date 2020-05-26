function playerAdvert( ply, args )

	if args == "" or ply:Team() == TEAM_ADMIN or ply:isCP() or ply:Team() == TEAM_CITIZEN then

		ply:SendLua( string.format( [[notification.AddLegacy( "%s", 1, 5 )]], CLASSICADVERT.failMessage ) )
		return ""
	else

		for k,pl in pairs( player.GetAll() ) do
			local senderColor = team.GetColor( ply:Team() )
			DarkRP.talkToPerson( pl, senderColor, CLASSICADVERT.chatPrefix.." "..ply:Nick(), CLASSICADVERT.advertTextColor, args, ply )

		end

		return ""

	end

end
DarkRP.defineChatCommand( CLASSICADVERT.chatCommand, playerAdvert )