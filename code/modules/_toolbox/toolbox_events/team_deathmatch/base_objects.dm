//****************Base Objects**************
//This file is for base objects important to the game mode and event

	//Clonepod Or Whatever

GLOBAL_LIST_EMPTY(TDM_cloners)
GLOBAL_LIST_EMPTY(TDM_cloner_records)
/obj/machinery/clonepod/TDM
	name = "spawn point cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	var/clone_time = 5 //seconds
	var/list/records = list()
	var/TDM_on = 0 //will behave like a normal clonepod if 0
	var/team
	var/list/click_cooldowns = list()
	var/click_cooldown = 3000
	var/times_cloned = 0
	var/list/teir_kills = list(0,3,6,15)
	var/last_go_out = null //to fix a bug that seems to be happening in the parent, it attempts to call go_out more then once.
	var/area/spawn_area = null //set as a /area type path, the spawner will send the person to this area at a random turf.
	var/list/team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/red,
		"t3" = /datum/outfit/TDM/red/t3,
		"t4" = /datum/outfit/TDM/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))
	var/datum/data/current_record = null
	var/list/last_cloned = list()
	var/rapid_death_time = 150 //how much time you must be alive for your death to count as a kill.
	var/cancel_flash = 0
	var/list/locked_to_teams = list()
	care_about_suiciding = 0

/obj/machinery/clonepod/TDM/Initialize()
	. = ..()
	if(!(src in GLOB.TDM_cloners))
		GLOB.TDM_cloners += src
	if(team)
		name = "[team] team [name]"

/obj/machinery/clonepod/TDM/Destroy()
	. = ..()
	GLOB.TDM_cloners -= src

/obj/machinery/clonepod/TDM/process()
	if(occupant && occupant.loc != src)
		occupant = null
	if(!occupant)
		for(var/mob/living/M in src)
			occupant = M
			break
	. = ..()
	if(TDM_on && team)
		if(!occupant && (team in GLOB.TDM_cloner_records))
			var/list/records_in_process = list()
			for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
				if(cloner.team != team || !cloner.current_record)
					continue
				records_in_process.Add(cloner.current_record)
			for(var/datum/data/record/R in GLOB.TDM_cloner_records[team])
				if(R in records_in_process)
					continue
				var/clonesuccess = grow_clone_from_record(src, R)
				if(clonesuccess == CLONING_SUCCESS)
					current_record = R
					break
		update_display_cases()
		update_display_screen_kills()

/obj/machinery/clonepod/TDM/attack_ghost(mob/user)
	if(!TDM_on)
		return
	if(locked_to_teams.len && locked_to_teams[user.ckey] && locked_to_teams[user.ckey] != team)
		to_chat(user,"<span class='warning'>You cannot join team [team], you are locked to a different team.</span>")
		return
	if(click_cooldowns[user.ckey] && click_cooldowns[user.ckey] > world.time)
		to_chat(user,"<span class='warning'>You cant respawn like this at this time.</span>")
		return
	var/client/C = user.client
	var/confirm = alert(user,"Do you wish to join the deathmatch battle?","Team Deathmatch","Yes","No")
	if(confirm != "Yes" || !C || !istype(C.mob,/mob/dead/observer))
		return
	if(user.ckey)
		for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
			cloner.click_cooldowns[user.ckey] = world.time+click_cooldown
			cloner.locked_to_teams[user.ckey] = team
	var/mob/living/carbon/human/H = create_human(user)
	H.ghostize(1)
	H.moveToNullspace()
	H.death()
	H.ghostize(1)
	qdel(H)
	alert(user,"You have been added to the clone queue.","Team Deathmatch","Ok")

/obj/machinery/clonepod/TDM/proc/update_display_cases()
	var/area/A = get_area(src)
	if(!A)
		return
	var/enemy_deaths = get_enemy_deaths()
	for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
		if((enemy_deaths >= case.death_count_unlock && !case.open)||(enemy_deaths < case.death_count_unlock && case.open))
			case.toggle_lock()

/obj/machinery/clonepod/TDM/proc/update_display_cases_tiers()
	var/area/A = get_area(src)
	if(!A)
		return
	for(var/obj/structure/displaycase/TDM_item_spawn/case in A)
		var/tier = 1
		for(var/t in teir_kills)
			if(tier == case.tier_level)
				case.death_count_unlock = t
				break
			tier++

/obj/machinery/clonepod/TDM/proc/update_display_screen_kills()
	var/area/A = get_area(src)
	if(!A)
		return
	var/kills = get_enemy_deaths()
	for(var/obj/machinery/status_display/screen in A)
		if(screen.message1 == "KILLS")
			screen.message2 = kills
			screen.update()

/obj/machinery/clonepod/TDM/proc/create_human(mob/M)
	var/mob/living/carbon/human/H = new()
	H.forceMove(loc)
	H.key = M.key
	if(H.client)
		H.client.prefs.copy_to(H)
	H.dna.update_dna_identity()
	var/datum/toolbox_event/team_deathmatch/TDM_event
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/team_deathmatch/E = SStoolbox_events.is_active(t)
			if(istype(E) && E.active)
				TDM_event = E
	if(H.mind)
		GLOB.dont_inform_to_adminhelp_death += H.mind
		H.mind.assigned_role = "Team Deathmatch"
		if(team)
			H.mind.special_role = team
		if(TDM_event)
			TDM_event.create_hud_for_mob(H)
	create_record(H)
	equip_clothing(H,TDM_event)
	return H

/obj/machinery/clonepod/TDM/proc/equip_clothing(mob/living/carbon/human/H,datum/toolbox_event/team_deathmatch/TDM)
	if(!istype(H))
		return
	var/chosen = get_current_tier_outfit()
	if(chosen)
		for(var/obj/O in H)
			qdel(O)
		H.equipOutfit(chosen)
		teleport_to_spawn(H)
		if(TDM && TDM.current_map)
			TDM.current_map.post_player_spawn(H,TDM)

/obj/machinery/clonepod/TDM/proc/get_current_tier_outfit()
	var/list/team_outfit = list()
	if(team && (team in team_outfits))
		team_outfit = team_outfits[team]
	var/enemy_deaths = get_enemy_deaths()
	var/teir = 0
	var/chosen = team_outfit["t[teir]"]
	for(var/t in teir_kills)
		if(enemy_deaths >= t)
			teir++
		if(team_outfit["t[teir]"])
			chosen = team_outfit["t[teir]"]
	if(chosen)
		return chosen
	return null

/obj/machinery/clonepod/TDM/proc/create_record(mob/M)
	var/mob/living/mob_occupant = get_mob_or_brainmob(M)
	var/datum/dna/dna
	var/mob/living/carbon/C = mob_occupant
	var/mob/living/brain/B = mob_occupant
	if(ishuman(mob_occupant))
		dna = C.has_dna()
	if(isbrain(mob_occupant))
		dna = B.stored_dna
	if(!istype(dna))
		return
	if(NO_DNA_COPY in dna.species.species_traits)
		return
	if(mob_occupant.suiciding || mob_occupant.hellbound)
		return
	if (isnull(mob_occupant.mind))
		return
	var/datum/data/record/R = new()
	if(dna.species)
		dna.delete_species = FALSE
		R.fields["mrace"] = dna.species
	else
		var/datum/species/rando_race = pick(GLOB.roundstart_races)
		R.fields["mrace"] = rando_race.type
	R.fields["name"] = mob_occupant.real_name
	R.fields["id"] = copytext_char(rustg_hash_string(RUSTG_HASH_MD5, mob_occupant.real_name), 2, 6)
	R.fields["UE"] = dna.unique_enzymes
	R.fields["UI"] = dna.uni_identity
	R.fields["SE"] = dna.mutation_index
	R.fields["blood_type"] = dna.blood_type
	R.fields["features"] = dna.features
	R.fields["factions"] = mob_occupant.faction
	R.fields["quirks"] = list()
	for(var/V in mob_occupant.roundstart_quirks)
		var/datum/quirk/T = V
		R.fields["quirks"][T.type] = T.clone_data()
	R.fields["traumas"] = list()
	if(ishuman(mob_occupant))
		R.fields["traumas"] = C.get_traumas()
	if(isbrain(mob_occupant))
		R.fields["traumas"] = B.get_traumas()
	R.fields["mindref"] = "[REF(mob_occupant.mind)]"
	R.fields["last_death"] = mob_occupant.stat == DEAD ? mob_occupant.mind.last_death : -1
	var/datum/data/record/old_record = find_record("mindref", REF(mob_occupant.mind), GLOB.TDM_cloner_records)
	if(!GLOB.TDM_cloner_records[team])
		GLOB.TDM_cloner_records[team] = list()
	if(old_record && team)
		GLOB.TDM_cloner_records[team] -= old_record
	GLOB.TDM_cloner_records[team] += R

/obj/machinery/clonepod/TDM/go_out(move = TRUE)
	var/mob/living/carbon/human/M = occupant
	. = ..()
	if(!occupant)
		current_record = null
	var/datum/toolbox_event/team_deathmatch/TDM_event
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/team_deathmatch/E = SStoolbox_events.is_active(t)
			if(istype(E) && E.active)
				TDM_event = E
	if(M)
		if(last_go_out != M)
			last_go_out = M
			if(istype(M))
				if(M.client)
					M.client.prefs.copy_to(M)
					M.dna.update_dna_identity()
				M.fully_heal(1)
				equip_clothing(M,TDM_event)
				if(cancel_flash)
					M.clear_fullscreen("flash")
			if(!mess)
				if(M.mind)
					var/last_time = last_cloned[M.mind]
					if(!last_time || !isnum(last_time) || world.time > last_time+rapid_death_time)
						last_cloned.Remove(M.mind)
					if(!(M.mind in last_cloned))
						times_cloned++
						last_cloned[M.mind] = world.time+rapid_death_time

/obj/machinery/clonepod/TDM/proc/teleport_to_spawn(mob/living/M)
	if(!istype(M))
		return
	var/turf/drop_off_turf
	if(ispath(spawn_area))
		for(var/area/A in world)
			if(A.type == spawn_area)
				spawn_area = A
				break
	if(istype(spawn_area))
		var/list/turfs = list()
		for(var/turf/T in spawn_area)
			if(T.density || istype(T,/turf/open/space) || istype(T,/turf/closed))
				continue
			var/obscured = 0
			for(var/obj/O in T)
				if(O.density)
					obscured = 1
					break
			if(obscured)
				continue
			turfs += T
		if(turfs.len)
			drop_off_turf = pick(turfs)
	else if(GLOB.TDM_cloner_dropoffs.len)
		var/list/dropoffs = list()
		for(var/obj/effect/landmark/TDM_cloner_transport/landmark in GLOB.TDM_cloner_dropoffs)
			if(isturf(landmark.loc) && landmark.team == team)
				dropoffs += landmark.loc
		if(dropoffs.len)
			var/turf/T = pick(dropoffs)
			if(T)
				drop_off_turf = T
	if(drop_off_turf)
		M.forceMove(drop_off_turf)
		var/list/spawns = list(M.loc,drop_off_turf)
		for(var/turf/T in spawns)
			spawn(0)
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, T)
				s.start()

/obj/machinery/clonepod/TDM/proc/get_enemy_deaths()
	. = 0
	if(!team)
		return
	for(var/obj/machinery/clonepod/TDM/cloner in GLOB.TDM_cloners)
		if(cloner == src || !cloner.team)
			continue
		if(cloner.team != team)
			. += cloner.times_cloned

/obj/machinery/clonepod/TDM/RefreshParts()	//locking these numbers, machine parts change nothing.
	. = ..()
	var/dmg_mult = CONFIG_GET(number/damage_multiplier)
	speed_coeff = ((150/clone_time)/dmg_mult)*2 //150 is what the cloner would normally set your cloneloss too upon spawning your new body.
	efficiency = 8
	fleshamnt = 0

/obj/machinery/clonepod/TDM/take_damage()
	return

/obj/machinery/clonepod/TDM/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/clonepod/TDM/ex_act(severity, target)
	return

/obj/machinery/clonepod/TDM/team_red
	team = TDM_RED_TEAM
/obj/machinery/clonepod/TDM/team_blue
	team = TDM_BLUE_TEAM

//cloner transport location
GLOBAL_LIST_EMPTY(TDM_cloner_dropoffs)
/obj/effect/landmark/TDM_cloner_transport
	name = "TDM cloner transport spot"
	var/team

/obj/effect/landmark/TDM_cloner_transport/Initialize()
	. = ..()
	GLOB.TDM_cloner_dropoffs.Add(src)

/obj/effect/landmark/TDM_cloner_transport/Destroy()
	. = ..()
	GLOB.TDM_cloner_dropoffs.Remove(src)

//clownpod
/obj/machinery/clonepod/TDM/clowner
	team = "red"
	team_outfits = list(
		TDM_RED_TEAM = list(
		"t1" = /datum/outfit/TDM/clown/red,
		"t3" = /datum/outfit/TDM/clown/red/t3,
		"t4" = /datum/outfit/TDM/clown/red/t4),
		TDM_BLUE_TEAM = list(
		"t1" = /datum/outfit/TDM/blue,
		"t3" = /datum/outfit/TDM/blue/t3,
		"t4" = /datum/outfit/TDM/blue/t4))

/obj/machinery/clonepod/TDM/clowner/Initialize()
	. = ..()
	var/thefindtext = findtext(name,"clone")
	while(thefindtext)
		name = replacetext(name,"clone","clown")
		thefindtext = findtext(name,"clone")
		if(!thefindtext)
			thefindtext = null

		//Spawn Protection

/obj/structure/TDM/spawn_protection
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	layer = 2.1
	density = 1
	CanAtmosPass = ATMOS_PASS_NO
	var/list/bump_exceptions = list(/obj/structure/TDM/spawn_protection,/obj/effect/particle_effect) //list of objects that will not bounce.
	var/team = null
	var/hasShocked = FALSE

/obj/structure/TDM/spawn_protection/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living))
		var/mob/living/L = mover
		if(team)
			if(L.mind && L.mind.assigned_role == "Team Deathmatch" && L.mind.special_role == team)
				return TRUE
	. = ..()
	if(!.)
		bump_field(mover)

/obj/structure/TDM/spawn_protection/proc/clear_shock()
	hasShocked = FALSE

/obj/structure/TDM/spawn_protection/proc/bump_field(atom/movable/AM as mob|obj)
	if(hasShocked || AM == src)
		return FALSE
	for(var/t in bump_exceptions)
		if(istype(AM,t))
			return
	hasShocked = TRUE
	if(isliving(AM) || AM.density)
		do_sparks(5, TRUE, AM.loc)
		var/atom/target = get_edge_target_turf(AM, get_dir(src, get_step_away(AM, src)))
		AM.throw_at(target, 200, 4)
	addtimer(CALLBACK(src, .proc/clear_shock), 5)

/obj/structure/TDM/spawn_protection/Move(atom/newloc, direct=0)
	var/oldloc = loc
	. = ..()
	if(oldloc && newloc != oldloc && !QDELETED(src))
		forceMove(oldloc)

/obj/structure/TDM/spawn_protection/red
	name = "red base"
	team = TDM_RED_TEAM


/obj/structure/TDM/spawn_protection/blue
	name = "blue base"
	team = TDM_BLUE_TEAM



		//Metal Doors

/obj/structure/mineral_door/iron/TDM
	name = "metal door"
	desc = "Heavy metal door. It looks very sturdy."


/obj/structure/mineral_door/iron/TDM/take_damage()
	return