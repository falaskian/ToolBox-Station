//**********************
//space jesus extra role
//**********************
/mob
	var/omnipotent_access = 0

/datum/extra_role/space_jesus
	var/mob/living/tracked_owner
	var/incorporeal_move = 1
	var/list/active_actions = list()
	var/list/action_datums = list(
				/datum/action/jesus_disappear,
				/datum/action/togglecorporeal,
				/datum/action/jesus_heal,
				/datum/action/jesus_hallelujah,
				/datum/action/jesus_destroyer)
	var/datum/mind/saved_mind
	var/list/owned_items = list()
	var/obj/item/gun/energy/pulse/destroyer/jesus/destroyer

/datum/extra_role/space_jesus/on_gain(mob/user)
	if(!affecting || !affecting.current)
		return
	if(!tracked_owner)
		tracked_owner = affecting.current
	jesus_skinify(tracked_owner)
	give_special_stats(tracked_owner)
	grant_actions()

/datum/extra_role/space_jesus/on_remove(mob/user)
	if(affecting && affecting.current)
		give_special_stats(affecting.current,1)
	tracked_owner = null

/datum/extra_role/space_jesus/process()
	if(!affecting || !affecting.current)
		return
	if(tracked_owner && affecting && isliving(affecting.current))
		if(tracked_owner != affecting.current)
			for(var/datum/action/A in active_actions)
				A.Remove(tracked_owner)
				A.Grant(affecting.current)
			tracked_owner = affecting.current
			give_special_stats(tracked_owner,1)
		tracked_owner.anchored = 1
		tracked_owner.hallucination = 0
		if(tracked_owner.stat == DEAD || !istype(tracked_owner,/mob/living/carbon))
			disappear()

/datum/extra_role/space_jesus/get_who_list_info()
	 return "<font color='black'><b>Space Jesus</b></font>"

/datum/extra_role/space_jesus/proc/grant_actions()
	for(var/path in action_datums)
		if(!ispath(path))
			continue
		var/skip = 0
		for(var/datum/action/A in active_actions)
			if(istype(A,path))
				skip = 1
				break
		if(skip)
			continue
		var/datum/action/A = new path()
		if(!istype(A,/datum/action))
			qdel(A)
			continue
		A.Grant(affecting.current)

/datum/extra_role/space_jesus/proc/give_special_stats(mob/living/M, remove = 0) //use remove = 1 to instead remove the stats
	if(!istype(M))
		return
	if(remove)
		M.incorporeal_move = 0
		M.omnipotent_access = 0
		if(M.status_flags & GODMODE)
			M.status_flags ^= GODMODE
		if(M.anchored && !M.buckled)
			M.anchored = 0
		M.unignore_slowdown(src)
	else
		M.incorporeal_move = incorporeal_move
		M.omnipotent_access = 1
		if(!(M.status_flags & GODMODE))
			M.status_flags ^= GODMODE
		M.anchored = 1
		M.ignore_slowdown(src)

/datum/extra_role/space_jesus/proc/jesus_skinify(mob/living/carbon/human/H)
	if(!istype(H))
		return
	H.name = "Space Jesus"
	H.real_name = "Space Jesus"
	var/datum/dna/D = H.dna
	H.skin_tone = "caucasian3"
	H.lip_color = "white"
	H.eye_color = "000"
	H.facial_hair_style = "Beard (Full)"
	H.facial_hair_color = "000"
	H.hair_style = "Long Fringe"
	H.hair_color = "000"
	H.gender = MALE
	if (istype(D))
		D.update_dna_identity()
	H.sync_mind()
	H.updateappearance()

/datum/extra_role/space_jesus/proc/disappear(delete_mob = 1)
	for(var/obj/item/I in owned_items)
		qdel(I)
	if(!affecting)
		return
	var/mob/living/H = affecting.current
	if(!istype(H))
		return
	for(var/obj/item/I in H.get_contents())
		if(!(I in owned_items))
			I.forceMove(get_turf(H))
		else
			qdel(I)
	new /obj/effect/particle_effect/smoke(get_turf(H))
	playsound(get_turf(H), 'sound/effects/smoke.ogg', 50, 0, 0, 0, 0)
	H.visible_message("<font size=3 color=red><b>Space Jesus has returned to heaven!</b></font>")
	H.stop_sound_channel(CHANNEL_HEARTBEAT)
	if(saved_mind)
		var/mob/dead/observer/ghost
		if(istype(saved_mind.current,/mob/living) && saved_mind.current != H)
			ghost = new(saved_mind.current)
			SStgui.on_transfer(H, ghost)
			ghost.key = H.key
			ghost.loc = H.loc
		else
			ghost = H.ghostize(0)
			ghost.mind = saved_mind
		ghost.can_reenter_corpse = TRUE
		saved_mind = null
	else
		H.ghostize(0)
	remove()
	if(delete_mob)
		var/atom/movable/to_delete
		if(istype(H.loc,/obj/item/organ/brain))
			to_delete = H.loc
			if(istype(H.loc.loc,/obj/item/bodypart/head))
				to_delete = H.loc.loc
		if(!to_delete)
			to_delete = H
		if(to_delete && !QDELETED(to_delete))
			to_delete.moveToNullspace()
			qdel(to_delete)

/datum/extra_role/space_jesus/on_death(gibbed)
	disappear(!gibbed)

/mob/proc/is_space_jesus()
	if(istype(src,/mob/living/carbon))
		var/mob/living/carbon/C = src
		var/datum/extra_role/space_jesus/S = C.has_extra_role(/datum/extra_role/space_jesus)
		if(S)
			return S
	return null

//*******
//Actions
//*******

//Disappear
/datum/action/jesus_disappear
	name = "Disappear"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "jaunt"

/datum/action/jesus_disappear/Trigger()
	if(!owner)
		return
	var/mob/living/H = owner
	if(!istype(H))
		return
	var/datum/extra_role/space_jesus/R = H.is_space_jesus()
	if(R)
		R.disappear()

//spawn desroyer gun
/datum/action/jesus_destroyer
	name = "Destroyer"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/obj/guns/energy.dmi'
	button_icon_state = "pulse"

/datum/action/jesus_destroyer/Trigger()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	var/datum/extra_role/space_jesus/R = H.is_space_jesus()
	if(!R)
		return
	if(R.destroyer)
		R.owned_items -= R.destroyer
		qdel(R.destroyer)
		R.destroyer = null
		return
	R.destroyer = new()
	R.owned_items += R.destroyer
	H.put_in_hands(R.destroyer)

//hallelujah emote
/datum/action/jesus_hallelujah
	name = "Hallelujah"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/obj/storage.dmi'
	button_icon_state = "bible"

/datum/action/jesus_hallelujah/Trigger()
	if(!owner)
		return
	var/mob/living/H = owner
	if(!istype(H))
		return
	var/datum/extra_role/space_jesus/R = H.is_space_jesus()
	if(!R)
		return
	playsound(get_turf(H), 'sound/effects/pray.ogg', 50, 0, 0, 0, 0)
	var/turf/T = get_turf(H)
	T.visible_message("<font size=3 color=blue><b>Hallelujah!</b></font>")

//Healing
/datum/action/jesus_heal
	name = "Heal Target"
	icon_icon = 'icons/obj/storage.dmi'
	button_icon_state = "firstaid"

/datum/action/jesus_heal/Trigger()
	if(!owner)
		return
	var/mob/living/H = owner
	if(!istype(H))
		return
	var/datum/extra_role/space_jesus/R = H.is_space_jesus()
	if(!R)
		return
	var/list/surrounding = list()
	for(var/mob/living/M in view(8,H))
		var/thename = "Noname"
		if(M.name)
			thename = "[M.name]"
		if(M.real_name && M.name != M.real_name)
			thename += "([M.real_name])"
		switch(M.stat)
			if(DEAD)
				thename += "(DEAD)"
			if(UNCONSCIOUS)
				thename += "(UNCONSCIOUS)"
		if(M == H)
			thename += "(YOU)"
		surrounding[avoid_assoc_duplicate_keys(thename, surrounding)] = M
	var/mob/living/L = surrounding[input(H,"Select who to heal.","Heal",null) as null|anything in surrounding]
	if(!istype(L))
		to_chat(H, "This can only be used on beings.")
		return

	L.revive(full_heal = 1, admin_revive = 1)
	message_admins("<span class='danger'>Admin [key_name_admin(H)] healed / revived [key_name_admin(L)]!</span>")
	log_admin("[key_name(H)] healed / Revived [key_name(L)].")
	var/turf/T = get_turf(H)
	playsound(T, 'sound/effects/pray.ogg', 50, 0, 0, 0, 0)
	T.visible_message("<font size=3 color=blue><b>Space Jesus heals [L]! Hallelujah!</b></font>")
	new /obj/effect/explosion(get_turf(L))

//Toggle Corporeal Form. aka pass through walls
/datum/action/togglecorporeal
	name = "Toggle Corporeal Form"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "blink"

/datum/action/togglecorporeal/Trigger()
	if(!owner)
		return
	var/mob/living/H = owner
	var/datum/extra_role/space_jesus/R = H.is_space_jesus()
	if(!R)
		return
	R.incorporeal_move = !R.incorporeal_move
	H.incorporeal_move = R.incorporeal_move
	if(H.incorporeal_move)
		to_chat(H,"You are now non corporeal.")
	else
		to_chat(H,"You are now corporeal.")

//**************
//Creating Jesus
//**************

/datum/admins/proc/space_jesus()
	set name = "Space Jesus"
	set category = "Adminbus"
	var/userckey = usr.ckey
	var/confirm = alert(usr,"Do you wish to become Space Jesus?","Space Jesus","Yes","Cancel")
	if(confirm != "Yes")
		return
	if(!isturf(usr.loc))
		to_chat(usr,"Can't spawn Space Jesus here.")
		return
	if(!istype(usr,/mob/dead/observer) || usr.ckey != userckey)
		to_chat(usr,"You must be a ghost for this.")
		return
	var/list/outfits = list("Naked" = new /datum/outfit(),"Original" = new /datum/outfit/jesus(),"Carpenter" = new /datum/outfit/jesus/carpenter())
	var/list/paths = subtypesof(/datum/outfit/job)
	for(var/path in paths)
		var/datum/outfit/job/O = new path()
		if(initial(O.can_be_admin_equipped))
			if(findtext(O.name,"\[",1,length(O.name)+1))
				continue
			outfits["[O.name] Jesus"] = O
			O.head = null
			O.mask = null
			O.id = null
			O.l_pocket = null
			O.r_pocket = null
			O.ears = null
			O.back = null
			O.backpack_contents = null
			O.box = null
			O.pda_slot = null
			O.backpack = null
			O.satchel  = null
			O.duffelbag = null
			O.toggle_helmet = FALSE
			if(!O.gloves)
				O.gloves = /obj/item/clothing/gloves/color/white/jesus
			O.glasses = /obj/item/clothing/glasses/godeye/jesus
	var/theoutfit = input("Select outfit", "Space Jesus", "Original") as null|anything in outfits
	var/chosenoutfit = outfits[theoutfit]
	if(!istype(chosenoutfit,/datum/outfit))
		chosenoutfit = /datum/outfit/jesus
	usr.jesusify(chosenoutfit)

/mob/proc/jesusify(datum/outfit/outfit)
	if(isnewplayer(src))
		to_chat(usr, "<span class='danger'>Cannot convert players who have not entered yet.</span>")
		return
	var/location = src.loc
	var/mob/living/carbon/human/M
	spawn(0)
		for(var/i=0, i<=7, i++)
			spawn(i*2)
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, location)
				s.start()
		playsound(get_turf(location), 'sound/effects/pray_chaplain.ogg', 50, 0, 0, 0, 0)
		var/obj/effect/forcefield/cult/C = new /obj/effect/forcefield/cult(get_turf(location))
		var/obj/effect/jesusportal/P = new /obj/effect/jesusportal(get_turf(location))
		var/savedkey = key
		spawn(15)
			qdel(P)
			qdel(C)
			new /obj/effect/explosion(get_turf(location))
			playsound(get_turf(location), 'sound/effects/explosion2.ogg', 25, 0, 0, 0, 0)
			var/turf/T = get_turf(location)
			T.visible_message("<font size=3 color=red><b>Your Lord, Space Jesus, descends upon the Earth!</b></font>")
			M = new /mob/living/carbon/human( location )
			if (!istype(M))
				to_chat(usr, "Oops! There was a problem. Contact a developer.")
				return
			M.mind_initialize()
			var/datum/extra_role/space_jesus/R = M.give_extra_role(/datum/extra_role/space_jesus)
			if(!R)
				qdel(M)
				to_chat(usr, "Oops! There was a problem, could not create jesus' powers. Contact a developer.")
				return
			if(M.mind)
				M.mind.assigned_role = "Space Jesus"
			if(mind && mind.assigned_role != M.mind.assigned_role)
				R.saved_mind = mind
			M.key = savedkey
			if(!istype(outfit))
				outfit = /datum/outfit/jesus
			M.equipOutfit(outfit)
			var/obj/item/clothing/gloves/G = M.gloves
			if(!G)
				G = new /obj/item/clothing/gloves/color/white/jesus()
				G.siemens_coefficient = 0
				G.permeability_coefficient = 0.05
				M.equip_to_slot_or_del(G,SLOT_GLOVES)
			if(istype(outfit,/datum/outfit) && outfit.name != "Space Jesus")
				M.real_name = "[outfit.name] Jesus"
			else
				M.real_name = "Space Jesus"
			M.name = M.real_name
			for(var/obj/item/I in M.get_contents())
				R.owned_items += I
			QDEL_IN(src, 1)
	. =  M

//The portal animation for when jesus enters.
/obj/effect/jesusportal
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"

/*/mob/living/carbon/human/jesus/examine(mob/user)
		var/msg = "<span class='info'>*---------*\nThis is <EM><font size=3>Space Jesus</font></EM>, your Lord and Savior!</span>\n"
		msg += "<font color=red>He is the real deal.</font><br>"
		msg += "*---------*</span>"
		to_chat(user, msg)*/

//********************
//Clothing and Outfits
//********************

//The old original carpenter outfit
/datum/outfit/jesus/carpenter
	name = "Space Jesus"
	uniform = /obj/item/clothing/under/suit/waiter/jesus
	suit = null //Since this is a child, no robe on this one.
	gloves = /obj/item/clothing/gloves/color/white/jesus
	shoes = /obj/item/clothing/shoes/jackboots/jesus
	glasses = /obj/item/clothing/glasses/godeye/jesus
	ears = /obj/item/radio/headset
	belt = /obj/item/storage/belt/utility/full

/obj/item/clothing/under/suit/waiter/jesus
	name = "carpenter uniform"
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/glasses/godeye/jesus
	icon_state = ""
	item_state = ""
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/glasses/godeye/jesus/worn_overlays(isinhands)
    . = list()
    if(!isinhands)
        . += image(layer = LYING_MOB_LAYER-0.01, icon = 'icons/effects/effects.dmi', icon_state = "m_shield")

/obj/item/clothing/gloves/color/white/jesus
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/shoes/jackboots/jesus
	name = "Black Boots"
	resistance_flags = INDESTRUCTIBLE

//Updated space jesus clothes.
/obj/item/clothing/suit/hooded/spacejesus
	name = "Divine Robes"
	desc = "It's super ugly and looks really old."
	icon = 'icons/oldschool/clothing/suititem.dmi'
	icon_state = "jesus_robe"
	item_state = "owl"
	item_color = "lightbrown"
	alternate_worn_icon = 'icons/oldschool/clothing/suitmob.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0, fire = 0, acid = 0)
	allowed = list(/obj/item/flashlight,/obj/item/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/storage/fancy/cigarettes,/obj/item/lighter)
	hoodtype = /obj/item/clothing/head/hooded/spacejesus
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/head/hooded/spacejesus
	name = "Divine Hood"
	desc = "It's super ugly and looks really old."
	icon = 'icons/oldschool/clothing/headitem.dmi'
	icon_state = "jesus_robe"
	alternate_worn_icon = 'icons/oldschool/clothing/headmob.dmi'
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/under/suit/spacejesus
	name = "Divine Undersuit"
	desc = "It's even older and uglier."
	icon = 'icons/oldschool/clothing/uniformitem.dmi'
	icon_state = "jesus_uniform"
	item_state = "lb_suit"
	alternate_worn_icon = 'icons/oldschool/clothing/uniformmob.dmi'
	resistance_flags = INDESTRUCTIBLE

/datum/outfit/jesus
	name = "Space Jesus"
	uniform = /obj/item/clothing/under/suit/spacejesus
	suit = /obj/item/clothing/suit/hooded/spacejesus
	gloves = /obj/item/clothing/gloves/color/white/jesus
	shoes = /obj/item/clothing/shoes/jackboots/jesus
	glasses = /obj/item/clothing/glasses/godeye/jesus
	ears = /obj/item/radio/headset
	belt = /obj/item/storage/belt/utility/full

/datum/outfit/jesus/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/obj/item/clothing/suit/hooded/hooded = H.wear_suit
	if(istype(hooded) && !hooded.suittoggled)
		hooded.ToggleHood()

//*************
//Destroyer Gun
//*************
/obj/item/gun/energy/pulse/destroyer/jesus
	name = "Jesus' Destroyer"
	var/unlocked = 0

/obj/item/gun/energy/pulse/destroyer/jesus/Initialize()
	. = ..()
	for(var/obj/item/ammo_casing/energy/A in ammo_type)
		A.e_cost = 0

/obj/item/gun/energy/pulse/destroyer/jesus/can_shoot()
	if(!unlocked && istype(loc,/mob/living/carbon))
		var/mob/living/carbon/C = loc
		if(!(C.mind && C.mind.assigned_role == "Space Jesus"))
			return FALSE
	return TRUE