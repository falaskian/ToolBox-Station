




/********************** TDM New & Updated Weapons **************************/



		//9mm Pistol - Stechkin - 12 ammo, 20DMG

/obj/item/gun/ballistic/automatic/pistol/tdm
	desc = "A small, easily concealable 9mm handgun."
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/tdm

/obj/item/ammo_box/magazine/pistolm9mm/tdm
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12



		//9mm Stetchkin APS - 3rnd brst, 12(4) ammo, uses same mags and does same dmg as Stechkin but automatic

/obj/item/gun/ballistic/automatic/pistol/APS/tdm
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/tdm



		//.357 Revolver - 6 ammo, 45DMG

/obj/item/gun/ballistic/revolver/tdm
	name = "\improper .357 revolver"
	desc = "Big Iron on his hip. Uses .357 ammo."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/tdm

/obj/item/ammo_box/magazine/internal/cylinder/tdm
	ammo_type = /obj/item/ammo_casing/a357/tdm
	max_ammo = 6

/obj/item/ammo_box/a357/tdm
	ammo_type = /obj/item/ammo_casing/a357/tdm
	max_ammo = 6

/obj/item/ammo_casing/a357/tdm
	projectile_type = /obj/item/projectile/bullet/a357/tdm

/obj/item/projectile/bullet/a357/tdm
	damage = 45



		//DoubleBarrel Shotgun - Shotgun loaded with buckshot

/obj/item/gun/ballistic/shotgun/doublebarrel/tdm/buckshot
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/tdm
	//rack_sound_volume = 0
	//fire_rate = 2 //being double barrelled, you don't rely on internal mechanisms.
	//pb_knockback = 3

/obj/item/ammo_box/magazine/internal/shot/dual/tdm
	name = "double-barrel shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "shotgun"
	max_ammo = 2
	multiload = 1 //Can be loaded with a speed loader

/* SHELL SPEED LOADER
/obj/item/ammo_box/s12g
	name = "speedloader (12g Buckshot)"
	desc = "Designed to quickly reload double-barrel shotguns."
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 2
	multiple_sprites = 1

//delete itself if ammo is 0 - basically delete the clip after loading ammo into shotgun
*/




		//Uzi 9mm - 3rnd brst, 24(8) ammo, 20DMG

/obj/item/gun/ballistic/automatic/pistol/APS/tdm/uzi
	name = "\improper Type U3 Uzi"
	desc = "A lightweight, burst-fire submachine gun, for when you really want someone dead. Uses 9mm rounds."
	icon_state = "miniuzi"
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_OPEN
	mag_display = TRUE
	mag_type = /obj/item/ammo_box/magazine/uzim9mm/tdm
	burst_size = 3

/obj/item/ammo_box/magazine/uzim9mm/tdm
	max_ammo = 24



		//Carbine - 10 ammo, 35DMG

/obj/item/gun/ballistic/automatic/surplus/tdm
	name = "carbine"
	desc = "California Compliant. Uses .45 carbine ammo and its bulky frame prevents one-hand firing."
	mag_type = /obj/item/ammo_box/magazine/m45carbine
	fire_delay = 0
	fire_rate = 2.5

/obj/item/ammo_box/magazine/m45carbine
	name = "rifle magazine (.45 Carbine)"
	desc = "California compliant 10 round magazine."
	icon_state = "75-8"
	ammo_type = /obj/item/ammo_casing/c45carbine
	caliber = ".45c"
	max_ammo = 10

/obj/item/ammo_casing/c45carbine
	name = ".45 carbine bullet casing"
	desc = "A .45 carbine bullet casing."
	caliber = ".45c"
	projectile_type = /obj/item/projectile/bullet/c45carbine

/obj/item/projectile/bullet/c45carbine
	name = ".45 carbine bullet"
	damage = 35



		//Knife - 35DMG, 30DMG thrown
/obj/item/kitchen/knife/combat/tdm
	desc = "A military combat utility survival knife."
	force = 35
	throwforce = 30
	bayonet = TRUE




/*

/********************** TDM GEAR **************************/







*/








/********************** OTHER **************************/


		//Snowballs

/obj/item/toy/snowball/tdm
	name = "snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 60


/obj/item/toy/snowball/tdm/yellow
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


/********************** DISPLAY CASE **************************/


/obj/structure/displaycase/itemspawn
	name = "item spawn display case"
	var/respawn_timer = 20

/obj/structure/displaycase/Initialize()
	.=..()
	if(showpiece)
		name = "[showpiece.name] display case"

/obj/structure/displaycase/itemspawn/attackby(obj/item/W, mob/user, params)
	return

/obj/structure/displaycase/itemspawn/obj_break(damage_flag)
	return

/obj/structure/displaycase/proc/dump()
	.=..()
	respawn_item()

/obj/structure/displaycase/proc/respawn_item()
	if(!start_showpiece_type)
		return
	spawn(respawn_timer)
		if(!showpiece)
			showpiece = new start_showpiece_type (src)
			update_icon()

