VOICEVIS = VOICEVIS or {}
VOICEVIS.VisualizerSetting = {}
VOICEVIS.Gamemode = 1
VOICEVIS.Visualizer = 6
VOICEVIS.ColorMode = 2
VOICEVIS.BorderColor = Color(40,40,40)
VOICEVIS.PanelColor = Color(25,25,25)
VOICEVIS.DefaultColor = Color(50,50,50,100)
VOICEVIS.DefaultOpacity = 100
VOICEVIS.CornerRounding = 0
VOICEVIS.Width = 250
VOICEVIS.Height = 50
VOICEVIS.YCord = 100

VOICEVIS.PlayerNameFont = {
	FONT = "Cordia New",
	SIZE = 22,
	THICKNESS = 1,
	COLOR = Color(160,160,160,120)
}

-- Settings for Player Tag Font
VOICEVIS.PlayerTagFont = {
	FONT = "Cordia New",
	SIZE = 19,
	THICKNESS = 1,
	COLOR = Color(160,160,160,60)
}

-- Settings for top right font
VOICEVIS.PlayerTopRightFont = {
	FONT = "Cordia New",
	SIZE = 16,
	THICKNESS = 1,
	COLOR = Color(160,160,160,10)
}

VOICEVIS.TopRightTextSetting = 4

-- Should there be a border around a player's avatar showing if they're a friend?
VOICEVIS.FriendAvatarBorder = true

-- The color of the border around a non friend
VOICEVIS.NotFriendColor = Color(129,196,214)

-- The color of the border around a friend
VOICEVIS.FriendColor = Color(129,214,171)

-- Here you can customize what players get what tags.
-- Keep in mind ULX uses ply:IsUserGroup("rank name") and Evolve uses ply:EV_GetRank() == "rank name"
function VOICEVIS:GetTagForPlayers(ply)
	if ply:IsSuperAdmin() then -- SuperAdmins get SuperAdmin tag.
		return "SuperAdmin"
		
	elseif ply:IsAdmin() then -- Admins will get Admin tag.
		return "Admin"
		
	end
end

-- Here you can customize what players get what colors for their visualizers
-- Keep in mind ULX uses ply:IsUserGroup("rank name") and Evolve uses ply:EV_GetRank() == "rank name"
function VOICEVIS:GetColorForPlayer(ply)
	if ply:SteamID() == "STEAM_0:1:209152329" then -- You should leave my steam ID here. :3
		return HSVToColor( math.abs(math.sin(0.3*RealTime())*128), 1, 1 ) -- Color fade
		
	elseif ply:IsAdmin() then -- Admins will get a light white color.
		return Color(255,255,255,60)
	end
end

-- Visualizer settings for visualizer #1
VOICEVIS.VisualizerSetting[1] = {
	WIDTH = 2, -- Width of each bar
	SPACING = 1, -- Space between each bar
	MULTIPLIER = 200 -- Multiplier to your voice
}

-- Visualizer settings for visualizer #3
VOICEVIS.VisualizerSetting[3] = {
	WIDTH = 1,
	SPACING = 0, -- Space between each box
	MULTIPLIER = 200, -- Multiplier for player voice
	BOXSIZE = 1 -- Size of the boxes
}

-- Visualizer settings for visualizer #4
VOICEVIS.VisualizerSetting[4] = {
	WIDTH = 5, -- Width of each line segment
	SPACING = -1, -- Space between each line segment
	MULTIPLIER = 100 -- Multiplier for player voice
}

-- Visualizer settings for visualizer #5
VOICEVIS.VisualizerSetting[5] = {
	AMOUNT = 60, -- Amount of circles
	MULTIPLIER = 200 -- Multiplier for player voice
}

-- Visualizer settings for visualizer #6
VOICEVIS.VisualizerSetting[6] = {
	WIDTH = 5, -- Width of each line segment
	SPACING = -1, -- Space between each line segment
	MULTIPLIER = 100 -- Multiplier for player voice
}
