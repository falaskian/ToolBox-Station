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
	var/player_assigned_role = "Team Deathmatch"
	var/map_loaded = 0
	var/list/saved_items = list()
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
	var/list/ruin_maps = list()
	var/list/active_ruins = list()
	var/list/ruin_turfs = list()
	var/building_ruin = 0
	var/list/death_caps = list(TDM_RED_TEAM = 30,TDM_BLUE_TEAM = 30)
	var/mob/living/announcer = /mob/living/simple_animal/pet/penguin/emperor/shamebrero/guin

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
		if(GLOB)
			GLOB.ghost_role_flags = NONE
		load_maps()
		setup_map()
		rotate_map()

/datum/toolbox_event/team_deathmatch/on_deactivate(mob/admin_user)
	. = ..()
	for(var/obj/machinery/clonepod/TDM/C in GLOB.TDM_cloners)
		C.TDM_on = 0
	if(GLOB)
		GLOB.ghost_role_flags = ALL

/datum/toolbox_event/team_deathmatch/process()
	if(SSticker.current_state != GAME_STATE_PLAYING || phase == GAME_OVER_PHASE)
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
			for(var/mob/living/L in GLOB.player_list)
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
			//spawning new joiners
			gather_and_spawn_lobbyists(1)

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
	for(var/mob/living/M in GLOB.player_list)
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
	if(ckey)
		var/mob/living/carbon/human/H = new(spawn_loc)
		M.transfer_to(H,1)
		if(!H.mind)
			H.mind_initialize()
		if(H.ckey != ckey)
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
		if(M.current)
			mobs += M.current
			if(I.loc != M.current)
				I.loc = M.current
			if(!(M.special_role in list(TDM_RED_TEAM,TDM_BLUE_TEAM)))
				I.icon_state = ""
			else
				I.icon_state = "team_[M.special_role]"
		images += I
	for(var/mob/M in mobs)
		if(M.client)
			for(var/image/I in images)
				if(!(I in M.client.images))
					M.client.images += I

/datum/toolbox_event/team_deathmatch/proc/gather_and_spawn_lobbyists(midround = 0)
	while(building_ruin)
		sleep(1)
	var/player_detected = 0
	var/list/minds_to_spawn = list()
	for(var/mob/living/L in GLOB.player_list)
		var/area/A = get_area(L)

		//putting this here so were only searching the player_list once per round tick
		if(midround && current_offlimits && L.mind && L.mind.assigned_role == player_assigned_role && L.mind.special_role)
			if(isturf(player_locations[L]))
				var/area/offlimits = locate(current_offlimits)
				if(A == offlimits)
					L.forceMove(player_locations[L])
			player_locations[L] = get_turf(L)

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
					cloner.equip_clothing(H)
			if(failed_to_launch)
				break
	else
		failed_to_launch = "Team deathmatch failed to start, not enough teams."
	return failed_to_launch

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
					if(M.ckey)
						players_to_restart += M
			for(var/mob/L in players_to_restart)
				if(!istype(L,/mob/living) && !isobserver(L))
					continue
				if(L.mind)
					L.mind.special_role = ""
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
	spawn(0)
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
				if(living_mob.mind && (living_mob.mind in GLOB.Original_Minds))
					GLOB.Original_Minds.Remove(living_mob.mind)
				T.JoinPlayerHere(living_mob)
				return 1

/datum/toolbox_event/team_deathmatch/update_player_inventory(mob/living/M)
	if(M.mind)
		M.mind.assigned_role = player_assigned_role
		create_hud_for_mob(M)

/datum/toolbox_event/team_deathmatch/override_late_join_spawn(mob/living/M,buckle = TRUE)
	. = override_job_spawn(M)

/datum/toolbox_event/team_deathmatch/PostRoundSetup()
	setup_map()

/datum/toolbox_event/team_deathmatch/proc/setup_map()
	var/area/A = locate(lobby_area)
	if(A)
		for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
			if(!case.open)
				case.toggle_lock()

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

/datum/toolbox_event/team_deathmatch/proc/rotate_map()
	while(building_ruin)
		sleep(1)
	var/datum/team_deathmatch_map/current = get_current_map()
	if(current && current.map)
		delete_ruin(current.map)
		current_offlimits = null
	if(ruin_maps.len)
		var/number = 1
		for(var/i=1,i<=ruin_maps.len,i++)
			var/datum/team_deathmatch_map/map = ruin_maps[i]
			if(map == current)
				number = i+1
				if(number > ruin_maps.len)
					number = 1
				break
		var/datum/team_deathmatch_map/new_map = ruin_maps[number]
		if(new_map && new_map.map)
			var/list/z_levels = SSmapping.levels_by_trait("Team_Deathmatch")
			spawn_ruin(new_map.map,z_levels)
			post_spawn(new_map)
			setup_cloners(new_map)

/datum/toolbox_event/team_deathmatch/proc/setup_cloners(datum/team_deathmatch_map/new_map)
	if(istype(new_map) && istype(new_map.map))
		var/list/turfs = get_all_ruin_floors(new_map.map)
		if(new_map.team_outfits && new_map.team_outfits.len)
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.loc in turfs)
					cloner.team_outfits = new_map.team_outfits.Copy()
					cloner.teir_kills = new_map.teir_kills
					cloner.update_display_cases_tiers()

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
						if(AM in saved_items)
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
							if((!L.client) && L.stat && ((!L.mind)||(L.mind && L.mind.assigned_role == player_assigned_role)))
								delete_this = 1
						if(!delete_this && istype(AM,/obj/item) && clean_items)
							delete_this = 1
						if(delete_this)
							if(L)
								for(var/obj/item/I in L.get_contents())
									if(I in saved_items)
										I.forceMove(L.loc)
										if(!(AM in saved_items))
											to_be_cleansed += I
							qdel(AM)
					if(repair)
						var/thetype = text2path(paramslist[type])
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
		if(new_map.map)
			var/list/turfs = get_all_ruin_floors(new_map.map)
			if(turfs.len)
				ruin_turfs[new_map] = list()
				for(var/turf/T in turfs)
					if(new_map.baseturf && !istype(T,/turf/open/space))
						T.baseturfs = new_map.baseturf
					for(var/atom/movable/AM in T)
						new_map.modify_object(AM)
						saved_items += AM
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
				saved_items += AM
			ruin_turfs[lobby_name] += "type=[T.type];x=[T.x];y=[T.y];z=[T.z]"
	for(var/path in subtypesof(/datum/team_deathmatch_map))
		var/datum/team_deathmatch_map/map = path
		if(initial(map.ban_map))
			continue
		map = new path()
		ruin_maps += map
		map.load_up()

//
//  "Have Fun!"
//   - Degeneral
//			"k nerd"
//				- Falaskian