

/********************** SECTIONS **************************/

/* DEFINES
 - TDM New & Updated Weapons
 - TDM GEAR
 - STRUCTURES
 - TURFS
 - AREAS
 - WINTER WONDERLAND - SNOWBALLS
*/



/********************** DEFINES **************************/


#define TEIR_2_KILLS 10
#define TEIR_3_KILLS 25
#define TEIR_4_KILLS 50
#define TDM_RED_TEAM "red"
#define TDM_BLUE_TEAM "blue"



/********************** TDM New & Updated Weapons **************************/


		//9mm Pistol - Stechkin - 12 ammo, 20DMG

/obj/item/gun/ballistic/automatic/pistol/TDM
	desc = "A small, easily concealable 9mm handgun. Damage: 20. Fire Rate: 3"
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/TDM

/obj/item/ammo_box/magazine/pistolm9mm/TDM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12



		//9mm Stetchkin APS - 3rnd brst, 12(4) ammo, uses same mags and does same dmg as Stechkin but automatic

/obj/item/gun/ballistic/automatic/pistol/APS/TDM
	desc = "Automatic, easily concealable 9mm handgun. Damage: 20. Fire Rate: 3"
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
	item_state = null
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


/obj/item/gun/ballistic/automatic/pistol/deagle/TDM
	fire_rate = 2.5



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
	if(do_after(user, healtime, user) && !(user && (user in users)))
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
	var/ammunition
	var/rack_sound
	var/respawn_timer = 20
	var/death_count_unlock = 0

/obj/structure/displaycase/TDM_item_spawn/Initialize()
	.=..()
	if(istype(showpiece,/obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/B = showpiece
		if(!B.internal_magazine && !ammunition)
			ammunition = B.mag_type
		if(B.rack_sound)
			rack_sound = B.rack_sound
	if(showpiece)
		name = "[showpiece.name] display case"
		desc = "[showpiece.desc]"

/obj/structure/displaycase/TDM_item_spawn/attack_hand(mob/user)
	if(start_showpiece_type && ammunition)
		var/list/user_contents = user.get_contents()
		for(var/obj/O in user_contents)
			if(istype(O,start_showpiece_type))
				dump_ammo(user)
				return
	. = ..()

/obj/structure/displaycase/TDM_item_spawn/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return
	dump_ammo(user)

/obj/structure/displaycase/TDM_item_spawn/attackby(obj/item/W, mob/user, params)
	return

/obj/structure/displaycase/TDM_item_spawn/take_damage()
	return

/obj/structure/displaycase/TDM_item_spawn/dump()
/*	if(showpiece)
		if(istype(showpiece, /obj/item/gun))
			if(chambered)
				var/obj/item/ammo_casing/A = chambered
				if(BB)
					var/obj/item/projectile/P = BB
			*/
	.=..()
	respawn_item()

/obj/structure/displaycase/TDM_item_spawn/proc/dump_ammo(mob/living/user)
	if(user && ammunition)
		var/obj/item/I = new ammunition(loc)
		user.put_in_hands(I)
		if(rack_sound)
			user << sound(rack_sound, volume = 50)

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
	var/last_opened = 0
	var/personal_cooldowns = list()

/obj/structure/TDM/medical_cabinet/attack_hand(mob/user)
	var/cooldown = personal_cooldowns[user.mind]
	if(cooldown && cooldown > world.time)
		return
	personal_cooldowns[user.mind] = world.time+10
	var/result = alert(user,"Take your meds","Medical Cabinet","Patch","Bandage","Cancel")
	personal_cooldowns[user.mind] = world.time+10
	var/meds
	var/list/options = list("Patch" = /obj/item/reagent_containers/pill/patch/styptic,"Bandage" = /obj/item/stack/medical/gauze/two)
	if(result in options)
		meds = options[result]
	else
		return
	if(meds)
		var/obj/item/I = new meds(user.loc)
		user.put_in_hands(I)
		if(last_opened+11 <= world.time)
			playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
			icon_state = "extinguisher_empty"
			last_opened = world.time
			spawn(10)
				icon_state = initial(icon_state)
				playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)


		//Cloner - Respawn

/obj/structure/TDM/respawn_pod
	name = "cloning pod"
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_1"

/obj/structure/TDM/respawn_pod/New()
	. = ..()
	var/obj/machinery/clonepod/TDM/C = new(loc)
	C.TDM_on = 1
	for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
		if(cloner == C || !cloner.team)
			continue
		if(cloner.team == TDM_RED_TEAM)
			C.team = TDM_BLUE_TEAM
			break
		if(cloner.team == TDM_BLUE_TEAM)
			C.team = TDM_RED_TEAM
			break
	qdel(src)

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

/obj/structure/TDM/spawn_protection
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	layer = 2
	density = 1
	var/team = null
	var/hasShocked = FALSE


/obj/structure/TDM/spawn_protection/Bumped(atom/movable/M)
	if(istype(M, /mob/living))
		var/mob/living/L = M
		if(team)
			if(L.mind && L.mind.assigned_role == "Team Deathmatch" && L.mind.special_role == team)
				var/turf/T = get_turf(src)
				if(T)
					L.forceMove(T)
					return
	bump_field(M)
	. = ..()


/obj/structure/TDM/spawn_protection/proc/clear_shock()
	hasShocked = FALSE


/obj/structure/TDM/spawn_protection/proc/bump_field(atom/movable/AM as mob|obj)
	if(hasShocked)
		return FALSE
	hasShocked = TRUE
	do_sparks(5, TRUE, AM.loc)
	var/atom/target = get_edge_target_turf(AM, get_dir(src, get_step_away(AM, src)))
	AM.throw_at(target, 200, 4)
	addtimer(CALLBACK(src, .proc/clear_shock), 5)



/obj/structure/TDM/spawn_protection/red
	name = "red base"
	team = TDM_RED_TEAM


/obj/structure/TDM/spawn_protection/blue
	name = "blue base"
	team = TDM_BLUE_TEAM



		//Metal Doors

/obj/structure/mineral_door/iron/TDM
	name = "metal door"
	desc = "Heavy metal door. It looks very sturdy."


/obj/structure/mineral_door/iron/TDM/take_damage()
	return







/********************** TURFS **************************/


		//Metal Walls

/turf/closed/indestructible/TDM/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms. It looks very sturdy."
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	canSmoothWith = /turf/closed/indestructible/TDM/wall


/turf/closed/indestructible/TDM/wall/rusty
	name = "rusted wall"
	desc = "A rusted metal wall. It looks very sturdy."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	icon_state = "wall"
	canSmoothWith = /turf/closed/indestructible/TDM/wall/rusty


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
			var/goforit = 0
			for (var/t in list(
			/turf/open/floor/sepia/TDM/dark_10
			))
				if(istype(T,t))
					goforit = 1
					break
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






	//Clonepod Or Whatever (This should go under structures section but who cares)

GLOBAL_LIST_EMPTY(TDM_cloners)
/obj/machinery/clonepod/TDM
	name = "spawn point cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	var/clone_time = 5 //seconds
	var/list/records = list()
	var/TDM_on = 0 //will behave like a normal clonepod if 0
	var/team
	var/list/click_cooldowns = list()
	var/click_cooldown = 3000
	var/times_cloned = 0

/obj/machinery/clonepod/TDM/Initialize()
	. = ..()
	if(!(src in GLOB.TDM_cloners))
		GLOB.TDM_cloners += src
	if(team)
		name = "[team] team [name]"

/obj/machinery/clonepod/TDM/Destroy()
	. = ..()
	GLOB.TDM_cloners -= src

/obj/machinery/clonepod/TDM/process()
	if(TDM_on && !occupant)
		for(var/datum/data/record/R in records)
			grow_clone_from_record(src, R)
	update_display_cases()
	. = ..()

/obj/machinery/clonepod/TDM/attack_ghost(mob/user)
	if(!TDM_on)
		return
	if(click_cooldowns[user.ckey] && click_cooldowns[user.ckey] > world.time)
		to_chat(user,"<span class='warning'>You cant respawn like this at this time.</span>")
		return
	var/client/C = user.client
	var/confirm = alert(user,"Do you wish to join the deathmatch battle?","Team Deathmatch","Yes","No")
	if(confirm != "Yes" || !C || !istype(C.mob,/mob/dead/observer))
		return
	create_human(user)
	click_cooldowns[user.ckey] = world.time+click_cooldown

/obj/machinery/clonepod/TDM/proc/update_display_cases()
	var/area/A = get_area(src)
	if(!A)
		return
	var/enemy_deaths = get_enemy_deaths()
	for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
		if(enemy_deaths >= case.death_count_unlock && !case.open)
			case.toggle_lock()

/obj/machinery/clonepod/TDM/proc/create_human(mob/M)
	var/mob/living/carbon/human/H = new()
	H.forceMove(loc)
	if(M.client)
		M.client.prefs.copy_to(H)
	H.dna.update_dna_identity()
	H.key = M.key
	if(H.mind)
		H.mind.assigned_role = "Team Deathmatch"
		if(team)
			H.mind.special_role = team
	create_record(H)
	equip_clothing(H)
	return H

/obj/machinery/clonepod/TDM/proc/equip_clothing(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/list/red_TDM_outfits = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4)
	var/list/blue_TDM_outfits = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4)
	var/list/team_outfit = list()
	switch(team)
		if(TDM_RED_TEAM)
			team_outfit = red_TDM_outfits
		else if("green")
			team_outfit = blue_TDM_outfits
	if(team_outfit.len)
		var/enemy_deaths = get_enemy_deaths()
		var/teir = 1
		var/chosen = team_outfit["t[teir]"]
		if(enemy_deaths >= TEIR_2_KILLS)
			teir = 2
		if(enemy_deaths >= TEIR_3_KILLS)
			teir = 3
		if(enemy_deaths >= TEIR_4_KILLS)
			teir = 4
		if(team_outfit["t[teir]"])
			chosen = team_outfit["t[teir]"]
		H.equipOutfit(chosen)

/obj/machinery/clonepod/TDM/proc/create_record(mob/M)
	var/mob/living/mob_occupant = get_mob_or_brainmob(M)
	var/datum/dna/dna
	var/mob/living/carbon/C = mob_occupant
	var/mob/living/brain/B = mob_occupant
	if(ishuman(mob_occupant))
		dna = C.has_dna()
	if(isbrain(mob_occupant))
		dna = B.stored_dna
	if(!istype(dna))
		return
	if(NO_DNA_COPY in dna.species.species_traits)
		return
	if(mob_occupant.suiciding || mob_occupant.hellbound)
		return
	if (isnull(mob_occupant.mind))
		return
	var/datum/data/record/R = new()
	if(dna.species)
		dna.delete_species = FALSE
		R.fields["mrace"] = dna.species
	else
		var/datum/species/rando_race = pick(GLOB.roundstart_races)
		R.fields["mrace"] = rando_race.type
	R.fields["name"] = mob_occupant.real_name
	R.fields["id"] = copytext_char(rustg_hash_string(RUSTG_HASH_MD5, mob_occupant.real_name), 2, 6)
	R.fields["UE"] = dna.unique_enzymes
	R.fields["UI"] = dna.uni_identity
	R.fields["SE"] = dna.mutation_index
	R.fields["blood_type"] = dna.blood_type
	R.fields["features"] = dna.features
	R.fields["factions"] = mob_occupant.faction
	R.fields["quirks"] = list()
	for(var/V in mob_occupant.roundstart_quirks)
		var/datum/quirk/T = V
		R.fields["quirks"][T.type] = T.clone_data()
	R.fields["traumas"] = list()
	if(ishuman(mob_occupant))
		R.fields["traumas"] = C.get_traumas()
	if(isbrain(mob_occupant))
		R.fields["traumas"] = B.get_traumas()
	R.fields["mindref"] = "[REF(mob_occupant.mind)]"
	R.fields["last_death"] = mob_occupant.stat == DEAD ? mob_occupant.mind.last_death : -1
	var/datum/data/record/old_record = find_record("mindref", REF(mob_occupant.mind), records)
	if(old_record)
		records -= old_record
	records += R

/obj/machinery/clonepod/TDM/go_out(move = TRUE)
	var/mob/living/carbon/human/M = occupant
	. = ..()
	if(M)
		if(istype(M))
			if(M.client)
				M.client.prefs.copy_to(M)
				M.dna.update_dna_identity()
			M.fully_heal()
			equip_clothing(M)

		if(!mess)
			times_cloned++

/obj/machinery/clonepod/TDM/proc/get_enemy_deaths()
	. = 0
	if(!team)
		return
	for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
		if(cloner == src || !cloner.team)
			continue
		if(cloner.team != team)
			. += cloner.times_cloned

/obj/machinery/clonepod/TDM/RefreshParts()	//locking these numbers, machine parts change nothing.
	. = ..()
	var/dmg_mult = CONFIG_GET(number/damage_multiplier)
	speed_coeff = ((150/clone_time)/dmg_mult)*2 //150 is what the cloner would normally set your cloneloss too upon spawning your new body.
	efficiency = 8
	fleshamnt = 0

/obj/machinery/clonepod/TDM/take_damage()
	return

/obj/machinery/clonepod/TDM/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/clonepod/TDM/ex_act(severity, target)
	return

/obj/machinery/clonepod/TDM/team_red
	team = TDM_RED_TEAM
/obj/machinery/clonepod/TDM/team_blue
	team = TDM_BLUE_TEAM

//Map Template
/datum/map_template/ruin/space/TDM_chambers
	name = "Team DeathMatch Combat Chambers"
	id = "tdm_combat"
	description = "The map for team deathmatch"
	unpickable = FALSE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Dust1.dmm"

/datum/map_template/ruin/space/TDM_lobby
	name = "Team DeathMatch Spawn Chamber"
	id = "tdm_lobby"
	description = "The team lobby for team deathmatch"
	unpickable = FALSE
	always_place = FALSE
	placement_weight = 1
	cost = 0
	allow_duplicates = FALSE
	prefix = "_maps/toolbox/TDM/Lobby.dmm"

var/global/team_death_match_chambers_spawned = 0
/proc/spawn_TDM_chambers()
	if(team_death_match_chambers_spawned)
		return 1
	var/list/z_levels = SSmapping.levels_by_trait(ZTRAIT_CENTCOM)
	var/datum/map_template/ruin/combat = SSmapping.space_ruins_templates["Team DeathMatch Combat Chambers"]
	var/datum/map_template/ruin/lobby = SSmapping.space_ruins_templates["Team DeathMatch Spawn Chamber"]
	var/list/chambers = list(combat,lobby)
	var/counts = 0
	var/did_we_change_it = 0
	if(z_levels && z_levels.len)
		for(var/datum/map_template/ruin/S in chambers)
			if(SSair.can_fire)
				SSair.can_fire = 0
				did_we_change_it = 1
			for(var/i=50,i>0,i--)
				if(S.try_to_place(pick(z_levels),/area/space))
					counts++
					break
	if(counts == chambers.len)
		team_death_match_chambers_spawned = 1
		TDM_dirt()
		. = 1
	if(did_we_change_it)
		SSair.can_fire = 1

//
//  "Have Fun!"
//   - Degeneral
//			"k nerd"
//				- Falaskian