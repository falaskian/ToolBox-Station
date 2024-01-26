
/********************** MAP DATUMS **************************/

/*		//Template - These two datums are required for your map to be in the rotation

/datum/team_deathmatch_map/template
	name = "TDM Map Name"
	map = /datum/map_template/ruin/space/TDM_Template //This can be either the type path of the specific map template ruin you want or the name of it
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //Number of respawn points for each team
	round_time = 0 //How long does the round last
	ban_map = 0 //Is map active in map rotation
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
		"t4" = /datum/outfit/TDM/blue/t4)) //Outfits for each tier - t1,t2,t3,t4
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 1
	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating //Turf that will spawn after explosion deletes a turf

/datum/map_template/ruin/space/TDM_Template
	name = "TDM Template Name"
	id = "tdm_template"
	description = "Short description of your map"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Template.dmm" //Map path
*/



		//Lobby

/datum/map_template/ruin/space/TDM_lobby
	name = "Team DeathMatch Lobby"
	id = "tdm_lobby"
	description = "Team DeathMatch Lobby."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Lobby_Big.dmm"




/********************** ACTIVE MAP ROTATION **************************/

		//Dust1

/datum/team_deathmatch_map/TDM_Dust1
	name = "TDM Dust1"
	map = /datum/map_template/ruin/space/TDM_Dust1
	baseturf = /turf/open/floor/plating/asteroid

/datum/map_template/ruin/space/TDM_Dust1
	name = "TDM Dust1"
	id = "tdm_combat"
	description = "Dust1 - map for team deathmatch."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Dust1.dmm"



		//Smeltery

/datum/team_deathmatch_map/TDM_smeltery
	name = "TDM Smeltery"
	map = /datum/map_template/ruin/space/TDM_smeltery
	baseturf = /turf/open/floor/plating/asteroid/basalt

/datum/map_template/ruin/space/TDM_smeltery
	name = "TDM Smeltery"
	id = "tdm_smeltery"
	description = "The Smeltery map for team deathmatch."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Smeltery.dmm"



		//Mine

/datum/team_deathmatch_map/mine
	name = "TDM Mine"
	map = /datum/map_template/ruin/space/TDM_Mine
	team_deaths = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
	round_time = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15)
	repair_map = 0
	clean_map_items = 0
	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating/asteroid
	ban_map = 1

/datum/map_template/ruin/space/TDM_Mine
	name = "TDM Mine"
	id = "tdm_template"
	description = "Fight and protect your lizard miners."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Mine.dmm"



		//MiniStation

/datum/team_deathmatch_map/ministation
	name = "TDM MiniStation"
	map = /datum/map_template/ruin/space/TDM_MiniStation
	baseturf = /turf/open/floor/plating
	ban_map = 0
	items_respawn = 1
//		repair_map = 1
//		clean_map_items = 1
//		clean_map_bodies = 1

/datum/map_template/ruin/space/TDM_MiniStation
	name = "Team DeathMatch MiniStation"
	id = "tdm_ministation"
	description = "Mini Station map for team deathmatch."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation.dmm"



		//MiniStation - GreyTide

/datum/team_deathmatch_map/ministation_greytide
	name = "TDM MiniStation - GreyTide"
	map = /datum/map_template/ruin/space/TDM_MiniStation_GreyTide
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_red),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_blue))
//	repair_map = 1
	clean_map_items = 0
//	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating
	items_respawn = 1

/datum/map_template/ruin/space/TDM_MiniStation_GreyTide
	name = "GreyTide MiniStation"
	id = "greytide_ministation"
	description = "Mini Station map for Greytiding."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation_GreyTide.dmm"



		//DeathRun

/datum/team_deathmatch_map/deathrun
	name = "DeathRun"
	map = /datum/map_template/ruin/space/TDM_DeathRun
	team_deaths = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 3) //Blue Team (Death) have only 3 respawn points
	round_time = 0
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/Runner),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/Death))
	baseturf = /turf/open/floor/holofloor/grass


/datum/map_template/ruin/space/TDM_DeathRun
	name = "DeathRun"
	id = "tdm_deathrun"
	description = "DeathRun Map"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/DeathRun.dmm"



		//Hide&Seek

/datum/team_deathmatch_map/hide_and_seek
	name = "Hide&Seek"
	map = /datum/map_template/ruin/space/MimeAcademy
	baseturf = /turf/open/floor/plating
	team_deaths = list(TDM_RED_TEAM = 5,TDM_BLUE_TEAM = 30)
	round_time = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,12,24)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/hunter_clown),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/hider_mime))
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 0
	clean_map_bodies = 0
	items_respawn = 1

/datum/map_template/ruin/space/MimeAcademy
	name = "MimeAcademy"
	id = "tdm_template"
	description = "Academy for gifted mimes."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MimeAcademy.dmm"






/********************** COMMUNITY MADE MAPS **************************/

		//TrainWreck - by Luckyrichard

/datum/team_deathmatch_map/trainwreck
	name = "TDM TrainWreck"
	map = /datum/map_template/ruin/space/TDM_TrainWreck
	team_deaths = list(TDM_RED_TEAM = 25,TDM_BLUE_TEAM = 25)
	round_time = 0
	ban_map = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15,20)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 1
	clean_map_bodies = 1
	baseturf = /turf/open/chasm

/datum/map_template/ruin/space/TDM_TrainWreck
	name = "TDM TrainWreck"
	id = "tdm_trainwreck"
	description = "TrainWreck map made by Luckyrichard."
	prefix = "_maps/toolbox/TDM/Comunity_made/TrainWreck.dmm"





/********************** INACTIVE MAPS **************************/
/*
		//MiniStation - GreyTide - NoBase

/datum/team_deathmatch_map/ministation_greytide_nobase
	name = "TDM MiniStation - GreyTide NoBase"
	map = /datum/map_template/ruin/space/TDM_MiniStation_GreyTide_NoBase
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_red),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_blue))
//	repair_map = 1
	clean_map_items = 0
//	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating

/datum/map_template/ruin/space/TDM_MiniStation_GreyTide_NoBase
	name = "GreyTide MiniStation - nobase"
	id = "greytide_ministation_nobase"
	description = "Mini Station map for Greytiding with no spawn protection."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation_GreyTide_nobase.dmm"


*/











