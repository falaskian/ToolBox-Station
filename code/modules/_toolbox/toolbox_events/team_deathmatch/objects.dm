/********************** MISC OBJECTS **************************/


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