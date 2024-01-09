//********************** MAPPING **************************/

//*********Map controller datum****************
/datum/team_deathmatch_map
	var/name = "TDM MAP"
	var/datum/map_template/ruin/map //This can be either the type path of the specific map template ruin you want or the name of it
	var/list/team_kills = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
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



	//Area Dirtier

/obj/TDM_map_modifier
	name = "Dirtifier Map Modifier"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/inited = 0 //making sure this object can only ever be triggered once.
	var/dirt_probability = 20 //The chance each turf will be dirtied.
	var/local_area = 1 //Should we dirty the area this object is sitting in?
	var/list/area_list = list() //lists of areas to dirty.
	var/list/turf_whitelist = list() //if we only want specific turfs to be dirtied, whitelist them here. if left empty then all turfs in the listed areas will be dirtied.
	var/list/turf_blacklist = list() //black list turfs to never be dirtied by this object.

/obj/TDM_map_modifier/Initialize()
	. = ..()
	if(inited)
		return
	inited = 1
	if(local_area)
		var/area/current_area = get_area(src)
		if(!(area_list in area_list))
			area_list += current_area.type
	for(var/a in area_list)
		var/area/A = locate(a)
		if(A)
			for(var/turf/open/floor/T in A)
				var/goforit = 1
				if(turf_whitelist.len)
					goforit = 0
					for (var/t in turf_whitelist)
						if(istype(T,t))
							goforit = 1
							break
				if(turf_blacklist.len)
					for (var/t in turf_blacklist)
						if(istype(T,t))
							goforit = 0
							break
				if(goforit && prob(dirt_probability))
					new /obj/effect/decal/cleanable/dirt(T)
	qdel(src)

/obj/TDM_map_modifier/Dust1
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

/obj/TDM_map_modifier/smeltery
	area_list = list(
		/area/TDM,
		/area/TDM/lobby,
		/area/TDM/red_base,
		/area/TDM/blue_base)
	turf_whitelist = list(
		/turf/open/floor/plating/rust,
		/turf/open/floor/sepia/TDM)
	turf_blacklist = list()



/********************** AREAS **************************/




/area/TDM
	name = "Arena"
	icon_state = "blue-red-d"
	has_gravity = TRUE
	dynamic_lighting = 0 //Fully lit at all times
	requires_power = 0 // Constantly powered
	always_unpowered = 0

/area/TDM/lobby
	name = "Lobby"
	icon_state = "blue-red2"

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