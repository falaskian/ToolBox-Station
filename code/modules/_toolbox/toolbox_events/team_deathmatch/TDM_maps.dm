
/********************** MAP DATUMS **************************/

/*		//Template - These two datums are required for your map to be in the rotation

/datum/team_deathmatch_map/template
	name = "TDM MAP"
	map = /datum/map_template/ruin/space/TDM_Template //This can be either the type path of the specific map template ruin you want or the name of it
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //round ends when a team meets their number of deaths
	round_time = 0 //this is how many seconds before the round ends. if 0 its ignored and the round can only end based on kills.
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
	ban_map = 0 //Should the map be invisible?

	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 1
	clean_map_bodies = 1
	clean_exceptions = list(/obj/effect/decal) //atom type paths that will be skipped during clean up.

	baseturf = null //set this to the turf that will remain after an explosion, if left unchanged it will be space. this applies to the whole map
	off_limits = /area/TDM/offlimits //set an area where players will be teleported away from if they enter it. an off limits area
	no_firing_allowed_areas = list(TDM_RED_TEAM = list(/area/TDM/red_base),TDM_BLUE_TEAM = list(/area/TDM/blue_base)) //modifies weapon firing pin so they cant fire in these areas. based on teams

	//game balancing
	increase_kills_per_player = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 2) //how many points does the kill requirement go up for player.
	increase_kills_after_threshold = 10 //how many players ar eneeded before increase_kills_per_player starts taking effect.
	team_ratio = list(TDM_RED_TEAM = 0,TDM_BLUE_TEAM = 0) //Change these numbers to force a certain team size ratio. 0 means this is ignored.
	team_ratio_balance_threshold = 0.1 //how much overflow is allowed before team_ratio forces balance

	//item respawns
	items_respawn = 0 //do items respawn when picked up or moved away from their spawn location?
	respawn_time = 3000 //time untill an item respawns.
	item_respawn_blacklist = list(/obj/item/clothing/head/crown) //A black list for items you dont want respawning.

	//Change these to have custom team huds, if left unchanged it will be the default tiny blue and red squares.
	custom_huds_icon = null //Set this as the icon.dmi file you want to use
	custom_huds_states = list( //this list is the icon states for each time you want to use.
		TDM_RED_TEAM = null,
		TDM_BLUE_TEAM = null)

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
	teir_kills = list(0,3,6,15)
	baseturf = /turf/open/floor/plating/asteroid
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1

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
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1

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
	round_time = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15)
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1
	repair_map = 0
	clean_map_items = 0
	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating/asteroid
	ban_map = 0

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
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1
	items_respawn = 1
//		repair_map = 1
//		clean_map_items = 1
//		clean_map_bodies = 1

/datum/map_template/ruin/space/TDM_MiniStation
	name = "TDM MiniStation"
	id = "tdm_ministation"
	description = "Mini Station map for team deathmatch."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation.dmm"



		//Church

/datum/team_deathmatch_map/church
	name = "TDM Church"
	map = /datum/map_template/ruin/space/TDM_Church
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	round_time = 0
	ban_map = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 1
	clean_map_bodies = 1
	baseturf = /turf/open/floor/plating/asteroid/has_air

/datum/map_template/ruin/space/TDM_Church
	name = "TDM Church"
	id = "tdm_church"
	description = "Small size Church map for TDM"
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Church.dmm"



		//Box

/datum/team_deathmatch_map/box
	name = "TDM Box (1v1)"
	map = /datum/map_template/ruin/space/TDM_Box
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	round_time = 0
	ban_map = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 1
	clean_map_bodies = 1
	items_respawn = 1
	baseturf = /turf/open/floor/plating/asteroid

/datum/map_template/ruin/space/TDM_Box
	name = "TDM Box (1v1)"
	id = "tdm_church"
	description = "Tiny size map for TDM designed for 1v1-s."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Box.dmm"


		//MiniStation - GreyTide

/datum/team_deathmatch_map/ministation_greytide
	name = "GreyTide MiniStation"
	map = /datum/map_template/ruin/space/TDM_MiniStation_GreyTide
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_red),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/assistant_blue))
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1
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
	prefix = "_maps/toolbox/TDM/MiniStation_GreyTide_no_displaycases.dmm"



		//Hide&Seek - MimeAcademy

/datum/team_deathmatch_map/hide_and_seek
	name = "H&S MimeAcademy"
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
	custom_huds_icon = 'icons/oldschool/huds.dmi'
	custom_huds_states = list(
		TDM_RED_TEAM = "team_clown",
		TDM_BLUE_TEAM = "team_mime")
	list/team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 4)
	team_ratio_balance_threshold = 0.1

	var/list/tracked_farters = list()
	var/fart_timer = 200 //how long a mime has to stay in one place before farting
	var/fart_camper_distance = 3 //how far must a mime move to stop farting.
	var/fart_probability = 40 //The chance per server tick that a camping mime will fart.
	var/reset_fart_timer_after_fart = TRUE //when a mime farts should the timer reset? If FALSE then he will fart constantly while camping.

	var/list/mime_spells = list(/obj/effect/proc_holder/spell/targeted/mime/speak,/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/TDM)

//mimes fart when not moving around enough.
/datum/team_deathmatch_map/hide_and_seek/process_mob(mob/living/L,datum/toolbox_event/team_deathmatch/TDM)
	if(istype(L) && L.mind && L.mind.assigned_role == TDM.player_assigned_role && L.stat == CONSCIOUS)
		if(L.mind.special_role == TDM_BLUE_TEAM)
			var/turf/tdmT = TDM.player_locations[L]
			if(!tdmT)
				return
			if(!tracked_farters[L] && tdmT)
				tracked_farters[L] = list(
					"last_turf" = tdmT,
					"last_time" = world.time)
			var/list/mime_shit = tracked_farters[L]
			var/turf/last_turf = mime_shit["last_turf"]
			var/last_time = mime_shit["last_time"]
			var/too_close = 0
			if(get_dist(tdmT,last_turf) <= fart_camper_distance)
				too_close = 1
			var/timesup = 0
			if(isnum(last_time) && world.time >= last_time+fart_timer)
				timesup = 1
			if(!too_close)
				mime_shit["last_time"] = world.time
				mime_shit["last_turf"] = tdmT
			else if(too_close && timesup)
				if(prob(fart_probability))
					L.emote("fart")
					if(reset_fart_timer_after_fart)
						mime_shit["last_time"] = world.time
						mime_shit["last_turf"] = tdmT

/datum/team_deathmatch_map/hide_and_seek/post_player_spawn(mob/living/L,datum/toolbox_event/team_deathmatch/TDM)
	if(istype(L) && L.mind && L.mind.assigned_role == TDM.player_assigned_role && L.stat == CONSCIOUS)
		var/titlename = null
		if(L.mind.special_role == TDM_BLUE_TEAM)
			titlename = "mime"
			L.mind.miming = 1
			var/list/found_spells = list()
			for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
				found_spells += S.type
			for(var/spell in mime_spells)
				if(!(spell in found_spells))
					var/obj/effect/proc_holder/spell/S = new spell()
					L.mind.AddSpell(S)
		else if(L.mind.special_role == TDM_RED_TEAM)
			titlename = "clown"
		if(titlename && L.client)
			L.apply_pref_name(titlename, L.client)
		var/mob/living/carbon/human/H = L
		if(istype(H))
			var/obj/item/card/id/id = new /obj/item/card/id/()
			id.assignment = "Unknown"
			if(titlename)
				id.assignment = "[capitalize(titlename)]"
			id.registered_name = "[L.real_name]"
			id.update_label()
			if(titlename in icon_states(id.icon))
				id.icon_state = titlename
			H.equip_to_slot_or_del(id, SLOT_WEAR_ID)

/datum/map_template/ruin/space/MimeAcademy
	name = "H&S MimeAcademy"
	id = "tdm_template"
	description = "Academy for gifted mimes."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MimeAcademy.dmm"



		//Revolution - BoxStationSimple

/datum/team_deathmatch_map/bss
	name = "REV BoxStation_S"
	map = /datum/map_template/ruin/space/REV_BSS
	team_deaths = list(TDM_RED_TEAM = 10,TDM_BLUE_TEAM = 25)
	round_time = 0
	ban_map = 0
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15)
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/job/security),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/job/assistant))
	//control what gets cleaned during repair cycle
	repair_map = 1
	clean_map_items = 0
	clean_map_bodies = 1
	items_respawn = 1
	baseturf = /turf/open/floor/plating

	increase_kills_per_player = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 2)
	increase_kills_after_threshold = 10
	custom_huds_icon = 'icons/oldschool/huds.dmi'
	custom_huds_states = list(
		TDM_RED_TEAM = "team_red",
		TDM_BLUE_TEAM = "rev_head")
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 4)
	team_ratio_balance_threshold = 0.1

/datum/map_template/ruin/space/REV_BSS
	name = "REV BoxStation_S"
	id = "rev_box"
	description = "Modified BoxStation for TDM_REV gamemode."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/BoxStationSimple.dmm"



		//Nukies

/datum/team_deathmatch_map/nukies
	name = "TDM Nukies"
	map = /datum/map_template/ruin/space/TDM_Nukies //This can be either the type path of the specific map template ruin you want or the name of it
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //round ends when a team meets their number of deaths
	round_time = 0 //this is how many seconds before the round ends. if 0 its ignored and the round can only end based on kills.
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15) //kill requirements to unlock each teir of guns, 4 teirs right now.
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/nukie/nukie_hardsuit),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/nukie/security))
	ban_map = 0 //Should the map be invisible?

	//control what gets cleaned during repair cycle
	repair_map = 0
	clean_map_items = 0
	clean_map_bodies = 1
	clean_exceptions = list(/obj/effect/decal) //atom type paths that will be skipped during clean up.

	baseturf = /turf/open/floor/plating/asteroid/airless //set this to the turf that will remain after an explosion, if left unchanged it will be space. this applies to the whole map
	off_limits = /area/TDM/offlimits //set an area where players will be teleported away from if they enter it. an off limits area
	no_firing_allowed_areas = list(TDM_RED_TEAM = list(/area/TDM/red_base),TDM_BLUE_TEAM = list(/area/TDM/blue_base)) //modifies weapon firing pin so they cant fire in these areas. based on teams

	//game balancing
	increase_kills_per_player = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 2) //how many points does the kill requirement go up for player.
	increase_kills_after_threshold = 10 //how many players ar eneeded before increase_kills_per_player starts taking effect.
	team_ratio = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 3) //Change these numbers to force a certain team size ratio. 0 means this is ignored.
	team_ratio_balance_threshold = 0.1 //how much overflow is allowed before team_ratio forces balance

	//item respawns
	items_respawn = 0 //do items respawn when picked up or moved away from their spawn location?
	respawn_time = 3000 //time untill an item respawns.
	item_respawn_blacklist = list(/obj/item/clothing/head/crown) //A black list for items you dont want respawning.

	//Change these to have custom team huds, if left unchanged it will be the default tiny blue and red squares.
	custom_huds_icon = 'icons/oldschool/huds.dmi' //Set this as the icon.dmi file you want to use
	custom_huds_states = list( //this list is the icon states for each time you want to use.
		TDM_RED_TEAM = "synd",
		TDM_BLUE_TEAM = "team_blue")
	var/list/team_faction_settings = list(TDM_RED_TEAM = "Syndicate", TDM_BLUE_TEAM = "station_crew")

/datum/team_deathmatch_map/nukies/post_player_spawn(mob/living/L,datum/toolbox_event/team_deathmatch/TDM)
	if(istype(L) && L.mind && L.mind.assigned_role == TDM.player_assigned_role)
		if(L.mind.special_role in team_faction_settings)
			if("neutral" in L.faction)
				L.faction -= "neutral"
			if(!(team_faction_settings[L.mind.special_role] in L.faction))
				L.faction += team_faction_settings[L.mind.special_role]

/datum/map_template/ruin/space/TDM_Nukies
	name = "TDM Nukies"
	id = "tdm_nukies"
	description = "Modified ministation for nukie gamemode."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Nukies.dmm"



		//Planetary Nukies

/datum/team_deathmatch_map/planetary_nukies
	name = "TDM Planetary Nukies"
	map = /datum/map_template/ruin/space/TDM_Planetary_Nukies //This can be either the type path of the specific map template ruin you want or the name of it
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //round ends when a team meets their number of deaths
	round_time = 0 //this is how many seconds before the round ends. if 0 its ignored and the round can only end based on kills.
	team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	teir_kills = list(0,3,6,15) //kill requirements to unlock each teir of guns, 4 teirs right now.
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red/nukie,
		"t3" = /datum/outfit/TDM/red/nukie/t3,
		"t4" = /datum/outfit/TDM/red/nukie/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	ban_map = 0 //Should the map be invisible?

	//control what gets cleaned during repair cycle
	repair_map = 0
	clean_map_items = 0
	clean_map_bodies = 1
	clean_exceptions = list(/obj/effect/decal) //atom type paths that will be skipped during clean up.

	baseturf = /turf/open/floor/plating/asteroid/has_air //set this to the turf that will remain after an explosion, if left unchanged it will be space. this applies to the whole map
	off_limits = /area/TDM/offlimits //set an area where players will be teleported away from if they enter it. an off limits area
	no_firing_allowed_areas = list(TDM_RED_TEAM = list(/area/TDM/red_base),TDM_BLUE_TEAM = list(/area/TDM/blue_base)) //modifies weapon firing pin so they cant fire in these areas. based on teams

	//game balancing
	increase_kills_per_player = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 2) //how many points does the kill requirement go up for player.
	increase_kills_after_threshold = 10 //how many players ar eneeded before increase_kills_per_player starts taking effect.
	team_ratio = list(TDM_RED_TEAM = 1,TDM_BLUE_TEAM = 1) //Change these numbers to force a certain team size ratio. 0 means this is ignored.
	team_ratio_balance_threshold = 0.1 //how much overflow is allowed before team_ratio forces balance

	//item respawns
	items_respawn = 0 //do items respawn when picked up or moved away from their spawn location?
	respawn_time = 3000 //time untill an item respawns.
	item_respawn_blacklist = list(/obj/item/clothing/head/crown) //A black list for items you dont want respawning.

	//Change these to have custom team huds, if left unchanged it will be the default tiny blue and red squares.
	custom_huds_icon = 'icons/oldschool/huds.dmi' //Set this as the icon.dmi file you want to use
	custom_huds_states = list( //this list is the icon states for each time you want to use.
		TDM_RED_TEAM = "synd",
		TDM_BLUE_TEAM = "team_blue")
	var/list/team_faction_settings = list(TDM_RED_TEAM = "red_team", TDM_BLUE_TEAM = "blue_team")

/datum/team_deathmatch_map/planetary_nukies/post_player_spawn(mob/living/L,datum/toolbox_event/team_deathmatch/TDM)
	if(istype(L) && L.mind && L.mind.assigned_role == TDM.player_assigned_role)
		if(L.mind.special_role in team_faction_settings)
			if("neutral" in L.faction)
				L.faction -= "neutral"
			if(!(team_faction_settings[L.mind.special_role] in L.faction))
				L.faction += team_faction_settings[L.mind.special_role]

/datum/map_template/ruin/space/TDM_Planetary_Nukies
	name = "TDM Planetary Nukies"
	id = "tdm_planetary_nukies"
	description = "Modified planet based ministation for nukie gamemode."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Planetary_Nukies.dmm"


	//DustPlanet - Xenos

/datum/team_deathmatch_map/dustplanet_xenos
	name = "Dust Planet Xenos"
	map = /datum/map_template/ruin/space/DustPlanet_Xenos //This can be either the type path of the specific map template ruin you want or the name of it
	team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //round ends when a team meets their number of deaths
	round_time = 0 //this is how many seconds before the round ends. if 0 its ignored and the round can only end based on kills.
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
		"t1" = null))
	ban_map = 0

	//control what gets cleaned during repair cycle
	repair_map = 0
	clean_map_items = 0
	clean_map_bodies = 0
	clean_exceptions = list(/obj/effect/decal) //atom type paths that will be skipped during clean up.

	baseturf = /turf/open/floor/plating/asteroid/has_air //set this to the turf that will remain after an explosion, if left unchanged it will be space. this applies to the whole map
	off_limits = /area/TDM/offlimits //set an area where players will be teleported away from if they enter it. an off limits area
	no_firing_allowed_areas = list(TDM_RED_TEAM = list(/area/TDM/red_base),TDM_BLUE_TEAM = list(/area/TDM/blue_base)) //modifies weapon firing pin so they cant fire in these areas. based on teams

	//game balancing
	increase_kills_per_player = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 2) //how many points does the kill requirement go up for player.
	increase_kills_after_threshold = 10 //how many players ar eneeded before increase_kills_per_player starts taking effect.
	team_ratio = list(TDM_RED_TEAM = 3,TDM_BLUE_TEAM = 1) //Change these numbers to force a certain team size ratio. 0 means this is ignored.
	team_ratio_balance_threshold = 0.1 //how much overflow is allowed before team_ratio forces balance

	//item respawns
	items_respawn = 0 //do items respawn when picked up or moved away from their spawn location?
	respawn_time = 3000 //time untill an item respawns.
	item_respawn_blacklist = list(/obj/item/clothing/head/crown) //A black list for items you dont want respawning.

	//Change these to have custom team huds, if left unchanged it will be the default tiny blue and red squares.
	custom_huds_icon = 'icons/oldschool/huds.dmi' //Set this as the icon.dmi file you want to use
	custom_huds_states = list( //this list is the icon states for each time you want to use.
		TDM_RED_TEAM = "team_red",
		TDM_BLUE_TEAM = "team_blue")
	var/list/team_faction_settings = list(TDM_RED_TEAM = "red_team", TDM_BLUE_TEAM = "blue_team")

/datum/team_deathmatch_map/dustplanet_xenos/post_player_spawn(mob/living/L,datum/toolbox_event/team_deathmatch/TDM)
	if(istype(L) && L.mind && L.mind.assigned_role == TDM.player_assigned_role)
		var/mob/living/main_mob = L
		if(main_mob.mind.special_role == TDM_BLUE_TEAM)
			main_mob = L.change_mob_type(/mob/living/carbon/alien/larva/fast_growing, null, null, 1)
		if(main_mob && main_mob.mind.special_role in team_faction_settings)
			if("neutral" in main_mob.faction)
				main_mob.faction -= "neutral"
			if(!(team_faction_settings[main_mob.mind.special_role] in main_mob.faction))
				main_mob.faction += team_faction_settings[main_mob.mind.special_role]

/datum/map_template/ruin/space/DustPlanet_Xenos
	name = "Dust Planet Xenos"
	id = "tdm_dustplanet_xenos"
	description = "Modified planet based ministation for xeno gamemode."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/DustPlanet_Xenos.dmm"



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
	team_ratio = list(TDM_RED_TEAM = 5,TDM_BLUE_TEAM = 1)
	team_ratio_balance_threshold = 0.1


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




/********************** COMMUNITY MADE MAPS **************************/

		//TrainWreck - by Luckyrichard

/datum/team_deathmatch_map/trainwreck
	name = "TDM TrainWreck"
	map = /datum/map_template/ruin/space/TDM_TrainWreck
	team_deaths = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
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
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE





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
	name = "TDM MiniStation - GreyTide NoBase"
	id = "greytide_ministation_nobase"
	description = "Mini Station map for Greytiding with no spawn protection."
	unpickable = TRUE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/MiniStation_GreyTide_nobase.dmm"


*/











