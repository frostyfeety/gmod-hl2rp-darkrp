--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)
AddDoorGroup("Альянс", TEAM_OTA1, TEAM_OTA2, TEAM_CP4, TEAM_CP3, TEAM_CP2, TEAM_CP1)
AddDoorGroup("ГСР", TEAM_CWU1, TEAM_CWU2, TEAM_CWU3, TEAM_CWU4, TEAM_CWU5, TEAM_CWU6)
AddDoorGroup("Повстанцы", TEAM_REBEL1, TEAM_REBEL2, TEAM_REBEL3)