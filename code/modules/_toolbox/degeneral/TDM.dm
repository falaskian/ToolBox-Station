

/********************** SECTIONS **************************/

/* DEFINES
 - TDM New & Updated Weapons
 - TDM GEAR - OUTFITS, CLOTHES
 - STRUCTURES
 - TURFS
 - AREAS
 - WINTER WONDERLAND - SNOWBALLS
*/



/********************** DEFINES **************************/

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


/*
	//OUTFIT TEMPLATE

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


	//Lobby

/datum/outfit/TDM_lobby
    name = "TDM Lobby"
    uniform = /obj/item/clothing/under/color/grey
    shoes = /obj/item/clothing/shoes/sneakers/black

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



		//TDM Clowns

	//TDM Clown Red

/datum/outfit/TDM/clown/red
	name = "TDM Clown Red Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown
	belt = /obj/item/storage/belt/fannypack/red
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/red/t3
	name = "TDM Clown Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/red/t4
	name = "TDM Clown Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



	//TDM Clown Blue

/datum/outfit/TDM/clown/blue
	name = "TDM Clown Blue Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown/blue
	belt = /obj/item/storage/belt/fannypack/blue
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/sexyclown
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/blue/t3
	name = "TDM Clown Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/blue/t4
	name = "TDM Clown Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



		//TDM Mime

/datum/outfit/TDM/mime
	name = "TDM Mime"
	uniform = /obj/item/clothing/under/rank/civilian/mime/TDM
	belt = /obj/item/storage/belt/fannypack/red
	suit = /obj/item/clothing/suit/suspenders/TDM
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/sneakers/black
	head = /obj/item/clothing/head/frenchberet
	mask = /obj/item/clothing/mask/gas/mime/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/mime/t3
	name = "TDM Mime T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/mime/t4
	name = "TDM Mime T3"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



		//DeathRun Outfits

	//Death Outfit

/datum/outfit/TDM/Death
	name = "TDM Death"
	uniform = /obj/item/clothing/under/color/black/TDM
	suit = /obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM
	neck = /obj/item/clothing/neck/cloak/chap/bishop/black/TDM
	belt = /obj/item/storage/belt/fannypack/black
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/bishopmitre/black/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	r_hand = /obj/item/nullrod/scythe


	//Runner Outfit

/datum/outfit/TDM/Runner
	name = "TDM Runner"
	uniform = /obj/item/clothing/under/color/grey/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two



		//TDM Space Outfits

	//Red Team Space Suit

/datum/outfit/TDM/red_space
	name = "TDM Red Team Space"
	uniform = /obj/item/clothing/under/color/red/TDM
	belt = /obj/item/storage/belt/fannypack/red
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/old
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	suit = /obj/item/clothing/suit/space/syndicate/black/red/TDM
	back = /obj/item/tank/jetpack/oxygen/security/TDM_Red
	head = /obj/item/clothing/head/helmet/space/syndicate/black/red/TDM


	//Blue Team Space Suit

/datum/outfit/TDM/blue_space
	name = "TDM Blue Team Space"
	uniform = /obj/item/clothing/under/color/blue/TDM
	belt = /obj/item/storage/belt/fannypack/blue
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/old
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	suit = /obj/item/clothing/suit/space/syndicate/black/blue/TDM
	back = /obj/item/tank/jetpack/oxygen/TDM_Blue
	head = /obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM



		//TDM Assistants

	//TDM Assistant Red

/datum/outfit/TDM/assistant_red
	name = "TDM Assistant Red"
	uniform = /obj/item/clothing/under/color/grey/TDM
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	accessory = /obj/item/clothing/accessory/armband/TDM


	//TDM Assistant Blue

/datum/outfit/TDM/assistant_blue
	name = "TDM Assistant Blue"
	uniform = /obj/item/clothing/under/color/grey/TDM
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	accessory = /obj/item/clothing/accessory/armband/blue/TDM



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

/obj/item/clothing/head/beret/TDM/green
	name = "green beret"
	color = "#00B200" //Green



		//Jumpsuits

	//Red TDM Jumpsuit

/obj/item/clothing/under/color/red/TDM
	can_adjust = 0
	resistance_flags = 115

/obj/item/clothing/under/color/red/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Jumpsuit

/obj/item/clothing/under/color/blue/TDM
	can_adjust = 0
	resistance_flags = 115

/obj/item/clothing/under/color/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Black TDM Jumpsuit

/obj/item/clothing/under/color/black/TDM
	can_adjust = 0
	resistance_flags = 115

/obj/item/clothing/under/color/black/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Grey TDM Jumpsuit

/obj/item/clothing/under/color/grey/TDM
	can_adjust = 0
	resistance_flags = 115

/obj/item/clothing/under/color/grey/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Armbands

	//Red Armband

/obj/item/clothing/accessory/armband/TDM
	resistance_flags = 115

/obj/item/clothing/accessory/armband/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue Armband

/obj/item/clothing/accessory/armband/blue/TDM
	resistance_flags = 115

/obj/item/clothing/accessory/armband/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


		//Death Clothes

	//Death Robe

/obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM
	name = "death robe"
	desc = "Very ominous robe."

/obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Death Hat

/obj/item/clothing/head/bishopmitre/black/TDM
	name = "death hat"
	desc = "Very ominous hat."

/obj/item/clothing/head/bishopmitre/black/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Death Cloak

/obj/item/clothing/neck/cloak/chap/bishop/black/TDM
	name = "death cloak"
	desc = "Very ominous cloak."

/obj/item/clothing/neck/cloak/chap/bishop/black/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Space Suits

	//Red TDM Space Suit

/obj/item/clothing/suit/space/syndicate/black/red/TDM
	resistance_flags = 115

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Space Suit

/obj/item/clothing/suit/space/syndicate/black/blue/TDM
	resistance_flags = 115

/obj/item/clothing/suit/space/syndicate/black/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Space Helmets

	//Red TDM Space Helmet

/obj/item/clothing/head/helmet/space/syndicate/black/red/TDM
	resistance_flags = 115

/obj/item/clothing/head/helmet/space/syndicate/black/red/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Space Helmet

/obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM
	resistance_flags = 115

/obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//JetPacks

	//Harness Jetpack TDM

/obj/item/tank/jetpack/oxygen/harness/TDM
	resistance_flags = 115

	//Red TDM JetPack

/obj/item/tank/jetpack/oxygen/security/TDM_Red
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	resistance_flags = 115


	//Blue TDM JetPack

/obj/item/tank/jetpack/oxygen/TDM_Blue
	resistance_flags = 115



		//Mimes

	//TDM Mime Mask

/obj/item/clothing/mask/gas/mime/TDM
	resistance_flags = 115

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//TDM Mime Jumpsuit

/obj/item/clothing/under/rank/civilian/mime/TDM
	can_adjust = 0
	resistance_flags = 115

/obj/item/clothing/under/rank/civilian/mime/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//TDM Mime Suspenders

/obj/item/clothing/suit/suspenders/TDM
	resistance_flags = 115

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
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
	var/tier_level = 1

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



		// Boxes

/obj/structure/ore_box/TDM
	name = "sturdy box"
	desc ="A heavy wooden box. It looks very sturdy."
	anchored = 1
	resistance_flags = 115


/obj/structure/ore_box/TDM/take_damage()
	return



		//Sandbags

/obj/structure/barricade/sandbags/TDM
	desc = "Bags of sand. Self explanatory. They look very sturdy."
	canSmoothWith = list(/obj/structure/barricade/sandbags/TDM, /obj/structure/barricade/sandbags, /turf/closed/wall, /turf/closed/wall/r_wall, /obj/structure/falsewall, /obj/structure/falsewall/reinforced, /turf/closed/wall/rust, /turf/closed/wall/r_wall/rust, /obj/structure/barricade/security)


/obj/structure/barricade/sandbags/TDM/take_damage()
	return



		//Banners

/obj/item/banner/TDM
	anchored = 1

/obj/item/banner/TDM/red
	icon_state = "banner-red"

/obj/item/banner/TDM/blue
	icon_state = "banner-blue"



		//Windows
obj/structure/window/plastitanium/tough/TDM
	desc = "A window made of an alloy of of plasma and titanium. It looks very sturdy."

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



		//APC

/obj/structure/TDM/apc
	name = "area power controller"
	desc = "A control terminal for the area's electrical systems."
	icon = 'icons/obj/power.dmi'
	icon_state = "apc0"

/obj/structure/TDM/apc/Initialize()
	update_icon()


/obj/structure/TDM/apc/red/update_icon()


/obj/structure/TDM/apc/red/update_icon()
//	.=..()
	SSvis_overlays.add_vis_overlay(src, icon, "apco3-0", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
	SSvis_overlays.add_vis_overlay(src, icon, "apcox-1", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
	SSvis_overlays.add_vis_overlay(src, icon, "apco0-0", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)



/obj/structure/TDM/apc/blue/update_icon()


/obj/structure/TDM/apc/blue/update_icon()
//	.=..()
	SSvis_overlays.add_vis_overlay(src, icon, "apco3-1", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
	SSvis_overlays.add_vis_overlay(src, icon, "apcox-0", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
	SSvis_overlays.add_vis_overlay(src, icon, "apco0-3", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)



		//Optic Fibre

/obj/structure/cable/TDM
	name = "optic fibre"
	desc = "Huh? Where does this lead to?"
	light_power = 0.3
	light_range = 3.5
	light_color = null


/obj/structure/cable/TDM/Initialize()
	var/thedash = findtext(icon_state, "-")
	var/num1 = copytext(icon_state, 1, thedash)
	var/num2 = copytext(icon_state, thedash+1, length(icon_state)+1)
	d1 = num1
	d2 = num2
	.=..()


/obj/structure/cable/TDM/hide(i)
	return


/obj/structure/cable/TDM/yellow
	cable_color = "#ffff00"
	color = "#ffff00"


/obj/structure/cable/TDM/white
	cable_color = "#ffffff"
	color = null



		//Floodlight

/obj/structure/TDM/floodlight
	name = "floodlight"
	desc = "A pole with powerful mounted lights on it. Due to its high power draw, it must be powered by a direct connection to a wire node."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floodlight_on"
	density = TRUE
	max_integrity = 200
	light_power = 1.5
	light_range = 8


		//Blast Doors

/obj/machinery/door/poddoor/TDM
	autoclose = FALSE
	resistance_flags = 115

/obj/machinery/door/poddoor/TDM/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0

/obj/machinery/door/poddoor/TDM/fast
//	autoclose = 20 //2 seconds
	open_speed = 2

/obj/machinery/door/poddoor/TDM/fast/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0


		//TDM Ore Furnace

/obj/machinery/mineral/ore_redemption/TDM
	name = "furnace"
	use_power = 0
	resistance_flags = 115
	circuit = /obj/item/circuitboard/machine/ore_redemption/TDM

/obj/machinery/mineral/ore_redemption/TDM/process()
	.=..()
	if(!materials.mat_container || panel_open || !powered())
		return
	materials.mat_container.retrieve_all(get_step(src, output_dir))

/obj/machinery/mineral/ore_redemption/TDM/ui_interact(mob/user, datum/tgui/ui)
	return

/obj/machinery/mineral/ore_redemption/TDM/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore))
		.=..()
	else
		return


		//TDM Furnace Circuit Board

/obj/item/circuitboard/machine/ore_redemption/TDM
	name = "furnace board"


		//TDM Recycler - Crusher

/obj/machinery/recycler/TDM
	name = "crusher"
	desc = "A large crushing machine, dont fall in."
	resistance_flags = 115

/obj/machinery/recycler/TDM/Initialize()
	.=..()
	obj_flags |= EMAGGED
	safety_mode = FALSE
	update_icon()

/obj/machinery/recycler/TDM/attackby(obj/item/I, mob/user, params)
	return



/********************** TURFS **************************/


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





/********************** CLOWNS **************************/


		//CLOWN WEAPONS

	//Banana -

/obj/item/reagent_containers/food/snacks/grown/banana/TDM
	name = "deadly banana"
	desc = "It's an excellent weapon for a clown. Very nutritious! It seems like you could eat it in three bites. Damage: 35 Damage Thrown: 20"
	force = 35
	throwforce = 20
	bitesize = 3
	trash = /obj/item/grown/bananapeel/TDM
	list_reagents = list(/datum/reagent/medicine/bicaridine = 30, /datum/reagent/consumable/nutriment = 3)

	//Banana Peel

/obj/item/grown/bananapeel/TDM
	name = "deadly banana peel"
	desc = "A peel from a banana. You just want to throw it. Damage Thrown: 35"
	throwforce = 35




		//CLOWN CLOTHES

/obj/item/clothing/under/rank/civilian/clown/TDM
	can_adjust = 0

/obj/item/clothing/under/rank/civilian/clown/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/mask/gas/clown_hat/TDM

/obj/item/clothing/mask/gas/clown_hat/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/under/rank/civilian/clown/blue/TDM
	can_adjust = 0

/obj/item/clothing/under/rank/civilian/clown/blue/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/shoes/clown_shoes/TDM
//	slowdown = 0.2

/obj/item/clothing/shoes/clown_shoes/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/mask/gas/sexyclown/TDM

/obj/item/clothing/mask/gas/sexyclown/TDM/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)




		//TDM CLOWN OUTFITS


	//OUTFIT TDM CLOWN RED

/datum/outfit/TDM/clown/red
	name = "TDM Clown Red Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown
	belt = /obj/item/storage/belt/fannypack/red
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/food/snacks/grown/banana/TDM
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/red/t3
	name = "TDM Clown Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/red/t4
	name = "TDM Clown Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



	//OUTFIT TDM CLOWN BLUE

/datum/outfit/TDM/clown/blue
	name = "TDM Clown Blue Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown/blue
	belt = /obj/item/storage/belt/fannypack/blue
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/sexyclown
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/food/snacks/grown/banana/TDM
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/blue/t3
	name = "TDM Clown Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/blue/t4
	name = "TDM Clown Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt






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
GLOBAL_LIST_EMPTY(TDM_cloner_records)
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
	var/list/teir_kills = list(0,3,6,15)
	var/list/team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))

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
	if(TDM_on && team && !occupant && (team in GLOB.TDM_cloner_records))
		for(var/datum/data/record/R in GLOB.TDM_cloner_records[team])
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
		if((enemy_deaths >= case.death_count_unlock && !case.open)||(enemy_deaths < case.death_count_unlock && case.open))
			case.toggle_lock()

/obj/machinery/clonepod/TDM/proc/update_display_cases_tiers()
	var/area/A = get_area(src)
	if(!A)
		return
	for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
		var/tier = 1
		for(var/t in teir_kills)
			if(tier == case.tier_level)
				case.death_count_unlock = t
				break
			tier++

/obj/machinery/clonepod/TDM/proc/create_human(mob/M)
	var/mob/living/carbon/human/H = new()
	H.forceMove(loc)
	H.key = M.key
	if(H.client)
		H.client.prefs.copy_to(H)
	H.dna.update_dna_identity()
	if(H.mind)
		GLOB.dont_inform_to_adminhelp_death += H.mind
		H.mind.assigned_role = "Team Deathmatch"
		if(team)
			H.mind.special_role = team
	create_record(H)
	equip_clothing(H)
	return H

/obj/machinery/clonepod/TDM/proc/equip_clothing(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/list/team_outfit = list()
	if(team && (team in team_outfits))
		team_outfit = team_outfits[team]
	if(team_outfit && team_outfit.len)
		var/enemy_deaths = get_enemy_deaths()
		var/teir = 1
		var/chosen = team_outfit["t[teir]"]
		for(var/t in teir_kills)
			if(enemy_deaths >= t)
				teir++
			if(team_outfit["t[teir]"])
				chosen = team_outfit["t[teir]"]
		for(var/obj/O in H)
			qdel(O)
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
	var/datum/data/record/old_record = find_record("mindref", REF(mob_occupant.mind), GLOB.TDM_cloner_records)
	if(!GLOB.TDM_cloner_records[team])
		GLOB.TDM_cloner_records[team] = list()
	if(old_record && team)
		GLOB.TDM_cloner_records[team] -= old_record
	GLOB.TDM_cloner_records[team] += R

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

//clownpod
/obj/machinery/clonepod/TDM/clowner
	team = "red"
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/clown/red,
		"t3" = /datum/outfit/TDM/clown/red/t3,
		"t4" = /datum/outfit/TDM/clown/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))

/obj/machinery/clonepod/TDM/clowner/Initialize()
	. = ..()
	var/thefindtext = findtext(name,"clone")
	while(thefindtext)
		name = replacetext(name,"clone","clown")
		thefindtext = findtext(name,"clone")
		if(!thefindtext)
			thefindtext = null


/********************** ECONOMY **************************/

		//TDM Lizard Workers


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM
	name =  "Lizard Worker"
	equipped_items = list(/obj/item/clothing/under/color/grey = SLOT_W_UNIFORM)


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM/red
	equipped_items = list(/obj/item/clothing/under/color/red = SLOT_W_UNIFORM)


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM/blue
	equipped_items = list(/obj/item/clothing/under/color/blue = SLOT_W_UNIFORM)


		//TDM ore node

// dont forget to place crates and /obj/effect/slave_ore_dropoff_point

/obj/structure/lizard_ore_node/TDM
	ore = list(/obj/item/stack/ore/gold = 10)




//
//  "Have Fun!"
//   - Degeneral
//			"k nerd"
//				- Falaskian