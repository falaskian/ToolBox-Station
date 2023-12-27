//Use this file to for things related to round start or new spawn initializations.

//for debugging purposes -falaskian
/*var/global/debug_time_check_start = 0
var/global/debug_time_check = 0
var/global/debug_check_count = 1
/proc/falaskian_debug(reset = 0)
	if(reset)
		debug_check_count = 1
		debug_time_check_start = 0
		debug_time_check = 0
	if(debug_time_check_start == 0)
		debug_time_check_start = world.timeofday
	debug_time_check = world.timeofday
	to_chat(world,"DEBUG: [debug_check_count], [(debug_time_check-debug_time_check_start)/10] seconds.")
	debug_check_count++*/

//old school pipe icons
/datum/config_entry/flag/old_school_vents
/datum/config_entry/flag/black_computers
/datum/config_entry/flag/self_surgery

proc/Initialize_Falaskians_Shit()
	//initialize_discord_channel_list()
	initialize_toolbox_features()
	SaveStation()
	load_chaos_assistant_chance()
	GLOB.reinforced_glass_recipes += new/datum/stack_recipe("reinforced delivery window", /obj/structure/window/reinforced/fulltile/delivery/unanchored, 5, time = 0, on_floor = TRUE, window_checks = TRUE)
	GLOB.metal_recipes += new/datum/stack_recipe("desk bell", /obj/structure/desk_bell, 2, time = 30, on_floor = TRUE)
	new_player_cam = new()
	world.update_status()

/atom/movable/screen/toolboxlogo
	name = "Toolbox Station"
	icon = 'icons/oldschool/toolboxlogo.dmi'
	icon_state = ""
	screen_loc = "south:16,east-5:10"
	mouse_opacity = 0
	layer = 20
	plane = 100

/atom/movable/screen/toolboxlogo/New()
	alpha = round(255*0.7,1)
	. = ..()

/*/datum/config_entry/string/discordurl*/

/*/client/verb/discord()
	set name = "discord"
	set desc = "Join the discord."
	set hidden = 1
	var/discordurl = CONFIG_GET(string/discordurl)
	if (discordurl)
		if(alert("This will open the discord invitation in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(discordurl)
	else
		src << sound('sound/items/bikehorn.ogg')
		to_chat(src, "<span class='danger'>The discord URL is not set in the server configuration.</span>")*/

/datum/config_entry/flag/show_round_time_on_hub
GLOBAL_LIST_EMPTY(hub_features)
/world/proc/update_status_toolbox()
	var/theservername = CONFIG_GET(string/servername)
	if (!theservername)
		theservername = "Space Station 13"
	var/dat = "<b>[theservername]</B> "
	var/theforumurl = CONFIG_GET(string/forumurl)
	var/thediscordlink = CONFIG_GET(string/discordurl)
	if(theforumurl || thediscordlink)
		dat += "("
		if(theforumurl)
			dat += "<a href=\"[theforumurl]\">Forums</a>"
		if(theforumurl && thediscordlink)
			dat += "|"
		if(thediscordlink)
			dat += "<a href=\"[thediscordlink]\">Discord</a>"
		dat += ")<br>"
	if(SSmapping && SSmapping.config && SSmapping.config.map_name)
		dat += "Map: [SSmapping.config.map_name]"
	if(SSticker)
		if(SSticker.current_state < GAME_STATE_PLAYING)
			dat += "<br>New Round Starting."
		else if (SSticker.current_state > GAME_STATE_PLAYING)
			dat += "<br>New round soon."
		else if(CONFIG_GET(flag/show_round_time_on_hub))
			var/worldtime = max(world.time-SSticker.round_start_time,0)
			var/hours = 0
			var/minutes = 0
			var/timeout = 24
			while(worldtime >= 36000 && timeout > 0)
				timeout--
				hours++
				worldtime -= 36000
			timeout = 59
			while(worldtime >= 600 && timeout > 0)
				timeout--
				minutes++
				worldtime -= 600
			if(minutes >= 300)
				minutes++
			if(length("[minutes]") < 2)
				minutes = "0[minutes]"
			dat += "<br>Round Time: [hours]:[minutes]"
	else
		dat += "<br>Restarting."
	if(GLOB)
		if(!GLOB.hub_features.len)
			GLOB.hub_features = file2list("config/hub_features.txt")
		if(GLOB.hub_features.len)
			dat += "<br>"
			var/linecount = 1
			for(var/line in GLOB.hub_features)
				dat += "[line]"
				if(linecount < GLOB.hub_features.len)
					dat += "<br>"
				linecount++
	world.status = dat

//modifying a player after hes equipped when spawning in as crew member.
/datum/outfit
	var/ignore_special_events = 0
/datum/outfit/proc/update_toolbox_inventory(mob/living/carbon/human/H)
	var/themonth = text2num(time2text(world.timeofday,"MM"))
	var/theday = text2num(time2text(world.timeofday,"DD"))
	//var/theyear = text2num(time2text(world.timeofday,"YYYY"))
	if(!istype(H))
		return
	if(!H.wear_mask && H.ckey == "landrydragon")
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H),SLOT_WEAR_MASK)
	if(H.ckey == "iksxde")
		H.equip_to_slot_or_del(new /obj/item/bughunter(H), SLOT_IN_BACKPACK)
	if(H.ckey == "nibberfa0t1337")
		H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/condiment/saltshaker(H), SLOT_IN_BACKPACK)
	if(H.ckey == "silas4000")
		var/obj/item/toy/plush/carpplushie/C = new()
		C.name = "Gift of Carp-Sie"
		C.desc = "I shall return some day."
		H.equip_to_slot_or_del(C, SLOT_IN_BACKPACK)
		if(H.mind && H.mind.assigned_role == "Chaplain")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/carp_costume(H), SLOT_IN_BACKPACK)
	if(H.ckey == "luckyrichard")
		H.equip_to_slot_or_del(new /obj/item/book/manual/autismchild(H), SLOT_IN_BACKPACK)
	if(H.ckey == "cran")
		H.equip_to_slot_or_del(new /obj/item/toy/plush/slimeplushie, SLOT_IN_BACKPACK)
	//st patricks day
	if(themonth == 3 && theday == 17 && !ignore_special_events)
		if(H.w_uniform)
			H.w_uniform.name = "Green [H.w_uniform.name]"
			H.w_uniform.icon_state = "green"
			H.w_uniform.item_state = "g_suit"
			H.w_uniform.item_color = "green"
			H.regenerate_icons()
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/E = SStoolbox_events.cached_events[t]
			if(E && E.active)
				E.update_player_inventory(H)

/client
	var/list/shared_ips = list()
	var/list/shared_ids = list()

//giving detective back his telescopic baton
/datum/outfit/job/detective/New()
	backpack_contents.Remove(/obj/item/melee/classic_baton/police)
	backpack_contents[/obj/item/melee/classic_baton/police/telescopic] = 1
	. = ..()

/datum/outfit/job/warden/New()
	suit_store = /obj/item/gun/energy/laser/scatter/shotty
	. = ..()

/obj/structure/closet/secure_closet/warden/PopulateContents()
	. = ..()
	for(var/obj/item/gun/ballistic/shotgun/automatic/combat/compact/C in src)
		qdel(C)

/proc/generate_plasmaman_name()
	var/list/elements = list("Helium", "Lithium", "Beryllium", "Sodium", "Magnesium", "Aluminum", "Potassium",\
		"Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Gallium", "Germanium", "Selenium", "Rubidium", "Strontium",\
		"Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Cadmium", "Indium",\
		"Tellurium", "Cesium", "Barium", "Lanthanum", "Cerium", "Praseodymium", "Neodymium", "Promethium", "Samarium", "Europium",\
		"Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium", "Hafnium", "Rhenium", "Osmium",\
		"Iridium", "Platinum", "Thallium", "Polonium", "Francium", "Radium", "Actinium", "Thorium", "Protactinium", "Uranium",\
		"Neptunium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Nobelium",\
		"Lawrencium", "Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium")
	return "[pick(elements)] \Roman[rand(1,25)]"

//machine circuitboards remembering variables from the machine.
/*/obj/machinery/proc/upload_to_circuit_memory()
	if(circuit)
		for(var/V in savable_data)
			if(V in vars)
				circuit.saved_data[V] = vars[V]

/obj/machinery/proc/download_from_circuit_memory()
	if(circuit)
		for(var/V in savable_data)
			if((V in vars) && (V in circuit.saved_data))
				vars[V] = circuit.saved_data[V]

/obj/item/circuitboard
	var/list/saved_data = list()

/obj/machinery
	var/list/savable_data = list()

/obj/machinery/computer/rdconsole
	savable_data = list("locked")*/

//*********
//Omnilathe
//*********
//Science protolathe converts to an omni lathe depending on a config entry

/datum/config_entry/number/omnilathe
/obj/machinery/rnd/production/protolathe/department/science/Initialize(roundstart)
	if(roundstart && CONFIG_GET(number/omnilathe))
		name = "protolathe"
		allowed_department_flags = ALL
		department_tag = "Unidentified"
		circuit = /obj/item/circuitboard/machine/protolathe
		//container_type = OPENCONTAINER
		requires_console = TRUE
		consoleless_interface = FALSE
	return ..()

/obj/machinery/rnd/production/techfab/department/science/Initialize(roundstart)
	if(roundstart && CONFIG_GET(number/omnilathe))
		name = "technology fabricator"
		desc = "Produces researched prototypes with raw materials and energy."
		icon_state = "protolathe"
		allowed_department_flags = ALL
		department_tag = "Unidentified"
		circuit = /obj/item/circuitboard/machine/techfab
		//container_type = OPENCONTAINER
	return ..()

/obj/machinery/rnd/production/circuit_imprinter/department/science/Initialize(roundstart)
	if(roundstart && CONFIG_GET(number/omnilathe))
		name = "circuit imprinter"
		desc = "Manufactures circuit boards for the construction of machines."
		icon_state = "circuit_imprinter"
		//container_type = OPENCONTAINER
		circuit = /obj/item/circuitboard/machine/circuit_imprinter
		requires_console = TRUE
		consoleless_interface = FALSE
		allowed_department_flags = ALL
		department_tag = "Unidentified"
	return ..()

//To ask the player to adminhelp if they are griefed
GLOBAL_LIST_EMPTY(dont_inform_to_adminhelp_death)
/client/proc/inform_to_adminhelp_death()
	var/list/this_guy = list(src,ckey)
	if(mob)
		this_guy += mob
		if(mob.mind)
			this_guy += mob.mind
	for(var/t in this_guy)
		if(t in GLOB.dont_inform_to_adminhelp_death)
			return
	spawn(30)
		var/informed = alert(src,"If you feel this death was illegitimate. Please adminhelp and an admin will investigate this death for you.","You Have Died","No thanks","Admin PM now")
		if(informed != "Admin PM now")
			return
		var/adminhelptext = input(src,"Enter admin help message.","Admin Help","I have died, is this death legit?") as text
		if(adminhelptext)
			adminhelp(adminhelptext)

//fixing the in_range() bug
/*/proc/toolbox_in_range(atom/source, atom/user)
	var/turf/sourceloc = source.loc
	var/turf/userloc = user.loc
	if(!istype(sourceloc))
		sourceloc = get_turf(source)
	if(!istype(userloc))
		userloc = get_turf(user)
	if((sourceloc.z == userloc.z) && (get_dist(sourceloc, userloc) <= 1))
		return 1
	return 0*/

//borgs can now unbuckle.
/atom/movable/attack_robot(mob/living/user)
	if(Adjacent(user) && can_buckle && has_buckled_mobs())
		return attack_hand(user)
	else
		return ..()

//give acting captain
/mob/living/carbon/human/proc/give_acting_captaincy()
	var/obj/item/card/id/id = wear_id.GetID()
	if(istype(id) && id.access)
		if(!(ACCESS_CAPTAIN in id.access))
			id.access += ACCESS_CAPTAIN
			to_chat(src,"<span class='big bold'><font color='blue'>You are the acting captain.</font><span>")
			to_chat(src,"<B>You have been given access to the Captain's Office on your ID. It is recommended that you head over to the Captain's Office and secure the Captain's personal belongings.</B>")
			for(var/mob/M in GLOB.player_list)
				if(istype(M,/mob/dead/new_player) || M == src)
					continue
				to_chat(M,"<span class='big bold'><font color='blue'>[real_name] is the acting captain!</font><span>")
				CHECK_TICK

/proc/create_acting_captain()
	var/list/chain_of_command = list(
		"Head of Personnel",
		"Head of Security",
		"Chief Engineer",
		"Research Director",
		"Chief Medical Officer")
	var/heads_found = 0
	for(var/mob/living/M in GLOB.player_list)
		if(!M.mind)
			continue
		if(M.mind && M.mind.assigned_role in chain_of_command)
			heads_found = 1
			chain_of_command[M.mind.assigned_role] = M
	if(heads_found)
		for(var/job in chain_of_command)
			if(istype(chain_of_command[job],/mob/living/carbon/human))
				var/mob/living/carbon/human/H = chain_of_command[job]
				H.give_acting_captaincy()
				return 1
	return 0

/proc/create_latejoin_acting_captain(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!SSjob || !SSticker || SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(!H.mind || !(H.mind.assigned_role in GLOB.command_positions))
		return
	var/foundexistinghead = 0
	for(var/command_position in GLOB.command_positions)
		if(command_position == H.mind.assigned_role)
			continue
		var/datum/job/j = SSjob.GetJob(command_position)
		if(!j)
			continue
		if(j.current_positions >= 1)
			foundexistinghead = 1
			break
	if(!foundexistinghead)
		H.give_acting_captaincy()

//this is so AI can track things with a hashtag in the name like mule bots. Yeah thats what its for...... -falaskian
/proc/Clean_up_hashtags(name)
	. = ""
	if(length(name))
		for(var/i=1,i<=length(name),i++)
			var/theletter = copytext(name,i,i+1)
			if(theletter != "#")
				. += theletter

//tooblox on mob login -falaskian
/client
	var/datum/mind/previous_mind
	var/previous_mob_type
/mob/proc/toolbox_on_mob_login()
	if(SStoolbox_events && SStoolbox_events.cached_events.len)
		for(var/e in SStoolbox_events.cached_events)
			var/datum/toolbox_event/E = SStoolbox_events.is_active(e)
			if(E && E.active)
				E.on_login(src)
	if(client)
		var/skip = 0
		if(!client.previous_mind)
			client.previous_mind = mind
			skip = 1
		if(!client.previous_mob_type)
			client.previous_mob_type = type
			skip = 1
		if(!skip)
			var/list/skip_types = list(
				/mob/dead/new_player,
				/mob/living/carbon/human/virtual_reality)
			if(!(type in skip_types) && !(client.previous_mob_type in skip_types))
				if(client.previous_mind != mind)
					spawn(0)
						alert(client,"You are in control of another entity. You remember nothing that happened previously up until this point.","Memories Wiped.","Ok")
			client.previous_mind = mind
			client.previous_mob_type = type

		/*if (client.prefs)
			var/datum/preferences/prefs = client.prefs
			if (!prefs.fps_asked) // Asks client if they want to try 60 fps
				prefs.fps_asked = 1
				if (prefs.clientfps < 60)
					var/response = alert(client, "We can see that your preferences are set to play at less than 60 FPS. Would you like to try 60 FPS?\nYou can change this in the future Preferences Tab -> Game Preferences -> FPS to 0 (for default).", "60 FPS Prompt - Once Only", "Yes", "No")
					if (response == "Yes")
						prefs.clientfps = 60
						client.fps = 60

				prefs.save_preferences()*/

//Mass changing area lighting the lazy way.
/area
	var/list/rgb_remake = list()

/area/New()
	. = ..()
	remake_RGB()

/area/proc/remake_RGB()
	if(islist(rgb_remake) && rgb_remake.len)
		var/R = rgb_remake[1]
		var/G = rgb_remake[2]
		var/B = rgb_remake[3]
		var/themax = max(R,G,B)
		lighting_colour_tube = rgb(R,G,B)
		lighting_colour_bulb = rgb(R == themax ? R : round(R*0.8,1),G == themax ? G : round(G*0.8,1),B == themax ? B : round(B*0.8,1))
		lighting_colour_night = rgb(R == themax ? R : round(R*0.8,1),G == themax ? G : round(G*0.8,1),B == themax ? B : round(B*0.8,1))
		for(var/obj/machinery/light/L in contents)
			if(istype(L,/obj/machinery/light/small))
				L.bulb_colour = lighting_colour_bulb
				L.light_color = lighting_colour_bulb
			else
				L.bulb_colour = lighting_colour_tube
				L.light_color = lighting_colour_tube
			L.nightshift_light_color = lighting_colour_night
			L.update_icon()

//general areas
/area/hallway
	rgb_remake = list(240, 240, 255)
/area/storage
	rgb_remake = list(138, 255, 146)
/area/storage/primary
	rgb_remake = null
/area/storage/tools
	rgb_remake = null
/area/crew_quarters
	rgb_remake = list(240, 240, 255)
/area/crew_quarters/kitchen
	rgb_remake = null //I think kitchen should remain unchanged.
/area/crew_quarters/bar
	rgb_remake = list(148, 115, 65)
/area/ai_monitored/storage/eva
	rgb_remake = list(255, 255, 255)
/area/chapel
	rgb_remake = list(148, 115, 65)
/area/library
	rgb_remake = list(148, 115, 65)
/area/hydroponics
	rgb_remake = list(192, 255, 189)
/area/shuttle
	rgb_remake = list(240, 240, 255)

//command areas
/area/bridge
	rgb_remake = list(209, 255, 248)
	lighting_brightness_tube = 6
	lighting_brightness_bulb = 5
	lighting_brightness_night = 5
/area/crew_quarters/heads
	rgb_remake = list(209, 255, 248)
/area/bridge/meeting_room
	rgb_remake = list(148, 115, 65)
	lighting_brightness_tube = 10
	lighting_brightness_bulb = 6
	lighting_brightness_night = 6
area/ai_monitored/nuke_storage
	rgb_remake = list(133, 133, 133)
/area/gateway
	rgb_remake = list(209, 255, 248)

//security areas
/area/security
	rgb_remake = list(255, 166, 166)
/area/security/prison
	rgb_remake = list(128, 68, 68)
	lighting_brightness_tube = 6 //making perma darker, Fuck their feelings.
	lighting_brightness_bulb = 5
	lighting_brightness_night = 5
/area/ai_monitored/security/armory
	rgb_remake = list(255, 166, 166)
	lighting_brightness_tube = 6 //making armory darker
	lighting_brightness_bulb = 5
	lighting_brightness_night = 5
/area/mine/laborcamp
	rgb_remake = list(255, 166, 166)

//medical areas
/area/medical
	rgb_remake = list(230, 255, 235)
/area/medical/virology
	rgb_remake = list(194, 255, 210)
/area/medical/apothecary
	rgb_remake = list(255, 230, 161)
/area/medical/surgery
	rgb_remake = list(255, 255, 255)
/area/medical/morgue
	rgb_remake = list(105, 199, 130)

//engineering areas
/area/engine
	rgb_remake = list(255, 205, 105)
/area/storage/tech
	rgb_remake = list(255, 205, 105)
	lighting_brightness_tube = 5
	lighting_brightness_bulb = 4
	lighting_brightness_night = 4
/area/engine/gravity_generator
	lighting_brightness_tube = 5
	lighting_brightness_bulb = 4
	lighting_brightness_night = 4
/area/construction
	rgb_remake = list(255, 205, 105)
/area/tcommsat/computer
	rgb_remake = list(255, 205, 105) //telecoms office has engineering color.
/area/tcommsat/server
	rgb_remake = list(0, 94, 0)
	lighting_brightness_tube = 5
	lighting_brightness_bulb = 4
	lighting_brightness_night = 4

//science areas
/area/science
	rgb_remake = list(255, 209, 254)
/area/science/xenobiology
	lighting_brightness_tube = 6
	lighting_brightness_bulb = 5
	lighting_brightness_night = 5
/area/science/server
	rgb_remake = list(0, 94, 0)
	lighting_brightness_tube = 6
	lighting_brightness_bulb = 5
	lighting_brightness_night = 5
/area/science/robotics/lab
	rgb_remake = list(255, 227, 227)

//cargo areas
/area/quartermaster
	rgb_remake = list(255, 221, 135)
/area/mine
	rgb_remake = list(255, 221, 135)

//blacklisting station room modules. Why is there a blacklist for ruins but not these rooms?
/proc/toolboxhatesthisroom(datum/map_template/random_room/R)
	. = FALSE
	if(istype(R))
		var/thefile = "[global.config.directory]/randomroomblacklist.txt"
		if(fexists(thefile))
			var/list/banned = generateMapList(thefile)
			if(banned.Find(R.mappath))
				. = TRUE

//converting hair and beards from old source to new source
/proc/convert_hairs(oldhair,list/haircheck)
	if(!(oldhair in haircheck))
		var/Oldhair = oldhair
		var/list/words = list()
		var/thespace = findtext(Oldhair," ",1,length(Oldhair)+1)
		if(thespace)
			var/timeout = 10 //dont like infinite loops
			while(thespace && timeout > 0)
				timeout--
				thespace = findtext(Oldhair," ",1,length(Oldhair)+1)
				words += copytext(Oldhair,1,thespace)
				Oldhair = copytext(Oldhair,thespace+1,length(Oldhair)+1)
		else
			words += Oldhair
		var/new_hair
		for(var/hair in haircheck)
			var/lowertext = lowertext(hair)
			var/wordcount = words.len
			for(var/w in words)
				if(!w)
					continue
				if(findtext(lowertext,lowertext(w),1,length(lowertext)+1))
					wordcount--
			if(wordcount <= 0)
				new_hair = hair
		if(new_hair)
			return new_hair
	return oldhair

//A system for toolbox developers to add new assets to the RSC file
GLOBAL_LIST_EMPTY(toolbox_assets)
client/proc/load_toolbox_assets()
	if(!GLOB.toolbox_assets.len)
		for(var/t in subtypesof(/datum/toolbox_asset))
			var/datum/toolbox_asset/asset = new t()
			GLOB.toolbox_assets += asset
	for(var/datum/toolbox_asset/asset in GLOB.toolbox_assets)
		if(islist(asset.assets) && asset.assets.len)
			for(var/thing in asset.assets)
				src << browse_rsc(file(asset.assets[thing]),thing)

/datum/toolbox_asset
	var/list/assets = list() //fill this list like this example list(mypng.png = icons/mypng.png)

//modular code initializations
/proc/initialize_toolbox_features()
	for(var/t in subtypesof(/datum/toolbox_feature))
		var/datum/toolbox_feature/T = new t()
		T.run_feature()

/datum/toolbox_feature

/datum/toolbox_feature/proc/run_feature()

//getting other accesses. This is called in access.dm, used by the airlock circuit board and rcds.
GLOBAL_LIST_INIT(toolbox_accesses_region, list())
GLOBAL_LIST_INIT(toolbox_accesses_region_name, list())
GLOBAL_LIST_INIT(toolbox_accesses_desc, list())

/proc/get_other_accesses(type,entry)
	entry = "[entry]"
	switch(type)
		if("department")
			return GLOB.toolbox_accesses_region[entry]
		if("department_name")
			return GLOB.toolbox_accesses_region_name[entry]
		if("desc")
			return GLOB.toolbox_accesses_desc[entry]