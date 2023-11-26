/obj/item/cartridge/virus/clown
	return_modes = list(4,5,6)
	var/pda_mode_setting = 63
	var/bananapoints = 0
	var/list/purchased = list()
	var/list/clown_buyables = list(
	/obj/item/grenade/chem_grenade/banana = "cost=5;remaining=10",
	/obj/item/reagent_containers/food/snacks/pie/cream = "cost=5;remaining=20",
	/obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = "cost=10;remaining=10",
	/obj/item/bikehorn = "cost=10;remaining=3",
	/obj/item/storage/crayons = "cost=15;remaining=3",
	/obj/item/reagent_containers/hypospray/itchingpowder = "cost=10;remaining=5",
	/obj/item/storage/box/snappops = "cost=30;remaining=10",
	/obj/item/toy/crayon/spraycan = "cost=10;remaining=5",
	/obj/item/paper_bin/construction = "cost=10;remaining=2",
	/obj/item/flashlight/lamp/bananalamp = "cost=50;remaining=2",
	/obj/item/grenade/chem_grenade/glitter/random = "cost=50;remaining=8",
	/obj/item/megaphone/clown = "cost=50;remaining=2",
	/obj/item/clothing/suit/space/hardsuit/clown = "cost=80;remaining=1",
	/obj/item/banhammer = "cost=100;remaining=1",
	/obj/item/instrument/bikehorn = "cost=100;remaining=1",
	/obj/item/pneumatic_cannon/pie = "cost=200;remaining=2",
	/obj/item/clothing/shoes/clown_shoes/banana_shoes = "cost=200;remaining=1",
	/obj/item/reagent_containers/pill/mutadone  = "cost=300;remaining=1",
	/obj/item/grenade/chem_grenade/lube = "cost=400;remaining=3",
	/obj/mecha/combat/honker = "cost=4000;remaining=1")

/obj/item/cartridge/virus/clown/customreaction(href_list,mob/living/carbon/user)
	if(host_pda && user && user.mind && user.mind.assigned_role == "Clown")
		if(href_list["choice"] == "clownstore")
			host_pda.mode = pda_mode_setting
			host_pda.attack_self(user)
		else if(href_list["clownstorebuy"])
			var/thepath = text2path(href_list["clownstorebuy"])
			if(ispath(thepath) && (thepath in clown_buyables))
				var/list/amounts = params2list(clown_buyables[thepath])
				amounts["cost"] = text2num(amounts["cost"])
				amounts["remaining"] = text2num(amounts["remaining"])
				if(isnum(amounts["cost"]) && isnum(amounts["remaining"]))
					if(thepath in purchased)
						amounts["remaining"] = max(amounts["remaining"] - purchased[thepath],0)
					if(amounts["remaining"] > 0)
						if(bananapoints >= amounts["cost"])
							var/atom/movable/AM = new thepath(get_turf(user))
							playsound(user.loc, 'sound/machines/terminal_processing.ogg', 15, TRUE)
							if(istype(AM,/obj/item))
								user.put_in_hands(AM)
							bananapoints -= amounts["cost"]
							if(!purchased[thepath])
								purchased[thepath] = 1
							else
								purchased[thepath] = purchased[thepath]+1
							to_chat(user,"<span class='notice'>You purchase [AM] for [amounts["cost"]] Banana Points.</span>")
							host_pda.attack_self(user)
						else
							to_chat(user,"<span class='Warning'>You do not have enough Banana Points.</span>")
					else
						to_chat(user,"<span class='Warning'>There is no more in stock.</span>")

/obj/item/cartridge/virus/clown/generate_menu()
	if(host_pda && usr && host_pda.mode == pda_mode_setting)
		var/dat = ""
		if(usr.mind && usr.mind.assigned_role == "Clown")
			dat += "<h2><font color='#66ff66'>Honk Store!!</font></h2>"
			dat += "<font color='#66ff66'>Insert Bananas to gain points!"
			dat += "<P><B>Banana Points: [bananapoints]</B></font></P>"
			for(var/path in clown_buyables)
				if(!ispath(path)||!clown_buyables[path])
					continue
				var/atom/movable/AM = path
				if(ispath(AM))
					var/list/amounts = params2list(clown_buyables[path])
					amounts["cost"] = text2num(amounts["cost"])
					amounts["remaining"] = text2num(amounts["remaining"])
					if(!isnum(amounts["cost"]) || !isnum(amounts["remaining"]))
						continue
					if(path in purchased)
						amounts["remaining"] = max(amounts["remaining"] - purchased[path],0)
					var/entry = "([amounts["remaining"]])[uppertext(initial(AM.name))]"
					if(bananapoints >= amounts["cost"] && amounts["remaining"] > 0)
						entry = "<A href='?src=\ref[src];custommenu=1;clownstorebuy=[path]'>[entry]</A>"
					dat += "<font color='#66ff66'>[entry] Cost: [amounts["cost"]]</font><br>"
		else
			dat += "<P><font color='#66ff66'>HONK! Unauthorized not a clown detected!!</font></P>"
			playsound(usr.loc, 'sound/misc/sadtrombone.ogg', 50, 1)
		if(dat)
			return dat
	return ..()

/obj/item/cartridge/virus/clown/get_background_color()
	if(host_pda && host_pda.mode == pda_mode_setting)
		return "#ff99ff"
	return ..()

/obj/item/cartridge/virus/clown/insert_item(mob/user,obj/item/I)
	if(istype(I,/obj/item/reagent_containers/food/snacks/grown/banana))
		var/obj/item/reagent_containers/food/snacks/grown/banana/banana = I
		if(banana.seed && isnum(banana.seed.potency) && user.doUnEquip(I))
			var/potency = banana.seed.potency
			bananapoints += max(round(potency/5),1)
			qdel(banana)
			playsound(user.loc, 'sound/machines/pda_button1.ogg', 30, TRUE)
			spawn(20)
				playsound(user.loc, 'sound/items/bikehorn.ogg', 30, 1)
			to_chat(user,"<span class='notice'>You insert the [banana] into the [host_pda]. There is now [bananapoints] Banana Points available.</span>")
			return TRUE
	return FALSE

//banana pie grenade
/obj/item/grenade/chem_grenade/banana
	name = "banana grenade"
	desc = "HONK!."
	stage = GRENADE_READY
	icon_state = "banana"

/obj/item/grenade/chem_grenade/banana/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/consumable/banana, 60)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/banana/stage_change(N)
	icon_state = "chemg"
	. = ..()
	if(stage == GRENADE_READY)
		icon_state = initial(icon_state)

//banana reagent turf react sometimes makes cake
/datum/reagent/consumable/banana/reaction_turf(turf/T, reac_volume)
	if(prob(1))
		var/breads = 0
		for(var/obj/item/reagent_containers/food/snacks/store/bread/banana/B in range(1,T))
			breads++
		if(breads <= 1)
			new /obj/item/reagent_containers/food/snacks/store/bread/banana(T)
	. = ..()

//space lube grenade
/obj/item/grenade/chem_grenade/lube
	name = "space lube grenade"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/lube/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	B2.reagents.add_reagent(/datum/reagent/water, 40)
	B2.reagents.add_reagent(/datum/reagent/lube, 60)

	beakers += B1
	beakers += B2

//glitter bombs
/obj/item/grenade/chem_grenade/glitter/random
	name = "glitter grenade"
	icon_state = "disco"
	var/list/glitter_bomb_types = list(
		/obj/item/grenade/chem_grenade/glitter/pink,
		/obj/item/grenade/chem_grenade/glitter/blue,
		/obj/item/grenade/chem_grenade/glitter/white)

/obj/item/grenade/chem_grenade/glitter/random/Initialize()
	var/chosen_type = pick(glitter_bomb_types)
	var/obj/item/grenade/chem_grenade/glitter/G = chosen_type
	name = initial(G.name)
	desc = initial(G.desc)
	glitter_type = initial(G.glitter_type)
	. = ..()

/obj/item/grenade/chem_grenade/glitter/random/stage_change(N)
	icon_state = "chemg"
	. = ..()
	if(stage == GRENADE_READY)
		icon_state = initial(icon_state)
