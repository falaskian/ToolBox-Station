/*
A hostile human animal mob that is customizable. -Falaskian
*/
/mob/living/simple_animal/hostile/customhumanoid
	name = "human"
	icon = 'icons/mob/human.dmi'
	icon_state = "human_basic" //This is simply so it's not blank when viewed in the map editor.
	var/forcename = 0 //Force the name? if 0 it will have a random name based on race.
	maxHealth = 100
	health = 100
	melee_damage = 5 //by default this mob will be unarmed, so we do 5 damage.
	melee_damage_type = "brute"
	attack_sound = 'sound/weapons/punch1.ogg' //these are automatically changed based on the items held.
	var/override_attack_sound = 0 //Use this if you want to force a specific attack sound.
	attacktext = "punches" //^
	var/override_attacktext = 0 //Use this if you want to force a specific attacktext message.
	var/damage_modifier = -1 //set to 0 or a positive number to modify the damage of this mob as a multiplier. 0 will work in causing 0 damage
	gold_core_spawnable = 0 //The default version of this mob should not spawn from gold cores.
	var/race = "human" // "human", "lizard" or "ashwalker". No others have been programmed in yet. If one of these is not chosen it defaults to "human".
	var/humanskincolor //only used when human is selected. defaults to "caucasian2" if nothing is selected here. Its ok to leave this blank.
	var/list/lizardskincolor_red = list(50,200) //these are to choose the lizards skin color based on RGB, range is 1-255. You can instead just enter one number instead of a list of two.
	var/list/lizardskincolor_green = list(50,200) //^
	var/list/lizardskincolor_blue = list(50,200) //^
	var/adjustsize = null
	var/skincolor //Final calculated skincolor for memeory. Change this to force a specific skin color. Must be a 6 character html tag. Example (#32ADHE)
	var/list/human_traits = list( //this is only used for human. hair and facial hair.
		"hair_style" = null,
		"facial_hair_style" = null,
		"hair_color" = null,
		"facial_hair_color" = null)
	var/list/equipped_items = list( //equipped gear. Replace the 'null' with the type path of the piece of clothing you want to equip there. When making a child you can delete the unused ones.
		null = SLOT_BACK,
		null = SLOT_WEAR_MASK,
		null = SLOT_BELT,
		null = SLOT_EARS,
		null = SLOT_GLASSES,
		null = SLOT_GLOVES,
		null = SLOT_HEAD,
		null = SLOT_SHOES,
		null = SLOT_WEAR_SUIT,
		null = SLOT_W_UNIFORM)
	var/list/humanoid_held_items = list(null,null) //equipped weapons type paths. Only two should be present.
	var/start_dead = 0 //the mobs starts off dead. Use this to spawn custom corpses at round start.
	//for retaliation
	var/retaliation = 0
	var/list/enemies = list()
	var/init_on_spawn = 1
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/customhumanoid/Initialize()
	. = ..()
	if(init_on_spawn)
		Initialize_icons()

/mob/living/simple_animal/hostile/customhumanoid/proc/Initialize_icons()
	//we default back to human if race isnt properly chosen.
	if(!(race in list("human","lizard","ashwalker")))
		race = "human"
	//whats his name? Sorry I didnt program in women, is that sexist?
	if(!forcename)
		switch(race)
			if("human")
				name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
			if("lizard", "ashwalker")
				name = lizard_name(MALE)
	var/list/overlayslist = list()
	var/image/I
	//figuring out skin color
	if(!skincolor)
		skincolor = get_skincolor() //made this a proc because I use it in another proc.
	//making limbs
	icon_state = "" //Deleting the default icon_state since we wont be using it, only overlays.
	var/list/bodyparts = list(
		"r_arm" = 4.2,
		"l_arm" = 4.2,
		"r_hand" = 4.2,
		"l_hand" = 4.2,
		"r_leg" = 4.2,
		"l_leg" = 4.2,
		"head_m" = 4.1,
		"chest_m" = 4.0)
	var/race_icon = race
	if(race == "ashwalker")
		race_icon = "lizard"
	for(var/text in bodyparts)
		I = new()
		I.icon = 'icons/mob/human_parts_greyscale.dmi'
		I.icon_state = "[race_icon]_[text]"
		I.color = "#[skincolor]"
		I.layer = bodyparts[text]
		overlayslist += I
	//making body and facial features.
	switch(race)
		if("human")
			var/datum/sprite_accessory/hair/hair = GLOB.hair_styles_list[human_traits["hair_style"]]
			var/datum/sprite_accessory/facial_hair/facial_hair = GLOB.facial_hair_styles_list["Beard ([human_traits["facial_hair_style"]])"]
			if(istype(hair))
				I = new()
				I.icon = hair.icon
				I.icon_state = hair.icon_state
				I.color = "#[human_traits["hair_color"]]"
				I.layer = 4.4
				overlayslist += I
			if(istype(facial_hair))
				I = new()
				I.icon = facial_hair.icon
				I.icon_state = facial_hair.icon_state
				I.color = "#[human_traits["facial_hair_color"]]"
				I.layer = 4.4
				overlayslist += I
		if("lizard", "ashwalker")
			//for now, we hard coded what specific lizard mutant parts are used. Lizards all look the same anyway.
			var/list/body_part_states = list("m_body_markings_ltiger_ADJ" = 4.3,
			"m_tail_spikes_FRONT" = 4.5,
			"m_tail_spikes_BEHIND" = 3.9, //Lizard layering is annoying.
			"m_snout_roundlight_FRONT" = 4.5,
			"m_snout_roundlight_ADJ"= 4.3,
			"m_horns_curled_ADJ"= 4.3,
			"m_frills_aqua_ADJ" = 4.3,
			"m_spines_longmeme_ADJ" = 4.3,
			"m_spines_longmeme_BEHIND" = 3.9)
			for(var/state in body_part_states)
				I = new()
				I.icon = 'icons/mob/mutant_bodyparts.dmi'
				I.icon_state = state
				I.color = "#[skincolor]"
				I.layer = 4.3
				overlayslist += I
	//building icons for equipped items
	var/list/confirmed_slots = list( //to make sure the slots were never accidently changed by the mapper and also to indicate which icon layer each slot uses.
		"[SLOT_BACK]" = BACK_LAYER,
		"[SLOT_WEAR_MASK]" = FACEMASK_LAYER,
		"[SLOT_BELT]" = BELT_LAYER,
		"[SLOT_EARS]" = EARS_LAYER,
		"[SLOT_GLASSES]" = GLASSES_LAYER,
		"[SLOT_GLOVES]" = HANDS_LAYER,
		"[SLOT_HEAD]" = HEAD_LAYER,
		"[SLOT_SHOES]" = SHOES_LAYER,
		"[SLOT_WEAR_SUIT]" = SUIT_LAYER,
		"[SLOT_W_UNIFORM]" = UNIFORM_LAYER)
	var/list/icon_files = list( //turns out the way the code knows where to check for each onmob icon file is really unintuitive and hard coded so I gotta do this.
		"[SLOT_BACK]" = 'icons/mob/back.dmi',
		"[SLOT_WEAR_MASK]" = 'icons/mob/mask.dmi',
		"[SLOT_BELT]" = 'icons/mob/belt.dmi',
		"[SLOT_EARS]" = 'icons/mob/ears.dmi',
		"[SLOT_GLASSES]" = 'icons/mob/eyes.dmi',
		"[SLOT_GLOVES]" = 'icons/mob/hands.dmi',
		"[SLOT_HEAD]" = 'icons/mob/head.dmi',
		"[SLOT_SHOES]" = 'icons/mob/feet.dmi',
		"[SLOT_WEAR_SUIT]" = 'icons/mob/suit.dmi',
		"[SLOT_W_UNIFORM]" = 'icons/mob/uniform.dmi')
	for(var/path in equipped_items)
		if(!path || !ispath(path) || !equipped_items[path] || !("[equipped_items[path]]" in confirmed_slots))
			continue
		var/obj/item/item = new path()
		I = item.build_worn_icon(state = item.icon_state, default_layer = confirmed_slots["[equipped_items[path]]"], default_icon_file = icon_files["[equipped_items[path]]"])
		I.layer = confirmed_slots["[equipped_items[path]]"]
		equipped_items[item] = equipped_items[path]
		equipped_items.Remove(path)
		overlayslist += I
	//building icons for held items.
	var/which_hand = 0
	//Taking the attack_sound and attacktext from the highest damaging item.
	var/highest_damage = melee_damage
	for(var/path in humanoid_held_items)
		if(which_hand > 1)
			break //Cancel this loop if theres more then 2 hands.
		if(!ispath(path))
			continue
		var/obj/item/item = new path()
		if(item.force > highest_damage)
			melee_damage = item.force
			if(isnum(damage_modifier) && damage_modifier >= 0)
				melee_damage = melee_damage*damage_modifier
			highest_damage = item.force
			if(!override_attacktext)
				var/changedattacktext = 0
				if(item.attack_verb)
					if(islist(item.attack_verb))
						attacktext = pick(item.attack_verb)
						changedattacktext = 1
					else if(istext(item.attack_verb))
						attacktext = item.attack_verb
						changedattacktext = 1
				if(!changedattacktext)
					attacktext = "attacks"
			if(!override_attack_sound)
				if(!item.hitsound)
					if(item.damtype == "fire")
						attack_sound = 'sound/items/welder.ogg'
					if(item.damtype == "brute")
						attack_sound = "swing_hit"
				else
					attack_sound = item.hitsound
		var/hand_icon = item.righthand_file
		if(which_hand)
			hand_icon = item.lefthand_file
		which_hand++
		var/t_state = item.item_state
		if(!t_state)
			t_state = item.icon_state
		I = item.build_worn_icon(state = t_state, default_layer = HANDS_LAYER, default_icon_file = hand_icon, isinhands = TRUE)
		humanoid_held_items += item
		humanoid_held_items.Remove(path)
		overlayslist += I
	add_overlay(overlayslist)
	if(isnum(adjustsize) && adjustsize != 1)
		transform *= adjustsize
	if(start_dead)
		death()

//made this a proc because I use it more then once.
/mob/living/simple_animal/hostile/customhumanoid/proc/get_skincolor()
	. = skincolor
	if(!.)
		if(race == "lizard" || race == "ashwalker")
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
			. = sanitize_hexcolor(rgb(lizardskincolor_red,lizardskincolor_green,lizardskincolor_blue),include_crunch=0)
		else //ensuring it assumes a human skin color if race gets messed up.
			if(!humanskincolor)
				humanskincolor = "caucasian2" //defaulting to caucasian2 just incase no proper skin color is selected.
			. = sanitize_hexcolor(skintone2hex(humanskincolor), desired_format=6, include_crunch=0)
	if(copytext(.,1,2) == "#")
		. = copytext(.,2,length(.)+1)

//doing this as its own proc so it can be used in other ways.
/mob/living/simple_animal/hostile/customhumanoid/proc/create_human()
	var/mob/living/carbon/human/H = new(loc)
	if(gender == FEMALE)
		H.gender = FEMALE
	else
		H.gender = MALE
	H.real_name = name
	H.name = H.real_name
	var/thespecies
	switch(race)
		if("lizard")
			thespecies = /datum/species/lizard
		if("ashwalker")
			thespecies = /datum/species/lizard/ashwalker
		else
			thespecies = /datum/species/human
	H.set_species(thespecies, icon_update=1)
	if(race == "lizard" || race == "ashwalker")
		//As mentioned above, lizard mutant body parts are hard coded because who cares.
		H.dna.features["body_markings"] = "Light Tiger Body"
		H.dna.features["tail_lizard"] = "Spikes"
		H.dna.features["snout"] = "Round + Light"
		H.dna.features["horns"] = "Curled"
		H.dna.features["frills"] = "Aquatic"
		H.dna.features["spines"] = "Long + Membrane"
		H.dna.features["mcolor"] = skincolor
	else
		H.hair_style = human_traits["hair_style"]
		H.hair_color = human_traits["hair_color"]
		H.facial_hair_style = human_traits["facial_hair_style"]
		H.facial_hair_color = human_traits["facial_hair_color"]
		H.skin_tone = humanskincolor
	//Because degeneral hates underwear.
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.regenerate_icons()
	//equipping items to the dead mob.
	for(var/obj/item/item in equipped_items)
		if(!istype(item) || !equipped_items[item])
			continue
		if(race == "ashwalker" && equipped_items[item] == SLOT_SHOES) //ashwalkers cant wear shoes
			continue
		H.equip_to_slot_or_del(item, equipped_items[item])
	//no point in equipping the hand held items, we just put them on the floor.
	for(var/obj/item/item in humanoid_held_items)
		H.put_in_hands(item)
	H.faction = faction.Copy()
	if(isnum(adjustsize) && adjustsize != 1)
		H.transform *= adjustsize
	return H

/mob/living/simple_animal/hostile/customhumanoid/death(gibbed)
	. = ..()
	var/mob/living/carbon/human/H = create_human()
	H.death()
	if(gibbed)
		H.gib()
	qdel(src)

/mob/living/simple_animal/hostile/customhumanoid/Login()
	. = ..()
	if(client)
		var/mob/living/carbon/human/H = create_human()
		H.dir = dir
		H.ckey = client.ckey
		qdel(src)

//retaliation flag. because fuckin tg sucks
//this is literally copy pasted from retaltiate.dm
/mob/living/simple_animal/hostile/customhumanoid/Found(atom/A)
	if(retaliation)
		if(isliving(A))
			var/mob/living/L = A
			if(!L.stat)
				return L
			else
				enemies -= L
		else if(A.will_mob_attack(src))
			return A
	return ..()

/mob/living/simple_animal/hostile/customhumanoid/ListTargets()
	if(retaliation)
		if(!enemies.len)
			return list()
		var/list/see = ..()
		see &= enemies
		return see
	else
		return ..()

/mob/living/simple_animal/hostile/customhumanoid/proc/Retaliate()
	if(retaliation)
		for(var/atom/movable/A as obj|mob in oview(vision_range, src))
			if(isliving(A))
				var/mob/living/M = A
				if(attack_same || !faction_check_mob(M))
					enemies |= M
				if(istype(M, /mob/living/simple_animal/hostile/retaliate))
					var/mob/living/simple_animal/hostile/retaliate/H = M
					if(attack_same && H.attack_same)
						H.enemies |= enemies
			else if(A.will_mob_attack(src))
				enemies |= A
				enemies |= A.will_mob_attack(src)
		return FALSE

/mob/living/simple_animal/hostile/customhumanoid/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(retaliation)
		if(. > 0 && stat == CONSCIOUS)
			Retaliate()
