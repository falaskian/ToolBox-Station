

/********************** SECTIONS **************************/

/* TDM New & Updated Weapons
 - TDM GEAR
 - STRUCTURES
 - TURFS
 - AREAS
 - WINTER WONDERLAND - SNOWBALLS
*/



/********************** TDM New & Updated Weapons **************************/



		//9mm Pistol - Stechkin - 12 ammo, 20DMG

/obj/item/gun/ballistic/automatic/pistol/TDM
	desc = "A small, easily concealable 9mm handgun. Damage: 20."
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/TDM

/obj/item/ammo_box/magazine/pistolm9mm/TDM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12



		//9mm Stetchkin APS - 3rnd brst, 12(4) ammo, uses same mags and does same dmg as Stechkin but automatic

/obj/item/gun/ballistic/automatic/pistol/APS/TDM
	desc = "Automatic, easily concealable 9mm handgun. Damage: 20."
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/TDM



		//.357 Revolver - 6 ammo, 45DMG

/obj/item/gun/ballistic/revolver/TDM
	name = "\improper .357 revolver"
	desc = "Big Iron on his hip. Uses .357 ammo. Damage: 45."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/TDM

/obj/item/ammo_box/magazine/internal/cylinder/TDM
	ammo_type = /obj/item/ammo_casing/a357/TDM
	max_ammo = 6

/obj/item/ammo_box/a357/TDM
	ammo_type = /obj/item/ammo_casing/a357/TDM
	max_ammo = 6

/obj/item/ammo_casing/a357/TDM
	projectile_type = /obj/item/projectile/bullet/a357/TDM

/obj/item/projectile/bullet/a357/TDM
	damage = 45



		//SHOTGUNS

		//DoubleBarrel Shotgun - Slug
/obj/item/gun/ballistic/shotgun/doublebarrel/TDM
	desc = "A true classic. Damage: 60."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/TDM
	//rack_sound_volume = 0
	//fire_rate = 2 //being double barrelled, you don't rely on internal mechanisms.
	//pb_knockback = 3


		//DoubleBarrel Shotgun - Buckshot
/obj/item/gun/ballistic/shotgun/doublebarrel/TDM/buckshot
	desc = "A true classic. Damage: 54."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/TDM/buckshot


		//Pump Shotgun - Slug
/obj/item/gun/ballistic/shotgun/TDM
	desc = "A traditional shotgun with wood furniture and a four-shell capacity underneath. Damage: 60."
	name = "pump shotgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/TDM


		//Pump Shotgun - Buckshot
/obj/item/gun/ballistic/shotgun/TDM/buckshot
	desc = "A traditional shotgun with wood furniture and a four-shell capacity underneath. Damage: 54."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/TDM/buckshot



		//Shotgun Mags

	//DoubleBarrel - Slug
/obj/item/ammo_box/magazine/internal/shot/dual/TDM
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 2
	multiload = 1

	//DoubleBarrel - Buckshot
/obj/item/ammo_box/magazine/internal/shot/dual/TDM/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

	//Pump Shotgun - Slug
/obj/item/ammo_box/magazine/internal/shot/TDM
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 4
	multiload = 1

	//Pump Shotgun - Buckshot
/obj/item/ammo_box/magazine/internal/shot/TDM/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot



		//Shotgun Ammo
//obj/item/ammo_casing/shotgun/TDM

//obj/item/projectile/bullet/shotgun_slug/TDM
	//damage = 55




/obj/item/ammo_box/s12g
	name = "speedloader (12g Buckshot)"
	desc = "Designed to quickly reload double-barrel shotguns."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "gshell-live"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 2



/obj/item/ammo_box/s12g/Initialize()
	.=..()
	update_icon()


/obj/item/ammo_box/s12g/update_icon()
	overlays.Cut()
	.=..()
	var/image/I = new()
	I.icon = icon
	I.icon_state = icon_state
	I.pixel_x = pixel_x+3
	I.pixel_y = pixel_y-3
	overlays += I
	if(stored_ammo.len <= 0)
		qdel(src)
		return



/* SHELL SPEED LOADER
/obj/item/ammo_box/s12g
	name = "speedloader (12g Buckshot)"
	desc = "Designed to quickly reload double-barrel shotguns."
	icon_state = "762-2"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 2
	multiple_sprites = 1

//delete itself if ammo is 0 - basically delete the clip after loading ammo into shotgun
*/



		//Uzi 9mm - 3rnd brst, 24(8) ammo, 20DMG

/obj/item/gun/ballistic/automatic/pistol/APS/TDM/uzi
	name = "\improper Type U3 Uzi"
	desc = "A lightweight submachine gun. Uses 9mm rounds. Damage: 20."
	icon_state = "miniuzi"
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_OPEN
	mag_display = TRUE
	mag_type = /obj/item/ammo_box/magazine/uzim9mm/TDM
	burst_size = 3

/obj/item/ammo_box/magazine/uzim9mm/TDM
	max_ammo = 24



		//Carbine - 10 ammo, 35DMG

/obj/item/gun/ballistic/automatic/surplus/TDM
	name = "carbine"
	desc = "California Compliant. Uses .45 carbine ammo and its bulky frame prevents one-hand firing. Damage: 35."
	mag_type = /obj/item/ammo_box/magazine/m45carbine
	fire_delay = 0
	fire_rate = 2.5

	//Magazine
/obj/item/ammo_box/magazine/m45carbine
	name = "rifle magazine (.45 Carbine)"
	desc = "California compliant 10 round magazine."
	icon_state = "75-8"
	ammo_type = /obj/item/ammo_casing/c45carbine
	caliber = ".45c"
	max_ammo = 10

/obj/item/ammo_box/magazine/m45carbine/update_icon()
	..()
	if(ammo_count())
		icon_state = "75-8"
	else
		icon_state = "75-0"

	//Ammo
/obj/item/ammo_casing/c45carbine
	name = ".45 carbine bullet casing"
	desc = "A .45 carbine bullet casing."
	caliber = ".45c"
	projectile_type = /obj/item/projectile/bullet/c45carbine

	//Bullet
/obj/item/projectile/bullet/c45carbine
	name = ".45 carbine bullet"
	damage = 35


		//Knife - 35DMG, 30DMG thrown
/obj/item/kitchen/knife/combat/TDM
	desc = "A military combat knife. Damage: 35. Damage thrown: 30."
	force = 35
	throwforce = 30
	bayonet = TRUE






/********************** TDM GEAR **************************/



		//OUTFITS

	//Red Team

/datum/outfit/TDM/red
	name = "TDM Red Team T1"
	uniform = /obj/item/clothing/under/color/red/TDM
	belt = /obj/item/storage/belt/fannypack/red
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/TDM/red
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/red/t3
	name = "TDM Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/red/t4
	name = "TDM Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt


	//Blue Team

/datum/outfit/TDM/blue
	name = "TDM Blue Team T1"
	uniform = /obj/item/clothing/under/color/blue/TDM
	belt = /obj/item/storage/belt/fannypack/blue
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/TDM/blue
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/blue/t3
	name = "TDM Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/blue/t4
	name = "TDM Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



/*		//OUTFIT TEMPLATE
/datum/outfit/template
	name = "template"
	uniform = null
	suit = null
	back = null
	belt = null
	gloves = null
	shoes = null
	head = null
	mask = null
	neck = null
	ears = null
	glasses = null
	id = null
	l_pocket = null
	r_pocket = null
	suit_store = null
	r_hand = null
	l_hand = null
	toggle_helmet = TRUE
	internals_slot = null
	list/backpack_contents = null
	list/implants = null
	accessory = null
*/



		//Clothes

	//Berets

/obj/item/clothing/head/beret/TDM
	name = "beret"
	desc = "A beret. Very stylish but offers no protection."
	icon_state = "beret_ce" //White


/obj/item/clothing/head/beret/TDM/red
	name = "red beret"
	desc = "A red beret. Very stylish but offers no protection."
	icon_state = "beret_badge"


/obj/item/clothing/head/beret/TDM/blue
	name = "blue beret"
	desc = "A blue beret. Very stylish but offers no protection."
	icon_state = "beret_captain"


	//Jumpsuits

/obj/item/clothing/under/color/red/TDM
	can_adjust = 0

/obj/item/clothing/under/color/red/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/under/color/blue/TDM
	can_adjust = 0

/obj/item/clothing/under/color/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/********************** STRUCTURES **************************/


		//Wall Healer

obj/structure/TDM
	anchored = 1

obj/structure/TDM/take_damage()
	return

obj/structure/TDM/wallmed
	name = "InstaMed"
	desc = "Wall-mounted healing station."
	icon = 'icons/obj/vending.dmi'
	icon_state = "wallmed"
	var/healtime = 10
	var/cooldown = 100
	var/list/users = list()

obj/structure/TDM/wallmed/attack_hand(mob/living/user)
	if(iscyborg(user))
		return
	if(user && (user in users))
		to_chat(user, "<span class='warning'>[name] is still recharging.</span>")
		user << sound('sound/machines/buzz-two.ogg', volume = 50)
		return
	if(do_after(user, healtime, user) && (user && (user in users)))
		users.Add(user)
		user.revive(full_heal = TRUE)
		to_chat(user, "<span class='notice'>[name] heals all your wounds.</span>")
		playsound(loc, 'sound/effects/refill.ogg', 50)
		spawn(cooldown)
			if(user)
				users.Remove(user)
		spawn(7)
			playsound(loc, 'sound/machines/defib_ready.ogg', 50)



		//Display Case

/obj/structure/displaycase/TDM_item_spawn
	name = "item spawn display case"
	var/respawn_timer = 20

/obj/structure/displaycase/TDM_item_spawn/Initialize()
	.=..()
	if(showpiece)
		name = "[showpiece.name] display case"
		desc = "[showpiece.desc]"


/obj/structure/displaycase/TDM_item_spawn/attackby(obj/item/W, mob/user, params)
	return

/obj/structure/displaycase/TDM_item_spawn/take_damage()
	return

/obj/structure/displaycase/TDM_item_spawn/dump()
	.=..()
	respawn_item()

/obj/structure/displaycase/TDM_item_spawn/proc/respawn_item()
	if(!start_showpiece_type)
		return
	spawn(respawn_timer)
		if(!showpiece)
			showpiece = new start_showpiece_type (src)
			update_icon()



	//Medical Cabinet

/obj/structure/TDM/medical_cabinet
	name = "medical cabinet"
	desc = "A small wall mounted cabinet designed to hold medical equipment."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "extinguisher_closed"





		//Cloner - Respawn

/obj/structure/TDM/respawn_pod
	name = "cloning pod"
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_1"



		// Boxes

/obj/structure/ore_box/TDM
	name = "sturdy box"
	desc ="A heavy wooden box. It looks very sturdy."
	anchored = 1


/obj/structure/ore_box/TDM/take_damage()
	return



		//Sandbags

/obj/structure/barricade/sandbags/TDM
	desc = "Bags of sand. Self explanatory. They look very sturdy."
	canSmoothWith = list(/obj/structure/barricade/sandbags/TDM, /obj/structure/barricade/sandbags, /turf/closed/wall, /turf/closed/wall/r_wall, /obj/structure/falsewall, /obj/structure/falsewall/reinforced, /turf/closed/wall/rust, /turf/closed/wall/r_wall/rust, /obj/structure/barricade/security)


/obj/structure/barricade/sandbags/TDM/take_damage()
	return

		//Half Wall
/obj/structure/barricade/sandbags/TDM/half_wall
	name = "half wall"
	desc = "Stone half wall. You need to be close to shoot accurately over it. It looks very sturdy."
	color = "#909090"
	canSmoothWith = list(/obj/structure/barricade/sandbags/TDM/half_wall, /obj/structure/barricade/sandbags, /turf/closed/wall, /turf/closed/wall/r_wall, /obj/structure/falsewall, /obj/structure/falsewall/reinforced, /turf/closed/wall/rust, /turf/closed/wall/r_wall/rust, /obj/structure/barricade/security)

/obj/structure/barricade/sandbags/TDM/half_wall/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) & dir)
		var/checking = FLYING | FLOATING
		return . || mover.movement_type & checking
	return TRUE



		//Banners

/obj/item/banner/TDM
	anchored = 1

/obj/item/banner/TDM/red
	icon_state = "banner-red"

/obj/item/banner/TDM/blue
	icon_state = "banner-blue"



		//Windows
obj/structure/window/plastitanium/tough/TDM

obj/structure/window/plastitanium/tough/TDM/take_damage()
	return



		//Spawn Protection

/obj/structure/trap/ctf/TDM
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	layer = 2
	density = 0


/obj/structure/trap/ctf/TDM/red
	name = "red base"
	density = 1
//	team = RED_TEAM


/obj/structure/trap/ctf/TDM/blue
	name = "blue base"
	density = 1
//	team = BLUE_TEAM




/*
/obj/structure/trap/ctf
	name = "Spawn protection"
	desc = "Stay outta the enemy spawn!"
	icon_state = "trap"
	resistance_flags = INDESTRUCTIBLE
	var/team = WHITE_TEAM
	time_between_triggers = 1
	anchored = TRUE
	alpha = 255

/obj/structure/trap/ctf/examine(mob/user)
	return

/obj/structure/trap/ctf/trap_effect(mob/living/L)
	if(!is_ctf_target(L))
		return
	if(!(src.team in L.faction))
		to_chat(L, "<span class='danger'><B>Stay out of the enemy spawn!</B></span>")
		L.death()

/obj/structure/trap/ctf/red
	team = RED_TEAM
	icon_state = "trap-fire"

/obj/structure/trap/ctf/blue
	team = BLUE_TEAM
	icon_state = "trap-frost"

*/








		//Metal Doors

/obj/structure/mineral_door/iron/TDM
	name = "metal door"
	desc = "Heavy metal door. It looks very sturdy."


/obj/structure/mineral_door/iron/TDM/take_damage()
	return





/********************** TURFS **************************/

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


		//Dirt

/proc/TDM_dirt()
	for(var/a in list(
		/area/TDM,
		/area/TDM/lobby,
		/area/TDM/red_base,
		/area/TDM/blue_base
		))
		var/area/A = locate(a)
		for(var/turf/open/floor/T in A)
			var/goforit = 1
			for (var/t in list(
			/turf/open/floor/plasteel/stairs
			))
				if(istype(T,t))
					goforit = 0
					break
			if(goforit && prob(20))
				new /obj/effect/decal/cleanable/dirt(T)


/********************** AREAS **************************/




/area/TDM
	name = "Arena"
	icon_state = "blue-red-d"
	has_gravity = TRUE
	dynamic_lighting = 0 //Fully lit at all times
	requires_power = 0 // Constantly powered


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








/********************** WINTER WONDERLAND **************************/


		//Snowballs

/obj/item/toy/snowball/TDM
	name = "snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 60


/obj/item/toy/snowball/TDM/yellow
	name = "yellow snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	color = "#ffff00"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 120



		//Turfs

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



		//Snow Guns

	//DoubleBarrel Snowgun

/obj/item/gun/ballistic/shotgun/doublebarrel/snowgun
	name = "\improper double-barreled snowgun"
	desc = "Double-barreled snowgun. Uses snowballs as ammo."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/snowball
	fire_delay = 30

/obj/item/ammo_box/magazine/internal/shot/dual/snowball
	ammo_type = /obj/item/ammo_casing/snowball
	max_ammo = 2



	//FourBarrel Snowgun

/obj/item/gun/ballistic/shotgun/doublebarrel/snowgun/fourbarrel
	desc = "Four-barreled snowgun. Uses snowballs as ammo."
	name = "\improper four-barreled snowgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/snowball/fourbarrel

/obj/item/ammo_box/magazine/internal/shot/dual/snowball/fourbarrel
	ammo_type = /obj/item/ammo_casing/snowball
	max_ammo = 4



	//Snowball / Ammo

/obj/item/ammo_casing/snowball
	name = "snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	caliber = "snow"
	projectile_type = /obj/item/projectile/bullet/snowball
	throwforce = 60

/obj/item/ammo_casing/snowball/afterattack(atom/target as mob|obj|turf|area, mob/user)
	if(user.dropItemToGround(src))
		throw_at(target, throw_range, throw_speed)

/obj/item/ammo_casing/snowball/throw_impact(atom/hit_atom)
	if(!..())
		playsound(src, 'sound/effects/pop.ogg', 20, 1)
		qdel(src)

/obj/item/ammo_casing/snowball/update_icon()



/obj/item/ammo_casing/snowball/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, spread_mult = 1, atom/fired_from)
	.=..()
	if(.)
		qdel(src)


	//Snowball / Bullet

/obj/item/projectile/bullet/snowball
    name = "snowball"
    icon = 'icons/obj/toy.dmi'
    icon_state = "snowball"
    damage = 55
    //hitsound_wall = "ricochet"
    //impact_effect_type = /obj/effect/temp_visual/impact_effect
    //hitsound = 'sound/weapons/pierce.ogg'


















//
//  Have Fun!
//   - Degeneral
//