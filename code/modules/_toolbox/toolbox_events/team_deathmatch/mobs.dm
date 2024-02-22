
/********************** MOBS **************************/

	//GUIN

/mob/living/simple_animal/pet/penguin/emperor/shamebrero/guin
	name = "Guin"
	desc = "Meet our captivating host."
	maxHealth = 1000
	health = 1000
	layer = 4.6

/mob/living/simple_animal/pet/penguin/emperor/shamebrero/guin/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE)
	return 0


	//Dead Frog

/mob/living/simple_animal/hostile/retaliate/frog/dead

/mob/living/simple_animal/hostile/retaliate/frog/dead/Initialize()
	.=..()
	death()


		//Aliens

	//Grown Larva

/mob/living/carbon/alien/larva/grown
	amount_grown = 100
	max_grown = 100


	//Fast Growing Larva

/mob/living/carbon/alien/larva/fast_growing
	amount_grown = 0
	max_grown = 20

	//Queen

/mob/living/carbon/alien/humanoid/royal/queen/TDM

/*
/mob/living/carbon/alien/humanoid/royal/queen/TDM/nuke_disk/Initialize()
 	. = ..()
 	new /obj/item/disk/nuclear(src.contents)
 */

/obj/item/organ/alien/eggsac/TDM
	name = "egg sac"
	icon_state = "eggsac"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = "eggsac"
	w_class = WEIGHT_CLASS_BULKY
	alien_powers = list(/obj/effect/proc_holder/alien/lay_egg/TDM)

/obj/effect/proc_holder/alien/lay_egg/TDM
	name = "Lay Egg"
	desc = "Lay an egg that expands your colony numbers by consuming dead host bodies and hatching new larvas. Costs 75 Plasma."
	plasma_cost = 75
	check_turf = TRUE
	action_icon_state = "alien_egg"

/obj/effect/proc_holder/alien/lay_egg/TDM/fire(mob/living/carbon/user)
	if(locate(/obj/machinery/clonepod/TDM/alien) in get_turf(user))  //this is probably broken if it doesnt include children of clonepod/TDM/alien typepath
		to_chat(user, "<span class='alertalien'>There's already an egg here.</span>")
		return FALSE

	if(!check_vent_block(user))
		return FALSE

	user.visible_message("<span class='alertalien'>[user] has laid an egg!</span>")
	if(user.mind.special_role == TDM_BLUE_TEAM)
		new /obj/machinery/clonepod/TDM/alien/team_blue(user.loc)
		return TRUE
	if(user.mind.special_role == TDM_RED_TEAM)
		new /obj/machinery/clonepod/TDM/alien/team_red(user.loc)
		return TRUE
	else
		to_chat(user, "<span class='alertalien'>You dont seem to be part of a team.</span>")
		return FALSE