/obj/effect/turf_decal/plaque/toolbox
	name = "plaque"
	icon = 'icons/oldschool/ss13sign1rowdecals.dmi'
	var/ismain = 0
/obj/effect/turf_decal/plaque/toolbox/New()
	. = ..()
	if(ismain)
		if(!isturf(loc))
			qdel(src)
			return
		var/startx = x-3
		for(var/i=1,i<=7,i++)
			var/turf/T = locate(startx,y,z)
			if(istype(T))
				var/obj/effect/turf_decal/plaque/toolbox/P = new(T)
				if(T == loc)
					P = src
				else
					P = new(T)
				P.icon_state = "S[i]"
			startx++
		ismain = 0

/*
//rapid parts exchanger can now replace apc cells
/obj/machinery/power/apc/exchange_parts(mob/user, obj/item/storage/part_replacer/W)
	if(!istype(W) || !cell)
		return FALSE
	if(!W.works_from_distance && ((!usr.Adjacent(src)) || (cant_parts_exchange())))
		return FALSE
	for(var/obj/item/stock_parts/cell/C in W.contents)
		if(C.maxcharge > cell.maxcharge)
			var/atom/movable/oldcell = cell
			if(W.remove_from_storage(C))
				C.doMove(oldcell.loc)
				if(W.handle_item_insertion(oldcell, 1))
					cell = C
					W.notify_user_of_success(user,C,oldcell)
					W.play_rped_sound()
					return TRUE
	return ..()

/obj/machinery/power/apc/cant_parts_exchange()
	if(!panel_open)
		return 1

/obj/machinery/proc/cant_parts_exchange()
	if(flags_1 & NODECONSTRUCT_1)
		return 1


/obj/item/storage/part_replacer/proc/notify_user_of_success(mob/user,atom/newitem,atom/olditem)
	if(!user || !newitem || !olditem)
		return
	to_chat(user, "<span class='notice'>[olditem.name] replaced with [newitem.name].</span>")*/

//reinforced delivery window. allows items to be placed on tables underneath it
/obj/structure/window/reinforced/fulltile/delivery
	name = "reinforced delivery window"
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "delivery_window"
	flags_1 = 0
	smooth = SMOOTH_FALSE
	canSmoothWith = list()
	glass_amount = 5
	CanAtmosPass = ATMOS_PASS_YES

/obj/structure/window/reinforced/fulltile/delivery/unanchored
	anchored = FALSE

//***************************
//plant disk organizing shelf
//***************************

#define EMPTYDISKNAME "Blank Disks"
/obj/structure/plant_disk_shelf
	name = "Plant Data Disk Storage Shelf"
	desc = "Where we store our plant genes."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "plant_disk_shelf"
	anchored = 1
	density = 0
	pixel_y = 32
	var/max_disks = 26
	var/list/plant_disks = list()

/obj/structure/plant_disk_shelf/attack_hand(mob/living/user)
	user.set_machine(src)
	var/datum/browser/popup = new(user, "plantdiskstorage", "[name]", 450, 600)
	var/dat = "<B>Stored Plant Data Disks</B><BR><BR>"
	if(!plant_disks.len)
		dat += "Empty"
	else
		for(var/disk in plant_disks)
			if(istype(plant_disks[disk],/list))
				var/list/this_list = plant_disks[disk]
				if(this_list.len)
					dat += "[disk] ([this_list.len]) <A href='?src=\ref[src];disk=[disk]'>Remove</A><br>"
	popup.set_content(dat)
	popup.open()

/obj/structure/plant_disk_shelf/proc/remove_disk(disk)
	if(!disk)
		return
	var/diskname = disk
	if(istype(diskname,/obj/item/disk/plantgene))
		var/obj/item/disk/plantgene/P = disk
		if(P.gene)
			diskname = P.gene.get_name()
		else
			diskname = EMPTYDISKNAME
	if(diskname in plant_disks)
		var/list/this_list = plant_disks[diskname]
		if(istype(this_list,/list) && this_list.len)
			var/obj/item/disk/thedisk = pick(this_list)
			if(istype(thedisk))
				this_list -= thedisk
				if(!this_list.len)
					plant_disks.Remove(diskname)
				else
					plant_disks[diskname] = this_list
				thedisk.forceMove(loc)
				thedisk.pixel_x = rand(-4,4)
				thedisk.pixel_y = rand(-4,4)
				update_icon()
				return thedisk
	return null

/obj/structure/plant_disk_shelf/proc/add_disk(obj/item/disk/plantgene/disk)
	if(!istype(disk) || get_disk_count() >= max_disks)
		return 0
	disk.forceMove(src)
	if(disk.loc != src)
		return 0
	if(disk.gene)
		var/gene_name = disk.gene.get_name()
		if(gene_name in plant_disks && istype(plant_disks[gene_name],/list))
			var/list/this_list = plant_disks[gene_name]
			this_list += disk
			plant_disks[gene_name] = this_list
		else
			plant_disks[gene_name] = list(disk)
	else
		if((EMPTYDISKNAME in plant_disks) && istype(plant_disks[EMPTYDISKNAME],/list))
			var/list/this_list = plant_disks[EMPTYDISKNAME]
			this_list += disk
			plant_disks[EMPTYDISKNAME] = this_list
		else
			plant_disks[EMPTYDISKNAME] = list(disk)
	update_icon()
	return 1

/obj/structure/plant_disk_shelf/Topic(var/href, var/list/href_list)
	if(..())
		return
	usr.set_machine(src)
	if(href_list["disk"])
		var/obj/item/disk/plantgene/disk = remove_disk(href_list["disk"])
		if(istype(disk) && ishuman(usr))
			usr.put_in_hands(disk)
		return attack_hand(usr)

/obj/structure/plant_disk_shelf/attackby(obj/item/W, mob/living/user, params)
	if(istype(W,/obj/item/disk/plantgene))
		if(get_disk_count() < max_disks)
			if(user.dropItemToGround(W))
				add_disk(W)
				if(user.machine == src)
					attack_hand(user)
		else
			to_chat(user, "<div class='warning'>You cannot put any more disks in the [src].</div>")
	else
		return ..()

/obj/structure/plant_disk_shelf/proc/get_disk_count()
	. = 0
	for(var/obj/item/disk/plantgene/P in src)
		.++
	return .

/obj/structure/plant_disk_shelf/update_icon()
	overlays.Cut()
	if(plant_disks && plant_disks.len)
		var/diskcount = get_disk_count()
		var/shelfcap = round(max_disks/2,1)
		var/pixelx = 0
		var/pixely = 0
		for(var/i=1,i<=diskcount,i++)
			if(i>(shelfcap*2))
				break
			var/image/I = new()
			I.icon = icon
			I.icon_state = "[icon_state]_disk"
			I.pixel_x = pixelx
			I.pixel_y = pixely
			pixelx = pixelx+2
			if(!pixely && i >= 13)
				pixelx = 0
				pixely = -10
			overlays += I

/obj/structure/plant_disk_shelf/Destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(loc)
		if(istype(AM,/obj/item/disk))
			AM.pixel_x = rand(-4,4)
			AM.pixel_y = rand(-4,4)
	plant_disks = list()
	return ..()
#undef EMPTYDISKNAME
/*
//animal cookies
/obj/item/reagent_containers/food/snacks/cracker
	var/copied = 0

/obj/item/reagent_containers/food/snacks/cracker/New()
	var/list/available = list()
	for(var/mob/living/M in range(3,get_turf(src)))
		if(istype(M,/mob/living/carbon/monkey) || (istype(M,/mob/living/simple_animal) && !istype(M,/mob/living/simple_animal/hostile) && !istype(M,/mob/living/simple_animal/bot) && !istype(M,/mob/living/simple_animal/slime)))
			available += M
	var/choice
	if(available.len)
		choice = pick(available)
	if(choice)
		copy_animal(choice)
	. = ..()

/obj/item/reagent_containers/food/snacks/cracker/proc/copy_animal(atom/A)
	if(!A)
		return
	overlays.Cut()
	var/matrix/M = new()
	transform = M
	name = "animal cracker"
	desc = "Its a [A.name]!"
	var/icon/mask = icon(A.icon,initial(A.icon_state),dir = 4)
	mask.Blend(rgb(255,255,255))
	mask.BecomeAlphaMask()
	var/icon/cracker = new/icon('icons/oldschool/objects.dmi', "crackertexture")
	cracker.AddAlphaMask(mask)
	var/image/overlay = image(cracker)
	overlays += overlay
	/*var/image/shades = new()
	shades.icon = A.icon
	shades.icon_state = A.icon_state
	shades.overlays += A.overlays
	shades.color = list(0.30,0.30,0.30,0, 0.60,0.60,0.60,0, 0.10,0.10,0.10,0, 0,0,0,1, 0,0,0,0)
	shades.alpha = round(255*0.5,1)
	overlays += shades*/
	M *= 0.6
	transform = M*/

//**********************
//Chemical Reagents Book
//**********************

/obj/item/book/manual/wiki/chemistry/Initialize(roundstart)
	. = ..()
	if(roundstart)
		var/bookcount = 0
		for(var/obj/item/book/manual/falaskian_chemistry/F in loc)
			bookcount++
		if(!bookcount)
			new /obj/item/book/manual/falaskian_chemistry(loc)

/obj/item/book/manual/falaskian_chemistry
	name = "Guide to all chemical recipes in the known universe."
	desc = "A complete list of all chemicals recipes and their effects."
	author = "Mangoulium XCIX"
	unique = 1
	icon_state = "book8"
	window_size = "970x710"

/obj/item/book/manual/falaskian_chemistry/New()
	..()
	var/image/I = new()
	I.icon = 'icons/obj/chemical.dmi'
	I.icon_state = "dispenser"
	I.transform = I.transform*0.5
	overlays += I

/obj/item/book/manual/falaskian_chemistry/update_icon()

/obj/item/book/manual/falaskian_chemistry/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen))
		return
	. = ..()

/obj/item/book/manual/falaskian_chemistry/attack_self(mob/user)
	if(is_blind(user))
		to_chat(user, "<span class='warning'>As you are trying to read, you suddenly feel very stupid!</span>")
		return
	if(ismonkey(user))
		to_chat(user, "<span class='notice'>You skim through the book but can't comprehend any of it.</span>")
		return
	if(dat)
		var/sizex = 970
		var/sizey = 710
		if(window_size)
			var/xlocation = findtext(window_size,"x",1,length(window_size)+1)
			if(xlocation && isnum(text2num(copytext(window_size,1,xlocation))) && isnum(text2num(copytext(window_size,xlocation,length(window_size)+1))))
				sizex = text2num(copytext(window_size,1,xlocation))
				sizey = text2num(copytext(window_size,xlocation,length(window_size)+1))
		var/datum/browser/popup = new(user, "book", "[name]", sizex, sizey)
		popup.set_content(dat)
		popup.open()
		title = name
		user.visible_message("[user] opens a book titled \"[title]\" and begins reading intently.")
		//user.SendSignal(COMSIG_ADD_MOOD_EVENT, "book_nerd", /datum/mood_event/book_nerd)
		onclose(user, "book")
	else
		to_chat(user, "<span class='notice'>This book is completely blank!</span>")

/obj/item/book/manual/falaskian_chemistry/Initialize()
	. = ..()
	if(!dat)
		for(var/obj/item/book/manual/falaskian_chemistry/F in world)
			if(F == src)
				continue
			if(F.dat)
				dat = F.dat
				break
	if(!dat)
		populate_reagents()

/obj/item/book/manual/falaskian_chemistry/proc/populate_reagents()
	var/list/reactions = list()
	for(var/path in subtypesof(/datum/chemical_reaction))
		var/datum/chemical_reaction/C = new path()
		if(!C.name || !C.id || !C.results || !C.results.len)
			qdel(C)
			continue
		for(var/t in C.results)
			reactions[t] = C
	var/list/all_reagents = list()
	var/list/crafted_reagents = list(
		"Medicine" = list(),
		"Toxin" = list(),
		"Ethanol" = list(),
		"Consumable" = list(),
		"Drug" = list(),
		"Other Various Chemicals" = list())
	for(var/path in subtypesof(/datum/reagent))
		var/datum/reagent/R = new path()
		if(!R.name)
			qdel(R)
			continue
		all_reagents[R.type] = R
		if(R.type in reactions)
			if(istype(R,/datum/reagent/medicine))
				crafted_reagents["Medicine"][R.name] = R
			else if(istype(R,/datum/reagent/toxin))
				crafted_reagents["Toxin"][R.name] = R
			else if(istype(R,/datum/reagent/consumable))
				if(istype(R,/datum/reagent/consumable/ethanol))
					crafted_reagents["Ethanol"][R.name] = R
				else
					crafted_reagents["Consumable"][R.name] = R
			else if(istype(R,/datum/reagent/drug))
				crafted_reagents["Drug"][R.name] = R
			else
				crafted_reagents["Other Various Chemicals"][R.name] = R
		else
			qdel(R)
	for(var/cat in crafted_reagents)
		crafted_reagents[cat] = sortList(crafted_reagents[cat])
	dat = "<h1>All Chemical Recipes In The Known Universe</h1>"
	dat += "Written by [author].<BR>"
	for(var/cat in crafted_reagents)
		dat += "<h2>[cat]</h2><br>"
		for(var/crafted in crafted_reagents[cat])
			var/datum/reagent/R = crafted_reagents[cat][crafted]
			dat += "<B>[R.name]</B><BR>"
			if(R.description)
				dat += "[R.description]<BR>"
			var/datum/chemical_reaction/C = reactions[R.type]
			dat += "<B>Formula:</B> "
			var/totalparts = 0
			for(var/i=1,i<=C.required_reagents.len,i++)
				var/t = C.required_reagents[i]
				var/parts = "1 part"
				if(C.required_reagents[t] && isnum(C.required_reagents[t]))
					parts = C.required_reagents[t]
					totalparts += parts
					if(parts > 1)
						parts = "[parts] parts"
					else
						parts = "[parts] part"
				var/partname = t
				if(t in all_reagents)
					var/datum/reagent/R2 = all_reagents[t]
					partname = R2.name
				dat += "[parts] [partname]"
				if(i < C.required_reagents.len)
					dat += ", "
			dat += "<BR>"
			if(C.required_catalysts.len)
				dat += "<B>Catalyst"
				if(C.required_catalysts.len > 1)
					dat += "s"
				dat += ":</B> "
				for(var/t in C.required_catalysts)
					var/units = 1
					if(C.required_catalysts[t])
						units = C.required_catalysts[t]
					if(units > 1)
						units = "[units] units"
					else
						units = "[units] unit"
					var/catalystname = t
					if(t in all_reagents)
						var/datum/reagent/R2 = all_reagents[t]
						catalystname = R2.name
					dat += "[units] of [catalystname]"
				dat += "<BR>"
			var/craftedunits = C.results[R.type]
			if(totalparts && craftedunits && totalparts != craftedunits)
				if(craftedunits > 1)
					craftedunits = "[craftedunits] units"
				else
					craftedunits = "[craftedunits] unit"
				dat += "Results in [craftedunits] for every [totalparts] units in reagents.<BR>"
			if(C.required_temp)
				var/heated = "heated"
				if(C.is_cold_recipe)
					heated = "cooled"
				dat += "Must be [heated] to a temperature of [C.required_temp]<BR>"
			dat += "<BR>"

//Making it so borgs can set up the engine -falaskian
/obj/machinery/portable_atmospherics/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/tank) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

/obj/machinery/power/rad_collector/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/tank/internals/plasma) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

/obj/machinery/power/port_gen/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/stack/sheet) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

//making certain things again useable by silicons. -falaskian
/obj/machinery/power/rad_collector/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/power/rad_collector/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/tank_dispenser/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/conveyor_switch/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/conveyor_switch/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/disposal/bin/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/disposal/bin/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/field/generator/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/particle_accelerator/control_box/attack_robot(mob/user)
	if(construction_state == 2)
		attack_hand(user)
	else
		return ..()

//Degenerals large airlocks

/obj/machinery/door/airlock/glass_large/security
	name = "large glass airlock"
	icon = 'icons/oldschool/airlock_large_security.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/large_sec
	glass = TRUE
	bound_width = 64 // 2x1
	panel_attachment = "top"

/obj/structure/door_assembly/large_sec
	name = "security airlock assembly"
	icon = 'icons/oldschool/airlock_large_security.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/glass_large/security
	airlock_type = /obj/machinery/door/airlock/glass_large/security
	bound_width = 64 // 2x1

//make shuttles bolt the door on launch
/obj/docking_port/mobile/proc/bolt_and_unbolt_exits(unbolt = 0)
	var/area/A = get_area(src)
	var/list/airlocks = list()
	for(var/obj/machinery/door/airlock/airlock in A)
		if(airlock in airlocks)
			continue
		airlocks += airlock
		var/has_space = 0
		for(var/turf/T in orange(1,airlock))
			if(T.x != airlock.x && T.y != airlock.y)
				continue
			if(T.density)
				continue
			if(istype(T,/turf/open/space))
				has_space = 1
				break
			var/area/TA = get_area(T)
			if(TA.type != A.type)
				has_space = 1
				break
		if(has_space)
			if(!unbolt)
				airlock.bolt()
			else
				airlock.unbolt()

//disease logging
/*/datum/disease/proc/log_disease_transfer_attempt(atom/cause,atom/victim,method)
	if(istype(victim,/mob/living/carbon))
		var/mob/living/carbon/C = victim
		if(!C.CanContractDisease(src))
			return
	var/logtext = "DISEASE: Disease transfer attempt. Disease name: "
	if(istype(src,/datum/disease/advance))
		logtext += "Advanced(Symptoms:"
		var/datum/disease/advance/A = src
		var/symptomcount = 1
		for(var/datum/symptom/S in A.symptoms)
			logtext += "[S.name]"
			if(symptomcount < A.symptoms.len)
				logtext += ","
		logtext += ")"
	else
		logtext += "[name]"
	if(method)
		logtext += " Transfer method: "
		var/transfermethod = "Unknown"
		if(isnum(method) || isnum(text2num(method)))
			var/nummethod = "[method]"
			var/list/methods = list(
				"[TOUCH]" = "Contact",
				"[INGEST]" = "Injestion",
				"[VAPOR]" = "Breathing Vapor",
				"[PATCH]" = "Patch",
				"[INJECT]" = "Direct Blood Injection"
				)
			if(methods[nummethod])
				transfermethod = "[methods[nummethod]]"
		else
			transfermethod = "[method]"
		logtext += "[transfermethod] "
	var/causetext = "No Origin"
	var/victimtext = "No Victim"
	if(istype(cause))
		var/atom/tool_used
		if(!istype(cause,/mob/living))
			var/atom/find_mob = cause
			var/timeout = 15
			while(timeout > 0 && find_mob && !istype(find_mob,/mob))
				find_mob = find_mob.loc
				timeout--
			if(istype(find_mob, /mob/living))
				tool_used = cause
				cause = find_mob
		if(istype(cause,/mob/living))
			var/mob/living/living = cause
			var/theckey = "no-ckey"
			if(living.ckey)
				theckey = "[living.ckey]"
			causetext = "[living.real_name]([theckey])"
		else
			causetext = "[cause.name]"
		var/turf/T = get_turf(cause)
		if(T)
			causetext += "([T.x],[T.y],[T.z]"
			var/area/A = get_area(T)
			if(A)
				causetext += " \"[A.name]\""
			causetext += ")"
		if(tool_used)
			causetext += " Tool used: [tool_used.name]"
		causetext += " "
	if(istype(victim))
		if(istype(victim,/mob/living))
			var/mob/living/living = victim
			var/theckey = "no-ckey"
			if(living.ckey)
				theckey = "[living.ckey]"
			victimtext = "[living.real_name]([theckey])"
		else
			victimtext = "[victim.name]"
		var/turf/T = get_turf(victim)
		if(T)
			victimtext += "([T.x],[T.y],[T.z]"
			var/area/A = get_area(T)
			if(A)
				victimtext += " \"[A.name]\""
			victimtext += ")"
		victimtext += " "
	logtext += "Origin: [causetext] Victim: [victimtext]"
	if(istype(victim,/mob/living))
		var/mob/living/V = victim
		V.log_message("<font color='orange'>[logtext]</font>", INDIVIDUAL_ATTACK_LOG)
	log_game(logtext)
	return logtext*/

//reverting egun nerfs with one proc
/obj/item/gun/energy/e_gun/Initialize()
	if(w_class == WEIGHT_CLASS_BULKY)
		w_class = WEIGHT_CLASS_NORMAL
	if(weapon_weight == WEAPON_MEDIUM)
		weapon_weight = WEAPON_LIGHT
	return ..()

/obj/item/gun/energy/laser/Initialize()
	if(w_class == WEIGHT_CLASS_BULKY)
		w_class = WEIGHT_CLASS_NORMAL
	return ..()

//on vend item modification for vending machines. allows you to affect the item or vending machine post vending the item.
/obj/machinery/vending
	var/price_override = list()
	var/premium_price_override = list()

/obj/machinery/vending/proc/vend_item(item_path,atom/dropoffspot)
	var/atom/A = new item_path(dropoffspot)
	if(A)
		on_vend(A)
	return A

/obj/machinery/vending/proc/on_vend(atom/movable/AM)

//making power cells spawn with full energy not empty because thats super gay.
/datum/design/basic_cell/New()
	. = ..()
	build_path = /obj/item/stock_parts/cell

/datum/design/high_cell/New()
	. = ..()
	build_path = /obj/item/stock_parts/cell/high

/datum/design/super_cell/New()
	. = ..()
	build_path = /obj/item/stock_parts/cell/super

/datum/design/hyper_cell/New()
	. = ..()
	build_path = /obj/item/stock_parts/cell/hyper

/datum/design/bluespace_cell/New()
	. = ..()
	build_path = /obj/item/stock_parts/cell/bluespace

//fast loading shotguns
/obj/item/gun/ballistic/shotgun
	var/bag_reload_time = 8 //Time between shell loads. First one is instant.
	var/next_bag_reload = 0

/obj/item/gun/ballistic/shotgun/get_dumping_location()
	return src

/obj/item/gun/ballistic/shotgun/attackby(obj/item/A, mob/user, params)
	if(istype(A,/obj/item/storage/box) || istype(A,/obj/item/storage/belt/bandolier))
		reload_from_bag(A,user)
		return
	return ..()

/obj/item/gun/ballistic/shotgun/storage_contents_dump_act(datum/component/storage/src_object, mob/user)
	if(istype(src_object.parent,/obj/item/storage/box) || istype(src_object.parent,/obj/item/storage/belt/bandolier))
		reload_from_bag(src_object.parent,user)
		return
	return ..()

/obj/item/gun/ballistic/shotgun/proc/reload_from_bag(obj/item/storage/bag, mob/user)
	if(!istype(bag) || !user)
		return
	if(next_bag_reload > world.time)
		to_chat(user, "<span class='notice'>It's hard to rummage this quickly with these shells.</span>")
		return
	var/success = 1
	next_bag_reload = world.time+bag_reload_time
	while(success && magazine.ammo_count(countempties = TRUE) < magazine.max_ammo)
		var/obj/item/ammo_casing/reload
		for(var/obj/item/ammo_casing/A in bag)
			if(A.BB && (A.caliber == magazine.caliber || (!magazine.caliber && A.type == magazine.ammo_type))) //The same checks as when you manually load a shell to the gun.
				reload = A
				break
		if(reload && bag && !QDELETED(reload) && !QDELETED(bag))
			attackby(reload,user) //We just call attackby, it does the rest.
			next_bag_reload+=bag_reload_time
			if(magazine.ammo_count(countempties = TRUE) >= magazine.max_ammo)
				break
			success = do_after(user, bag_reload_time, TRUE, src, TRUE)
		else
			break
		stoplag(1) //Dont wanna crash server if something goes wrong here.

//autobuckling noose, for mapping purposes. yeah thats it.
/obj/structure/chair/noose/autobuckle/Initialize()
	. = ..()
	var/mob/to_buckle
	for(var/mob/living/carbon/human/M in loc)
		if(istype(M,/mob/living/carbon/human))
			to_buckle = M
			break
	if(to_buckle)
		buckle_mob(to_buckle)
		return
	qdel(src)

/obj/effect/spawner/structure/window/plastitanium/tough
	name = "plastitanium window spawner"
	icon_state = "plastitaniumwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/plastitanium/tough)

/obj/effect/spawner/structure/window/plastitanium/station_to_space
	name = "plastitanium window spawner"
	icon_state = "plastitaniumwindow_spawner"
	spawn_list = list(/obj/machinery/door/firedoor/window, /obj/structure/grille, /obj/structure/window/plastitanium/tough)

/obj/structure/window/plastitanium/tough
	max_integrity = 400

/obj/structure/sign/poster/contraband/mime
	name = "Mime"
	desc = "Some kind of modern art piece."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "poster_mime"

//dried bread machine
/obj/machinery/vending/snack/dried_bread
	name = "\improper sustenance vendor"
	desc = null
	product_slogans = null
	product_ads = null
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/breadslice/dried = 15)
	contraband = list()
	refill_canister = /obj/item/vending_refill/snack/dried_bread
	default_price = 10
	extra_price = 20
	spawn_on_random = 0
	var/list/L = list()

/obj/item/vending_refill/snack/dried_bread
	machine_name = "\improper sustenance vendor"

//getting a list of an entire telecomms network of machines. I couldnt find anything like this already existing.
/obj/machinery/telecomms/proc/get_entire_network()
	. = list()
	if(!network)
		return
	. += src
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		if(T.network != network)
			continue
		for(var/obj/machinery/telecomms/T2 in T.links)
			if(T.network != network)
				continue
			if((T2 in .) && !(T in .))
				. += T
				break

//unanchored objects for mapping and supply packs
/obj/machinery/processor/unanchored
	anchored = 0

/obj/machinery/microwave/unanchored
	anchored = 0

/obj/machinery/reagentgrinder/unanchored
	anchored = 0

/obj/machinery/hydroponics/constructable/unanchored
	anchored = 0

//return of circuit lab
/area/science/circuit
	name = "Circuitry Lab"
	icon_state = "cir_lab"

//a better way to handle how animals attack mechs and stuff
/atom/proc/will_mob_attack(mob/attacker)
	return FALSE

/obj/mecha/will_mob_attack(mob/living/simple_animal/attacker)
	if(occupant && attacker.CanAttack(occupant))//Just so we don't attack empty mechs
		return occupant
	return ..()


//aoe light switch. A light switch that does not rely on area but instead scans out the room to find its lights.
/obj/machinery/light_switch/aoe
	var/view_range = 7
	var/turf/affected_turfs = list()
	var/on_state = 1

/obj/machinery/light_switch/aoe/Initialize()
	. = ..()
	update_lights()

/obj/machinery/light_switch/aoe/toggle_lights()
	on_state = !on_state
	update_lights()

/obj/machinery/light_switch/aoe/proc/update_lights()
	for(var/obj/O in view(view_range,src))
		if(O == src)
			continue
		if(istype(O,/obj/machinery/light) && object_in_los(O))
			var/obj/machinery/light/L = O
			L.switched_off_seperately = !on_state
			L.seton(on_state)
		if(istype(O,/obj/machinery/light_switch/aoe) && object_in_los(O))
			var/obj/machinery/light_switch/aoe/A = O
			A.on_state = on_state
			A.update_icon()
	update_icon()

/obj/machinery/light_switch/aoe/proc/object_in_los(atom/movable/AM)
	var/turf/current = loc
	var/turf/destination = AM.loc
	var/timeout = view_range*2
	while(current != destination && timeout > 0)
		timeout--
		var/failure = 0
		if(current.density)
			failure = 1
		if(!failure)
			for(var/atom/movable/movable in current)
				if(movable.opacity)
					failure = 1
					break
		if(failure)
			break
		current = get_step(current,get_dir(current,destination))
		if(timeout <= 0)
			break
	if(current == destination)
		return TRUE
	return FALSE

/obj/machinery/light_switch/aoe/examine(mob/user)
	. = ..()
	. -= "It is [area.lightswitch ? "on" : "off"]."
	. += "It is [on_state ? "on" : "off"]."

/obj/machinery/light_switch/aoe/update_icon()
	if(stat & NOPOWER)
		icon_state = "light-p"
	else
		if(on_state)
			icon_state = "light1"
		else
			icon_state = "light0"

		//wide display screen
/obj/machinery/status_display/wide
	icon = 'icons/oldschool/toolbox64x32.dmi'
	icon_state = "display_frame"
	maptext_width = 64
	chars_per_line = 14
	separator = "  "