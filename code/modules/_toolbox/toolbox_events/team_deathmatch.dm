#define SETUP_LOBBY "phase1"
#define LOBBY_PHASE "phase2"
#define SETUP_PHASE "phase3"
#define COMBAT_PHASE "phase4"
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
	var/round_startup_complete = 0
	var/list/saved_items = list()
	var/phase = SETUP_LOBBY
	var/area/lobby_area = /area/TDM/lobby
	var/lobby_outfit = /datum/outfit/TDM_lobby
	var/list/team_lobby_areas = list(
		/area/TDM/lobby/red = "red",
		/area/TDM/lobby/blue = "blue")
	var/list/team_home_areas = list(
		/area/TDM/red_base= "red",
		/area/TDM/blue_base = "blue")
	var/next_timer = 0
	var/list/players = list()
	var/list/teams = list()
	var/list/remembering = list()
	var/timers = list(
		"start timer" = 60,
		"match duration" = 300)
	var/list/active_ruins = list()
	var/list/ruin_turfs = list()
	var/death_cap = 30

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
	spawn(0)
		while(!SSjob || !SSjob.initialized)
			stoplag()
		for(var/j in SSjob.name_occupations)
			overriden_outfits[j] = lobby_outfit
	spawn(0)
		while(!SSmapping || !SSmapping.initialized)
			stoplag()
		if(round_startup_complete)
			setup_map()

/datum/toolbox_event/team_deathmatch/on_deactivate(mob/admin_user)
	. = ..()
	for(var/obj/machinery/clonepod/TDM/C in GLOB.TDM_cloners)
		C.TDM_on = 0

/datum/toolbox_event/team_deathmatch/process()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
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
					L.revive(1)
			if(world.time >= next_timer-100 && !("10seconds" in remembering))
				announce("Team deathmatch will begin in 10 seconds")
				remembering["10seconds"] = 1
			if(world.time >= next_timer)
				phase = SETUP_PHASE
				remembering.Remove("10seconds")
		if(SETUP_PHASE)
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team)
					cloner.TDM_on = 1
			var/failed_to_launch = gather_and_spawn_lobbyists()
			if(failed_to_launch)
				phase = SETUP_LOBBY
				teams.Cut()
				announce(failed_to_launch)
				return
			phase = COMBAT_PHASE
			//var/time_left = set_timer("match duration") //because fuck timers
			announce("Team deathmatch has begun, this round ends when one team reaches [death_cap] kills.")
			clean_repair_ruins()
		if(COMBAT_PHASE)
			gather_and_spawn_lobbyists(1)
			if(world.time >= next_timer-100 && !("10seconds" in remembering))
				announce("This Team deathmatch round will end in 10 seconds")
				remembering["10seconds"] = 1
			//if(world.time >= next_timer) //because fuck timers
			var/list/team_deaths = list()
			for(var/t in teams)
				team_deaths[t] = 0
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team && cloner.team in team_deaths)
					team_deaths[cloner.team] +=	cloner.times_cloned
			var/loser_so_far= ""
			var/top_deaths_so_far = 0
			var/winning_team
			for(var/t in team_deaths)
				if(!loser_so_far)
					loser_so_far = t
				if(team_deaths[t] > top_deaths_so_far)
					top_deaths_so_far = team_deaths[t]
					loser_so_far = t
			for(var/t in team_deaths)
				if(t != loser_so_far)
					winning_team = t
			if(top_deaths_so_far >= death_cap)
				announce("This round is over. The winner is Team [winning_team] with [top_deaths_so_far] kills.")
				phase = SETUP_LOBBY
				remembering.Remove("10seconds")
				clean_repair_ruins()
				restart_players()

/datum/toolbox_event/team_deathmatch/proc/set_timer(time = 60)
	if(istext(time))
		if(timers[time] && isnum(timers[time]))
			time = timers[time]
		else
			time = 60
	next_timer = world.time + (time*10)
	return time

/datum/toolbox_event/team_deathmatch/proc/announce(message)
	for(var/mob/living/M in GLOB.player_list)
		if(M.mind && M.mind.assigned_role == player_assigned_role)
			to_chat(M,"<B>[message]</B>")

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
		if(old_mob && !QDELETED(old_mob))
			qdel(old_mob)

/datum/toolbox_event/team_deathmatch/proc/gather_and_spawn_lobbyists(midround = 0)
	var/player_detected = 0
	for(var/mob/living/L in GLOB.player_list)
		var/area/A = get_area(L)
		for(var/a in team_lobby_areas)
			if(istype(A,a) && L.mind)
				if(!teams[team_lobby_areas[a]])
					teams[team_lobby_areas[a]] = list()
				teams[team_lobby_areas[a]] += L.mind
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
				if(!cloner.team)
					continue
				if(cloner.team == t)
					team_cloners += cloner
			for(var/datum/mind/M in team)
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
				players_to_restart = GLOB.player_list
			for(var/mob/L in players_to_restart)
				if(!istype(L,/mob/living) && !isobserver(L))
					continue
				if(L.mind && L.mind.assigned_role == player_assigned_role)
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
		while(!team_death_match_chambers_spawned)
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

/datum/toolbox_event/team_deathmatch/override_late_join_spawn(mob/living/M,buckle = TRUE)
	. = override_job_spawn(M)

/datum/toolbox_event/team_deathmatch/PostRoundSetup()
	round_startup_complete = 1
	setup_map()

/datum/toolbox_event/team_deathmatch/proc/setup_map()
	spawn(0)
		spawn_TDM_chambers()
	while(!team_death_match_chambers_spawned)
		sleep(1)
	save_ruin_data()
	for(var/obj/machinery/clonepod/TDM/cloner in world)
		if(!(cloner in GLOB.TDM_cloners) && cloner.team)
			GLOB.TDM_cloners += cloner
	var/area/A = locate(lobby_area)
	if(A)
		for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
			if(!case.open)
				case.toggle_lock()

/datum/toolbox_event/team_deathmatch/proc/get_all_ruin_floors()
	var/list/results = list()
	for(var/datum/map_template/ruin/R in active_ruins)
		var/list/coords_list = params2list(active_ruins[R])
		if(islist(coords_list) && coords_list.len)
			var/turf/center = locate(text2num(coords_list["x"]),text2num(coords_list["y"]),text2num(coords_list["z"]))
			if(istype(center))
				var/list/turfs = R.get_affected_turfs(center,1)
				if(turfs.len)
					results.Add(turfs)
	return results

/datum/toolbox_event/team_deathmatch/proc/save_ruin_data()
	var/list/turfs = get_all_ruin_floors()
	if(turfs.len)
		for(var/turf/T in turfs)
			for(var/obj/item/I in T)
				saved_items += I
			ruin_turfs["x=[T.x];y=[T.y];z=[T.z]"] = T.type

/datum/toolbox_event/team_deathmatch/proc/clean_repair_ruins()
	for(var/t in ruin_turfs)
		var/list/paramslist = params2list(t)
		if(!islist(paramslist) || !paramslist.len)
			continue
		var/turf/T = locate(text2num(paramslist["x"]),text2num(paramslist["y"]),text2num(paramslist["z"]))
		if(T)
			var/thetype = ruin_turfs[t]
			if(thetype)
				if(T.type != thetype)
					T.ChangeTurf(thetype)
			for(var/atom/movable/AM in T)
				if(AM in saved_items)
					continue
				var/delete_this = 0
				var/mob/living/L
				if(istype(AM,/mob/living))
					L = AM
					if((!L.client) && L.stat && ((!L.mind)||(L.mind && L.mind.assigned_role == player_assigned_role)))
						delete_this = 1
				if(!delete_this && istype(AM,/obj/item))
					delete_this = 1
				if(delete_this)
					if(L)
						for(var/obj/item/I in L.get_contents())
							if(I in saved_items)
								I.forceMove(L.loc)
					qdel(AM)
			if(istype(T,/turf/open/floor))
				var/turf/open/floor/F = T
				if(F.initial_gas_mix && F.air)
					F.air.copy_from_turf(F)
					F.update_icon()

