
/********************** TDM OBJECTS **************************/


obj/structure/TDM
	anchored = 1
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE



		//Wall Healer

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
	if(do_after(user, healtime, src) && !(user && (user in users)))
		users.Add(user)
		user.revive(full_heal = TRUE,admin_revive = TRUE)
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
	var/list/no_firing_allowed_areas = list()
	var/install_firing_pin = 1

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

/obj/structure/displaycase/TDM_item_spawn/proc/update_showpiece()
	if(showpiece)
		var/desc_extension = ""
		var/melee = 0
		var/throwdam = 0
		var/shot_damage = 0
		var/ammo = 0
		var/burst = 0
		var/rof = 0
		if(showpiece.force >= 4)
			melee = showpiece.force
		if(showpiece.throwforce >= 3)
			throwdam = showpiece.throwforce
		if(istype(showpiece,/obj/item/gun))
			var/obj/item/gun/G = showpiece
			if(install_firing_pin)
				if(G.pin)
					qdel(G.pin)
					G.pin = null
				var/obj/item/firing_pin/TDM/new_pin = new()
				if(src.no_firing_allowed_areas.len)
					new_pin.no_firing_allowed_areas = src.no_firing_allowed_areas
				G.pin = new_pin
			else if(!G.pin)
				G.pin = new /obj/item/firing_pin()
			if(G.chambered && G.chambered.BB)
				shot_damage = G.chambered.BB.damage
			if(istype(G,/obj/item/gun/ballistic))
				var/obj/item/gun/ballistic/B = G
				if(B.magazine && B.magazine.max_ammo)
					ammo = B.magazine.max_ammo
					if(!G.chambered && !shot_damage)
						for(var/obj/item/ammo_casing/A in B.magazine)
							if(A.BB)
								shot_damage = A.BB.damage
				if(B.fire_delay)
					burst = B.fire_delay
				if(B.fire_rate)
					rof = B.fire_rate
		var/list/words = list(
			"Damage" = shot_damage,
			"Ammo" = ammo,
			"Burst" = burst,
			"Rate of fire" = rof,
			"Melee Damage" = melee,
			"Throw Damage" = throwdam)
		var/line = 0
		for(var/t in words)
			line++
			if(!words[t])
				continue
			desc_extension += "[t]: [words[t]]"
			if(line < words.len)
				desc_extension += ", "
		if(desc_extension)
			showpiece.desc = "[showpiece.desc] [desc_extension]."
			desc = "[desc] [desc_extension]"

/obj/structure/displaycase/TDM_item_spawn/proc/update_to_map(datum/team_deathmatch_map/map)
	if(map && map.no_firing_allowed_areas && map.no_firing_allowed_areas.len)
		no_firing_allowed_areas = map.no_firing_allowed_areas
		update_showpiece()

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
		if(showpiece && !istype(showpiece,start_showpiece_type))
			showpiece.forceMove(loc)
			showpiece = null
		if(!showpiece)
			showpiece = new start_showpiece_type (src)
		if(showpiece)
			update_showpiece()
		update_icon()

/obj/structure/displaycase/TDM_item_spawn/examine()
	. = ..()
	if(!open)
		. += "<span class='notice'>Unlocks at [death_count_unlock] kills.</span>"

	//Greytide display case

/obj/structure/displaycase/TDM_item_spawn/greytide
	var/last_flip_item_time = 0
	var/flip_item_time = 200
	var/list/inventory = list()
	var/list/inventory_black_list = list(
		/obj/item/twohanded/required/kirbyplants,
		/obj/item/gun)

/obj/structure/displaycase/TDM_item_spawn/greytide/Initialize()
	. = ..()
	flip_item_time = rand(flip_item_time-5,flip_item_time+5)
	START_PROCESSING(SSobj, src)

/obj/structure/displaycase/TDM_item_spawn/greytide/process()
	if(world.time >= last_flip_item_time+flip_item_time)
		last_flip_item_time = world.time
		respawn_item(1)

/obj/structure/displaycase/TDM_item_spawn/greytide/update_to_map(datum/team_deathmatch_map/map)
	. = ..()
	for(var/obj/structure/displaycase/TDM_item_spawn/greytide/G in world)
		if(G == src || G.z != z)
			continue
		if(G.inventory.len)
			inventory = G.inventory.Copy()
			break
	if(!map || !map.map)
		return

	//manually add things here. This should be done here because of reasons.
	inventory = list(
		/obj/item/stack/sheet/iron/ten,
		/obj/item/stack/sheet/glass/ten)

	if(map.map)
		var/datum/toolbox_event/team_deathmatch/E
		if(SStoolbox_events)
			for(var/t in SStoolbox_events.cached_events)
				E = SStoolbox_events.is_active(t)
				if(istype(E) && E.active)
					break
		if(!E)
			return
		var/list/coords_list = params2list(E.active_ruins[map.map])
		if(islist(coords_list) && coords_list.len)
			var/turf/center = locate(text2num(coords_list["x"]),text2num(coords_list["y"]),text2num(coords_list["z"]))
			if(istype(center))
				var/list/turfs = map.map.get_affected_turfs(center,1)
				if(turfs.len)
					for(var/turf/T in turfs)
						for(var/obj/O in T)
							var/skip = 0
							if(istype(O,/obj/machinery/vending))
								var/obj/machinery/vending/V = O
								for(var/t in V.products+V.contraband+V.premium)
									if(!(t in inventory))
										inventory += t
								skip = 1
							if(istype(O,/obj/structure/closet))
								var/obj/structure/closet/C = O
								for(var/obj/item/I in C)
									if(!(I.type in inventory))
										inventory += I.type
								skip = 1
							for(var/t in inventory_black_list)
								if(istype(O,t))
									skip = 1
									break
							if(skip)
								continue
							if(!O.anchored && !(O.type in inventory))
								inventory += O.type

/obj/structure/displaycase/TDM_item_spawn/greytide/dump()
	. = ..()
	last_flip_item_time = world.time

/obj/structure/displaycase/TDM_item_spawn/greytide/respawn_item(process_only = 0)
	if(process_only)
		if(showpiece)
			showpiece.moveToNullspace()
			for(var/atom/A in showpiece)
				qdel(A)
			qdel(showpiece)
			showpiece = null
		if(!showpiece && inventory.len)
			var/spawnpath = pick(inventory)
			showpiece = new spawnpath(src)
		update_icon()


		//Tier 1

	//Knife
/obj/structure/displaycase/TDM_item_spawn/knife
	start_showpiece_type = /obj/item/kitchen/knife/combat/TDM
	tier_level = 1

	//Stechkin
/obj/structure/displaycase/TDM_item_spawn/stechkin
	start_showpiece_type = /obj/item/gun/ballistic/automatic/pistol/TDM
	tier_level = 1

	//M1911
/obj/structure/displaycase/TDM_item_spawn/m1911
	start_showpiece_type = /obj/item/gun/ballistic/automatic/pistol/m1911
	tier_level = 1


		//Tier 2

	//Revolver
/obj/structure/displaycase/TDM_item_spawn/revolver
	start_showpiece_type = /obj/item/gun/ballistic/revolver/TDM
	ammunition = /obj/item/ammo_box/a357/TDM
	tier_level = 2

	//Shotgun - Buckshot
/obj/structure/displaycase/TDM_item_spawn/shotgun
	start_showpiece_type = /obj/item/gun/ballistic/shotgun/TDM/buckshot
	ammunition = /obj/item/ammo_box/s12g
	tier_level = 2

	//APS
/obj/structure/displaycase/TDM_item_spawn/APS
	start_showpiece_type = /obj/item/gun/ballistic/automatic/pistol/APS/TDM
	tier_level = 2


		//Tier 3

	//Carbine
/obj/structure/displaycase/TDM_item_spawn/carbine
	start_showpiece_type = /obj/item/gun/ballistic/automatic/surplus/TDM
	tier_level = 3

	//Bolt Action
/obj/structure/displaycase/TDM_item_spawn/bolt_action
	start_showpiece_type = /obj/item/gun/ballistic/rifle/boltaction/TDM
	ammunition = /obj/item/ammo_box/a762/TDM
	tier_level = 3

	//Uzi
/obj/structure/displaycase/TDM_item_spawn/uzi
	start_showpiece_type = /obj/item/gun/ballistic/automatic/pistol/APS/TDM/uzi
	tier_level = 3

	//Riot Shield
/obj/structure/displaycase/TDM_item_spawn/shield
	start_showpiece_type = /obj/item/shield/riot
	tier_level = 3


		//Tier 4

	//Deagle
/obj/structure/displaycase/TDM_item_spawn/deagle
	start_showpiece_type = /obj/item/gun/ballistic/automatic/pistol/deagle/TDM
	tier_level = 4

	//Sniper
/obj/structure/displaycase/TDM_item_spawn/sniper
	start_showpiece_type = /obj/item/gun/ballistic/automatic/sniper_rifle/TDM
	tier_level = 4

	//c20r
/obj/structure/displaycase/TDM_item_spawn/c20r
	start_showpiece_type = /obj/item/gun/ballistic/automatic/c20r/unrestricted/TDM
	tier_level = 4


		//Experimantal

	//Grenade launcher
/obj/structure/displaycase/TDM_item_spawn/grenade_launcher
	start_showpiece_type = /obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted
	ammunition = /obj/item/ammo_casing/a40mm
	tier_level = 4

	//Rocket launcher
/obj/structure/displaycase/TDM_item_spawn/rocket_launcher
	start_showpiece_type = /obj/item/gun/ballistic/rocketlauncher/unrestricted
	ammunition = /obj/item/ammo_casing/caseless/rocket
	tier_level = 4

	//Frag grenade
/obj/structure/displaycase/TDM_item_spawn/frag_grenade
	start_showpiece_type = /obj/item/grenade/syndieminibomb/TDM
	ammunition = null
	tier_level = 4

	//RCD
/obj/structure/displaycase/TDM_item_spawn/rcd
	start_showpiece_type = /obj/item/construction/rcd
	ammunition = /obj/item/rcd_ammo
	tier_level = 4

	//MediGun
/obj/structure/displaycase/TDM_item_spawn/medigun
	start_showpiece_type = /obj/item/gun/medbeam/TDM/team
	ammunition = /obj/item/clothing/glasses/hud/health
	tier_level = 2

	//Katana
/obj/structure/displaycase/TDM_item_spawn/katana
	start_showpiece_type = /obj/item/katana/TDM
	ammunition = /obj/item/clothing/head/fedora
	tier_level = 3

	//Police Baton
/obj/structure/displaycase/TDM_item_spawn/baton
	start_showpiece_type = /obj/item/melee/classic_baton/police/deputy
	ammunition = /obj/item/reagent_containers/food/snacks/donut
	tier_level = 2

	//Hardsuit - Sec
/obj/structure/displaycase/TDM_item_spawn/hardsuit_sec
	start_showpiece_type = /obj/item/clothing/suit/space/hardsuit/security
	ammunition = /obj/item/tank/jetpack/oxygen/harness
	tier_level = 2

	//Hardsuit - Nukie
/obj/structure/displaycase/TDM_item_spawn/hardsuit_nukie
	start_showpiece_type = /obj/item/clothing/suit/space/hardsuit/syndi
	ammunition = /obj/item/tank/jetpack/oxygen/harness
	tier_level = 1



	//Medical Cabinet

/obj/structure/TDM/medical_cabinet
	name = "medical cabinet"
	desc = "A small wall mounted cabinet designed to hold medical equipment."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "medical_cabinet2_closed"
	var/last_opened = 0
	var/personal_cooldowns = list()

/obj/structure/TDM/medical_cabinet/attack_hand(mob/user)
	var/cooldown = personal_cooldowns[user.mind]
	if(cooldown && cooldown > world.time)
		return
	personal_cooldowns[user.mind] = world.time+10
	var/list/options = list("Brute Patch" = /obj/item/reagent_containers/pill/patch/styptic, "Burn Patch" = /obj/item/reagent_containers/pill/patch/kelotane, "Bandage" = /obj/item/stack/medical/gauze/two)
	var/result = input(user,"Take your meds","Medical Cabinet","Brute Patch") as null|anything in options
	personal_cooldowns[user.mind] = world.time+10
	var/meds
	if(result in options)
		meds = options[result]
	else
		return
	if(meds)
		var/obj/item/I = new meds(user.loc)
		user.put_in_hands(I)
		if(last_opened+11 <= world.time)
			playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
			icon_state = "medical_cabinet2_open"
			last_opened = world.time
			spawn(10)
				icon_state = initial(icon_state)
				playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)

		// Burn Patch, this didnt exist
/obj/item/reagent_containers/pill/patch/kelotane
	name = "burn patch"
	desc = "Helps with burns."
	list_reagents = list(/datum/reagent/medicine/kelotane = 12)
	icon_state = "bandaid_burn"


		// Boxes

/obj/structure/ore_box/TDM
	name = "sturdy box"
	desc ="A heavy wooden box. It looks very sturdy."
	anchored = 1
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE


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
	layer = 4.1

/obj/item/banner/TDM/red
	icon_state = "banner-red"

/obj/item/banner/TDM/blue
	icon_state = "banner-blue"



		//Windows
obj/structure/window/plastitanium/tough/TDM
	desc = "A window made of an alloy of of plasma and titanium. It looks very sturdy."
	flags_1 = PREVENT_CLICK_UNDER_1 | NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF


		//Indestructable Shuttle Window
/obj/structure/window/shuttle/TDM
	desc = "A reinforced, air-locked pod window. It looks very sturdy."
	flags_1 = PREVENT_CLICK_UNDER_1 | NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

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
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/machinery/door/poddoor/TDM/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0

/obj/machinery/door/poddoor/TDM/fast
//	autoclose = 20 //2 seconds
	open_speed = 2
	crush_damage = 40

/obj/machinery/door/poddoor/TDM/fast/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0


		//TDM Furnace Circuit Board

/obj/item/circuitboard/machine/ore_redemption/TDM
	name = "furnace board"


		//TDM Recycler - Crusher

/obj/machinery/recycler/TDM
	name = "crusher"
	desc = "A large crushing machine, dont fall in."
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/machinery/recycler/TDM/Initialize()
	.=..()
	obj_flags |= EMAGGED
	safety_mode = FALSE
	update_icon()

/obj/machinery/recycler/TDM/attackby(obj/item/I, mob/user, params)
	return


		//TDM Conveyor. -starts on -cant be switched -cant be disassembled

/obj/machinery/conveyor/TDM
	immune_to_switches = 0
	var/cant_be_disesembled = 0
	var/start_position = 1 // 1 for start forward, -1 for start backwards, 0 for start off

/obj/machinery/conveyor/TDM/Initialize()
	. = ..()
	operating = start_position
	update_move_direction()

//cant be cant_be_disesembled
/obj/machinery/conveyor/TDM/attackby(obj/item/I, mob/user, params)
	if(cant_be_disesembled && I.tool_behaviour && (I.tool_behaviour in list(TOOL_CROWBAR,TOOL_WRENCH,TOOL_SCREWDRIVER)))
		return
	return ..()

//variations
/obj/machinery/conveyor/TDM/permanent
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE
	cant_be_disesembled = 1



		//BlackBoard

/obj/structure/TDM/blackboard
	name = "Blackboard"
	desc = "School blackboard."
	icon = 'icons/oldschool/blackboard.dmi'
	icon_state = "blackboard"
	max_integrity = 500

/obj/structure/TDM/blackboard/meta
	name = "Blackboard"
	desc = "School blackboard."
	icon = 'icons/oldschool/blackboard.dmi'
	icon_state = "metaschool"



	//Glass Sheet x10 - because this didnt exist.

/obj/item/stack/sheet/glass/ten
	amount = 10



	//TDM firing pin

/obj/item/firing_pin/TDM
	fail_message = "<span class='warning'>Do not fire that thing in here!</span>"
	var/list/no_firing_allowed_areas = list()
	can_be_removed = 0
	var/last_do_not_fire_sound = 0

/obj/item/firing_pin/TDM/pin_auth(mob/living/user)
	if(no_firing_allowed_areas.len && user.mind && user.mind.special_role && (user.mind.special_role in no_firing_allowed_areas))
		var/list/areas = no_firing_allowed_areas[user.mind.special_role]
		var/area/A = get_area(user)
		for(var/a in areas)
			if(istype(A,a))
				if(world.time >= last_do_not_fire_sound)
					last_do_not_fire_sound = world.time+50
					user << sound('sound/toolbox/donotfire.ogg', volume = 100)
				return FALSE
	return ..()



	//TDM reequipper dresser

/obj/structure/TDM_dresser
	name = "Re-equipper"
	desc = "Re-equips you with your updated tier of gear."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	anchored = 1
	density = 1
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE
	var/list/equip_cooldowns = list()
	var/equip_cooldown = 100

/obj/structure/TDM_dresser/take_damage()
	return

/obj/structure/TDM_dresser/attack_hand(mob/living/user)
	. = ..()
	if(istype(user,/mob/living/carbon/human) && user.mind && user.mind.special_role)
		var/mob/living/carbon/human/H = user
		var/theoutfit
		for(var/obj/machinery/clonepod/TDM/C in GLOB.TDM_cloners)
			if(C.team == user.mind.special_role)
				theoutfit = C.get_current_tier_outfit()
				break
		if(theoutfit)
			if(!(H in equip_cooldowns) || ((H in equip_cooldowns) && world.time >= equip_cooldowns[H]))
				equip_cooldowns[H] = world.time+equip_cooldown
				H.equipOutfit(theoutfit)
				to_chat(H,"<span class='notice'>You re-equip your self.</span>")
				var/datum/outfit/O = new theoutfit()
				var/list/Ovars = O.vars
				var/list/Hclothingtypes = list()
				var/list/Hcontents = H.get_contents()
				for(var/obj/object in Hcontents)
					if(!(object.type in Hclothingtypes))
						Hclothingtypes += object.type
				for(var/vari in Ovars)
					var/newpath = Ovars[vari]
					if(ispath(newpath))
						if(newpath == O.type)
							continue
						if(!(newpath in Hclothingtypes))
							var/obj/object = new newpath(H.loc)
							if(istype(object))
								var/fullhandstext = ""
								var/handsuccess = H.put_in_hands(object)
								if(!handsuccess)
									fullhandstext = ", dropped to ground"
								to_chat(H,"<span class='warning'>Could not equip [object.name][fullhandstext].</span>")
				qdel(O)



	//Street lines
/obj/structure/TDM/street_line
	name = "white line"
	icon = 'icons/turf/decals.dmi'
	icon_state = "warningline_white"
	dir = 8
	pixel_x = 13



		//Regenerating fire extinguisher cabinet or whatever

/obj/structure/extinguisher_cabinet/regenerating
	var/last_take = 0
	var/respawn_time = 200
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/structure/extinguisher_cabinet/regenerating/proc/regenerate_extinguisher()
	if(!last_take)
		last_take = world.time
		START_PROCESSING(SSobj, src)

/obj/structure/extinguisher_cabinet/regenerating/process()
	if(last_take > 0 && world.time >= last_take+respawn_time)
		last_take= 0
		stored_extinguisher = new /obj/item/extinguisher(src)
		if(opened)
			opened = !opened
			playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/structure/extinguisher_cabinet/regenerating/contents_explosion(severity, target)
	. = ..()
	regenerate_extinguisher()

/obj/structure/extinguisher_cabinet/regenerating/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH && !stored_extinguisher)
		return
	. = ..()

/obj/structure/extinguisher_cabinet/regenerating/attack_hand(mob/user)
	. = ..()
	if(. || iscyborg(user) || isalien(user))
		return
	if(!stored_extinguisher && !last_take)
		regenerate_extinguisher()

/obj/structure/extinguisher_cabinet/regenerating/attack_tk(mob/user)
	. = ..()
	if(stored_extinguisher)
		regenerate_extinguisher()

/obj/structure/extinguisher_cabinet/regenerating/take_damage()
	return

/obj/structure/extinguisher_cabinet/regenerating/obj_break(damage_flag)
	broken = 0
	return

/obj/structure/extinguisher_cabinet/regenerating/deconstruct(disassembled = TRUE)
	return



		//Fence Door
obj/structure/TDM/fence_door
	name = "fence door"
	desc = "A chain link fence door. Its locked."
	icon = 'icons/obj/fence.dmi'
	icon_state = "door_closed"



		//Pickups

obj/item/TDM_pickup
	name = "pick up"
	desc = "Click on me to pick me up."

obj/item/TDM_pickup/health
	name = "instant-aid kit"
	desc = "Heals 50 damage of any type."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	var/total_healing = 50
	var/health_percent_pickup_minimum = 0.9 //the modifier to see if their health is too high to pick this up.

obj/item/TDM_pickup/health/attack_hand(mob/living/user)
	if(iscyborg(user) || !istype(user))
		return
	if(user.health >= round(user.maxHealth*health_percent_pickup_minimum,1))
		user << sound('sound/machines/buzz-two.ogg', volume = 50)
		to_chat(user, "<span class='warning'><B>Your health is too high right now.</B></span>")
		return
	if(!isturf(loc))
		loc = get_turf(src)
	. = ..()

obj/item/TDM_pickup/health/equipped(mob/living/user, slot)
	. = ..()
	var/bruteloss = user.getBruteLoss()
	var/fireloss = user.getFireLoss()
	var/toxloss = user.getToxLoss()
	var/oxyloss = user.getOxyLoss()
	var/healing_remaining = total_healing
	if(bruteloss)
		user.adjustBruteLoss(healing_remaining*-1)
		healing_remaining -= bruteloss
	if(healing_remaining > 0 && fireloss)
		user.adjustFireLoss(healing_remaining*-1)
		healing_remaining -= fireloss
	if(healing_remaining > 0 && toxloss)
		user.adjustToxLoss(healing_remaining*-1)
		healing_remaining -= fireloss
	if(healing_remaining > 0 && oxyloss)
		user.adjustOxyLoss(healing_remaining*-1)
		healing_remaining -= oxyloss
	to_chat(user,"<span class='notice'>You have been healed.</span>")
	playsound(loc, 'sound/effects/refill.ogg', 100)
	qdel(src)

		//Universal Magazine

/obj/item/universal_magazine
	name = "Chameleon Magazine"
	desc = "This magazine is a revolutionary universal weapons magazine, constructed with advanced nanotechnology that instantly adjusts and morphs its ammunition to flawlessly match any firearm, ensuring seamless compatibility and maximizing adaptability on the battlefield."
	icon = 'icons/oldschool/items.dmi'
	icon_state = "universalammo"
	w_class = 2
	var/list/specific_ammo = list() //forces a specific ammo for a specific weapon. write list entries like this example; /obj/item/gun/ballistic/shotgun = /obj/item/ammo_box/magazine/internal/shot/lethal

/obj/item/universal_magazine/afterattack(atom/target as mob|obj|turf|area, mob/user)
	if(istype(target,/obj/item/gun/ballistic) && (CanReach(user,target) || (target in user.DirectAccess())))
		var/obj/item/gun/ballistic/B = target
		var/new_mag_type = null
		if(B.type in specific_ammo)
			new_mag_type = specific_ammo[B.type]
		else if(!B.internal_magazine && B.mag_type && (!B.magazine || B.tac_reloads))
			new_mag_type = B.mag_type
		else if((B.bolt_type == BOLT_TYPE_NO_BOLT || B.internal_magazine) && B.magazine)
			var/gunammo_type = B.magazine.ammo_type
			var/guncaliber = B.magazine.caliber
			if(!gunammo_type || !guncaliber)
				var/obj/item/ammo_box/magazine/internalmag = B.mag_type
				if(internalmag)
					gunammo_type = initial(internalmag.ammo_type)
					guncaliber = initial(internalmag.caliber)
			var/topammo = 0
			for(var/t in subtypesof(/obj/item/ammo_box))
				if(findtext("[t]","/obj/item/ammo_box/magazine/internal"))
					continue
				var/obj/item/ammo_box/box = t
				var/boxcaliber = initial(box.caliber)
				var/boxammo_type = initial(box.ammo_type)
				if((boxammo_type == gunammo_type) || (guncaliber && boxcaliber == guncaliber))
					if(initial(box.max_ammo) > topammo)
						new_mag_type = t
			if(!new_mag_type && gunammo_type)
				new_mag_type = gunammo_type
		if(new_mag_type)
			var/obj/item/box = new new_mag_type()
			if(box)
				moveToNullspace()
				to_chat(user, "<span class='notice'>The [src] transforms into <B>[capitalize(box.name)]</B>.</span>")
				if(user.put_in_hands(box))
					B.attackby(box,user)
				else
					box.forceMove(user.loc)
				qdel(src)
		return
	. = ..()



		//floating item hologram

/obj/structure/holographic_item
	name = "floating item"
	desc = null
	icon = 'icons/oldschool/items.dmi'
	icon_state = "hololamp_broken"
	anchored = 1
	density = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE
	var/image/item_image = null
	var/obj/item/holder = null
	var/last_take = 0
	var/current_outline_frame = 1
	var/list/animation_direction = 1

	//dynamic variables (editable)
	var/image_starter_pixel_y = 5
	var/starting_item		//set as the type of item that will spawn inside this.
	var/respawn_time = 0		//how long to respawn the item once taken?
	var/list/glow_outline_frames = list(		//Set each list entry as how you want each animated frame to be. time: how long is the fame. size: outline thickness. R.G.B: red, green and blue color numbers for the outline. Alpha: the alpha of the outline
		"time=1.7;size=0;R=250;G=228;B=140;alpha=0",
		"time=1.3;size=1;R=250;G=228;B=140;alpha=50",
		"time=1.3;size=1;R=250;G=228;B=140;alpha=80",
		"time=1.3;size=1;R=250;G=228;B=140;alpha=110",
		"time=1.3;size=2;R=250;G=228;B=140;alpha=110")

/obj/structure/holographic_item/Initialize()
	. = ..()
	respawn_item()
	update_icon()
	spawn(0)
		var/sleep_duration = 1
		while(!QDELETED(src))
			sleep_duration = animate_outline()
			if(!isnum(sleep_duration))
				sleep_duration = 1
			sleep_duration = max(1,sleep_duration)
			sleep(sleep_duration)

/obj/structure/holographic_item/process()
	if(!last_take || world.time >= last_take+respawn_time)
		respawn_item()
		STOP_PROCESSING(SSobj, src)

/obj/structure/holographic_item/attack_hand(mob/user)
	if(holder)
		var/holderoldloc = holder.loc
		holder.attack_hand(user)
		if(holder.loc != holderoldloc)
			to_chat(user,"<span class='notice'>You take the [holder].</span>")
			holder = null
			animate_outline()
			last_take = world.time
			START_PROCESSING(SSobj, src)
			update_icon()
			return
	. = ..()

/obj/structure/holographic_item/proc/animate_outline()
	if(!item_image)
		update_icon()
	if(!holder)
		item_image.filters = null
		item_image.pixel_y = image_starter_pixel_y
		return
	if(current_outline_frame >= glow_outline_frames.len||current_outline_frame <= 1)
		current_outline_frame = clamp(current_outline_frame, 1, glow_outline_frames.len)
		animation_direction *= -1
	var/list/paramslist = params2list(glow_outline_frames[current_outline_frame])
	var/sleep_duration = 1
	if(paramslist.len)
		var/thealpha = text2num(paramslist["alpha"])
		var/thesize = text2num(paramslist["size"])
		var/animation_color = rgb(text2num(paramslist["R"]),text2num(paramslist["G"]),text2num(paramslist["B"]),thealpha)
		sleep_duration = text2num(paramslist["time"])
		item_image.pixel_y = (image_starter_pixel_y+current_outline_frame)-1
		if(thesize > 0 && thealpha > 0)
			item_image.filters = filter(type="outline", size=thesize, color=animation_color)
		else if(filters)
			item_image.filters = null
	current_outline_frame += animation_direction
	update_icon()
	return sleep_duration

/obj/structure/holographic_item/proc/respawn_item()
	holder = new starting_item(src)
	name = holder.name
	desc = holder.desc
	update_icon()

/obj/structure/holographic_item/update_icon()
	overlays.Cut()
	if(!item_image)
		item_image = new()
	item_image.icon = null
	item_image.icon_state = null
	item_image.overlays.Cut()
	item_image.color = null
	if(holder)
		icon_state = "hololamp"
		item_image.icon = holder.icon
		item_image.icon_state = holder.icon_state
		item_image.overlays = holder.overlays
		item_image.color = holder.color
	else
		icon_state = "hololamp_broken"
	overlays.Add(item_image)

/obj/structure/holographic_item/take_damage()
	return

/obj/structure/holographic_item/Destroy()
	if(holder)
		if(holder.loc == src)
			qdel(holder)
		holder = null
	return . = ..()


		//floating ammo hologram

/obj/structure/holographic_item/universal_magazine
	starting_item = /obj/item/universal_magazine
	respawn_time = 250

		//floating health hologram

/obj/structure/holographic_item/health_pickup
	starting_item = /obj/item/TDM_pickup/health
	respawn_time = 300




		//Breakable locker

/obj/structure/closet/TDM
	anchorable = 0
	anchored = 1
	var/broken_icon = 'icons/oldschool/objects.dmi'
	var/broken_icon_state = "locker_broken"

/obj/structure/closet/TDM/bust_open()
	. = ..()
	visible_message("<B>The [src] breaks open.</B>")
	addtimer(CALLBACK(src, .proc/reset_broken), 300)

/obj/structure/closet/TDM/proc/reset_broken()
	broken = FALSE
	obj_integrity = max_integrity
	visible_message("The [src] seems to have been repaired on its own.")
	update_icon()

/obj/structure/closet/TDM/can_close(mob/living/user)
	if(broken)
		if(user)
			to_chat(user, "<span class='danger'>The [src] seems to be completely smashed.</span>")
		return FALSE
	return ..()

/obj/structure/closet/TDM/obj_destruction(damage_flag)
	obj_integrity = integrity_failure

/obj/structure/closet/TDM/examine(mob/user)
	. = ..()
	if(broken)
		. += "<span class='warning'>It appears to be totally smashed.</span>"

/obj/structure/closet/TDM/update_icon()
	if(opened && broken && !icon_door_override && !is_animating_door)
		cut_overlays()
		layer = BELOW_OBJ_LAYER
		var/image/I = new()
		I.icon = broken_icon
		I.icon_state = broken_icon_state
		I.pixel_x = -5
		I.pixel_y = -1
		overlays.Add(I)
		return
	return . = ..()

/obj/structure/closet/TDM/tool_interact(obj/item/W, mob/user)
	. = TRUE
	if(opened && W.tool_behaviour == cutting_tool)
		return
	. = ..()

/obj/structure/closet/TDM/attackby(obj/item/W, mob/user, params)
	if((user in src) || (istype(W,/obj/item/stack/sheet/plasteel) && opened && !istype(src,/obj/structure/closet/secure_closet) && !istype(src,/obj/structure/closet/crate)))
		return
	return ..()


		//TDM mime wall
/obj/effect/forcefield/mime/TDM

/obj/effect/forcefield/mime/TDM/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living))
		var/mob/living/L = mover
		if(L.mind && L.mind.assigned_role == "Team Deathmatch" && L.mind.special_role == TDM_BLUE_TEAM)
			return TRUE
	. = ..()

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/TDM
	summon_type = list(/obj/effect/forcefield/mime/TDM)



	//Turret

/obj/machinery/porta_turret/syndicate/TDM
	name = "turret"
	desc = "A ballistic semi-automatic auto-turret."
	icon_state = "syndie_off"
	base_icon_state = "syndie"
	faction = list("no_team")
	max_integrity = 250
	obj_integrity = 250
	scan_range = 8
	shot_delay = 3
	installation = null
	always_up = 1
	use_power = NO_POWER_USE
	has_cover = 0
	req_access = null
	mode = TURRET_LETHAL
	stun_projectile = /obj/item/projectile/bullet/c9mm
	lethal_projectile = /obj/item/projectile/bullet/c9mm
	lethal_projectile_sound = 'sound/weapons/gunshot.ogg'
	stun_projectile_sound = 'sound/weapons/gunshot.ogg'
	armor = list("melee" = 50, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 80, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 90)

/obj/machinery/porta_turret/syndicate/TDM/target(atom/movable/target)
	if(target)
		setDir(get_dir(base, target))//even if you can't shoot, follow the target
		shootAt(target)
		addtimer(CALLBACK(src, .proc/shootAt, target), 5)
		return TRUE

	//Red Team Turret
/obj/machinery/porta_turret/syndicate/TDM/red_team
	name = "red team turret"
	faction = list("red_team")

	//Blue Team Turret
/obj/machinery/porta_turret/syndicate/TDM/blue_team
	name = "blue team turret"
	faction = list("blue_team")


	//ATV

/obj/vehicle/ridden/atv/TDM
	key_type = /obj/item/key
	light_power = 1
	light_range = 7

/obj/vehicle/ridden/atv/TDM/Initialize()
	. = ..()
	inserted_key = new /obj/item/key(src)


	//Armed ATV

/obj/vehicle/ridden/atv/TDM/armed
	var/turret_type = /obj/machinery/porta_turret/syndicate/TDM
	var/obj/machinery/porta_turret/turret = null
	key_type = /obj/item/key

/obj/vehicle/ridden/atv/TDM/armed/Initialize()
	. = ..()
	turret = new turret_type(loc)
	turret.base = src
	turret.density = FALSE
	update_turret_dir()

/obj/vehicle/ridden/atv/TDM/armed/proc/update_turret_dir()
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


/obj/vehicle/ridden/atv/TDM/armed/Moved()
	. = ..()
	update_turret_dir()

	//Red Team Armed ATV
/obj/vehicle/ridden/atv/TDM/armed/red_team
	color = "#FFD6D6"
	turret_type = /obj/machinery/porta_turret/syndicate/TDM/red_team

	//Blue Team Armed ATV
/obj/vehicle/ridden/atv/TDM/armed/blue_team
	color = "#D4DAFF"
	turret_type = /obj/machinery/porta_turret/syndicate/TDM/blue_team



	//Team ID Cards

/obj/item/card/id/red_team
	name = "Access card"
	desc = "Red Team access card."
	icon_state = "sec"
	registered_name = null
	assignment = null
	access = list("red_team")


/obj/item/card/id/blue_team
	name = "Access card"
	desc = "Blue Team access card."
	icon_state = "med"
	registered_name = null
	assignment = null
	access = list("blue_team")

/obj/machinery/light/indestructible
	desc = "A lighting fixture. Seems very sturdy."
	flags_1 = NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/light/indestructible/attack_hand(mob/living/user)
	return


	//Nukie - Station Nuke

/obj/machinery/nuclearbomb/selfdestruct/TDM
	name = "Nuclear Self-Destruct Terminal"
	var/round_end_announce = "This round is over. Major Nukie Victory!"

/obj/machinery/nuclearbomb/selfdestruct/TDM/actually_explode()
	to_chat(world,"wow this worked")
	for(var/t in SStoolbox_events.cached_events)
		var/datum/toolbox_event/team_deathmatch/T = SStoolbox_events.cached_events[t]
		if(istype(T))
			to_chat(world,"wow this worked [T.type]")
			if(T.active)
				to_chat(world,"wow this worked 2")
				T.phase = GAME_OVER_PHASE
				T.announce(round_end_announce)
				explosion(src.loc,6, 12, 24, 0)
				spawn(100)
					T.phase = SETUP_LOBBY
					T.clean_repair_ruins()
					T.restart_players()
					SSmapping.remove_nuke_threat(src)
					T.rotate_map()




