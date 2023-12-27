//event subsystem
SUBSYSTEM_DEF(toolbox_events)
	name = "Toolbox Events"
	runlevels = RUNLEVEL_GAME
	var/savepath = "data/other_saves/toolbox_events.sav"
	var/list/cached_events = list()
	init_order = INIT_ORDER_MAPPING+1
	//flags = SS_NO_FIRE

/datum/controller/subsystem/toolbox_events/Initialize(timeofday)
	. = ..()
	if(cached_events.len)
		return
	for(var/t in subtypesof(/datum/toolbox_event))
		var/datum/toolbox_event/E = new t()
		if(!E.eventid)
			continue
		cached_events[E.eventid] = E
	src.load_settings()
	for(var/t in cached_events)
		var/datum/toolbox_event/E = cached_events[t]
		if(!E)
			continue
		if(E.should_auto_activate())
			E.active = 1
		if(E.active)
			E.on_activate()

/datum/controller/subsystem/toolbox_events/proc/is_active(event)
	. = null
	if(event && istext(event))
		var/datum/toolbox_event/E = cached_events[event]
		if(E && E.active)
			. = E

/datum/controller/subsystem/toolbox_events/proc/load_settings()
	if(!fexists(savepath))
		return
	var/savefile/S = new /savefile(savepath)
	if(S)
		for(var/t in cached_events)
			var/datum/toolbox_event/E = cached_events[t]
			if(!E)
				continue
			var/thevalue = 0
			S["[E.eventid]"] >> thevalue
			if(isnum(thevalue))
				E.active = thevalue

/datum/controller/subsystem/toolbox_events/proc/save_settings()
	var/savefile/S = new /savefile(savepath)
	for(var/t in cached_events)
		var/datum/toolbox_event/E = cached_events[t]
		if(!E)
			continue
		if(isnum(E.active))
			S["[E.eventid]"] << E.active

/datum/controller/subsystem/toolbox_events/fire(resumed = 0)
	for(var/t in cached_events)
		var/datum/toolbox_event/E = cached_events[t]
		if(!E)
			continue
		if(E.active && E.processes)
			E.process()

/*
The event. Make children of this to make a new event.
*/
/datum/toolbox_event
	var/title //Title of the event. This is seen in game.
	var/desc //Description of the end.
	var/eventid = "" //This is the text id tag of the event. Used in code, must not contain spaces. Example: "clowns_vs_mimes"
	var/active = 0
	var/processes = 0
	var/list/overriden_outfits = list() //populate list like this list("Clown" = /datum/outfit/new_clown). This replaces the outfit for any job you put the title in for.
	var/list/overriden_job_titles = list() //populate list like this list("Clown" = "Fuckhead"). This replaces the name of the job with the associated entry.
	var/list/overriden_total_job_positions = list() //populate list like this list("Clown" = 50). This overrides the max jobs available of the mentioned job. Make 0 to ban the job.
	var/list/allow_job_multispawn_on_loc = list() //populate list like this list("Clown"). This allows the jobs in this list to spawn on the same tile for meme reasons. Like having 50 mime players spawn all ontop of eachother.
	var/list/block_job_position_changes = list() //populate list like this list("Clown"). This allows you to block the HOP console from modifying how many positions of a job are available.
	var/list/job_whitelist = list() //populate list like this list("Clown" = "player_ckey"). This whitelists a job for a specific player.
	var/override_priority_announce_sound //Put a link to a sound file to override the sound played when any station announcement happens.
	var/override_AI_name //text string. forces the job start AI to be named this.
	var/override_space_zlevel_count = -1 //set to 0 or higher to override how many extra space zlevels there will be. -1 means its ignored
	var/override_mining = -1 //Set as null to delete mining or another text string to change to another mining map. This must be coded in. -1 means its ignored
	var/delete_empty_z_level = 0 //The game will always add one extra totally empty z-level after finsihing generating all the z-levels. Setting to 1 prevents this.

/datum/toolbox_event/proc/on_activate(mob/admin_user) //this proc must have ..() .... Add any code to this, it will activate when the event is enabled.
	spawn(0)
		while(!SSjob || !SSjob.initialized)
			stoplag()
		for(var/datum/job/J in SSjob.occupations)
			if((J.title in overriden_total_job_positions) && isnum(overriden_total_job_positions[J.title]))
				J.spawn_positions = overriden_total_job_positions[J.title]
				J.total_positions = overriden_total_job_positions[J.title]

/datum/toolbox_event/proc/on_deactivate(mob/admin_user) //this proc must have ..() .... Add any code to this, it will activate when the event is enabled.
	spawn(0)
		while(!SSjob || !SSjob.initialized)
			stoplag()
		for(var/datum/job/J in SSjob.occupations)
			if(J.title in overriden_total_job_positions)
				J.total_positions = initial(J.total_positions)

/datum/toolbox_event/proc/should_auto_activate() //A way to check if external factors should trigger this event at server start up. Like a holiday.
	return FALSE

/datum/toolbox_event/proc/override_job_spawn(mob/living/living_mob)//if you want your event to spawn people at different location or modify their spawn location at round start code it here.
	return FALSE

/datum/toolbox_event/proc/on_login(mob/M) //This triggers when someone gains control of a mob while the event is active. will trigger every time they change mobs.

/datum/toolbox_event/proc/update_player_inventory(mob/living/M) //this is called after the player who spawns in has been equipped and has control of their mob. This only triggers once for the mob per round

/datum/toolbox_event/proc/block_new_player_cam(mob/living/M) //return true if you need the event to block the new player camera from revealing the station.
	return FALSE

/datum/toolbox_event/proc/custom_modify_job_outfit(datum/job/job,mob/living/owner) //use this to modify the job or its outfit in anyway. return null if you want to change nothing. This is different then the overriden_outfits list. This lets you change small things or whatever you need.
	return null

/datum/toolbox_event/proc/override_paycheck(datum/bank_account/account) //If you need a paycheck for players modified do it here. Must return he modified paycheck amount as num.
	return null

/datum/toolbox_event/proc/override_ai_laws(datum/ai_laws/laws) //Called after the main job spawned AI has been given its laws. This is not called on a constructed AI.
	return FALSE

/datum/toolbox_event/proc/modify_player_rank(rank,mob/dead/new_player/player) //Called when assigning a rank to a player. Use this to modify what their rank should be changed to by returning the new rank as text. The new rank title should be the title of an existing /datum/job in game.
	return null

/datum/toolbox_event/proc/override_late_join_spawn(mob/living/M,buckle = TRUE) //Use this to override how a player is spawned in after joining late. Returning true cancels the normal spawning proc.
	return FALSE

/datum/toolbox_event/proc/PostRoundSetup() //Called when the round is successfully set up and is about to switch over to round playing mode but ticker.current_state is still GAME_STATE_SETTING_UP

/datum/toolbox_event/proc/generate_event_z_levels() //This proc is called right before any extra space z-levels are generated.

/datum/admins/proc/toggle_tb_event()
	set category = "Server"
	set name = "Toggle TB Event"
	set desc = "Toggles one of toolboxes round affecting events."
	if(!SStoolbox_events)
		return
	var/list/event_list = list()
	for(var/t in SStoolbox_events.cached_events)
		var/datum/toolbox_event/E = SStoolbox_events.cached_events[t]
		event_list["[E.title] ([E.active ? "on" : "off"])"] = E.eventid
	var/which = input(usr,"Choose which event to toggle.","Toggle TB Event",null) as null|anything in event_list
	if(!SStoolbox_events)
		return
	which = event_list[which]
	if(!(which in SStoolbox_events.cached_events))
		return
	var/datum/toolbox_event/E = SStoolbox_events.cached_events[which]
	if(!E)
		return
	var/getdesc = alert(usr,"You have chosen \"[E.title]\".","Toggle TB Event","Toggle Event","Read Description")
	var/activate = 0
	switch(getdesc)
		if("Toggle Event")
			activate = 1
		if("Read Description")
			getdesc = alert(usr,"Description: [E.desc]","[E.title]","Toggle Event","Cancel")
			if(getdesc != "Toggle Event")
				return
			activate = 1
	if(activate)
		E.active = !E.active
		if(E.active)
			E.on_activate(usr)
		else
			E.on_deactivate(usr)
		message_admins("[usr.key] has toggled [E.active ? "on" : "off"] the \"[E.title]\" event. [E.active ? "This event will stay on through out all rounds until disabled." : ""]")
		log_game("[usr.key] has toggled [E.active ? "on" : "off"] the \"[E.title]\" event.")
		SStoolbox_events.save_settings()
