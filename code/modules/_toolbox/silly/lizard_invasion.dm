/mob/living/simple_animal/hostile/customhumanoid/ashligger
	name = "lizard"
	race = "ashwalker"
	attacktext = "slashes"
	gold_core_spawnable = 1
	dont_wander_atoms = list(/turf/open/chasm,/turf/open/lava,/obj/structure/bonfire)
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/bonespear)

/mob/living/simple_animal/hostile/customhumanoid/ashligger/red
	lizardskincolor_red = list(150,200) //Red is the dominant color.
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/customhumanoid/ashligger/green
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(150,200)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/customhumanoid/ashligger/blue
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(150,200)

//Archers
/mob/living/simple_animal/hostile/customhumanoid/ashligger/green/ranged
	maxHealth = 80
	health = 80
	gold_core_spawnable = 1
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/gun/ballistic/bow/ashen)
	ranged = 1
	rapid_melee = 1
	casingtype = /obj/item/ammo_casing/caseless/arrow/wood
	projectilesound = 'sound/weapons/bowfire.ogg'
	retreat_distance = 2
	minimum_distance = 6

/mob/living/simple_animal/hostile/customhumanoid/ashligger/green/ranged/ash_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/ash

/mob/living/simple_animal/hostile/customhumanoid/ashligger/green/ranged/bone_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/bone

//Axemen
/mob/living/simple_animal/hostile/customhumanoid/ashligger/green/axe
	maxHealth = 120
	health = 120
	name = "lizard"
	race = "lizard"
	attacktext = "slashes"
	gold_core_spawnable = 1
	melee_damage = 23
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/fireaxe/boneaxe)
	adjustsize = 1.2

//Warchief
/mob/living/simple_animal/hostile/customhumanoid/ashligger/green/axe/warchief
	equipped_items = list(
		/obj/item/clothing/mask/rat/tribal = SLOT_WEAR_MASK,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)


/********************** LIZARD INVASION EVENT **************************/

//SPAWNER
/obj/structure/lavaland/ash_walker/invasion
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 400
	spawn_threshold = 1
	drops_on_deconstruct = list()
	meat_counter = 6
	faction = list()
	var/list/lizardskincolor_red = list(25,200)
	var/list/lizardskincolor_green = list(25,200)
	var/list/lizardskincolor_blue = list(25,200)
	var/theskincolor

/obj/structure/lavaland/ash_walker/invasion/Initialize()
	. = ..()
	ashies.name = "Lizard Invader"
	if(islist(lizardskincolor_red))
		if(lizardskincolor_red.len > 1)
			lizardskincolor_red = rand(lizardskincolor_red[1],lizardskincolor_red[2])
		else
			lizardskincolor_red = lizardskincolor_red[1]
	if(islist(lizardskincolor_green))
		if(lizardskincolor_green.len > 1)
			lizardskincolor_green = rand(lizardskincolor_green[1],lizardskincolor_green[2])
		else
			lizardskincolor_green = lizardskincolor_green[1]
	if(islist(lizardskincolor_blue))
		if(lizardskincolor_blue.len > 1)
			lizardskincolor_blue = rand(lizardskincolor_blue[1],lizardskincolor_blue[2])
		else
			lizardskincolor_blue = lizardskincolor_blue[1]
	lizardskincolor_red = clamp(lizardskincolor_red,50,200)
	lizardskincolor_green = clamp(lizardskincolor_green,50,200)
	lizardskincolor_blue = clamp(lizardskincolor_blue,50,200)
	theskincolor = sanitize_hexcolor(rgb(lizardskincolor_red,lizardskincolor_green,lizardskincolor_blue),include_crunch=0)

/obj/structure/lavaland/ash_walker/invasion/can_consume(mob/living/M)
	if(faction_check(faction, M.faction, FALSE))
		return FALSE
	return TRUE

/obj/structure/lavaland/ash_walker/invasion/spawn_mob()
	if(meat_counter >= spawn_threshold)
		var/obj/effect/mob_spawn/human/ash_walker/invader/invader = new(get_step(loc, pick(GLOB.alldirs)), ashies)
		invader.faction = faction
		invader.theskincolor = theskincolor
		invader.color = "#[theskincolor]"
		visible_message("<span class='danger'>One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!</span>")
		meat_counter -= spawn_threshold

/obj/effect/mob_spawn/human/ash_walker/invader
	name = "Ash Walker Invader Egg"
	var/selected_role
	var/theskincolor
	short_desc = "You are an ash walker. Work together to destroy your enemies."
	flavour_text = "Invaders are near! we must defend the nest. \
	Invaders seek to tear apart the nest and its domain. Destroy them all! \
	Get fresh sacrifices for your nest."

/obj/effect/mob_spawn/human/ash_walker/invader/attack_ghost(mob/user)
	if(!SSticker.HasRoundStarted() || !loc || !ghost_usable)
		return
	if(!uses)
		to_chat(user, "<span class='warning'>This spawner is out of charges!</span>")
		return
	if(QDELETED(src) || QDELETED(user))
		return
	var/ghost_role = alert("Become [mob_name]? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(ghost_role == "No" || !loc)
		return
	var/list/classes = list("warrior","shaman","archer","builder")
	var/class = input(user,"Pick a class","Lizard Invasion!","warrior") as null|anything in classes
	if(!loc || !(class in classes))
		return
	var/newoutfit
	switch(class)
		if("warrior")
			selected_role = /datum/extra_role/lizard_invader/warrior
			newoutfit = /datum/outfit/ashwalker/warrior
		if("shaman")
			selected_role = /datum/extra_role/lizard_invader/shaman
			newoutfit = /datum/outfit/ashwalker/shaman
		if("archer")
			selected_role = /datum/extra_role/lizard_invader/archer
			newoutfit = /datum/outfit/ashwalker/archer
		if("builder")
			selected_role = /datum/extra_role/lizard_invader/builder
			newoutfit = /datum/outfit/ashwalker/builder
	if(newoutfit && selected_role)
		qdel(outfit)
		outfit = new newoutfit()
	log_game("[key_name(user)] became a Lizard Invader.")
	create(ckey = user.ckey)

/obj/effect/mob_spawn/human/ash_walker/invader/equip(mob/living/carbon/human/M)
	. = ..()
	M.gender = MALE
	if(theskincolor)
		M.dna.features["mcolor"] = theskincolor
	M.underwear = "Nude"
	M.undershirt = "Nude"
	M.socks = "Nude"
	M.update_body()
	M.regenerate_icons()
	M.name = M.real_name
	M.faction = faction

/obj/effect/mob_spawn/human/ash_walker/invader/special(mob/living/carbon/human/M)
	to_chat(M, "<b>Drag the corpses of men and beasts to your nest. It will absorb them to create more of your kind. Protect it with your life. Destroy all who oppose you and your tribe!</b>")
	if(selected_role)
		M.give_extra_role(selected_role)
	M.mind.add_antag_datum(/datum/antagonist/ashwalker, team)
	M.fully_replace_character_name(null,random_unique_lizard_name(gender))
	return

/obj/structure/lavaland/ash_walker/invasion/red
	faction = list("redliggerinvaders")
	lizardskincolor_red = list(150,200)
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(1,25)

/obj/structure/lavaland/ash_walker/invasion/green
	faction = list("greenliggerinvaders")
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(150,200)
	lizardskincolor_blue = list(1,25)

/obj/structure/lavaland/ash_walker/invasion/blue
	faction = list("blueliggerinvaders")
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(150,200)

/********************** OUTFITS **************************/
/datum/outfit/ashwalker/warrior
	r_hand = /obj/item/twohanded/bonespear
	r_pocket = /obj/item/flashlight/lantern

/datum/outfit/ashwalker/archer
	r_hand = /obj/item/gun/ballistic/bow/ashen
	belt = /obj/item/storage/belt/quiver/full
	l_pocket = /obj/item/kitchen/knife/combat/bone
	r_pocket = /obj/item/flashlight/lantern

/datum/outfit/ashwalker/builder
	l_pocket = /obj/item/kitchen/knife/combat/bone
	r_pocket = /obj/item/flashlight/lantern
	belt = /obj/item/storage/belt/utility/servant

/datum/outfit/ashwalker/shaman
	head = null
	mask = /obj/item/clothing/mask/rat/tribal
	l_pocket = /obj/item/kitchen/knife/combat/bone
	r_pocket = /obj/item/flashlight/lantern

/obj/item/storage/belt/quiver/full/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_casing/caseless/arrow/wood = 8)
	generate_items_inside(items_inside,src)


/********************** SPELLS **************************/
//builder
/obj/effect/proc_holder/spell/targeted/faction_door
	name = "Build locked door (requires 10 wood)"
	desc = "Builds a wooden door that can only be opened by you and your friends, requires 10 wood in hand."
	school = "transmutation"
	charge_max = 50
	clothes_req = FALSE
	sound = null
	action_icon = 'icons/obj/doors/mineral_doors.dmi'
	action_icon_state = "wood"
	range = -1
	include_user = TRUE
	cooldown_min = 600
	var/door_type = /obj/structure/mineral_door/wood/faction_locked

/obj/effect/proc_holder/spell/targeted/faction_door/cast(list/targets,mob/user)
	var/obj/item/stack/sheet/mineral/wood/W = user.get_item_for_held_index(user.active_hand_index)
	if(istype(W) && W.amount >= 10)
		var/turf/T = get_turf(user)
		if(T && !istype(T,/turf/closed) && !istype(T,/turf/open/space))
			var/obj/structure/mineral_door/wood/faction_locked/door = new(T)
			door.faction = user.faction

/obj/effect/proc_holder/spell/targeted/faction_door/perform(list/targets, recharge, mob/living/user)
	var/obj/item/stack/sheet/mineral/wood/W = user.get_item_for_held_index(user.active_hand_index)
	var/theamount = 0
	if(istype(W,/obj/item/stack/sheet/mineral/wood))
		theamount = W.amount
	if(theamount <= 10)
		to_chat(user, "<span class='warning'>You are not holding enough wood, requires 10.</span>")
		return
	. = ..()

/obj/effect/proc_holder/spell/targeted/conjure_item/wood
	name = "Wood"
	desc = "Concentrates necropolis magic to conjure wood, useful for construction."
	item_type = /obj/item/stack/sheet/mineral/wood/twentyfive
	charge_max = 600
	action_icon = 'icons/obj/hydroponics/harvest.dmi'
	action_icon_state = "logs"

/obj/item/stack/sheet/mineral/wood/twentyfive
	amount = 25

/obj/effect/proc_holder/spell/targeted/conjure_item/bamboo
	name = "Bamboo"
	desc = "Concentrates necropolis magic to conjure bamboo cuttings, useful for crafting punji stick traps."
	item_type = /obj/item/stack/sheet/mineral/bamboo/five
	charge_max = 250
	action_icon = 'icons/obj/stack_objects.dmi'
	action_icon_state = "sheet-bamboo"

/obj/item/stack/sheet/mineral/bamboo/five
	amount = 5

//shaman
//heal spell
/obj/effect/proc_holder/spell/aimed/shaman_heal
	name = "Ritual Healing"
	desc = ""
	school = "restoration"
	projectile_type = null
	deactive_msg = "You cancel your healing spell."
	active_msg = "You ready your healing spell."
	action_icon = 'icons/obj/decals.dmi'
	action_icon_state = "minskymedicb"
	base_icon_state = "minskymedicb"
	active_icon_state = "minskymedicb"
	sound = null
	charge_max = 150
	clothes_req = 0
	var/channel_time = 50
	var/obj/item/gun/medbeam/gun

/obj/effect/proc_holder/spell/aimed/shaman_heal/update_icon()
	action.button_icon_state = "[base_icon_state]"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/shaman_heal/Initialize()
	. = ..()
	gun = new()
	gun.explode_on_crossed_beams = 0
	gun.mounted = 1

/obj/effect/proc_holder/spell/aimed/shaman_heal/Destroy()
	. = ..()
	qdel(gun)

/obj/effect/proc_holder/spell/aimed/shaman_heal/perform(list/targets, recharge, mob/user)
	var/mob/living/L = targets[1]
	if(!istype(L))
		return
	return ..()

/obj/effect/proc_holder/spell/aimed/shaman_heal/fire_projectile(mob/living/user, atom/target)
	. = TRUE
	spawn(0)
		if(gun)
			spawn(0)
				gun.process_fire(target, user)
			do_after(user, channel_time, target = user)
			remove_ranged_ability()
			if(gun)
				gun.LoseTarget()

//summon spell
/obj/effect/proc_holder/spell/aimed/summon_lizard
	name = "Summon Thrall"
	desc = "Open a portal to summon a minion thrall. This minion will be friendly to your tribe and defend it."
	school = "conjuration"
	projectile_type = null
	deactive_msg = "You cancel your summoning spell."
	active_msg = "You prepare to summon..."
	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "summons"
	base_icon_state = "summons"
	active_icon_state = "summons"
	sound = null
	charge_max = 600
	clothes_req = 0
	var/summontype = /mob/living/simple_animal/hostile/customhumanoid/ashligger/no_icon
	var/max_summons = 8
	var/list/spawned_mobs = list()
	var/theskincolor

/obj/effect/proc_holder/spell/aimed/summon_lizard/update_icon()
	action.button_icon_state = "[base_icon_state]"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/aimed/summon_lizard/fire_projectile(mob/living/carbon/user, atom/target)
	if(!target)
		return
	var/turf/T = get_turf(target)
	if(!is_turf_cool(T))
		to_chat(user, "<span class='warning'>You cannot cast that there.</span>")
	new /obj/effect/lizard_bhole(T)
	var/mob/living/simple_animal/hostile/customhumanoid/H = new summontype(T)
	H.skincolor = user.dna.features["mcolor"]
	H.Initialize_icons()
	H.faction = user.faction
	H.adjustsize = 0.9
	H.transform *= 0.9
	H.maxHealth = 60
	H.health = 60
	H.real_name = "Ashwalker Thrall"
	H.name = "Ashwalker Thrall"
	spawned_mobs += H
	H.handle_automated_action()
	remove_ranged_ability()

/mob/living/simple_animal/hostile/customhumanoid/ashligger/no_icon
	init_on_spawn = 0

/obj/effect/proc_holder/spell/aimed/summon_lizard/can_cast(mob/user = usr)
	. = ..()
	if(.)
		var/mobcount = 0
		for(var/l in spawned_mobs)
			if(!istype(l,/mob/living) )
				spawned_mobs.Remove(l)
			else if(istype(l,/atom/movable))
				var/atom/movable/AM = l
				if(QDELETED(AM))
					spawned_mobs.Remove(AM)
			mobcount++
		if(mobcount >= 8)
			to_chat(user, "<span class='warning'>You control too many soldiers already.</span>")
			. = FALSE

/obj/effect/proc_holder/spell/aimed/summon_lizard/proc/is_turf_cool(turf/T)
	. = 1
	if(istype(T,/turf/open) && T != loc && !istype(T,/turf/open/space))
		for(var/obj/O in T)
			if(O.density)
				. = 0
				break
	else
		. = 0

//archer
//conjure arrow spell
/obj/effect/proc_holder/spell/targeted/conjure_item/arrow
	name = "Conjure Arrow"
	desc = "Concentrates necropolis magic to conjure an arrow."
	item_type = /obj/item/ammo_casing/caseless/arrow/wood
	charge_max = 100
	action_icon = 'icons/obj/ammo.dmi'
	action_icon_state = "arrow"

//summon bow
/obj/effect/proc_holder/spell/targeted/summon_bow
	name = "Summon Bow"
	desc = "Recalls your bow to your hand."
	school = "transmutation"
	charge_max = 300
	clothes_req = FALSE
	sound = null
	action_icon = 'icons/obj/guns/projectile.dmi'
	action_icon_state = "ashenbow_unloaded"
	range = -1
	include_user = TRUE
	cooldown_min = 600
	var/obj/item/gun/ballistic/bow/bow
	var/bow_type = /obj/item/gun/ballistic/bow/ashen

/obj/effect/proc_holder/spell/targeted/summon_bow/cast(list/targets,mob/user)
	if(!bow || QDELETED(bow))
		var/obj/item/gun/ballistic/bow/newbow = new bow_type()
		bow = newbow
		user.put_in_hands(newbow)
	else
		if(bow)
			if(istype(bow.loc,/obj))
				var/obj/O = bow.loc
				var/datum/component/storage/S = O.GetComponent(/datum/component/storage)
				if(istype(S))
					S.remove_from_storage(bow,user.loc)
			bow.forceMove(user.loc)
			user.put_in_hands(bow)
	to_chat(user, "<span class='noticeg'>You summon your bow to your hand.</span>")
	. = ..()

/obj/effect/proc_holder/spell/targeted/summon_bow/perform(list/targets, recharge, mob/living/user)
	var/list/thecontents = user.get_contents()
	if(bow && (bow in thecontents))
		to_chat(user, "<span class='warning'>You already have your bow!</span>")
		return
	return ..()

//lizard invader extra role datum.
/datum/extra_role/lizard_invader
	var/faction = list()
	var/resize = 1
	var/list/spell_list = list()
	var/introduction_text

/datum/extra_role/lizard_invader/get_who_list_info()
	return "<font color='red'>Lizard Invader</font>"

/datum/extra_role/lizard_invader/on_gain(mob/user)
	. = ..()
	if(resize != 1 && user)
		user.transform *= resize
	if(spell_list.len)
		for(var/t in spell_list)
			if(!ispath(t))
				continue
			var/obj/effect/proc_holder/spell/S = new t()
			user.mind.AddSpell(S)
	if(introduction_text)
		to_chat(user,"<B>[introduction_text]</B>")

//shaman
/datum/extra_role/lizard_invader/shaman
	introduction_text = "You are the SHAMAN. You have the ability to HEAL others and SUMMON THRALLS. Use these to help your allies. Remember you are a pacifist and cannot fight directly."
	resize = 0.9
	spell_list = list(/obj/effect/proc_holder/spell/aimed/summon_lizard,/obj/effect/proc_holder/spell/aimed/shaman_heal)

/datum/extra_role/lizard_invader/shaman/on_gain(mob/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_PACIFISM, TRAIT_GENERIC)

//warrior
/datum/extra_role/lizard_invader/warrior
	introduction_text = "You are the WARRIOR. You have the ability to charge and attack people by holding the ALT key and clicking a target."
	var/last_charge_attack = 0
	var/charge_cooldown = 200
	resize = 1.1

/datum/extra_role/lizard_invader/warrior/on_click(atom/A)
	if(last_charge_attack+charge_cooldown > world.time)
		var/secondsremaining = (last_charge_attack+charge_cooldown)-world.time
		to_chat(affecting.current,"<span class='warning'>Your charge attack is on cooldown. [round(secondsremaining/10,1)] seconds remaining.</span>")
		return
	if((!istype(affecting.current,/mob/living/carbon))||!(affecting.current.mobility_flags & MOBILITY_STAND))
		return
	var/chargetext = "[affecting.current] charges"
	if(istype(A,/atom/movable))
		chargetext += "at [A]"
	affecting.current.visible_message("<span class='danger'>[chargetext].</span>")
	playsound(affecting.current.loc, 'sound/toolbox/charge.ogg', 100, 0)
	var/turf/T = get_turf(affecting.current)
	var/turf/Aturf = get_turf(A)
	if(get_dist(T,Aturf) <= 1 || T == Aturf)
		return
	last_charge_attack = world.time
	var/steps = 12
	var/turf/current = T
	while(steps > 0 && current != Aturf)
		if(!Aturf || !T)
			break
		if(affecting.current.stat || affecting.current.restrained()||!(affecting.current.mobility_flags & MOBILITY_STAND))
			return
		steps--
		var/thedir = get_dir(current,Aturf)
		var/turf/newT = get_step(current,thedir)
		if(!newT.density && !istype(newT,/turf/closed) && newT.Adjacent(current))
			var/stepped = step(affecting.current,thedir)
			current = get_turf(affecting.current)
			if(!stepped)
				break
			sleep(0.5)
			if(A && A.loc)
				Aturf = get_turf(A)
		else
			break
	var/atom/the_target
	if(affecting.current.Adjacent(A))
		the_target = A
	else if(Aturf.Adjacent(current))
		var/list/adjacentmobs = list()
		var/list/adjacentobjs = list()
		for(var/atom/movable/AM in Aturf)
			if(!AM.Adjacent(affecting.current))
				continue
			if(AM == affecting.current)
				continue
			if(istype(AM,/mob/living))
				adjacentmobs += AM
			else if(istype(AM,/obj) && AM.density)
				adjacentobjs += AM
		if(adjacentmobs.len)
			the_target = pick(adjacentmobs)
		else if(adjacentobjs.len)
			the_target = pick(adjacentobjs)
	if(the_target)
		var/obj/item/W = affecting.current.get_active_held_item()
		if(W)
			W.melee_attack_chain(affecting.current, A)
		else
			affecting.current.UnarmedAttack(A,1)
		if(istype(A,/mob/living))
			affecting.current.visible_message("<span class='danger'>[affecting.current]'s charge knocks down [A].</span>")
			var/mob/living/M = A
			M.Paralyze(30)
	for(var/mob/living/M in orange(1,affecting.current))
		if(M == the_target || M == affecting.current)
			continue
		if(affecting.current.faction_check_mob(M))
			continue
		affecting.current.visible_message("<span class='danger'>[affecting.current]'s charge knocks down [M].</span>")
		M.Paralyze(20)

/datum/extra_role/lizard_invader/archer
	introduction_text = "You are the ARCHER. You have the to conjure arrows and summon your bow back to you at any time."
	spell_list = list(/obj/effect/proc_holder/spell/targeted/conjure_item/arrow,/obj/effect/proc_holder/spell/targeted/summon_bow)

/datum/extra_role/lizard_invader/archer/on_gain(mob/user)
	. = ..()
	var/list/thecontents = user.get_contents()
	for(var/obj/item/gun/ballistic/bow/B in thecontents)
		for(var/obj/effect/proc_holder/spell/targeted/summon_bow/spell in user.mind.spell_list)
			spell.bow = B
			break
		break

/obj/effect/proc_holder/spell/targeted/summon_bow

/datum/extra_role/lizard_invader/builder
	introduction_text = "You are the BUILDER. You can summon bamboo sticks and wood to your hands. You can also summon a magic door using your wood that will only open for members of your tribe."
	spell_list = list(/obj/effect/proc_holder/spell/targeted/conjure_item/wood,/obj/effect/proc_holder/spell/targeted/conjure_item/bamboo,/obj/effect/proc_holder/spell/targeted/faction_door)

//wooden door
/obj/structure/mineral_door/wood/faction_locked
	var/list/faction = list()

/obj/structure/mineral_door/wood/faction_locked/TryToSwitchState(atom/user)
	if(isSwitchingStates || !anchored)
		return
	var/mob/living/M = user
	if(ismecha(user))
		var/obj/mecha/mecha = user
		M = mecha.occupant
	if(isliving(M))
		if(faction_check(faction, M.faction, FALSE))
			return ..()
	return

//need nest
//archer spell
//need fix spell reset on heal spell
//fix charge
