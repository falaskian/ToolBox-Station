/********************** TDM New & Updated Weapons **************************/

/obj/item/gun/ballistic/automatic/sniper_rifle/TDM
	name = "sniper rifle"
	desc = "A long ranged weapon that does significant damage. No, you can't quickscope."
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = "sound/weapons/sniper_shot.ogg"
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	rack_sound = "sound/weapons/sniper_rack.ogg"
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	fire_delay = 40
	burst_size = 1
	w_class = WEIGHT_CLASS_NORMAL
	zoomable = TRUE
	zoom_amt = 0 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE
	block_upgrade_walk = 1
	zoom_requires_in_active_hand = 1

	//9mm Pistol - Stechkin - 12 ammo, 20DMG
/obj/item/gun/ballistic/automatic/pistol/TDM
	desc = "A small, easily concealable 9mm handgun."
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/TDM

/obj/item/ammo_box/magazine/pistolm9mm/TDM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12



	//9mm Stetchkin APS - 3rnd brst, 12(4) ammo, uses same mags and does same dmg as Stechkin but automatic
/obj/item/gun/ballistic/automatic/pistol/APS/TDM
	desc = "Automatic, easily concealable 9mm handgun."
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm/TDM
	can_be_dual_wielded = 0


	//.357 Revolver - 6 ammo, 45DMG
/obj/item/gun/ballistic/revolver/TDM
	name = "\improper .357 revolver"
	desc = "Big Iron on his hip. Uses .357 ammo."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/TDM
	fire_rate = 1.7
	can_be_dual_wielded = 0

	//Magazine - Internal
/obj/item/ammo_box/magazine/internal/cylinder/TDM
	ammo_type = /obj/item/ammo_casing/a357/TDM
	max_ammo = 6

	//Ammo
/obj/item/ammo_casing/a357/TDM
	projectile_type = /obj/item/projectile/bullet/a357/TDM

	//Bullet
/obj/item/projectile/bullet/a357/TDM
	damage = 45

	//Speedloader
/obj/item/ammo_box/a357/TDM
	ammo_type = /obj/item/ammo_casing/a357/TDM
	max_ammo = 6


		//Shotguns

	//DoubleBarrel Shotgun - Slug
/obj/item/gun/ballistic/shotgun/doublebarrel/TDM
	desc = "A true classic."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/TDM
	//rack_sound_volume = 0
	//fire_rate = 2 //being double barrelled, you don't rely on internal mechanisms.
	//pb_knockback = 3
	can_be_dual_wielded = 0

	//DoubleBarrel Shotgun - Buckshot
/obj/item/gun/ballistic/shotgun/doublebarrel/TDM/buckshot
	desc = "A true classic."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/TDM/buckshot
	can_be_dual_wielded = 0

	//Pump Shotgun - Slug
/obj/item/gun/ballistic/shotgun/TDM
	desc = "A traditional shotgun with wood furniture and a four-shell capacity underneath."
	name = "pump shotgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/TDM
	can_be_dual_wielded = 0

	//Pump Shotgun - Buckshot
/obj/item/gun/ballistic/shotgun/TDM/buckshot
	mag_type = /obj/item/ammo_box/magazine/internal/shot/TDM/buckshot
	can_be_dual_wielded = 0


		//Shotgun Mags

	//DoubleBarrel - Slug
/obj/item/ammo_box/magazine/internal/shot/dual/TDM
	ammo_type = /obj/item/ammo_casing/shotgun/TDM
	max_ammo = 2
	multiload = 1

	//DoubleBarrel - Buckshot
/obj/item/ammo_box/magazine/internal/shot/dual/TDM/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/TDM

	//Pump Shotgun - Slug
/obj/item/ammo_box/magazine/internal/shot/TDM
	ammo_type = /obj/item/ammo_casing/shotgun/TDM
	max_ammo = 4
	multiload = 1

	//Pump Shotgun - Buckshot
/obj/item/ammo_box/magazine/internal/shot/TDM/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/TDM


		//Shotgun Ammo

	//Slug
/obj/item/ammo_casing/shotgun/TDM
	projectile_type = /obj/item/projectile/bullet/shotgun_slug/TDM

	//Buckshot
/obj/item/ammo_casing/shotgun/buckshot/TDM
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun_buckshot/TDM


		//Shotgun Projectile

	//Slug
/obj/item/projectile/bullet/shotgun_slug/TDM
	damage = 60
	armour_penetration = -20

	//Buckshot
/obj/item/projectile/bullet/pellet/shotgun_buckshot/TDM
	name = "buckshot pellet"
	damage = 12
	tile_dropoff = 0.5


	//Shotgun Speedloader

	//Buckshot
/obj/item/ammo_box/s12g
	name = "speedloader (12g Buckshot)"
	desc = "Designed to quickly reload double-barrel shotguns."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "gshell-live"
	item_state = null
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/TDM
	max_ammo = 2

/obj/item/ammo_box/s12g/Initialize()
	.=..()
	update_icon()

/obj/item/ammo_box/s12g/update_icon()
	overlays.Cut()
	.=..()
	var/ammo_count = 0
	for(var/obj/item/ammo_casing/A in src)
		if(A.BB)
			ammo_count++
	if(ammo_count > 1)
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
	desc = "A lightweight submachine gun. Uses 9mm rounds."
	icon_state = "miniuzi"
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_OPEN
	mag_display = TRUE
	mag_type = /obj/item/ammo_box/magazine/uzim9mm/TDM
	burst_size = 3
	can_be_dual_wielded = 0

	//Uzi Magazine
/obj/item/ammo_box/magazine/uzim9mm/TDM
	max_ammo = 24



	//Carbine - 10 ammo, 35DMG
/obj/item/gun/ballistic/automatic/surplus/TDM
	name = "carbine"
	desc = "California Compliant. Uses .45 carbine ammo and its bulky frame prevents one-hand firing."
	mag_type = /obj/item/ammo_box/magazine/m45carbine
	fire_delay = 0
	fire_rate = 2.8
	can_be_dual_wielded = 0

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
	desc = "A military combat knife."
	force = 35
	throwforce = 30
	bayonet = TRUE


	//Katana
/obj/item/katana/TDM
	force = 50


	//Deagle
/obj/item/gun/ballistic/automatic/pistol/deagle/TDM
	fire_rate = 2.5
	can_be_dual_wielded = 0



	//c20r SMG
/obj/item/gun/ballistic/automatic/c20r/unrestricted/TDM
	can_be_dual_wielded = 0



	//Bolt Action Rifle
/obj/item/gun/ballistic/rifle/boltaction/TDM
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/TDM
	can_be_dual_wielded = 0

	//Magazine - Internal
/obj/item/ammo_box/magazine/internal/boltaction/TDM
	ammo_type = /obj/item/ammo_casing/a762/TDM

	//Ammo
/obj/item/ammo_casing/a762/TDM
	projectile_type = /obj/item/projectile/bullet/a762/TDM

	//Projectile
/obj/item/projectile/bullet/a762/TDM
	damage = 60
	armour_penetration = 20

	//SpeedLoader - Clip
/obj/item/ammo_box/a762/TDM
	ammo_type = /obj/item/ammo_casing/a762/TDM



	//MediGun

/obj/item/gun/medbeam/TDM
	name = "MediGun"
	var/color_cross = "#80F5FF"
	var/heal_brute = -15
	var/heal_burn = -15
	var/heal_tox = -5
	var/heal_oxy = -5

/obj/item/gun/medbeam/TDM/on_beam_tick(var/mob/living/target)
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), color_cross)
	target.adjustBruteLoss(heal_brute)
	target.adjustFireLoss(heal_burn)
	target.adjustToxLoss(heal_tox)
	target.adjustOxyLoss(heal_oxy)
	return

	//MediGun Team - Heals teammates and damages enemies

/obj/item/gun/medbeam/TDM/team
	desc = "Heals teammates and damages enemies. Don't cross the streams!"
	var/enemy_damage = 10 //Burn
	var/beam_harm_color = "#F23838" //color of the beam when it is doing damage

/obj/item/gun/medbeam/TDM/team/on_beam_tick(var/mob/living/target)
	var/mob/living/user = loc
	if(!check_team(target,user))
		target.adjustFireLoss(enemy_damage)
		return
	.=..()

/obj/item/gun/medbeam/TDM/team/proc/check_team(mob/living/target,mob/living/user)
	if(istype(user) && user.mind && istype(target) && target.mind && target.mind.special_role == user.mind.special_role)
		return TRUE
	return FALSE

/obj/item/gun/medbeam/TDM/team/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!check_team(target,user))
		beam_color = beam_harm_color
	else
		beam_color = initial(beam_color)
	.=..()


	//TDM Frag Grenade

/obj/item/grenade/syndieminibomb/TDM
	name = "frag grenade"
	desc = "Fire in the hole."
	icon_state = "frag"
	var/Destruction_range = 0 //Deletes turfs
	var/Heavy_impact_range = 0 //Damages and deletes walls and floors
	var/Light_impact_range = 3 //Damages turfs and delimbs mobs, only deletes mineral walls
	var/Flash_range = 4 //Flashes the player
	var/Flame_range = 2 //Range of flames that can light player on fire

/obj/item/grenade/syndieminibomb/TDM/prime()
	update_mob()
	explosion(src.loc,Destruction_range,Heavy_impact_range,Light_impact_range,Flash_range,flame_range = Flame_range)
	qdel(src)


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
	can_be_dual_wielded = 0

/obj/item/ammo_box/magazine/internal/shot/dual/snowball
	ammo_type = /obj/item/ammo_casing/snowball
	max_ammo = 2



	//FourBarrel Snowgun

/obj/item/gun/ballistic/shotgun/doublebarrel/snowgun/fourbarrel
	desc = "Four-barreled snowgun. Uses snowballs as ammo."
	name = "\improper four-barreled snowgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/snowball/fourbarrel
	can_be_dual_wielded = 0

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

