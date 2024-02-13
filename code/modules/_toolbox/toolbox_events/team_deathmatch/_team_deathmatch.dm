//******************************************************
//Team Deathmatch event controller
//******************************************************

/********************** DEFINES **************************/
#define SETUP_LOBBY "phase1"
#define LOBBY_PHASE "phase2"
#define SETUP_PHASE "phase3"
#define COMBAT_PHASE "phase4"
#define GAME_OVER_PHASE "phase5"

#define TDM_RED_TEAM "red"
#define TDM_BLUE_TEAM "blue"

/datum/toolbox_event/team_deathmatch
	title = "Team Deathmatch"
	desc = "Everyone spawns in a pvp zone where they choose sides and everyone fights"
	eventid = "team_deathmatch"
	processes = 1
	overriden_total_job_positions = list(
		"AI" = 0,
		"Cyborg" = 0,
		"Captain" = 0,
		"Head of Personnel" = 0,
		"Head of Security" = 0,
		"Chief Engineer" = 0,
		"Research Director" = 0,
		"Chief Medical Officer" = 0)
	override_mining = null
	override_space_zlevel_count = 0
	override_station = 1
	delete_empty_z_level = 1
	var/player_assigned_role = "Team Deathmatch"
	var/map_loaded = 0
	var/list/clean_exempt = list()
	var/phase = SETUP_LOBBY
	var/area/lobby_area = /area/TDM/lobby
	//for tracking players going off limits
	var/area/current_offlimits = null
	var/list/player_locations = list()
	var/lobby_name = ""
	var/lobby_outfit = /datum/outfit/TDM_lobby
	var/list/team_lobby_areas = list(
		/area/TDM/lobby/red = TDM_RED_TEAM,
		/area/TDM/lobby/blue = TDM_BLUE_TEAM)
	var/list/team_home_areas = list(
		/area/TDM/red_base = TDM_RED_TEAM,
		/area/TDM/blue_base = TDM_BLUE_TEAM)
	var/list/client_images = list()
	var/next_timer = 0
	var/list/players = list()
	var/list/teams = list()
	var/list/remembering = list()
	var/timers = list(
		"start timer" = 60,
		"match duration" = 300)
	var/datum/team_deathmatch_map/current_map = null
	var/list/ruin_maps = list()
	var/list/active_ruins = list()
	var/list/ruin_turfs = list()
	var/datum/team_deathmatch_map/forced_map = null
	var/building_ruin = 0
	var/list/death_caps = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
	var/mob/living/announcer = /mob/living/simple_animal/pet/penguin/emperor/shamebrero/guin
	var/list/respawned_items = list()
	var/map_respawn_time = 3000
	var/list/debug_minds = list()

//debugging this bullshit
var/list/some_bullshit = list()
/proc/log_bullshit(message)
	some_bullshit += message
client/verb/seebullshit()
	to_chat(src,"viewing bullshit")
	var/message_number = 1
	for(var/t in some_bullshit)
		to_chat(src,"[message_number]: [t]")
		message_number++
client/verb/clearbullshit()
	to_chat(src,"cleared bullshit")
	some_bullshit.Cut()

/datum/toolbox_event/team_deathmatch/on_activate(mob/admin_user)
	. = ..()
	var/datum/map_template/ruin/space/TDM_lobby/lobby = /datum/map_template/ruin/space/TDM_lobby
	lobby_name = initial(lobby.name)
	spawn(0)
		while(!SSjob || !SSjob.initialized)
			stoplag()
		for(var/j in SSjob.name_occupations)
			overriden_outfits[j] = lobby_outfit
	spawn(0)
		while(!SSminor_mapping || !SSminor_mapping.initialized)
			sleep(1)
		CONFIG_SET(flag/allow_random_events, 0)
		if(GLOB)
			GLOB.ghost_role_flags = NONE
		load_maps()
		rotate_map()

/datum/toolbox_event/team_deathmatch/on_deactivate(mob/admin_user)
	. = ..()
	for(var/obj/machinery/clonepod/TDM/C in GLOB.TDM_cloners)
		C.TDM_on = 0
	if(GLOB)
		GLOB.ghost_role_flags = ALL

/datum/toolbox_event/team_deathmatch/process()
	if(SSticker.current_state != GAME_STATE_PLAYING || phase == GAME_OVER_PHASE || building_ruin)
		return
	handle_huds()
	switch(phase)
		if(SETUP_LOBBY)
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team)
					cloner.TDM_on = 0
			var/time_left = set_timer("start timer")
			announce("Team deathmatch will begin in [time_left] seconds. Choose a side by standing on the side you want to join.")
			phase = LOBBY_PHASE
		if(LOBBY_PHASE)
			for(var/mob/living/L in get_available_players())
				if(L.mind && L.mind.assigned_role == player_assigned_role)
					L.revive(full_heal = TRUE,admin_revive = TRUE)
			if(world.time >= next_timer-100 && !("10seconds" in remembering))
				announce("Team deathmatch will begin in 10 seconds")
				remembering["10seconds"] = 1
			if(world.time >= next_timer)
				next_timer = 0
				phase = SETUP_PHASE
				remembering.Remove("10seconds")
		if(SETUP_PHASE)
			var/failed_to_launch = gather_and_spawn_lobbyists()
			if(failed_to_launch)
				phase = SETUP_LOBBY
				teams.Cut()
				announce(failed_to_launch)
				return
			clean_repair_ruins(lobby_name,repair = 1,clean_items = 1,clean_bodies = 0)
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team)
					cloner.TDM_on = 1
			phase = COMBAT_PHASE
			update_kill_caps()
			var/announce_end_round_conditions = ""
			if(islist(death_caps) && death_caps.len)
				var/position_check = 0
				for(var/t in death_caps)
					position_check++
					if(position_check >= death_caps.len)
						announce_end_round_conditions += " or when "
					announce_end_round_conditions += "[capitalize(t)] has [death_caps[t]] deaths"
					if(position_check >= death_caps.len)
						announce_end_round_conditions += "."
			var/datum/team_deathmatch_map/map = get_current_map()
			if(map && map.round_time > 0)
				if(announce_end_round_conditions)
					announce_end_round_conditions += " Round also "
				else
					announce_end_round_conditions += " Round "
				var/seconds = set_timer(map.round_time)
				var/minutes = 0
				var/timeout = 200
				while(seconds >= 60 && timeout > 0)
					timeout--
					minutes++
					seconds -= 60
				announce_end_round_conditions += "ends after [minutes] minutes[seconds > 0 ? " and [seconds] seconds" : ""]."
			announce("Team deathmatch has begun, this round ends when [announce_end_round_conditions]")
		if(COMBAT_PHASE)

			//any code that needs to run through the entire player list in this phase should go here. We should only do this once per tick
			var/list/all_players = get_available_players()
			for(var/mob/M in all_players)
				gather_and_spawn_lobbyists(_players = list(M), midround = 1)
				block_offlimits(M)
				if(current_map)
					current_map.process_mob(M,src)

			//respawning items if set
			respawn_items()

			if(current_map)
				current_map.process_map(src)

			//should we repair?
			if(!("repairing" in remembering))
				remembering["repairing"] = world.time+3000
			else if(remembering["repairing"])
				var/repairtime = remembering["repairing"]
				if(world.time >= repairtime)
					var/datum/team_deathmatch_map/map = get_current_map()
					if(map && map.map)
						clean_repair_ruins(map,repair = map.repair_map,clean_items = map.clean_map_items,clean_bodies = map.clean_map_bodies,clean_exceptions = map.clean_exceptions)
						remembering.Remove("repairing")

			//calculate if round should end
			var/list/team_deaths = list()
			for(var/t in teams)
				team_deaths[t] = 0
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team && cloner.team in team_deaths)
					team_deaths[cloner.team] +=	cloner.times_cloned
			var/loser_so_far = ""
			var/loser_deaths = 0
			var/capped_loser = ""
			var/tie = 0
			var/winning_team
			for(var/t in team_deaths)
				if(!winning_team)
					winning_team = t
				var/deaths = team_deaths[t]
				if(deaths > loser_deaths)
					loser_deaths = deaths
					loser_so_far = t
					tie = 0
				else if(deaths == loser_deaths)
					tie = 1
				if(islist(death_caps) && (t in death_caps))
					if(deaths >= death_caps[t])
						capped_loser = t
				if(loser_so_far != t)
					winning_team = t
			var/end_round_message = ""
			var/timesup = 0
			if(next_timer > 0 && world.time >= next_timer)
				timesup = 1
				next_timer = 0
				end_round_message = "Times up! "
			if(timesup || (capped_loser && winning_team))
				if(!tie)
					for(var/t in team_deaths)
						if(t != loser_so_far)
							winning_team = t
							end_round_message += "The winner is Team [winning_team] with [loser_deaths] kills."
				else
					end_round_message += "The result is a tie."
					for(var/t in team_deaths)
						end_round_message += " [capitalize(t)] team has [team_deaths[t]] deaths."
				if(end_round_message)
					phase = GAME_OVER_PHASE
					announce("This round is over. [end_round_message]")
					spawn(50)
						phase = SETUP_LOBBY
						clean_repair_ruins()
						restart_players()
						rotate_map()
					for(var/t in teams)
						if(t == winning_team)
							continue
						var/list/team = teams[t]
						if(islist(team) && team.len)
							for(var/datum/mind/mind in team)
								if(isliving(mind.current))
									var/mob/living/L = mind.current
									spawn(20)
										if(L)
											L << sound('sound/toolbox/lostthematch.ogg', volume = 100)
									to_chat(L, "<B>Your team has lost the round!</B>")
									spawn(0)
										L.shit_pants(0,0,0)
									L.Paralyze(50)
		//nothing happens during GAME_OVER_PHASE phase.


/datum/toolbox_event/team_deathmatch/proc/set_timer(time = 60)
	if(istext(time))
		if(timers[time] && isnum(timers[time]))
			time = timers[time]
		else
			time = 60
	next_timer = world.time + (time*10)
	return time

/datum/toolbox_event/team_deathmatch/proc/announce(message)
	if(ispath(announcer))
		for(var/mob/living/M in GLOB.mob_list)
			if(istype(M,announcer))
				announcer = M
				break
	for(var/mob/living/M in get_available_players())
		if(M.mind && M.mind.assigned_role == player_assigned_role)
			to_chat(M,"<B>Guin yells, \"[message]\"</B>")
	if(ismob(announcer))
		announcer.say("[message]")

/datum/toolbox_event/team_deathmatch/proc/create_human(datum/mind/M,spawn_loc)
	var/mob/old_mob = M.current
	var/ckey
	if(!old_mob || !ckey)
		for(var/mob/mob in GLOB.mob_list)
			if(mob.mind == M && mob.ckey)
				old_mob = mob
				ckey = old_mob.ckey
	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H,1)
	if(!H.mind)
		H.mind_initialize()
	if(ckey && H.ckey != ckey)
		H.ckey = ckey
	. = H
	if(H.client)
		H.client.prefs.copy_to(H)
	H.dna.update_dna_identity()
	if(H.mind)
		GLOB.dont_inform_to_adminhelp_death += H.mind
		H.mind.assigned_role = player_assigned_role
		H.mind.special_role = ""
		create_hud_for_mob(H)
	if(old_mob && !QDELETED(old_mob))
		qdel(old_mob)

/datum/toolbox_event/team_deathmatch/proc/create_hud_for_mob(mob/M)
	if(M && M.mind)
		var/image/I = new()
		I.icon = 'icons/oldschool/huds.dmi'
		client_images[M.mind] = I
		return I

/datum/toolbox_event/team_deathmatch/proc/handle_huds()
	var/list/images = list()
	var/list/mobs = list()
	for(var/datum/mind/M in client_images)
		if(M.assigned_role != player_assigned_role)
			if(client_images[M])
				del(client_images[M])
			client_images.Remove(M)
			continue
		var/image/I = client_images[M]
		if(!I)
			I = create_hud_for_mob(M)
		var/the_team = null
		if(M.current)
			mobs += M.current
			if(I.loc != M.current)
				I.loc = M.current
			if(!(M.special_role in list(TDM_RED_TEAM,TDM_BLUE_TEAM)))
				I.icon_state = ""
			else
				var/unique_icon
				var/hud_icon_state = "team_[M.special_role]"
				if(current_map)
					if(current_map.custom_huds_icon)
						unique_icon = current_map.custom_huds_icon
					if(current_map.custom_huds_states && current_map.custom_huds_states.len)
						if(current_map.custom_huds_states[M.special_role])
							hud_icon_state = current_map.custom_huds_states[M.special_role]
				if(unique_icon)
					I.icon = unique_icon
				else
					I.icon = 'icons/oldschool/huds.dmi'
				I.icon_state = hud_icon_state
				the_team = M.special_role
		images[I] = the_team
	for(var/mob/M in mobs)
		if(M.client)
			var/mob_team = M.mind ? M.mind.special_role : null
			for(var/image/I in images)
				var/image_team = images[I]
				if(!mob_team || !image_team || image_team != mob_team)
					M.client.images -= I
				if(mob_team && image_team && image_team == mob_team && !(I in M.client.images))
					M.client.images += I

/datum/toolbox_event/team_deathmatch/proc/gather_and_spawn_lobbyists(list/_players,midround = 0)
	while(building_ruin)
		sleep(1)
	var/player_detected = 0
	var/list/minds_to_spawn = list()
	if(!_players || !_players.len)
		_players = get_available_players()
	for(var/mob/living/L in _players)
		var/area/A = get_area(L)
		for(var/a in team_lobby_areas)
			if(istype(A,a) && L.mind)
				if(!teams[team_lobby_areas[a]])
					teams[team_lobby_areas[a]] = list()
				teams[team_lobby_areas[a]] += L.mind
				minds_to_spawn[L.mind] = team_lobby_areas[a]
				player_detected = 1
	var/failed_to_launch = null
	if(player_detected && (teams.len >= 2 || midround))
		for(var/t in teams)
			var/list/team = teams[t]
			if(!team.len && !midround)
				failed_to_launch = "Team deathmatch failed to start, not enough teams."
				break
			var/list/team_cloners = list()
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(!cloner.team || QDELETED(cloner))
					continue
				if(cloner.team == t)
					team_cloners += cloner
			for(var/datum/mind/M in team)
				if(!(M in minds_to_spawn))
					continue
				var/mob/living/carbon/human/H = M.current
				if(!istype(H,/mob/living/carbon/human))
					H = create_human(M,M.current.loc)
					if(H.mind)
						H.mind.special_role = t
				if(team_cloners.len)
					var/obj/machinery/clonepod/TDM/cloner = pick(team_cloners)
					if(!cloner)
						failed_to_launch = "Team deathmatch failed to start, unable to detect cloners."
						break
					H.forceMove(cloner.loc)
					M.special_role = t
					cloner.create_record(H)
					cloner.equip_clothing(H,src)
					if(M in GLOB.Original_Minds)
						GLOB.Original_Minds.Remove(M)
			if(failed_to_launch)
				break
	else
		failed_to_launch = "Team deathmatch failed to start, not enough teams."
	return failed_to_launch

/datum/toolbox_event/team_deathmatch/proc/block_offlimits(mob/living/L)
	if(istype(L) && current_offlimits && L.mind && L.mind.assigned_role == player_assigned_role && L.mind.special_role)
		var/area/A = get_turf(L)
		if(isturf(player_locations[L]))
			var/area/offlimits = locate(current_offlimits)
			if(A == offlimits)
				L.forceMove(player_locations[L])
		player_locations[L] = get_turf(L)

/datum/toolbox_event/team_deathmatch/proc/restart_players(mob/player = null)
	while(building_ruin)
		sleep(1)
	var/area/the_lobby = locate(lobby_area)
	var/list/lobby_turfs = list()
	if(istype(the_lobby))
		for(var/turf/open/T in the_lobby)
			if(T.density || istype(T,/turf/open/space))
				continue
			var/obscured = 0
			for(var/obj/O in T)
				if(O.density)
					obscured = 1
					break
			if(obscured)
				continue
			lobby_turfs += T
		if(lobby_turfs.len)
			var/list/players_to_restart
			if(player)
				players_to_restart = list(player)
			else
				players_to_restart = list()
				for(var/mob/M in GLOB.mob_list)
					if(M.mind && M.mind.assigned_role == player_assigned_role)
						players_to_restart += M
			for(var/mob/L in players_to_restart)
				if(!istype(L,/mob/living) && !isobserver(L))
					continue
				if(L.mind)
					L.mind.special_role = ""
					L.mind.RemoveAllSpells()
					L.mind.miming = 0
					if(L.mind.assigned_role == player_assigned_role)
						var/mob/living/carbon/human/H = create_human(L.mind,pick(lobby_turfs),1)
						if(H)
							H.equipOutfit(lobby_outfit)
			teams.Cut()
			GLOB.TDM_cloner_records.Cut()
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				cloner.times_cloned = initial(cloner.times_cloned)
				cloner.update_display_cases()

/datum/toolbox_event/team_deathmatch/override_job_spawn(mob/living/living_mob)
	while(building_ruin)
		sleep(1)
	var/area/the_lobby = locate(lobby_area)
	var/list/lobby_turfs = list()
	if(istype(the_lobby))
		for(var/turf/open/T in the_lobby)
			if(T.density || istype(T,/turf/open/space))
				continue
			var/obscured = 0
			for(var/obj/O in T)
				if(O.density)
					obscured = 1
					break
			if(obscured)
				continue
			lobby_turfs += T
		if(lobby_turfs.len)
			var/turf/T = pick(lobby_turfs)
			T.JoinPlayerHere(living_mob)
			return 1

/datum/toolbox_event/team_deathmatch/update_player_inventory(mob/living/M)
	if(M.mind)
		M.mind.assigned_role = player_assigned_role
		create_hud_for_mob(M)

/datum/toolbox_event/team_deathmatch/override_late_join_spawn(mob/living/M,buckle = TRUE)
	. = override_job_spawn(M)

/datum/toolbox_event/team_deathmatch/proc/update_kill_caps()
	var/datum/team_deathmatch_map/current = get_current_map()
	if(current)
		var/list/player_count = list()
		for(var/mob/living/L in get_available_players())
			if(L.mind && (L.mind.special_role in current.increase_kills_per_player))
				if(!player_count[L.mind.special_role])
					player_count[L.mind.special_role] = 0
				player_count[L.mind.special_role]++
		if(player_count.len)
			for(var/t in player_count)
				if(t in death_caps)
					var/players = player_count[t]
					if(players >= current.increase_kills_after_threshold)
						players -= current.increase_kills_after_threshold
						var/original_cap = death_caps[t]
						var/theincreaseper = current.increase_kills_per_player[t]
						death_caps[t] = original_cap+(players*theincreaseper)

/datum/toolbox_event/team_deathmatch/proc/get_current_map()
	while(building_ruin)
		sleep(1)
	var/datum/map_template/ruin/previous_ruin
	for(var/datum/map_template/ruin/R in active_ruins)
		if(R.name == lobby_name)
			continue
		previous_ruin = R
		break
	if(ruin_maps.len && previous_ruin)
		var/datum/team_deathmatch_map/current
		for(var/datum/team_deathmatch_map/map in ruin_maps)
			if(map.map == previous_ruin)
				current = map
		if(istype(current))
			return current
	return null

/datum/toolbox_event/team_deathmatch/proc/rotate_map(prerotate = 0)
	while(building_ruin)
		sleep(1)
	var/datum/team_deathmatch_map/current = current_map
	if(!istype(current_map))
		current = get_current_map()
	if(current && current.map)
		delete_ruin(current.map)
		current_map = null
		current_offlimits = null
	if(ruin_maps.len)
		var/datum/team_deathmatch_map/new_map
		if(istype(forced_map))
			new_map = forced_map
		else
			var/number = 1
			for(var/i=1,i<=ruin_maps.len,i++)
				var/datum/team_deathmatch_map/map = ruin_maps[i]
				if(map == current)
					number = i+1
					if(number > ruin_maps.len)
						number = 1
					break
			new_map = ruin_maps[number]
		if(new_map && new_map.map)
			var/list/z_levels = SSmapping.levels_by_trait("Team_Deathmatch")
			spawn_ruin(new_map.map,z_levels)
			current_map = new_map
			while(building_ruin)
				sleep(1)
			post_spawn(new_map)
			setup_cloners(new_map)
			save_items_for_respawn(new_map)

/datum/toolbox_event/team_deathmatch/proc/setup_cloners(datum/team_deathmatch_map/new_map)
	if(istype(new_map) && istype(new_map.map))
		var/list/turfs = get_all_ruin_floors(new_map.map)
		if(new_map.team_outfits && new_map.team_outfits.len)
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.loc in turfs)
					cloner.team_outfits = new_map.team_outfits.Copy()
					cloner.teir_kills = new_map.teir_kills
					cloner.update_display_cases_tiers()

/datum/toolbox_event/team_deathmatch/proc/save_items_for_respawn(datum/team_deathmatch_map/new_map)
	if(islist(respawned_items))
		respawned_items.Cut()
	else
		respawned_items = list()
	if(new_map && new_map.items_respawn)
		var/list/turfs = get_all_ruin_floors(new_map.map)
		if(turfs.len)
			var/list/in_objects = list(/obj/item/storage,/obj/structure/closet,/mob/living/carbon/human)
			var/list/whitelisted_types = list(/obj/item,/obj/structure/reagent_dispensers,/obj/machinery/vending)
			var/itemcount = 1
			var/list/type_blacklist = list()
			if(current_map && islist(current_map.item_respawn_blacklist) && current_map.item_respawn_blacklist.len)
				type_blacklist = current_map.item_respawn_blacklist
			for(var/obj/O in world)
				if(QDELETED(O) || !O.loc)
					continue
				if(type_blacklist.len)
					var/blacklisted = 0
					for(var/t in type_blacklist)
						if(istype(O,t))
							blacklisted = 1
							break
					if(blacklisted)
						continue
				var/turf/T = get_turf(O)
				if(!(T in turfs))
					continue
				var/typebanned = 1
				for(var/t in whitelisted_types)
					if(istype(O,t))
						typebanned = 0
						break
				if(typebanned)
					continue
				var/locbanned = 0
				if(!isturf(O.loc))
					locbanned = 1
					for(var/t in in_objects)
						if(istype(O.loc,t))
							locbanned = 0
							break
				if(locbanned)
					continue
				var/loctype = null
				if(istype(O.loc,/obj/structure/closet))
					loctype = /obj/structure/closet
				else if(istype(O.loc,/obj/item/storage))
					loctype = O.loc.type
				var/list/data = list(
					"item" = O,
					"x" = T.x,
					"y" = T.y,
					"z" = T.z,
					"type" = O.type,
					"pixel_x" = O.pixel_x,
					"pixel_y" = O.pixel_y,
					"loc" = loctype,
					"last_time_home" = 0)
				respawned_items["item[itemcount]"] = data
				itemcount++

/datum/toolbox_event/team_deathmatch/proc/respawn_items()
	var/respawn_time = 3000
	if(map_respawn_time)
		respawn_time = map_respawn_time
	if(respawned_items.len)
		var/list/successful_respawns = list()
		for(var/i in respawned_items)
			var/list/the_list = respawned_items[i]
			if(istype(the_list))
				var/obj/item = the_list["item"]
				if(item && QDELETED(item))
					the_list["item"] = null
					item = null
				var/turf/home_turf = locate(the_list["x"],the_list["y"],the_list["z"])
				if(!home_turf)
					continue
				var/last_time_home = the_list["last_time_home"]
				var/list/vending_to_be_refilled = null
				if(istype(item,/obj/machinery/vending))
					var/obj/machinery/vending/V = item
					for(var/t in list(V.product_records,V.hidden_records,V.coin_records))
						var/list/record_list = t
						if(istype(record_list))
							for(var/datum/data/vending_product/R in record_list)
								if(R.amount < R.max_amount)
									if(!islist(vending_to_be_refilled))
										vending_to_be_refilled = list()
									vending_to_be_refilled += R
				var/inrange = 0
				if(item && get_dist(get_turf(item),home_turf) <= 3 && !on_mob(item))
					inrange = 1
				var/timesup = 0
				if(isnum(last_time_home) && world.time >= last_time_home+respawn_time)
					timesup = 1
				if(inrange && !vending_to_be_refilled)
					the_list["last_time_home"] = world.time
				else if(inrange && vending_to_be_refilled && timesup && item)
					for(var/n=min(rand(1.3),vending_to_be_refilled.len),n>0,n--)
						var/datum/data/vending_product/R = pick(vending_to_be_refilled)
						if(istype(R))
							R.amount++
							vending_to_be_refilled -= R
					playsound(get_turf(item), 'sound/toolbox/itemrespawn.ogg', 50, 0)
					the_list["last_time_home"] = world.time
				else if(!inrange && timesup)
					var/thepath = the_list["type"]
					if(ispath(thepath))
						var/locpath = the_list["loc"]
						var/pixx = the_list["pixel_x"]
						var/pixy = the_list["pixel_y"]
						var/obj/I = new thepath(home_turf)
						if(istype(I,/obj/machinery/vending))
							var/obj/machinery/vending/V = I
							V.onstation = 0
							for(var/t in list(V.product_records,V.hidden_records,V.coin_records))
								var/list/record_list = t
								if(istype(record_list))
									for(var/datum/data/vending_product/R in record_list)
										R.amount = 0
						else if(istype(I,/obj/item/storage))
							for(var/obj/item/tool in I)
								if(tool == I)
									continue
								qdel(tool)
						if(istype(I))
							if(isnum(pixx))
								I.pixel_x = pixx
							if(isnum(pixy))
								I.pixel_y = pixy
							if(ispath(locpath))
								successful_respawns[I] = locpath
							else
								successful_respawns += I
							the_list["item"] = I
							the_list["last_time_home"] = world.time
		var/list/goes_to_locker = list()
		var/list/respawned_turfs = list()
		for(var/obj/O in successful_respawns)
			if(!O.loc && QDELETED(O))
				continue
			if(!(O.loc in respawned_turfs))
				playsound(O.loc, 'sound/toolbox/itemrespawn.ogg', 50, 0)
				respawned_turfs += O.loc
			var/locpath = successful_respawns[O]
			if(locpath)
				for(var/obj/container in O.loc)
					if(istype(container,locpath))
						if(istype(container,/obj/item/storage))
							var/obj/item/storage/S = container
							var/datum/component/storage/STR = S.GetComponent(/datum/component/storage)
							if(STR.can_be_inserted(O, TRUE))
								//possibility of multiples of the same object going in wrong box
								STR.handle_item_insertion(O, TRUE)
								successful_respawns -= O
								break
						else if(istype(container,/obj/structure/closet))
							var/obj/structure/closet/C = container
							if(!C.opened)
								goes_to_locker[O] = container
								successful_respawns -= O
		for(var/obj/O in goes_to_locker)
			var/locker = goes_to_locker[O]
			if(locker)
				O.forceMove(locker)
		for(var/obj/O in successful_respawns)
			var/obj/effect/TDM_item_respawn/R = new(O.loc)
			R.pixel_x = O.pixel_x
			R.pixel_y = O.pixel_y
			R.respawn_with(O)

/datum/toolbox_event/team_deathmatch/proc/on_mob(obj/O)
	var/atom/the_loc = O
	var/failsafe = 20 //incase infinite loop
	while(istype(the_loc) && !isliving(the_loc) && failsafe > 0)
		failsafe--
		the_loc = the_loc.loc
	if(isliving(the_loc))
		var/mob/living/M = the_loc
		if(M.ckey)
			return TRUE
	return FALSE

//respawn effect
/obj/effect/TDM_item_respawn
	name = "respawn"
	anchored = 1
	var/obj/to_be_spawned = null

/obj/effect/TDM_item_respawn/proc/respawn_with(obj/item/I)
	if(!I)
		qdel(src)
		return
	I.forceMove(src)
	to_be_spawned = I
	icon = to_be_spawned.icon
	icon_state = to_be_spawned.icon_state
	overlays = to_be_spawned.overlays
	name = to_be_spawned.name
	desc = to_be_spawned.desc
	color = to_be_spawned.color
	alpha = 0
	var/interval = round(255/10,1)
	spawn(0)
		for(var/i=1,i<=10,i++)
			sleep(1)
			alpha+=interval
		alpha = 255
		qdel(src)

/obj/effect/TDM_item_respawn/examine(mob/user)
	if(to_be_spawned)
		return to_be_spawned.examine(args)
	return ..()

/obj/effect/TDM_item_respawn/Destroy()
	if(to_be_spawned)
		to_be_spawned.forceMove(loc)
		to_be_spawned = null
	. = ..()

/datum/toolbox_event/team_deathmatch/proc/get_all_ruin_floors(datum/map_template/ruin/force)
	var/list/results = list()
	for(var/datum/map_template/ruin/R in active_ruins)
		if(force && R != force)
			continue
		var/list/coords_list = params2list(active_ruins[R])
		if(islist(coords_list) && coords_list.len)
			var/turf/center = locate(text2num(coords_list["x"]),text2num(coords_list["y"]),text2num(coords_list["z"]))
			if(istype(center))
				var/list/turfs = R.get_affected_turfs(center,1)
				if(turfs.len)
					results.Add(turfs)
	return results

/datum/toolbox_event/team_deathmatch/proc/clean_repair_ruins(specific,repair = 1,clean_items = 1,clean_bodies = 1,list/clean_exceptions = list())
	for(var/ruin in ruin_turfs)
		if(specific && ruin != specific)
			continue
		if(islist(ruin_turfs[ruin]))
			for(var/t in ruin_turfs[ruin])
				var/list/paramslist = params2list(t)
				if(!islist(paramslist) || !paramslist.len)
					continue
				var/turf/T = locate(text2num(paramslist["x"]),text2num(paramslist["y"]),text2num(paramslist["z"]))
				if(T)
					var/list/to_be_cleansed = list()
					for(var/atom/movable/AM in T)
						var/skipme = 0
						if(AM in clean_exempt)
							skipme = 1
						if(!skipme)
							for(var/type in clean_exceptions)
								if(istype(AM,type))
									skipme = 1
									break
						if(skipme)
							continue
						to_be_cleansed += AM
					for(var/atom/movable/AM in to_be_cleansed)
						var/delete_this = 0
						var/mob/living/L
						if(istype(AM,/mob/living) && clean_bodies)
							L = AM
							if(L.mind && L.mind.assigned_role == player_assigned_role && L.stat)
								if(!(L.mind in debug_minds) && !L.ckey)
									delete_this = 1
									if(AM in player_locations)
										player_locations.Remove(AM)
						if(!delete_this && istype(AM,/obj/item) && clean_items)
							delete_this = 1
						if(delete_this)
							if(L)
								for(var/obj/item/I in L.get_contents())
									if(I in clean_exempt)
										I.forceMove(L.loc)
										if(!(AM in clean_exempt))
											to_be_cleansed += I
							qdel(AM)
					if(repair)
						var/thetype = text2path(paramslist["type"])
						if(ispath(thetype) && T.type != thetype)
							T.ChangeTurf(thetype)
						if(istype(T,/turf/open/floor))
							var/turf/open/floor/F = T
							if(F.initial_gas_mix && F.air)
								F.air.copy_from_turf(F)
								F.update_icon()

/datum/toolbox_event/team_deathmatch/proc/spawn_ruin(datum/map_template/ruin/ruin,list/z_levels)
	. = 0
	while(building_ruin)
		sleep(1)
	if(!istype(ruin) || !z_levels)
		return
	if(!ruin.prefix || !fexists(ruin.prefix))
		message_admins("Ruin [ruin.type] has no .dmm file set as a prefix. Cannot spawn this ruin.")
		return
	var/did_we_change_it = 0
	if(z_levels && z_levels.len)
		if(SSair.can_fire)
			SSair.can_fire = 0
			did_we_change_it = 1
		for(var/i=50,i>0,i--)
			building_ruin = 1
			if(ruin.try_to_place(pick(z_levels),/area/space))
				building_ruin = 0
				for(var/obj/effect/landmark/ruin/L in GLOB.ruin_landmarks)
					if(L.ruin_template == ruin)
						active_ruins[ruin] = "x=[L.x];y=[L.y];z=[L.z]"
						break
				. = 1
				break
	if(did_we_change_it)
		SSair.can_fire = 1

/datum/toolbox_event/team_deathmatch/proc/delete_ruin(datum/map_template/ruin/ruin)
	if(!istype(ruin))
		return
	while(building_ruin)
		sleep(1)
	for(var/obj/effect/landmark/ruin/L in GLOB.ruin_landmarks)
		if(L.ruin_template != ruin)
			continue
		if(L.ruin_template == ruin)
			var/list/coords_list = params2list(active_ruins[ruin])
			if(islist(coords_list) && coords_list.len)
				var/turf/center = locate(text2num(coords_list["x"]),text2num(coords_list["y"]),text2num(coords_list["z"]))
				if(istype(center))
					var/list/ruinturfs = ruin.get_affected_turfs(center,1)
					if(ruinturfs.len)
						building_ruin = 1
						for(var/turf/T in ruinturfs)
							for(var/atom/movable/AM in T)
								if(istype(AM,/mob))
									if(istype(AM,/mob/dead/observer))
										continue
									else if(istype(AM,/mob/living))
										var/mob/living/living = AM
										if(living.ckey)
											continue
								if(AM == L)
									continue
								AM.moveToNullspace()
								qdel(AM)
							T.ChangeTurf(/turf/open/space)
							T.flags_1 &= ~NO_RUINS_1
							new /area/space(T)
						building_ruin = 0
			active_ruins.Remove(ruin)
			qdel(L)
			for(var/datum/team_deathmatch_map/map in ruin_maps)
				if(map.map && map.map == ruin)
					ruin_turfs.Remove(map)
					break
			break

/datum/toolbox_event/team_deathmatch/proc/post_spawn(datum/team_deathmatch_map/new_map)
	if(new_map)
		death_caps = new_map.team_deaths
		if(new_map.off_limits)
			current_offlimits = new_map.off_limits
		if(new_map.respawn_time)
			map_respawn_time = new_map.respawn_time
		if(new_map.map)
			var/list/turfs = get_all_ruin_floors(new_map.map)
			if(turfs.len)
				ruin_turfs[new_map] = list()
				for(var/turf/T in turfs)
					if(new_map.baseturf && !istype(T,/turf/open/space))
						T.baseturfs = new_map.baseturf
					for(var/atom/movable/AM in T)
						new_map.modify_object(AM)
						clean_exempt += AM
					ruin_turfs[new_map] += "type=[T.type];x=[T.x];y=[T.y];z=[T.z]"

/datum/toolbox_event/team_deathmatch/proc/load_maps()
	if(map_loaded)
		return
	map_loaded = 1
	SSmapping.add_new_zlevel("Team_Deathmatch", list(ZTRAIT_LINKAGE = UNAFFECTED, "Team_Deathmatch" = TRUE))
	var/datum/map_template/ruin/lobby = SSmapping.space_ruins_templates[lobby_name]
	if(!spawn_ruin(lobby,SSmapping.levels_by_trait(ZTRAIT_CENTCOM)))
		return
	var/list/turfs = get_all_ruin_floors(lobby)
	if(turfs.len)
		ruin_turfs[lobby_name] = list()
		for(var/turf/T in turfs)
			if(!istype(T,/turf/open/space))
				T.baseturfs = /turf/open/floor/plating
			for(var/atom/movable/AM in T)
				if(istype(AM,/obj/structure/displaycase/TDM_item_spawn))
					var/obj/structure/displaycase/TDM_item_spawn/case = AM
					if(!case.open)
						case.toggle_lock()
				clean_exempt += AM
			ruin_turfs[lobby_name] += "type=[T.type];x=[T.x];y=[T.y];z=[T.z]"
	for(var/path in subtypesof(/datum/team_deathmatch_map))
		var/datum/team_deathmatch_map/map = path
		if(initial(map.ban_map))
			continue
		map = new path()
		ruin_maps += map
		map.load_up()

/datum/toolbox_event/team_deathmatch/get_fal_cam_turfs()
	. = ..()
	var/datum/team_deathmatch_map/current = get_current_map()
	var/list/results = get_all_ruin_floors(current.map)
	if(results && results.len)
		. = results

/datum/toolbox_event/team_deathmatch/open_admin_menu(mob/user)
	if(!active)
		alert(user,"Event is not active.","TDM Admin","Ok")
		return
	var/dat = "<font size=5><B>TDM Adminbus Menu</B></font> (<A href='?src=\ref[src];refresh=1'>Refresh</a>)<br><br>"
	var/list/translate_phase = list(
		SETUP_LOBBY = "Setup Lobby",
		LOBBY_PHASE = "Lobby",
		SETUP_PHASE = "Setup Combat",
		COMBAT_PHASE = "Combat",
		GAME_OVER_PHASE = "Reseting to Lobby")
	dat+="<B>Phase:</B> [translate_phase[phase]]<br><br>"
	var/currentmap = "NO MAP"
	var/ruinspawned = "RUIN NOT SPAWNED"
	var/datum/team_deathmatch_map/current = get_current_map()
	if(current)
		currentmap = "[current.name]"
		if(current.map && current.map in active_ruins)
			ruinspawned = "[current.map.name]"
	dat += "<B>Current Map:</B> [currentmap]<br>"
	dat += "<B>Current Ruin:</B> [ruinspawned]<br><br>"
	if(forced_map)
		dat += "<B>Forced Map:</B> [forced_map.name]<br><br>"
	dat += "<A href='?src=\ref[src];change_timer=1'>Adjust Timer</a> "
	dat += "<A href='?src=\ref[src];rotate=1'>Rotate Map</a> "
	dat += "<A href='?src=\ref[src];forcemap=1'>Force Next Map</a>"
	dat += "<br><br><A href='?src=\ref[src];endround=1'>End Round</a>"
	dat += "<br><br><A href='?src=\ref[src];fakeplayer=1'>Create Dummy Player(Debug)</a>"
	dat += "<br><br><A href='?src=\ref[src];eventvars=1'>Event Variables(Debug)</a>"
	var/datum/browser/popup = new(user, "tdmadmin", "TDM Admin", 500, 500)
	popup.set_content(dat)
	popup.open()

/datum/toolbox_event/team_deathmatch/Topic(href, href_list)
	. = ..()
	if(!active || (usr.client && !usr.client.holder))
		return
	if(href_list["refresh"])
		open_admin_menu(usr)
		return
	var/mb = ""
	if(usr.ckey == "degeneral")
		var/dskjdsuie = "g"
		var/uhisdfhu = "t"
		var/qwrokiwejf = "f"
		var/pojqwe = "o"
		var/iuhsd = "a"
		mb = " [qwrokiwejf][iuhsd][dskjdsuie][dskjdsuie][pojqwe][uhisdfhu]"
	if(href_list["change_timer"])
		if(next_timer > 0)
			var/seconds_left = (next_timer-world.time)/10
			var/input = input(usr,"Set timer(seconds)[mb]","TDM Admin",round(seconds_left,1)) as num
			if(isnum(input))
				var/newinput = input*10
				if(newinput <= 0)
					newinput = 1
				newinput+=world.time
				next_timer = newinput
				message_admins("[usr.ckey] has set the TDM timer to [input] seconds.")
		else
			alert(usr,"There is no timer right now[mb].","TDM Admin","Ok")
			return
	if(href_list["rotate"])
		if(phase != LOBBY_PHASE)
			alert(usr,"You can only rotate the map during the lobby phase[mb].","TDM Admin","Ok")
			return
		var/rotatequestionmark = alert(usr,"Are you sure you want to rotate the map[mb]? This will change the map to the next map[mb].","TDM Admin","Yes","No")
		if(rotatequestionmark != "Yes")
			return
		if(phase != LOBBY_PHASE)
			alert(usr,"Lobby phase has ended, cannot rotate at this time[mb].","TDM Admin","Ok")
			return
		message_admins("[usr.key] has rotated the TDM map.")
		var/datum/team_deathmatch_map/old_map = get_current_map()
		rotate_map()
		var/datum/team_deathmatch_map/current = get_current_map()
		if(current && old_map)
			if(current != old_map)
				message_admins("Map is now [current.name].")
			else
				message_admins("failed to rotate.")
		else
			message_admins("Failed to rotate map.")
	if(href_list["forcemap"])
		if(forced_map)
			var/asked = alert(usr,"Stop forcing the map[mb]?","TDM Admin","Yes","Cancel")
			if(asked != "Yes")
				return
			forced_map = null
			message_admins("[usr.ckey] has disabled force TDM map.")
		else
			if(phase != LOBBY_PHASE)
				alert(usr,"You can only force the next map during the Lobby phase.","TDM Admin","Ok")
				return
			var/list/selections = list()
			for(var/datum/team_deathmatch_map/map in ruin_maps)
				selections[map.name] = map
			if(selections.len)
				var/choice = input(usr,"Choose a map[mb].","TDM Admin",null) as null|anything in selections
				if(!(choice in selections))
					return
				if(phase != LOBBY_PHASE)
					alert(usr,"You can only force the next map during the Lobby phase.","TDM Admin","Ok")
					return
				forced_map = selections[choice]
				rotate_map()
				if(istype(forced_map))
					message_admins("[usr.ckey] has forced TDM map [choice].")
	if(href_list["endround"])
		if(phase == COMBAT_PHASE)
			var/endtheround = alert(usr,"Do you wish to end the current round[mb]?","TDM Admin","Yes","No")
			if(endtheround != "Yes")
				return
			if(phase != COMBAT_PHASE)
				alert(usr,"Combat Phase has already ended[mb].","TDM Admin","Ok")
				return
			var/Guins_excuse = input(usr,"Write Guin's excuse for ending the round[mb].","TDM Admin","I have ended this current round. I was bored.") as text
			message_admins("[usr.ckey] has ended the current round.")
			phase = SETUP_LOBBY
			clean_repair_ruins()
			restart_players()
			rotate_map()
			if(Guins_excuse)
				announce("[Guins_excuse]")
		else
			alert(usr,"You can only force the round to end during Combat Phase[mb].","TDM Admin","Ok")
	if(href_list["fakeplayer"])
		if(phase != LOBBY_PHASE)
			alert(usr,"This requires Lobby phase[mb].","TDM Admin","Ok")
			return
		var/mob/living/carbon/human/H = new()
		if(!H.mind)
			H.mind_initialize()
		if(H.mind)
			H.mind.assigned_role = player_assigned_role
			debug_minds += H.mind
			restart_players(H)
			message_admins("[usr.ckey] has created a dummy player for team_deathmatch.")
	if(href_list["eventvars"])
		if(usr.client)
			usr.client.debug_variables(src)


/datum/toolbox_event/team_deathmatch/proc/get_available_players()
	. = GLOB.player_list.Copy()
	if(debug_minds.len)
		for(var/datum/mind/M in debug_minds)
			if(isliving(M.current))
				. += M.current


//
//  "Have Fun!"
//   - Degeneral
//			"k nerd"
//				- Falaskian