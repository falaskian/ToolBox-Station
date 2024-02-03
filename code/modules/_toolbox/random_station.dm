/datum/controller/subsystem/mapping
	var/list/module_templates = list()

/datum/stationmodule_group
	var/name
	var/force
	var/always
	var/station_map //Checks if the necessary map is loaded. Leave empty to always spawn regardless of map.
	var/list/possibilities = list()
	var/chosen

/datum/stationmodule_group/proc/post_load()
	return

//this proc needs to be called in mapping subsystem initialize. this has to happen before atmos and power grids are initialized
/datum/controller/subsystem/mapping/proc/randomize_station()
	log_world("Randomizing station...")
	to_chat(world, "<span class='boldannounce'>Randomizing station...</span>")
	var/station_module_save_path = "data/other_saves/preloaded_station_modules.sav"
	var/savefile/S = new(station_module_save_path)
	var/list/preloaded_modules
	if(S)
		S["preloaded_modules"] >> preloaded_modules
	if(!istype(preloaded_modules,/list))
		preloaded_modules = list()
	for (var/type in subtypesof(/datum/stationmodule_group))
		var/datum/stationmodule_group/inited = new type()
		if(inited.station_map && inited.station_map != SSmapping.config.map_name)
			continue
		var/list/picklist = inited.possibilities.Copy()

		if((!inited.always) && (!(inited.type in preloaded_modules)))
			picklist.Add("none")

		inited.chosen = pick(picklist)

		if (inited.force)
			inited.chosen = inited.force

		if (inited.chosen == "none")
			log_world("Group: [inited.name] | Picked: Default")
		else
			log_world("Group: [inited.name] | Picked: [inited.chosen]")
			var/datum/map_template/temp = module_templates[inited.chosen]
			if (isnull(temp))
				log_world("Improperly set up stationgroup (no module template): [inited.chosen]")
			else
				var/z_level = picklist[inited.chosen][3]
				if(istext(z_level))
					var/list/zlevellist = SSmapping.levels_by_trait(z_level)
					if(zlevellist.len)
						z_level = SSmapping.levels_by_trait(z_level)[1]
				if(!isnum(z_level))
					log_world("Failed to load. \"[z_level]\" is not a usable zlevel number: [inited.chosen]")
					continue
				var/loadresult = temp.load(locate(picklist[inited.chosen][1], picklist[inited.chosen][2], z_level), centered=FALSE, placeOnTop=TRUE, overWrite=TRUE)
				if(!loadresult)
					log_world("Failed to load.[!z_level ? "No z level" : ""]: [inited.chosen]")
				inited.post_load()

	log_world("Finished randomizing station")
	to_chat(world, "<span class='boldannounce'>Finished randomizing station</span>")

//killingtorcher's admin verb for loading a randomized station template
/client/proc/map_template_load_force()
	set category = "Debug"
	set name = "Map template - Place (Overwrite)"

	var/datum/map_template/template

	var/map = input(usr, "Choose a Map Template to place at your CURRENT LOCATION","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		preview += image('icons/turf/overlays.dmi',S,"greenOverlay")
	usr.client.images += preview
	if(alert(usr,"Confirm location.","Template Confirm","Yes","No") == "Yes")
		if(template.load(T, centered = TRUE, placeOnTop=TRUE, overWrite=TRUE))
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] has placed a map template ([template.name]) at [ADMIN_COORDJMP(T)]</span>")
		else
			to_chat(usr, "Failed to place map")
			usr.client.images -= preview
	else
		usr.client.images -= preview

/proc/qdel_contents(turf/T)
	if (!isturf(T))
		return

	var/list/atom/allAtoms = list()
	for (var/atom/A in T)
		recurse_qdel(A, allAtoms)

	for(var/atom/ToDel in allAtoms)
		qdel(ToDel)
		if(istype(ToDel,/atom/movable))
			var/atom/movable/AM = ToDel
			AM.loc = null

/proc/recurse_qdel(atom/A, list/L)
	for (var/atom/nextA in A.contents)
		recurse_qdel(nextA, L)
	L.Add(A)


/datum/controller/subsystem/mapping/proc/preloadModules(path = "_maps/toolbox_modules/")
	var/list/filelist = flist(path)
	for (var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		module_templates[map] = T

/*/datum/stationmodule_group/maint1
	name = "Maintenance 1"
	station_map = "Box Station"
	//force = "alt_maint1.dmm"

/datum/stationmodule_group/maint1/New()
	possibilities["alt_maint1.dmm"] = list(161,149,2)
	..()

/datum/stationmodule_group/maint2
	name = "Maintenance 2"
	station_map = "Box Station"
	//force = "alt_maint2.dmm"

/datum/stationmodule_group/maint2/New()
	possibilities["alt_maint2.dmm"] = list(53,151,2)
	..()

/datum/stationmodule_group/maint3
	name = "Maintenance 3"
	station_map = "Box Station"
	//force = "alt_maint3.dmm"

/datum/stationmodule_group/maint3/New()
	possibilities["alt_maint3.dmm"] = list(189,83,2)
	..()

/datum/stationmodule_group/maint4
	name = "Maintenance 4"
	station_map = "Box Station"
	//force = "alt_maint4.dmm"

/datum/stationmodule_group/maint4/New()
	possibilities["alt_maint4.dmm"] = list(197,81,2)
	..()

/datum/stationmodule_group/maint5
	name = "Maintenance 5"
	station_map = "Box Station"
	//force = "alt_maint5.dmm"

/datum/stationmodule_group/maint5/New()
	possibilities["alt_maint5.dmm"] = list(174,69,2)
	..()

/datum/stationmodule_group/maint_clown
	name = "Maintenance Clown"
	station_map = "Box Station"
	//force = "alt_maint_clown.dmm"

/datum/stationmodule_group/maint_clown/New()
	possibilities["alt_maint_clown.dmm"] = list(82,165,2)
	..()*/

//singulo module
/datum/stationmodule_group/box_singulo
	name = "Boxstation Singulo"
	station_map = "Box Station"
	possibilities = list("alt_engi_singularity.dmm" = list(95,52,ZTRAIT_STATION),
		"alt_engi_supermatter.dmm" = list(95,52,ZTRAIT_STATION))
	//always = 1
	//force = "alt_engi_singularity.dmm"

/datum/stationmodule_group/box_singulo/post_load()
	if(chosen == "alt_engi_singularity.dmm")
		var/z_level = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
		if(isnum(z_level))
			var/turf/T = locate(102,81,z_level)
			if(T)
				new /obj/machinery/the_singularitygen(T)
	return ..()

/datum/admins/proc/preload_station_module()
	set name = "Preload Station Module"
	set category = "Server"
	var/station_module_save_path = "data/other_saves/preloaded_station_modules.sav"
	var/savefile/S = new(station_module_save_path)
	var/list/preloaded_modules
	if(S)
		S["preloaded_modules"] >> preloaded_modules
		var/dat = "<B>Preload Station Modules</B><br>"
		for(var/t in subtypesof(/datum/stationmodule_group))
			var/datum/stationmodule_group/module = new t()
			if(!module.possibilities.len)
				continue
			dat += "<B>Module name:</B> [module.name]<br>"
			for(var/text in module.possibilities)
				dat += "<b>Map file:</b> [text]<br>"
				dat += "<b>location:</b> "
				var/list/the_coords = module.possibilities[text]
				if(istype(the_coords,/list) && the_coords.len)
					var/listnum = 1
					for(var/coord in the_coords)
						dat += "[coord]"
						if(listnum < the_coords.len)
							dat += ", "
						listnum++
				else
					dat += "No Location"
				dat += "<br>"
			dat += "<b>Status:</b> "
			if(module.type in preloaded_modules)
				dat += "<font color='red'>FORCED</font>"
			else
				dat += "<font color='blue'>Random</font>"
			dat += " <a href='?src=\ref[usr.client.holder];[HrefToken()];toggle_station_module=[module.type]'>Toggle</a><br><br>"

		usr << browse(dat,"size=500x500,window=toggle_station_modules")

/datum/controller/subsystem/mapping/proc/toggle_preloaded_station_module(pathstring)
	pathstring = text2path(pathstring)
	if(!ispath(pathstring))
		return 0
	var/station_module_save_path = "data/other_saves/preloaded_station_modules.sav"
	var/savefile/S = new(station_module_save_path)
	var/list/preloaded_modules
	if(S)
		S["preloaded_modules"] >> preloaded_modules
		if(!istype(preloaded_modules,/list))
			preloaded_modules = list()
		if(istype(preloaded_modules,/list))
			var/toggledon = 0
			if(pathstring in preloaded_modules)
				preloaded_modules -= pathstring
			else
				toggledon = 1
				preloaded_modules += pathstring
			S["preloaded_modules"] << preloaded_modules
			message_admins("[usr.key] toggled [toggledon ? "on" : "off"] the forcing of station module [pathstring] to be loaded at round start.")
			log_game("[usr.key] toggled [toggledon ? "on" : "off"] the forcing of station module [pathstring] to be loaded at round start.")
			return 1
	return 0




