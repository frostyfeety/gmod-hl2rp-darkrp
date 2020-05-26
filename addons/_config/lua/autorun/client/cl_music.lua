local songs = {
    "sound/music/hl2_song26_trainstation1.mp3",
    "sound/music/hl2_song27_trainstation2.mp3"
}

net.Receive("rp_join_music", function()
    local path = table.Random(songs)
    sound.PlayFile( path, "noplay", function( station, errCode, errStr )
    	if ( IsValid( station ) ) then
            station:SetVolume(0.4)
    		station:Play()
    	else
    		print( "[MinervaRP] Error playing sound!", errCode, errStr )
    	end
    end )
end)

net.Receive("ras_zombie_event_ambient", function()
    sound.PlayFile( "sound/ambient/creatures/town_zombie_call1.wav", "noplay", function( station, errCode, errStr )
    	if ( IsValid( station ) ) then
            station:SetVolume(0.5)
    		station:Play()
    	else
    		print( "[MinervaRP] Error playing sound!", errCode, errStr )
    	end
    end )

    timer.Simple(5, function()
    sound.PlayFile( "sound/npc/overwatch/cityvoice/fprison_containexogens.wav", "noplay", function( station, errCode, errStr )
    	if ( IsValid( station ) ) then
            station:SetVolume(1)
    		station:Play()
    	else
    		print( "[MinervaRP] Error playing sound!", errCode, errStr )
    	end
    end )
    end)

    local musics = {
        "sound/music/hl2_song1.mp3",
        "sound/music/ravenholm_1.mp3",
        "sound/music/hl2_song17.mp3",
        "sound/music/hl2_song19.mp3"
    }

    timer.Simple(11.5, function()
    sound.PlayFile( musics[math.random(1,#musics)], "noplay", function( station, errCode, errStr )
    	if ( IsValid( station ) ) then
            station:SetVolume(0.4)
    		station:Play()
    	else
    		print( "[MinervaRP] Error playing sound!", errCode, errStr )
    	end
    end )
    end)
end)