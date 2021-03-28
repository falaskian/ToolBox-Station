
/********************** This object is used to modify the entire zlevel where it spawns. **************************/

/obj/full_zlevel_modifier
	name = "Full Z-level Modifier"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/inited = 0

/obj/full_zlevel_modifier/Initialize()
	if(inited)
		return 1
	inited = 1

/obj/full_zlevel_modifier/groundbase
	name = "Groundbase Initializer"
	var/base_turf = /turf/open/floor/plating/asteroid/has_air

/obj/full_zlevel_modifier/groundbase/Initialize()
	. = ..()
	if(.)
		return
	var/list/entirezlevel = block(locate(1,1,z),locate(world.maxx,world.maxy,z))
	for(var/turf/T in entirezlevel)
		if(T && T.z == z)
			if(istype(T,/turf/open/space))
				T.ChangeTurf(base_turf, base_turf)
				var/area/A = locate(/area/gb_away/explored)
				if(A)
					T.change_area(T.loc, A)
			var/reset_baseturf = 0
			if(islist(T.baseturfs) && ((/turf/baseturf_bottom in T.baseturfs)||(/turf/open/space in T.baseturfs)))
				reset_baseturf = 1
			else if(T.baseturfs in list(/turf/baseturf_bottom,/turf/open/space,/turf/open/space/basic))
				reset_baseturf = 1
			if(reset_baseturf)
				T.baseturfs = base_turf
	qdel(src)

/********************** SPAWNERS **************************/

/mob/living/simple_animal/hostile/spawner
	name = "monster nest"
	icon = 'icons/mob/nest.dmi'
	icon_state = "hole"
	health = 150
	maxHealth = 150
	gender = NEUTER
	var/list/spawned_mobs = list()
	var/max_mobs = 5
	var/spawn_delay = 0
	var/spawn_time = 30 //30 seconds default
	var/mob_types = list(/mob/living/simple_animal/hostile/carp = 1)
	var/spawn_text = "emerges from"
	status_flags = 0
	anchored = TRUE
	AIStatus = AI_OFF
	a_intent = INTENT_HARM
	stop_automated_movement = 1
	wander = 0
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 350
	layer = BELOW_MOB_LAYER
	del_on_death = 1


/mob/living/simple_animal/hostile/spawner/Destroy()
	for(var/mob/living/simple_animal/L in spawned_mobs)
		if(L.nest == src)
			L.nest = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/spawner/Life()
	. = ..()
	if(!.) // dead
		return
	spawn_mob()

/mob/living/simple_animal/hostile/spawner/proc/spawn_mob()
	if(spawned_mobs.len >= max_mobs)
		return 0
	if(spawn_delay > world.time)
		return 0
	spawn_delay = world.time + spawn_time*10
	var/chosen_mob_type = pickweight(mob_types)
	var/mob/living/simple_animal/L = new chosen_mob_type(src.loc)
	spawned_mobs += L
	L.nest = src
	L.faction = src.faction
	visible_message("<span class='danger'>[L] [spawn_text] [src].</span>")


/mob/living/simple_animal/hostile/spawner/lizard
	name = "lizard nest"
	icon = 'icons/mob/nest.dmi'
	icon_state = "ash_walker_nest"
	faction = list("lizard")
	light_power = 0.5
	light_range = 7
	max_mobs = 3
	mob_types = list(/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green = 1)
	loot = list(/obj/effect/lizard_nest_gib)

/obj/effect/lizard_nest_gib
	name = "lizard nest gibbing"
	desc = "Disgusting! Im covered in gibs."

/obj/effect/lizard_nest_gib/Initialize()
	. = ..()
	visible_message("<span class='boldannounce'>The tendril squirms in pain.</span>")
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, 0, 50, 1, 1)
	new /obj/effect/gibspawner/generic/lizard_nest(loc)
	new /obj/item/reagent_containers/food/snacks/egg/lizard_egg(loc)
	qdel(src)

/obj/effect/gibspawner/generic/lizard_nest
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core/nest)
	gibamounts = list(4,4,1)

/obj/effect/decal/cleanable/blood/gibs/core/nest
	name = "lizard nest remains"
	random_icon_states = list("gibmid3")



/mob/living/simple_animal/hostile/spawner/lizard/with_props/Initialize()
	.=..()
	var/list/turf_list = list()
	var/turf/E = get_step(loc, EAST)
	var/turf/W = get_step(loc, WEST)
	var/list/L_R = list(E,W)

	for(var/turf/turf in L_R)
		if(istype(turf, /turf/closed))
			continue
		var/shit_in_the_way = 0
		for(var/obj/O in turf)
			if(O.density)
				shit_in_the_way = 1
				break
		if(!shit_in_the_way)
			new /obj/structure/pike_torch(turf)


	for(var/turf/T in range(3, src))
		turf_list += T
		turf_list -= L_R
		turf_list -= src.loc

	var/turf/gibs = pick(turf_list)
	new /obj/effect/decal/cleanable/blood/gibs/up(gibs)
	turf_list -= list(gibs)

	var/turf/head_pike = pick(turf_list)
	new /obj/structure/headpike/spawnable/bone(head_pike)
	turf_list -= list(head_pike)

	var/turf/head_pike2 = pick(turf_list)
	new /obj/structure/headpike/spawnable/bone(head_pike2)
	turf_list -= list(head_pike2)


/mob/living/simple_animal/hostile/spawner/cave_spider
	name = "cave spider nest"
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "spider_nest"
	faction = list("cave")
	light_power = 0.5
	light_range = 7
	max_mobs = 5
	spawn_time = 30
	mob_types = list(/mob/living/simple_animal/hostile/poison/giant_spider/hunter/cave = 7, /mob/living/simple_animal/hostile/poison/giant_spider/cave = 1)
	loot = list(/obj/effect/cave_spider_nest_death)

/mob/living/simple_animal/hostile/spawner/cave_spider/Initialize()
	.=..()
	new /obj/structure/spider/stickyweb/aoe_spawn(loc)

/obj/effect/cave_spider_nest_death
	name = "cave spider nest death"
	desc = "Run!"

/obj/effect/cave_spider_nest_death/Initialize()
	. = ..()
	visible_message("<span class='boldannounce'>Spider nest shakes violently!</span>")
	visible_message("<span class='boldannounce'>Tarantula bursts out of the spider nest!</span>")
	playsound(loc,'sound/items/poster_ripped.ogg', 200, 0, 50, 1, 1)
	new /obj/effect/gibspawner/generic(loc)
	new /obj/item/reagent_containers/food/snacks/spidereggs(loc)
	var/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/cave/T = new(loc)
	T.faction = list("cave")
	qdel(src)


/mob/living/simple_animal/hostile/spawner/spooky_skeleton
	name = "pile of bones"
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "pile_of_bones"
	faction = list("cave")
	light_power = 0.5
	light_range = 7
	max_mobs = 4
	spawn_time = 20
	mob_types = list(/mob/living/simple_animal/hostile/skeleton/spooky = 1)
	loot = list(/obj/effect/spooky_skeleton_spawner_death)

/obj/effect/spooky_skeleton_spawner_death
	name = "pile of bones collapse"
	desc = "HE NEEDS SOME MILK!"

/obj/effect/spooky_skeleton_spawner_death/Initialize()
	. = ..()
	visible_message("<span class='boldannounce'>Huge spooky skeleton emerges out of pile of bones as it collapses!</span>")
	playsound(loc,'sound/hallucinations/growl1.ogg', 200, 0, 50, 1, 1)
	var/mob/living/simple_animal/hostile/skeleton/spooky/huge/H = new(loc)
	H.faction = list("cave")
	H.maxHealth = 200
	H.health = 200
	qdel(src)



/*
	var/tile_type = pick(/obj/structure/stone_tile/cracked, /obj/structure/stone_tile/surrounding_tile/cracked, /obj/structure/stone_tile/block/cracked)
	if(prob(70))
		for(var/turf/T in range(3, src))
			var/obj/structure/stone_tile/S = new tile_type(T)
			S.dir = pick(1,2,4,8)
*/
/********************** LIZARD SLAVES **************************/

GLOBAL_LIST_EMPTY(tribalslave_ore_dropoff_point)

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave
	name = "lizard slave"
	forcename = 1
	race = "lizard"
	attacktext = "slashes"
	environment_smash = 0
	gold_core_spawnable = 0
	equipped_items = list(/obj/item/clothing/under/rank/prisoner = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/pickaxe)
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(150,200)
	lizardskincolor_blue = list(1,25)
	retaliation = 1
	search_objects = 0
	wanted_objects = list(/obj/structure/closet/crate,/obj/structure/lizard_ore_node)
	var/obj/structure/lizard_ore_node/node_target
	var/list/memory_nodes = list()
	var/obj/structure/closet/crate/crate_memory
	var/size_modifier = 0.85

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/Initialize()
	.=..()
	transform *= size_modifier

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/create_human()
	var/mob/M = ..()
	M.transform *= size_modifier
	return M

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/ListTargets()
	var/list/targs = ..()
	if(!islist(targs))
		targs = list()
	var/turf/src_turf = get_turf(src)
	if(!targs.len)
		if(!has_ore())
			for(var/obj/structure/lizard_ore_node/node in GLOB.lizard_ore_nodes)
				if(src_turf.z == node.z)
					targs += node
		else
			var/list/dropoff_points = list()
			if(src_turf)
				for(var/text in GLOB.tribalslave_ore_dropoff_point)
					var/list/dropoff_point = params2list(text)
					var/turf/T = locate(text2num(dropoff_point["x"]),text2num(dropoff_point["y"]),text2num(dropoff_point["z"]))
					if(T)
						if(T.z != src_turf.z)
							continue
						dropoff_points += T
			if(dropoff_points.len)
				var/turf/dropoff_point = pick(dropoff_points)
				var/list/crates = list()
				for(var/obj/structure/closet/crate/crate in view(8, dropoff_point))
					if(!istype(crate, /obj/structure/closet/crate/secure))
						crates += crate
				if(crates.len)
					if(!crate_memory || !(crate_memory in crates))
						crate_memory = pick(crates)
					targs += crate_memory
	return targs

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/AttackingTarget()
	if(istype(target, /obj/structure/lizard_ore_node))
		var/obj/structure/lizard_ore_node/N = target
		N.enter_node(src)
		return
	else if(istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/C = target
		if(!C.opened)
			C.open()
		for(var/obj/item/stack/ore/ore in src)
			ore.forceMove(C.loc)
		spawn(15)
			C.close()
		return
	.=..()

/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/proc/has_ore()
	for(var/obj/item/stack/ore/ore in src)
		return 1
	return 0


/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/dead
	humanoid_held_items = list()
	start_dead = 1


//ORE NODE

GLOBAL_LIST_EMPTY(lizard_ore_nodes)

/obj/structure/lizard_ore_node
	name = "cavern"
	desc = "Dangerous caves only tribal lizards know how to navigate."
	icon = 'icons/mob/nest.dmi'
	icon_state = "hole"
	anchored = 1
	density = 0
	var/list/miners = list()
	var/list/allowed_miners = list(/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave = "time=10;amount=3")
	var/eject_dir = SOUTH
	resistance_flags = INDESTRUCTIBLE
	var/list/ore = list(/obj/item/stack/ore/iron = 40,
						/obj/item/stack/ore/uranium = 5,
						/obj/item/stack/ore/diamond = 1,
						/obj/item/stack/ore/gold = 10,
						/obj/item/stack/ore/titanium = 11,
						/obj/item/stack/ore/silver = 12,
						/obj/item/stack/ore/plasma = 20,
						/obj/item/stack/ore/bluespace_crystal = 1,
						/turf/closed/mineral/copper = 15,
						/obj/item/stack/ore/glass/basalt = 5,
						/obj/item/stack/ore/bananium = 1)

/obj/structure/lizard_ore_node/Initialize()
	GLOB.lizard_ore_nodes.Add(src)
	.=..()
	START_PROCESSING(SSobj, src)

/obj/structure/lizard_ore_node/proc/enter_node(atom/movable/AM)
	for(var/path in allowed_miners)
		if(istype(AM, path))
			AM.moveToNullspace()
			var/list/params_list = params2list(allowed_miners[path])
			var/thetime = text2num(params_list["time"])
			miners[AM] = world.time+thetime*10
			if(istype(AM, /mob/living/simple_animal))
				var/mob/living/simple_animal/animal = AM
				animal.AIStatus = AI_OFF
			break
	AM.visible_message("<span class='boldannounce'>[AM] enters [src].</span>")

/obj/structure/lizard_ore_node/process()
	for(var/atom/movable/AM in miners)
		var/time = miners[AM]
		if(!isnum(time))
			time = world.time+100
		if(world.time >= time)
			eject(AM)

/obj/structure/lizard_ore_node/proc/eject(atom/movable/AM)
	for(var/path in allowed_miners)
		if(istype(AM, path))
			var/list/params_list = params2list(allowed_miners[path])
			var/theamount = text2num(params_list["amount"])
			for(var/i=theamount,i>0,i--)
				var/selected_ore = pickweight(ore)
				new selected_ore(AM)
			var/turf/T = get_step(loc, eject_dir)
			if(!T)
				T = loc
			AM.visible_message("<span class='boldannounce'>[AM] emerges from [src].</span>")
			AM.forceMove(T)
			if(istype(AM, /mob/living/simple_animal))
				var/mob/living/simple_animal/animal = AM
				animal.AIStatus = AI_ON
			miners.Remove(AM)

/obj/structure/lizard_ore_node/Destroy()
	GLOB.lizard_ore_nodes.Remove(src)
	for(var/atom/movable/AM in miners)
		eject(AM)
	//add effect here

/obj/effect/slave_ore_dropoff_point
	name = "slave ore dropoff point"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/make_decal = 0

/obj/effect/slave_ore_dropoff_point/Initialize()
	var/turf/T = get_turf(src)
	if(T)
		GLOB.tribalslave_ore_dropoff_point.Add("x=[T.x];y=[T.y];z=[T.z]")
		if(make_decal)
			var/turf/left = locate(T.x-1,T.y,T.z)
			var/turf/right = locate(T.x+1,T.y,T.z)
			if(left && right)
				var/list/sides = list(left,T,right)
				for(var/turf/side in sides)
					var/decalnumber = 1
					var/obj/effect/decal/D = new(side)
					D.icon = 'icons/oldschool/objects.dmi'
					D.icon_state = "oredrop[decalnumber]"
					decalnumber++
	qdel(src)

//LIZARD EGGS
/obj/item/reagent_containers/food/snacks/egg/lizard_egg
	name = "lizard egg"
	icon = 'icons/oldschool/food.dmi'
	icon_state = "lizard_egg"
	desc = "Lizard egg that can be hatched using incubator."

//INCUBATOR
/obj/machinery/incubator
	name = "incubator"
	desc = "A pod for hatching eggs."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_0"
	color = "#ffd9b3"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/incubator
	var/amount_grown = 0
	var/obj/item/reagent_containers/food/snacks/egg/lizard_egg/egg = null
	var/egg_printslast = null
	var/status = "Its empty."
	var/incubation_failed = null

/obj/machinery/incubator/attackby(obj/item/I, mob/user, params)
	if(!egg && !incubation_failed && default_deconstruction_screwdriver(user, "pod_0_maintenance", initial(icon_state), I))
		return

	if(default_deconstruction_crowbar(I))
		qdel(src)
		return

	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		var/obj/item/reagent_containers/food/snacks/egg/E = I
		if(stat & (BROKEN|NOPOWER))
			to_chat(user, "<span class='warning'>[src] is out of order!</span>")
			return

		if(egg)
			to_chat(user, "<span class='warning'>An [E] is already in [src]!</span>")
			return

		if(!user.transferItemToLoc(E, src))
			to_chat(user, "<span class='warning'>[E] is stuck to your hand!</span>")
			return

		egg = E
		to_chat(user, "<span class='notice'>You insert [E] into [src].</span>")
		egg_printslast = E.fingerprintslast
		status = "[amount_grown]%"
		update_icon()
		if(incubation_failed)
			new /obj/effect/gibspawner/generic(loc)
			incubation_failed = null
			update_icon()

	else
		return ..()

/obj/machinery/incubator/process()
	if(stat & (BROKEN|NOPOWER))
		if(egg)
			QDEL_NULL(egg)
			amount_grown = 0
			incubation_failed = TRUE
			update_icon()
			return
	if(egg)
		amount_grown += rand(0,2)
		if(amount_grown >= 100)
			if(egg.type == /obj/item/reagent_containers/food/snacks/egg/lizard_egg)
				var/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/L = new /mob/living/simple_animal/hostile/randomhumanoid/tribal_slave(src.loc)
				log_game("[L] spawned via incubator by [egg_printslast] at [AREACOORD(src)]")
			else
				var/mob/living/simple_animal/chicken/C = new /mob/living/simple_animal/chicken(src.loc)
				C.eggsFertile = 0
			QDEL_NULL(egg)
			egg_printslast = null
			amount_grown = 0
			update_icon()


/obj/machinery/incubator/Destroy()
	QDEL_NULL(egg)

/obj/machinery/incubator/attack_hand(mob/user)
	if(incubation_failed)
		new /obj/effect/gibspawner/generic(loc)
		egg = qdel()
		incubation_failed = null
		amount_grown = 0
		update_icon()

/obj/machinery/incubator/examine(mob/user)
	. = ..()
	if(incubation_failed)
		to_chat(user, "<span class='warning'>Incubation Failed!</span>")
		return
	if(egg)
		to_chat(user, "Progress: [amount_grown]%")
		return
	else
		to_chat(user, "It is empty.")
		return

/obj/machinery/incubator/update_icon()
	if(egg)
		icon_state = "pod_1"
	else if(incubation_failed)
		icon_state = "pod_g"
	else
		icon_state = "pod_0"

/datum/design/board/incubator
	name = "Machine Design (Incubator)"
	desc = "The circuit board for an incubator."
	id = "incubator"
	build_path = /obj/item/circuitboard/machine/incubator
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
	category = list ("Research Machinery")

/obj/item/circuitboard/machine/incubator
	name = "Incubator (Machine Board)"
	build_path = /obj/machinery/incubator
	req_components = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)





/********************** LOOTDROPS **************************/


/obj/effect/spawner/lootdrop/minecart
	name = "gambling valuables spawner"
	loot = list(
				/obj/item/gun/ballistic/revolver/russian = 5,
				/obj/item/storage/box/syndie_kit/throwing_weapons = 1,
				/obj/item/toy/cards/deck/syndicate = 2
				)

/obj/effect/spawner/lootdrop/away_GB_gun
	name = "GB gun spawner with pin replacer"
	loot = list()

/obj/effect/spawner/lootdrop/away_GB_gun/Initialize()
	.=..()
	new /obj/item/mass_firing_pin_replacer/ground_base(loc)


/obj/effect/spawner/lootdrop/away_GB_gun/shotgun_sawn
	var/turf/original
	loot = list(
			/obj/item/stack/ore/iron = 10,
			/obj/item/ammo_casing/shotgun/buckshot = 10,
			/obj/item/kitchen/knife/combat/survival = 4,
			/obj/item/gun/ballistic/shotgun/doublebarrel/sawnoff = 2
			)



/obj/effect/spawner/lootdrop/bandana
	name = "GB minecart"
	loot = list(
			/obj/item/stack/ore/iron = 10,
			/obj/item/ammo_casing/shotgun/buckshot = 10,
			/obj/item/stack/ore/gold = 5,
			/obj/item/reagent_containers/food/snacks/canned/beans = 3,
			/obj/item/stack/medical/gauze/two = 3,
			/obj/item/clothing/mask/bandana/red = 2,
			/obj/item/clothing/mask/bandana/gold = 2,
			/obj/item/clothing/mask/bandana/black = 2,
			/obj/item/clothing/mask/bandana/blue = 2,
			/obj/item/clothing/mask/bandana/skull = 1,
			/obj/item/clothing/gloves/fingerless = 1,
			)

/obj/effect/spawner/lootdrop/bandolier
	name = "GB minecart"
	loot = list(
			/obj/item/stack/ore/iron = 10,
			/obj/item/ammo_casing/shotgun/buckshot = 10,
			/obj/item/stack/ore/gold = 5,
			/obj/item/reagent_containers/hypospray/medipen/survival = 3,
			/obj/item/storage/belt/bandolier = 1,
			)

/obj/effect/spawner/lootdrop/abandoned_mine_items
	loot = list(
			/obj/item/stack/ore/iron = 5,
			/obj/item/pickaxe = 3,
			/obj/structure/ore_box = 2,
			/obj/item/ammo_casing/shotgun/buckshot = 2,
			/obj/item/flashlight/lantern = 2,
			/obj/item/shovel = 1,
			/obj/item/storage/bag/ore = 1,
			)



/********************** OBJECTS **************************/

//Weapons

/obj/item/gun/ballistic/shotgun/doublebarrel/sawnoff
	name = "sawn-off double-barreled shotgun"
	desc = "Come with me if you want to live."
	w_class = WEIGHT_CLASS_NORMAL
	item_state = "gun"
	icon_state = "dshotgun_l"
	sawn_off = TRUE

/obj/item/gun/ballistic/shotgun/doublebarrel/sawnoff/Initialize()
	.=..()
	slot_flags &= ~SLOT_BACK
	slot_flags |= SLOT_BELT
	update_icon()

//fix shotgun ammo type

//obj/item/ammo_casing/shotgun/beanbag
//obj/item/ammo_box/magazine/internal/shot/dual



//FIRING PINS
/obj/item/firing_pin/area_locked    //area based firing pin that only works on Ground Base away mission
	name = "location firing pin"
	desc = "This safety firing pin only allows weapons to be fired in certain locations."
	fail_message = "<span class='warning'>LOCATION CHECK FAILED.</span>"
	pin_removeable = 0
	var/list/authorised_locations = list(/area/gb_away/ground_base)

/obj/item/firing_pin/area_locked/pin_auth(mob/living/user)
	var/area/A = get_area(src)
	if(istype(A, /area/gb_away/ground_base))
		return 1
	return 0


/obj/item/firing_pin/away_ground_base    //area based firing pin that only works on Ground Base away mission
	name = "gateway firing pin"
	desc = "This safety firing pin only allows weapons to be fired on location in an away mission."
	fail_message = "<span class='warning'>GATEWAY CHECK FAILED.</span>"
	pin_removeable = 0
	var/area/A = null

/obj/item/firing_pin/away_ground_base/pin_auth(mob/living/user)
	A = get_area(src)
	if(A.name == ("Ground Base" || "Ground Base Wasteland"))
		return 1
	return 0

/obj/item/firing_pin/z_level_locked    //firing pin that only works on the Z level it was spawned on
	name = "gateway firing pin"
	desc = "This safety firing pin allows weapons to be fired only on 'away' end of gateway."
	fail_message = "<span class='warning'>GATEWAY CHECK FAILED.</span>"
	pin_removeable = 0
	var/original_z_level = null

/obj/item/firing_pin/z_level_locked/Initialize()
	.=..()
	var/turf/T = get_turf(src)
	if(T)
		original_z_level = T.z

/obj/item/firing_pin/z_level_locked/pin_auth(mob/living/user)
	var/turf/T = get_turf(src)
	if(T && original_z_level && T.z == original_z_level)
		return 1
	return 0

//Replaces all gun firing pins on a turf you spawn it on with firing pin type you set in "firing_pin" variable
/obj/item/mass_firing_pin_replacer
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/obj/item/firing_pin = null

/obj/item/mass_firing_pin_replacer/Initialize()
	var/list/found_guns = list()
	for(var/atom/movable/AM in loc)
		if(istype(AM, /obj/structure/closet))
			for(var/obj/item/gun/G in AM)
				found_guns += G
		else if(istype(AM, /obj/item/gun))
			found_guns += AM
	for(var/obj/item/gun/G in found_guns)
		if(G.pin)
			qdel(G.pin)
			G.pin = null
		var/obj/item/firing_pin/P = new firing_pin(G)
		G.pin = P
	qdel(src)

/obj/item/mass_firing_pin_replacer/ground_base
	firing_pin = /obj/item/firing_pin/z_level_locked


//LANTERN ON
/obj/item/flashlight/lantern/on/Initialize()
	icon_state = "lantern-on"
	.=..()

//TORCH ON
/obj/item/flashlight/flare/torch/on/Initialize()
	icon_state = "torch-on"
	.=..()

/obj/item/stack/medical/gauze/two
	amount = 2

/********************** STRUCTURES **************************/


//Spawnable headpikes

/obj/structure/headpike/spawnable
	icon_state = "headpike"
	spear = /obj/item/twohanded/spear
	victim = /obj/item/bodypart/head


/obj/structure/headpike/spawnable/Initialize()
	spear = new spear(src)
	victim = new victim(src)
	update_icon()
	.=..()

/obj/structure/headpike/spawnable/bone
	icon_state = "headpike-bone"
	spear = /obj/item/twohanded/bonespear
	victim = /obj/item/bodypart/head

//Mining cart
/obj/structure/closet/crate/miningcar/minecart
	name = "minecart"
	desc = "A minecart for moving ore."

/obj/structure/closet/crate/miningcar/minecart/loot

/obj/structure/closet/crate/miningcar/minecart/loot/Initialize()
	.=..()
	if(prob(80))
		new /obj/effect/spawner/lootdrop/away_GB_gun/shotgun_sawn(src)
		new /obj/effect/spawner/lootdrop/bandolier(src)
		new /obj/effect/spawner/lootdrop/bandana(src)


/obj/structure/spider/stickyweb/aoe_spawn/Initialize()
	.=..()
	for(var/turf/T in range(1, src))
		if(loc == T || istype(T, /turf/closed))
			continue
		var/web_exists = 0
		for(var/obj/O in T)
			if(istype(O, /obj/structure/spider/stickyweb) || O.density)
				web_exists = 1
				break
		if(web_exists)
			continue
		var/thedir = get_dir(loc, T)
		var/theprobability = 80
		if(thedir in GLOB.diagonals)
			theprobability = 40
		if(prob(theprobability))
			new /obj/structure/spider/stickyweb(T)


//Pike Torch

/obj/structure/pike_torch
	name = "torch"
	desc = "A torch fashioned from some leaves and a log. It seems to be stuck in the ground."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "pike_torch-on"
	anchored = 1
	light_color = "#FA9632"
	light_range = 4

/obj/structure/pike_torch/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!usr.can_hold_items())
			return
		if(!usr.canUseTopic(src, BE_CLOSE(usr)))
			return
		usr.visible_message("<span class='notice'>[usr] grabs \the [src.name].</span>", "<span class='notice'>You grab \the [src.name].</span>")
		var/obj/item/flashlight/flare/torch/on/C = new /obj/item/flashlight/flare/torch/on(loc)
		TransferComponents(C)
		usr.put_in_hands(C)
		qdel(src)



//Fireproof railing

/obj/structure/railing/fireproof
	resistance_flags = (LAVA_PROOF|FIRE_PROOF)

/obj/structure/railing/corner/fireproof
	resistance_flags = (LAVA_PROOF|FIRE_PROOF)

//FENCES

//make this an actual buildable fence
/obj/structure/fence/smooth
	name = "fence"
	desc = "Metal fence."
	icon = 'icons/oldschool/smooth_fence.dmi'
	icon_state = "post"
	max_integrity = 300
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/fence/door/opened, /obj/structure/fence/door, /obj/structure/fence/smooth, /obj/structure/barricade/sandbags, /turf/closed/wall, /turf/closed/wall/r_wall, /obj/structure/falsewall, /obj/structure/falsewall/reinforced, /turf/closed/wall/rust, /turf/closed/wall/r_wall/rust)

//FENCE DOOR CLOSED
/obj/structure/fence/door/closed
	name = "fence door"
	desc = "Not very useful without a real lock."
	icon_state = "door_closed"
	cuttable = FALSE
	open = TRUE
	density = FALSE //Density FALSE results in closed door because monke who coded this put update_door_status() in initialize which flips the state to TRUE


/********************** MOBS **************************/

//VENOMOUS SNAKE
/mob/living/simple_animal/hostile/retaliate/poison/snake/venomous
	desc = "Don't tread on it."
	poison_per_bite = 1

/*****CAVE SPIERS*****/
/mob/living/simple_animal/hostile/poison/giant_spider/hunter/cave
	unique_name = 0
	name = "cave spider"
	melee_damage = 8
	poison_per_bite = 1
	maxHealth = 50
	move_to_delay = 2

/mob/living/simple_animal/hostile/poison/giant_spider/hunter/cave/Initialize()
	.=..()
	transform *= 0.8


/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/cave
	unique_name = 0
	name = "cave tarantula"
	maxHealth = 250
	move_to_delay = 5

/mob/living/simple_animal/hostile/poison/giant_spider/tarantula/cave/Initialize()
	.=..()
	transform *= 1.2

/mob/living/simple_animal/hostile/poison/giant_spider/cave
	unique_name = 0
	name = "giant cave spider"
	melee_damage = 10
	poison_per_bite = 2
	maxHealth = 100
	move_to_delay = 4

/mob/living/simple_animal/hostile/poison/giant_spider/cave/Initialize()
	.=..()

/****************/

//CAVE BAT
/mob/living/simple_animal/hostile/retaliate/bat/cave
	name = "cave bat"
	maxHealth = 30
	health = 30
	melee_damage = 7

/mob/living/simple_animal/hostile/retaliate/bat/cave/Initialize()
	.=..()
	transform *= 1.3




/********************** FLORA **************************/


/obj/structure/glowshroom/single/unidirectional
	icon_state = "glowshroom"

/obj/structure/glowshroom/single/unidirectional/CalcDir()
	floor = 1
	dir = 1



/********************** GROUNDBASE TURFS **************************/


/turf/open/floor/plating/asteroid/has_air    //asteroid turf that smooths with basalt and lava
	name = "sand"
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	digResult = /obj/item/stack/ore/glass

/turf/open/floor/plating/asteroid/has_air/Initialize()
	.=..()
	for(var/turf/T in range(1, src))
		if(T == src)
			continue
		if(istype(T, /turf/open/lava/smooth))
			ChangeTurf(/turf/open/floor/plating/asteroid/has_air_smooth)
		else if(istype(T, /turf/open/floor/plating/asteroid/basalt))
			ChangeTurf(/turf/open/floor/plating/asteroid/has_air_smooth)

/turf/open/floor/plating/asteroid/has_air/desert_flora   //asteroid turf with flora and fauna spawning

/turf/open/floor/plating/asteroid/has_air/desert_flora/Initialize()
	.=..()
	if(prob(0.10))
		new /mob/living/simple_animal/hostile/retaliate/poison/snake/venomous(src)
	if(prob(1))
		var/flora_type = pickweight(list(/obj/structure/flora/ash/cacti = 40, /obj/structure/flora/ausbushes = 33, /obj/structure/flora/ash/cap_shroom = 25))
		new flora_type(src)


/turf/open/floor/plating/asteroid/has_air_smooth    //asteroid-basalt border turf
	name = "sand"
	icon = 'icons/oldschool/asteroid_basalt_border.dmi'
	icon_state = "unsmooth"
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/plating/asteroid/has_air, /turf/open/floor/plating/asteroid/has_air_smooth, /turf/open/floor/plasteel, /turf/closed/wall, /turf/closed/mineral, /turf/open/floor/plating/astplate, /turf/open/floor/pod)



//Minerals - with air

/turf/closed/mineral/random/has_air
	environment_type = "basalt"
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/floor/plating/asteroid/has_air
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	defer_change = 1
	mineralChance = 10
	mineralSpawnChanceList = list(
		/turf/closed/mineral/uranium/has_air = 5, /turf/closed/mineral/diamond/has_air = 1, /turf/closed/mineral/gold/has_air = 10,
		/turf/closed/mineral/titanium/has_air = 11, /turf/closed/mineral/copper = 15,
		/turf/closed/mineral/silver/has_air = 12, /turf/closed/mineral/plasma/has_air = 20, /turf/closed/mineral/iron/has_air = 40,
		/turf/closed/mineral/gibtonite/has_air = 4, /turf/open/floor/plating/asteroid/airless/cave_has_air/abandoned_mine = 1,
		/turf/closed/mineral/bscrystal/has_air = 1, /turf/closed/mineral/bananium/has_air = 1)

/turf/closed/mineral/uranium/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/diamond/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/gold/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/titanium/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/silver/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/plasma/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/iron/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/gibtonite/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/bscrystal/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/closed/mineral/bananium/has_air
	turf_type = /turf/open/floor/plating/asteroid/has_air
	baseturfs = /turf/open/lava/smooth
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/********************** CAVE GENERATION **************************/

#define SPAWN_MEGAFAUNA "bluh bluh huge boss"
#define SPAWN_BUBBLEGUM 6

/turf/open/floor/plating/asteroid/airless/cave_has_air
	var/length = 100
	var/list/mob_spawn_list
	var/list/megafauna_spawn_list
	var/list/flora_spawn_list
	var/list/structure_spawn_list
	var/list/item_spawn_list
	var/sanity = 1
	var/forward_cave_dir = 1
	var/backward_cave_dir = 2
	var/going_backwards = TRUE
	var/has_data = FALSE
	var/data_having_type = /turf/open/floor/plating/asteroid/airless/cave_has_air/has_data
	var/mob_spawn_chance = 30 //Chance to spawn mobs on every tile
	var/mob_spawn_radius = 8 // How close can mobs spawn to eachother, reduces number of mobs and stops them from clumping up.
	var/structure_spawn_chance = 12
	var/item_spawn_chance = 12
	var/flora_spawn_chance = 2
	var/area/caveless_area = /area/mine/explored
	var/area/mobless_area = /area/gb_away/explored
	turf_type = /turf/open/floor/plating/asteroid/has_air

/turf/open/floor/plating/asteroid/airless/cave_has_air/has_data //subtype for producing a tunnel with given data
	has_data = TRUE


//ABANDONED MINE

/turf/open/floor/plating/asteroid/airless/cave_has_air/abandoned_mine

	mob_spawn_list = list(/mob/living/simple_animal/hostile/skeleton/plasmaminer = 1, /mob/living/simple_animal/hostile/poison/giant_spider/hunter/cave = 5, \
		/mob/living/simple_animal/hostile/retaliate/bat/cave = 2, /mob/living/simple_animal/hostile/poison/giant_spider/cave = 3, \
		/mob/living/simple_animal/hostile/skeleton/spooky = 5, /mob/living/simple_animal/hostile/skeleton/spooky/huge = 1)

	flora_spawn_list = list(/obj/structure/glowshroom/single/unidirectional = 1)

	structure_spawn_list = list(/obj/structure/barricade/wooden = 10, /obj/structure/closet/crate/miningcar/minecart/loot = 6, /obj/structure/spider/stickyweb/aoe_spawn = 1, \
	/obj/structure/ore_box = 3)

	item_spawn_list = list(/obj/item/stack/ore/iron = 5, /obj/effect/decal/remains/human = 2, /obj/item/stack/sheet/mineral/wood = 2, \
	/obj/item/pickaxe = 2, /obj/item/ammo_casing/shotgun/buckshot = 2, /obj/item/flashlight/lantern/on = 2,/obj/item/shovel = 1, \
	/obj/item/storage/bag/ore = 1, /obj/item/storage/bag/ore = 1, /obj/item/clothing/shoes/workboots/mining = 1)


	data_having_type = /turf/open/floor/plating/asteroid/airless/cave_has_air/abandoned_mine/has_data
	turf_type = /turf/open/floor/plating/asteroid/has_air
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/floor/plating/asteroid/airless/cave_has_air/abandoned_mine/has_data //subtype for producing a tunnel with given data
	has_data = TRUE



/turf/open/floor/plating/asteroid/airless/cave_has_air/Initialize()
/*
	if (!mob_spawn_list)
		mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goldgrub = 1, /mob/living/simple_animal/hostile/asteroid/goliath = 5, /mob/living/simple_animal/hostile/asteroid/basilisk = 4, /mob/living/simple_animal/hostile/asteroid/hivelord = 3)
	if (!megafauna_spawn_list)
		megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/dragon = 4, /mob/living/simple_animal/hostile/megafauna/colossus = 2, /mob/living/simple_animal/hostile/megafauna/bubblegum = SPAWN_BUBBLEGUM)
	if (!flora_spawn_list)
		flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 2 , /obj/structure/flora/ash/cap_shroom = 2 , /obj/structure/flora/ash/stem_shroom = 2 , /obj/structure/flora/ash/cacti = 1, /obj/structure/flora/ash/tall_shroom = 2)
*/
	. = ..()
	if(!has_data)
		produce_tunnel_from_data()

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/get_cave_data(set_length, exclude_dir = -1)
	// If set_length (arg1) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(!set_length)
		length = rand(25, 50)
	else
		length = set_length

	// Get our directiosn
	forward_cave_dir = pick(GLOB.alldirs - exclude_dir)
	// Get the opposite direction of our facing direction
	backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/produce_tunnel_from_data(tunnel_length, excluded_dir = -1)
	get_cave_data(tunnel_length, excluded_dir)
	// Make our tunnels
	make_tunnel(forward_cave_dir)
	if(going_backwards)
		make_tunnel(backward_cave_dir)
	// Kill ourselves by replacing ourselves with a normal floor.
	SpawnFloor(src)

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/make_tunnel(dir)
	var/turf/closed/mineral/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(ISODD(dir2angle(dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/closed/mineral/edge = get_step(tunnel, angle2dir(dir2angle(dir) + edge_angle))
			if(istype(edge))
				SpawnFloor(edge)

		if(!sanity)
			break

		// Move our tunnel forward
		tunnel = get_step(tunnel, dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				var/turf/open/floor/plating/asteroid/airless/cave_has_air/C = tunnel.ChangeTurf(data_having_type, null, CHANGETURF_IGNORE_AIR)
				C.going_backwards = FALSE
				C.produce_tunnel_from_data(rand(10, 15), dir)
			else
				SpawnFloor(tunnel)
		else //if(!istype(tunnel, parent)) // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			setDir(angle2dir(dir2angle(dir) )+ next_angle)


/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/SpawnFloor(turf/T)
	for(var/S in RANGE_TURFS(1, src))
		var/turf/NT = S
		if(!NT || isspaceturf(NT) || istype(NT.loc, /area/mine/explored) || istype(NT.loc, /area/lavaland/surface/outdoors/explored) || istype(NT.loc, caveless_area))
			sanity = 0
			break
	if(!sanity)
		return
	SpawnFlora(T)
	SpawnStructures(T)
	SpawnMonster(T)
	SpawnItems(T)
	T.ChangeTurf(turf_type, null, CHANGETURF_IGNORE_AIR)

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/SpawnMonster(turf/T)
	if(prob(mob_spawn_chance))
		if(istype(loc, mobless_area))
			return
		var/randumb = pickweight(mob_spawn_list)
		while(randumb == SPAWN_MEGAFAUNA)
			if(istype(loc, /area/lavaland/surface/outdoors/unexplored/danger)) //this is danger. it's boss time.
				var/maybe_boss = pickweight(megafauna_spawn_list)
				if(megafauna_spawn_list[maybe_boss])
					randumb = maybe_boss
					if(ispath(maybe_boss, /mob/living/simple_animal/hostile/megafauna/bubblegum)) //there can be only one bubblegum, so don't waste spawns on it
						megafauna_spawn_list[maybe_boss] = 0
			else //this is not danger, don't spawn a boss, spawn something else
				randumb = pickweight(mob_spawn_list)

		for(var/mob/living/simple_animal/hostile/H in urange(mob_spawn_radius,T)) //prevents mob clumps
			if((ispath(randumb, /mob/living/simple_animal/hostile/megafauna) || ismegafauna(H)) && get_dist(src, H) <= 7)
				return //if there's a megafauna within standard view don't spawn anything at all
			return
		for(var/S in structure_spawn_list)
			for(var/obj/structure/structure in T)
				if(istype(structure, S))
					return
		var/mob/living/simple_animal/A = new randumb(T)
		A.faction += "cave" //stops mobs from killing eachother

	return

#undef SPAWN_MEGAFAUNA
#undef SPAWN_BUBBLEGUM

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/SpawnFlora(turf/T)
	if(prob(flora_spawn_chance))
		if(istype(loc, /area/mine/explored) || istype(loc, /area/lavaland/surface/outdoors/explored))
			return
		var/randumb = pickweight(flora_spawn_list)
		for(var/obj/structure/glowshroom/single/unidirectional/F in range(4, T)) //Allows for growing patches, but not ridiculous stacks of flora
			if(!istype(F, randumb))
				return
		new randumb(T)

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/SpawnStructures(turf/T)
	if(prob(structure_spawn_chance))
		if(istype(loc, /area/mine/explored) || istype(loc, /area/lavaland/surface/outdoors/explored))
			return
		var/randumb = pickweight(structure_spawn_list)
		new randumb(T)

/turf/open/floor/plating/asteroid/airless/cave_has_air/proc/SpawnItems(turf/T)
	if(prob(item_spawn_chance))
		if(istype(loc, /area/mine/explored) || istype(loc, /area/lavaland/surface/outdoors/explored))
			return
		for(var/S in structure_spawn_list)
			for(var/obj/structure/structure in T)
				if(istype(structure, S))
					return
		var/randumb = pickweight(item_spawn_list)
		new randumb(T)



/********************** GROUNDBASE AREAS **************************/


/area/gb_away
	name = "Ground Base Wasteland"
	icon_state = "awaycontent1"
	has_gravity = TRUE

/area/gb_away/ground_base
	name = "Ground Base"
	icon_state = "awaycontent2"
	outdoors = FALSE
	always_unpowered = FALSE
	poweralm = FALSE
	power_environ = TRUE
	power_equip = TRUE
	power_light = TRUE
	ambient_buzz = 'sound/ambience/shipambience.ogg'


/area/gb_away/explored
	icon_state = "awaycontent3"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambient_buzz = 'sound/ambience/shipambience.ogg'
	ambient_effects = MINING

/area/lavaland/surface/outdoors/unexplored/GB
	name = "Ground Base Wasteland"

/area/lavaland/surface/outdoors/unexplored/danger/GB
	name = "Ground Base Wasteland"




/********************** VENDING **************************/

/obj/machinery/vending/z_level_locked
	tiltable = FALSE
	var/firing_pin = /obj/item/firing_pin/z_level_locked

/obj/machinery/vending/z_level_locked/on_vend(atom/movable/AM)
	. = ..()
	var/obj/item/gun/G = AM
	if(istype(G))
		qdel(G.pin)
		G.pin = new firing_pin(G)

/obj/machinery/vending/z_level_locked/handgun
	name = "\improper Liberation Station - Handguns & Submachineguns"
	desc = "An overwhelming amount of <b>ancient patriotism</b> washes over you just by looking at the machine."
	icon_state = "liberationstation"
	product_slogans = "Liberation Station: Your one-stop shop for all things second ammendment!;Be a patriot today, pick up a gun!;Quality weapons for cheap prices!;Better dead than red!"
	product_ads = "Float like an astronaut, sting like a bullet!;Express your second ammendment today!;Guns don't kill people, but you can!;Who needs responsibilities when you have guns?"
	vend_reply = "Remember the name: Liberation Station!"
	light_color = LIGHT_COLOR_RED
	products = list(/obj/item/gun/ballistic/automatic/pistol = 20,
				/obj/item/gun/ballistic/automatic/pistol/m1911 = 20,
				/obj/item/gun/ballistic/revolver/mateba = 20,
				/obj/item/gun/ballistic/automatic/pistol/deagle/sound = 20,
				/obj/item/gun/ballistic/automatic/pistol/deagle/gold = 1,)

	premium = list(/obj/item/gun/ballistic/automatic/proto = 20,
				/obj/item/gun/ballistic/automatic/pistol/APS = 20,
				/obj/item/gun/ballistic/automatic/mini_uzi = 20,
				/obj/item/gun/ballistic/automatic/c20r/unrestricted = 20,
				/obj/item/gun/ballistic/automatic/tommygun = 20,)

	contraband = list(/obj/item/clothing/under/misc/patriotsuit = 3,
					/obj/item/bedsheet/patriot = 5,
					/obj/item/reagent_containers/food/snacks/burger/superbite = 3)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = INDESTRUCTIBLE
	default_price = 50
	extra_price = 100
	payment_department = ACCOUNT_SEC
	price_override = list(/obj/item/gun/ballistic/automatic/pistol = 150,
					/obj/item/gun/ballistic/automatic/pistol/m1911 = 200,
		            /obj/item/gun/ballistic/automatic/pistol/deagle/sound = 600,
		            /obj/item/gun/ballistic/revolver/mateba = 500,
		            /obj/item/gun/ballistic/automatic/pistol/deagle/gold = 1200)

	premium_price_override = list(/obj/item/gun/ballistic/automatic/proto = 700,
				/obj/item/gun/ballistic/automatic/pistol/APS = 600,
				/obj/item/gun/ballistic/automatic/mini_uzi = 850,
				/obj/item/gun/ballistic/automatic/c20r/unrestricted = 1000,
				/obj/item/gun/ballistic/automatic/tommygun = 1200)


/obj/machinery/vending/z_level_locked/rifle_and_shotgun
	name = "\improper Liberation Station - Rifles & Shotguns"
	desc = "An overwhelming amount of <b>ancient patriotism</b> washes over you just by looking at the machine."
	icon_state = "liberationstation"
	product_slogans = "Liberation Station: Your one-stop shop for all things second ammendment!;Be a patriot today, pick up a gun!;Quality weapons for cheap prices!;Better dead than red!"
	product_ads = "Float like an astronaut, sting like a bullet!;Express your second ammendment today!;Guns don't kill people, but you can!;Who needs responsibilities when you have guns?"
	vend_reply = "Remember the name: Liberation Station!"
	light_color = LIGHT_COLOR_RED
	products = list(/obj/item/gun/ballistic/rifle/boltaction = 20,
					/obj/item/gun/ballistic/automatic/surplus = 20,
					/obj/item/gun/ballistic/automatic/wt550 = 15,
					/obj/item/gun/ballistic/automatic/ar = 15,
					/obj/item/gun/ballistic/automatic/m90 = 6,
					/obj/item/gun/ballistic/automatic/l6_saw = 6)

	premium = list(/obj/item/gun/ballistic/shotgun/doublebarrel = 20,
				/obj/item/gun/ballistic/shotgun/lethal = 20,
				/obj/item/gun/ballistic/shotgun/lever_action = 20,
				/obj/item/gun/ballistic/shotgun/automatic/combat = 15,
				/obj/item/gun/ballistic/shotgun/automatic/combat/compact = 10,
				/obj/item/gun/ballistic/shotgun/automatic/breaching = 10)

	contraband = list(/obj/item/clothing/under/misc/patriotsuit = 3,
					/obj/item/bedsheet/patriot = 5,
					/obj/item/reagent_containers/food/snacks/burger/superbite = 3)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = INDESTRUCTIBLE
	default_price = 50
	extra_price = 100
	payment_department = ACCOUNT_SEC
	price_override = list(/obj/item/gun/ballistic/rifle/boltaction = 200,
					/obj/item/gun/ballistic/automatic/surplus = 400,
					/obj/item/gun/ballistic/automatic/wt550 = 800,
					/obj/item/gun/ballistic/automatic/ar = 1200,
					/obj/item/gun/ballistic/automatic/m90 = 2200,
					/obj/item/gun/ballistic/automatic/l6_saw = 2500)

	premium_price_override = list(/obj/item/gun/ballistic/shotgun/doublebarrel = 150,
				/obj/item/gun/ballistic/shotgun/lethal = 250,
				/obj/item/gun/ballistic/shotgun/lever_action = 500,
				/obj/item/gun/ballistic/shotgun/automatic/combat = 600,
				/obj/item/gun/ballistic/shotgun/automatic/combat/compact = 650,
				/obj/item/gun/ballistic/shotgun/automatic/breaching = 250)


/obj/machinery/vending/z_level_locked/special_and_explosives
	name = "\improper Liberation Station - Special Weapons & Explosives"
	desc = "An overwhelming amount of <b>ancient patriotism</b> washes over you just by looking at the machine."
	icon_state = "liberationstation"
	product_slogans = "Liberation Station: Your one-stop shop for all things second ammendment!;Be a patriot today, pick up a gun!;Quality weapons for cheap prices!;Better dead than red!"
	product_ads = "Float like an astronaut, sting like a bullet!;Express your second ammendment today!;Guns don't kill people, but you can!;Who needs responsibilities when you have guns?"
	vend_reply = "Remember the name: Liberation Station!"
	light_color = LIGHT_COLOR_RED
	products = list(/obj/item/gun/energy/laser/retro = 20,
					/obj/item/gun/energy/laser/scatter = 20,
					/obj/item/gun/energy/lasercannon = 10,
					/obj/item/gun/energy/pulse/pistol = 2,
					/obj/item/gun/energy/beam_rifle = 1,
					/obj/item/gun/medbeam = 3)

	premium = list(/obj/item/gun/ballistic/automatic/sniper_rifle = 2,
				/obj/item/gun/ballistic/revolver/grenadelauncher = 2,
				/obj/item/gun/ballistic/automatic/gyropistol = 1,
				/obj/item/gun/energy/meteorgun = 1,
				/obj/item/gun/ballistic/rocketlauncher = 1)

	contraband = list(/obj/item/clothing/under/misc/patriotsuit = 3,
					/obj/item/bedsheet/patriot = 5,
					/obj/item/reagent_containers/food/snacks/burger/superbite = 3)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = INDESTRUCTIBLE
	default_price = 50
	extra_price = 100
	payment_department = ACCOUNT_SEC
	price_override = list(/obj/item/gun/energy/laser/retro = 350,
					/obj/item/gun/energy/laser/scatter = 400,
					/obj/item/gun/energy/lasercannon = 850,
					/obj/item/gun/energy/pulse/pistol = 3000,
					/obj/item/gun/energy/beam_rifle = 4000,
					/obj/item/gun/medbeam = 2500)

	premium_price_override = list(/obj/item/gun/ballistic/automatic/sniper_rifle = 2000,
								/obj/item/gun/ballistic/revolver/grenadelauncher = 1900,
								/obj/item/gun/ballistic/automatic/gyropistol = 3000,
								/obj/item/gun/energy/meteorgun = 4500,
								/obj/item/gun/ballistic/rocketlauncher = 2500)


/obj/machinery/vending/z_level_locked/ammo
	name = "\improper Liberation Station - Ammunition"
	desc = "An overwhelming amount of <b>ancient patriotism</b> washes over you just by looking at the machine."
	icon_state = "liberationstation"
	product_slogans = "Liberation Station: Your one-stop shop for all things second ammendment!;Be a patriot today, pick up a gun!;Quality weapons for cheap prices!;Better dead than red!"
	product_ads = "Float like an astronaut, sting like a bullet!;Express your second ammendment today!;Guns don't kill people, but you can!;Who needs responsibilities when you have guns?"
	vend_reply = "Remember the name: Liberation Station!"
	light_color = LIGHT_COLOR_RED
	products = list(/obj/item/ammo_box/magazine/tommygunm45 = 99,
					/obj/item/ammo_box/magazine/smgm9mm = 99,
					/obj/item/ammo_box/magazine/uzim9mm = 99,
					/obj/item/ammo_box/magazine/pistolm9mm = 99,
					/obj/item/ammo_box/magazine/m10mm = 99,
					/obj/item/ammo_box/magazine/m50 = 99,
					/obj/item/ammo_box/a357 = 99,
					/obj/item/storage/box/lethalshot = 99,
					/obj/item/ammo_box/a762 = 99,
					/obj/item/ammo_box/magazine/wt550m9 = 99,
					/obj/item/ammo_box/magazine/m10mm/rifle = 99)

	premium = list(/obj/item/ammo_box/magazine/mm712x82 = 99,
				/obj/item/ammo_box/magazine/m556 = 99,
				/obj/item/ammo_box/magazine/sniper_rounds = 99,
				/obj/item/ammo_box/magazine/m75 = 99,
				/obj/item/ammo_casing/a40mm = 99,
				/obj/item/ammo_casing/caseless/rocket = 99)

	contraband = list(/obj/item/clothing/under/misc/patriotsuit = 3,
					/obj/item/bedsheet/patriot = 5,
					/obj/item/reagent_containers/food/snacks/burger/superbite = 3)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = INDESTRUCTIBLE
	default_price = 50
	extra_price = 100
	payment_department = ACCOUNT_SEC
	price_override = list(/obj/item/ammo_box/magazine/tommygunm45 = 60,
					/obj/item/ammo_box/magazine/smgm9mm = 15,
					/obj/item/ammo_box/magazine/uzim9mm = 25,
					/obj/item/ammo_box/magazine/pistolm9mm = 10,
					/obj/item/ammo_box/magazine/m10mm = 10,
					/obj/item/ammo_box/magazine/m50 = 20,
					/obj/item/ammo_box/a357 = 15,
					/obj/item/storage/box/lethalshot = 10,
					/obj/item/ammo_box/a762 = 5,
					/obj/item/ammo_box/magazine/wt550m9 = 20,
					/obj/item/ammo_box/magazine/m10mm/rifle = 10)

	premium_price_override = list(/obj/item/ammo_box/magazine/mm712x82 = 100,
								/obj/item/ammo_box/magazine/m556 = 35,
								/obj/item/ammo_box/magazine/sniper_rounds = 50,
								/obj/item/ammo_box/magazine/m75 = 180,
								/obj/item/ammo_casing/a40mm = 60,
								/obj/item/ammo_casing/caseless/rocket = 80)



/********************** GATEWAY **************************/

GLOBAL_LIST_EMPTY(gateway_components)

/obj/machinery/gateway/centeraway/missing_component //Requires bluespace_cube to activate
	desc = "A mysterious gateway built by unknown hands. It seems some components are missing, they can be located using component pinpointer and GPS."
	var/has_cube = FALSE


/obj/machinery/gateway/centeraway/missing_component/toggleon(mob/user)
	if(!detect())
		return
	if(!stationgate)
		to_chat(user, "<span class='notice'>Error: No destination found.</span>")
		return
	if(!has_cube)
		to_chat(user, "<span class='notice'>Error: Gateway is missing a critical component. It can be located using component pinpointer and GPS.</span>")
		return
	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()

/obj/machinery/gateway/centeraway/missing_component/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/bluespace_cube))
		var/obj/item/bluespace_cube/C = I
		C.forceMove(src.contents)
		has_cube = TRUE
	.=..()


/obj/item/bluespace_cube
	name = "bluespace cube"
	desc = "An integral gateway component. It pulsates with a beautiful hypnotising glow."
	icon = 'icons/oldschool/items.dmi'
	icon_state = "subspace_cube"
	w_class = 3
	light_color = "#0099ff"
	light_power = 2
	light_range = 2
	resistance_flags = INDESTRUCTIBLE

/obj/item/bluespace_cube/Initialize()
	.=..()
	GLOB.gateway_components.Add(src)
	AddComponent(/datum/component/gps, "Gateway Component")



/obj/item/pinpointer/gateway_component
	name = "gateway component pinpointer"

/obj/item/pinpointer/gateway_component/scan_for_target()
	var/obj/item/bluespace_cube/C = locate() in GLOB.gateway_components
	target = C



/********************** VEHICLES **************************/


/obj/vehicle/ridden/atv/nt_turret
	var/obj/machinery/porta_turret/syndicate/vehicle_turret/nt_owned/turret = null
	key_type = /obj/item/key/nt_armed_atv

/obj/item/key/nt_armed_atv
	name = "armed atv key"
	desc = "A small red key."
	color = "#f54e5c"

/obj/machinery/porta_turret/syndicate/vehicle_turret/nt_owned
	name = "mounted turret"
	scan_range = 7
	density = FALSE
	faction = list("neutral")

/obj/vehicle/ridden/atv/nt_turret/Initialize()
	. = ..()
	turret = new(loc)
	turret.base = src

/obj/vehicle/ridden/atv/nt_turret/Moved()
	. = ..()
	if(turret)
		turret.forceMove(get_turf(src))
		switch(dir)
			if(NORTH)
				turret.pixel_x = 0
				turret.pixel_y = 4
				turret.layer = ABOVE_MOB_LAYER
			if(EAST)
				turret.pixel_x = -12
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER
			if(SOUTH)
				turret.pixel_x = 0
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER
			if(WEST)
				turret.pixel_x = 12
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER


/obj/machinery/porta_turret/syndicate/nt_owned
	name = "NT turret"
	scan_range = 7
	faction = list("neutral")



//IM A DUMB STEP EDITING SCRUB

/client/proc/EditedStepFinder()
	set name = "Step X and Y Finder"
	set category = "Debug"
	var/founderror = 0
	for(var/atom/movable/A in world)
		if(A.step_x != 0 || A.step_y != 0)
			message_admins("Found edited Step at ([A.x] [A.y] [A.z]). Name: \"[A.name]\" Type: \"[A.type]\"")
			founderror = 1
	if(!founderror)
		message_admins("Found no edited Steps in the world.")



