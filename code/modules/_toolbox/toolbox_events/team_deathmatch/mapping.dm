//********************** MAPPING **************************/

//*********Map controller datum****************
/datum/team_deathmatch_map
	var/name = "TDM MAP"
	var/datum/map_template/ruin/map //This can be either the type path of the specific map template ruin you want or the name of it
	var/list/team_deaths = list(TDM_RED_TEAM = 20,TDM_BLUE_TEAM = 20) //round ends when a team meets their number of deaths
	var/round_time = 0 //this is how many seconds before the round ends. if 0 its ignored and the round can only end based on kills.
	var/list/team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	var/list/teir_kills = list(0,3,6,15) //kill requirements to unlock each teir of guns, 4 teirs right now.
	var/list/team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	var/ban_map = 0 //Should the map be invisible?

	//control what gets cleaned during repair cycle
	var/repair_map = 1
	var/clean_map_items = 1
	var/clean_map_bodies = 1
	var/list/clean_exceptions = list(/obj/effect/decal) //atom type paths that will be skipped during clean up.

	var/baseturf = null //set this to the turf that will remain after an explosion, if left unchanged it will be space. this applies to the whole map
	var/off_limits = /area/TDM/offlimits //players will be teleported away from if they enter it. an off limits areacan be an area type path or a list of area type paths.
	var/list/no_firing_allowed_areas = list(TDM_RED_TEAM = list(/area/TDM/red_base),TDM_BLUE_TEAM = list(/area/TDM/blue_base)) //modifies weapon firing pin so they cant fire in these areas. based on teams

	//game balancing
	var/list/increase_kills_per_player = list(TDM_RED_TEAM = 2,TDM_BLUE_TEAM = 2) //how many points does the kill requirement go up for player.
	var/increase_kills_after_threshold = 10 //how many players ar eneeded before increase_kills_per_player starts taking effect.
	var/list/team_ratio = list(TDM_RED_TEAM = 0,TDM_BLUE_TEAM = 0) //Change these numbers to force a certain team size ratio. 0 means this is ignored.
	var/team_ratio_balance_threshold = 0.1 //how much overflow is allowed before team_ratio forces balance

	//item respawns
	var/items_respawn = 0 //do items respawn when picked up or moved away from their spawn location?
	var/respawn_time = 3000 //time untill an item respawns.
	var/list/item_respawn_blacklist = list(/obj/item/clothing/head/crown) //A black list for items you dont want respawning.

	//Change these to have custom team huds, if left unchanged it will be the default tiny blue and red squares.
	var/custom_huds_icon = null //Set this as the icon.dmi file you want to use
	var/list/custom_huds_states = list( //this list is the icon states for each time you want to use.
		TDM_RED_TEAM = null,
		TDM_BLUE_TEAM = null)

/datum/team_deathmatch_map/proc/load_up()
	if(map)
		var/mapname
		if(istext(map))
			mapname = map
		else if(ispath(map))
			var/datum/map_template/ruin/R = map
			if(initial(R.name))
				mapname = initial(R.name)
		if(mapname && istext(mapname))
			map = SSmapping.space_ruins_templates[mapname]

/datum/team_deathmatch_map/proc/modify_object(atom/movable/AM)
	if(istype(AM,/obj/structure/displaycase/TDM_item_spawn))
		var/obj/structure/displaycase/TDM_item_spawn/display = AM
		display.update_to_map(src)

/datum/team_deathmatch_map/proc/process_map(datum/toolbox_event/team_deathmatch/TDM)

/datum/team_deathmatch_map/proc/process_mob(mob/M,datum/toolbox_event/team_deathmatch/TDM)

/datum/team_deathmatch_map/proc/post_player_spawn(mob/living/M,datum/toolbox_event/team_deathmatch/TDM)

//************* TURFS *************


		//Metal Walls

/turf/closed/indestructible/riveted/TDM
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms. It looks very sturdy."


/turf/closed/indestructible/riveted/TDM/wall
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"


/turf/closed/indestructible/riveted/TDM/wall/rusty
	name = "rusted wall"
	desc = "A rusted metal wall. It looks very sturdy."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	icon_state = "wall"


		//Floor


/turf/open/floor/sepia/TDM
	slowdown = 0

/turf/open/floor/sepia/TDM/dark_10
	color = "#e6e6e6"


		//Stairs

/turf/open/floor/plasteel/stairs/TDM
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs_t"
	slowdown = 1

/turf/open/floor/plasteel/stairs/TDM/up
	dir = 1

/turf/open/floor/plasteel/stairs/TDM/right
	dir = 4

/turf/open/floor/plasteel/stairs/TDM/left
	dir = 8


/turf/open/floor/plasteel/stairs/TDM/sepia
	color = "#ae9b84"

/turf/open/floor/plasteel/stairs/TDM/sepia/up
	dir = 1

/turf/open/floor/plasteel/stairs/TDM/sepia/right
	dir = 4

/turf/open/floor/plasteel/stairs/TDM/sepia/left
	dir = 8


		//Mineral Walls

/turf/closed/mineral/has_air
	turf_type =	/turf/open/floor/plating/asteroid


		//Planetary turf with sky light

/turf/open/floor/plating/asteroid/has_air/desert_flora/TDM
		//Night
	light_color = "#945c34"
	light_power = 0.013
	light_range = 4


		//Snow Turfs

/turf/open/floor/plating/asteroid/snow/snowball
	name = "snow"
	desc = "Looks cold."
	baseturfs = /turf/open/floor/plating/asteroid/snow/snowball
	slowdown = 0
	environment_type = "snow"
	planetary_atmos = FALSE
	//archdrops = list() //maybe turn drops off for TDM?

/turf/open/floor/plating/asteroid/snow/snowball/attack_hand(mob/user)
	if(iscyborg(user))
		return
	if(do_after(user, 2))
		user.put_in_hands(new /obj/item/ammo_casing/snowball())
		to_chat(user, "<span class='notice'>You grab some snow and make a snowball.</span>")
		playsound(loc, 'sound/effects/shovel_dig.ogg', 15, 1, -3)




/********************** AREAS **************************/


/area/TDM
	name = "Arena"
	icon_state = "blue-red-d"
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED //Fully lit at all times
	requires_power = FALSE // Constantly powered
	always_unpowered = 0

/area/TDM/lobby
	name = "Lobby"
	icon_state = "blue-red2"

/area/TDM/lobby/nospawn
	name = "Lobby"
	desc = "Players wont spawn in this area."
	icon_state = "space_near"

/area/TDM/lobby/red
	name = "Join Red Team"
	icon_state = "red2"

/area/TDM/lobby/blue
	name = "Join Blue Team"
	icon_state = "blue2"

/area/TDM/red_base
	name = "Red Base"
	icon_state = "red2"


/area/TDM/blue_base
	name = "Blue Base"
	icon_state = "blue2"

/area/TDM/offlimits
	name = "Off Limits Area"
	icon_state = "space_near"


		//Dark Powered

/area/TDM/dark_powered
	icon_state = "space"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	has_gravity = STANDARD_GRAVITY
	requires_power = TRUE

/area/TDM/dark_powered/Initialize()
	. = ..()
	requires_power = FALSE


/area/TDM/dark_powered/red_base
	name = "Red Base"
	icon_state = "red2"


/area/TDM/dark_powered/blue_base
	name = "Blue Base"
	icon_state = "blue2"




/********************** EFFECTS **************************/

	//Blue Team corpse

/obj/effect/dead_body_spawner/blue_team_corpse
	name = "Blue Team Member Corpse"
	color = "#3645FF"
	outfit = /datum/outfit/TDM/blue

	//Red Team corpse

/obj/effect/dead_body_spawner/red_team_corpse
	name = "Red Team Member Corpse"
	color = "#00cc00"
	outfit = /datum/outfit/TDM/red




/********************** AREA MODIFIER **************************/

/obj/TDM_map_modifier
	name = "Map Modifier"
	desc = "Used to mass modiufy maps"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/inited = 0 //making sure this object can only ever be triggered once.
	var/list/ruin_turfs = null


/obj/TDM_map_modifier/Initialize()
	. = ..()
	if(inited)
		return
	inited = 1
	spawn(0)
		run_bs()
		qdel(src)



/obj/TDM_map_modifier/proc/run_bs()
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/team_deathmatch/E = SStoolbox_events.is_active(t)
			if(istype(E) && E.active)
				while(E.building_ruin)
					sleep(1)
	ruin_turfs = get_turfs()



/obj/TDM_map_modifier/proc/get_turfs()
	. = list()
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/team_deathmatch/E = SStoolbox_events.is_active(t)
			if(istype(E) && E.active)
				var/datum/team_deathmatch_map/map = E.get_current_map()
				if(map.map)
					. = E.get_all_ruin_floors(map.map)

/obj/TDM_map_modifier/grass_mouse_opacifier
	name = "Grass Map Modifier"
	desc = "Used to mass modiufy grass mouse_opacity variable to prevent bullets from hitting grass"

/obj/TDM_map_modifier/grass_mouse_opacifier/run_bs()
	. = ..()
	if(ruin_turfs.len)
		for(var/turf/T in ruin_turfs)
			for(var/obj/structure/flora/ausbushes/A in T)
				A.mouse_opacity = 0


/obj/TDM_map_modifier/mass_turf_modifier
	name = "Dirtifier Map Modifier"
	var/probability = 20 //The chance each turf will be dirtied.
	var/max_count = 0 //picks this many random turfs and only affects those.
	var/local_area = 1 //Should we dirty the area this object is sitting in?
	var/list/area_list = list() //lists of areas to dirty.
	var/list/turf_whitelist = list() //if we only want specific turfs to be dirtied, whitelist them here. if left empty then all turfs in the listed areas will be dirtied.
	var/list/turf_blacklist = list() //black list turfs to never be dirtied by this object.


/obj/TDM_map_modifier/mass_turf_modifier/run_bs()
	. = ..()
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/team_deathmatch/E = SStoolbox_events.is_active(t)
			if(istype(E) && E.active)
				while(E.building_ruin)
					sleep(1)
	if(local_area)
		var/area/current_area = get_area(src)
		if(!(area_list in area_list))
			area_list += current_area.type
	var/list/turfs = list()
	for(var/area/A in world)
		if(A.type in area_list)
			for(var/turf/open/floor/T in A)
				if(T in turfs)
					continue
				var/goforit = 1
				if(turf_whitelist.len)
					goforit = 0
					for(var/t in turf_whitelist)
						if(istype(T,t))
							goforit = 1
							break
				if(turf_blacklist.len)
					for(var/t in turf_blacklist)
						if(istype(T,t))
							goforit = 0
							break
				if(goforit)
					turfs += T
	var/max_searched = turfs.len
	if(max_count)
		max_searched = max_count
	for(var/i=max_searched,i>0,i--)
		var/turf/T = pick(turfs)
		turfs -= T
		if(prob(probability) && run_turf(T))
			return

/obj/TDM_map_modifier/mass_turf_modifier/proc/run_turf(turf/T) //if this proc returns TRUE then it stops the entire process.
	new /obj/effect/decal/cleanable/dirt(T)


	//Dust1 dirtifier

/obj/TDM_map_modifier/mass_turf_modifier/Dust1
	area_list = list(
		/area/TDM,
		/area/TDM/lobby,
		/area/TDM/red_base,
		/area/TDM/blue_base)
	turf_whitelist = list(
		/turf/open/floor/sepia/TDM/dark_10)
	turf_blacklist = list(
		/turf/open/floor/plasteel/stairs,
		/turf/open/floor/plating/asteroid)


	//Smeltry dirtifier

/obj/TDM_map_modifier/mass_turf_modifier/smeltery
	area_list = list(
		/area/TDM,
		/area/TDM/lobby,
		/area/TDM/red_base,
		/area/TDM/blue_base)
	turf_whitelist = list(
		/turf/open/floor/plating/rust,
		/turf/open/floor/sepia/TDM)
	turf_blacklist = list()


	//DustPlanet - Xeno dead body spawner

/obj/TDM_map_modifier/mass_turf_modifier/xeno_survivors
	probability = 100
	max_count = 6
	area_list = list(
		/area/TDM,
		/area/TDM/lobby,
		/area/TDM/red_base,
		/area/TDM/blue_base)
	turf_whitelist = list(
		/turf/open/floor/plasteel,
		/turf/open/floor/plating)
	turf_blacklist = list()

/obj/TDM_map_modifier/mass_turf_modifier/xeno_survivors/run_turf(turf/T)
	new /obj/effect/dead_body_spawner/blue_team_corpse(T)


