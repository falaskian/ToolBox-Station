/datum/round_event_control/anomaly
	name = "Anomaly: Energetic Flux"
	typepath = /datum/round_event/anomaly

	min_players = 1
	max_occurrences = 0 //This one probably shouldn't occur! It'd work, but it wouldn't be very fun.
	weight = 15

/datum/round_event/anomaly
	var/area/impact_area
	var/obj/effect/anomaly/anomaly_path = /obj/effect/anomaly/flux
	var/turf/event_turf
	announceWhen	= 1


/datum/round_event/anomaly/proc/findEventArea()
	var/static/list/allowed_areas
	if(!allowed_areas)
		//Places that shouldn't explode
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engine,
		/area/solar,
		/area/holodeck,
		/area/shuttle)
		)

		//Subtypes from the above that actually should explode.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engine/break_room))

		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes

	return safepick(typecache_filter_list(GLOB.sortedAreas,allowed_areas))

/datum/round_event/anomaly/setup()
	var/timeout = 5
	var/fail = 0
	while(!event_turf && timeout > 0)
		impact_area = findEventArea()
		if(!impact_area)
			CRASH("No valid areas for anomaly found.") //Crash kills the procedure in the first place, no return needed.
		var/list/turf_test = get_area_turfs(impact_area)
		if(!turf_test.len)
			fail = 1
			break
		for(var/turf/T in turf_test)
			if(istype(T,/turf/open/space) || istype(T,/turf/closed) || T.density)
				turf_test -= T
		if(turf_test.len)
			event_turf = pick(turf_test)
	if(fail || timeout <= 0)
		CRASH("Anomaly : No valid turfs found for anomally event.")
		//CRASH("Anomaly : No valid turfs found for [impact_area] - [impact_area.type]")

/datum/round_event/anomaly/announce(fake)
	priority_announce("Localized energetic flux wave detected on long range scanners. Expected location of impact: [impact_area.name].", "Anomaly Alert")

/datum/round_event/anomaly/start()
	if(!event_turf)
		return
	var/newAnomaly
	if(event_turf)
		newAnomaly = new anomaly_path(event_turf)
	if (newAnomaly)
		announce_to_ghosts(newAnomaly)
