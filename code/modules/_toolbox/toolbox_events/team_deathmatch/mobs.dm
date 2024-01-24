
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

