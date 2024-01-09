//**********Map datums*************

//Lobby Template
/datum/map_template/ruin/space/TDM_lobby
	name = "Team DeathMatch Spawn Chamber"
	id = "tdm_lobby"
	description = "The team lobby for team deathmatch"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Lobby.dmm"


/********************** MAP DATUMS **************************/

/datum/team_deathmatch_map/TDM_chambers
	map = /datum/map_template/ruin/space/TDM_chambers
	//team_kills = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)

/datum/map_template/ruin/space/TDM_chambers
	name = "Team DeathMatch Combat Chambers"
	id = "tdm_combat"
	description = "The map for team deathmatch"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Dust1.dmm"

/datum/team_deathmatch_map/TDM_smeltery
	map = /datum/map_template/ruin/space/TDM_smeltery
	//team_kills = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)

/datum/map_template/ruin/space/TDM_smeltery
	name = "Team DeathMatch Smeltery Chambers"
	id = "tdm_smeltery"
	description = "The smeltery map for team deathmatch"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Smeltery.dmm"

/datum/team_deathmatch_map/grey_tide
	name = "TDM GreyTide"
	map = /datum/map_template/ruin/space/TDM_GreyTide //This can be either the type path of the specific map template ruin you want or the name of it
	team_kills = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15) //kill requirements to unlock each teir of guns, 4 teirs right now.
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_red),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_blue))

/datum/map_template/ruin/space/TDM_GreyTide
	name = "Team DeathMatch GreyTide"
	id = "tdm_greytide"
	description = "The arrivals primary tool storage map for team deathmatch"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/GreyTide.dmm"



		//MiniStation

/datum/team_deathmatch_map/ministation
	name = "TDM MiniStation"
	map = /datum/map_template/ruin/space/TDM_MiniStation //This can be either the type path of the specific map template ruin you want or the name of it
	team_kills = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15) //kill requirements to unlock each teir of guns, 4 teirs right now.
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))


/datum/map_template/ruin/space/TDM_MiniStation
	name = "Team DeathMatch MiniStation"
	id = "tdm_ministation"
	description = "Mini Station map for team deathmatch"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation.dmm"