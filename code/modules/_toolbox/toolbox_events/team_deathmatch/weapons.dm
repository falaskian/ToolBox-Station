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

//*************** Misc Weapons ************

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

