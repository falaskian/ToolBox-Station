/********************** ECONOMY **************************/

		//TDM Lizard Workers


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM
	name =  "Lizard Worker"
	equipped_items = list(/obj/item/clothing/under/color/grey = SLOT_W_UNIFORM)


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM/red
	equipped_items = list(/obj/item/clothing/under/color/red = SLOT_W_UNIFORM)


/mob/living/simple_animal/hostile/customhumanoid/tribal_slave/TDM/blue
	equipped_items = list(/obj/item/clothing/under/color/blue = SLOT_W_UNIFORM)


		//TDM ore node

// dont forget to place crates and /obj/effect/slave_ore_dropoff_point

/obj/structure/lizard_ore_node/TDM
	ore = list(/obj/item/stack/ore/gold = 10)

		//TDM Ore Furnace

/obj/machinery/mineral/ore_redemption/TDM
	name = "furnace"
	use_power = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE
	circuit = /obj/item/circuitboard/machine/ore_redemption/TDM

/obj/machinery/mineral/ore_redemption/TDM/process()
	.=..()
	if(!materials.mat_container || panel_open || !powered())
		return
	materials.mat_container.retrieve_all(get_step(src, output_dir))

/obj/machinery/mineral/ore_redemption/TDM/ui_interact(mob/user, datum/tgui/ui)
	return

/obj/machinery/mineral/ore_redemption/TDM/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore))
		.=..()
	else
		return