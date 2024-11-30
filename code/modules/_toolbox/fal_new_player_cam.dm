/mob/dead/new_player/proc/do_new_player_cam_shit()
	spawn(0)
		if(!new_player_cam)
			new_player_cam = new()


var/global/obj/new_player_cam/new_player_cam = null

/obj/new_player_cam
	name = "floor"
	mouse_opacity = 0
	density = 0
	anchored = 1
	alpha = 0
	invisibility = 101
	var/tiles_moved_per_shot = 20
	var/reset_shot_if_no_floors_in_this_range = 4
	var/scroll_speed = 2
	var/atom/movable/screen/thescreen
	var/list/camturfs = list()
	var/turf/previousstart
	var/atom/movable/screen/toolboxlogo/toolboxlogo
	var/list/viewers = list()

/obj/new_player_cam/Destroy()
	unlock_eyes_from_cam()
	qdel(thescreen)
	return ..()

/obj/new_player_cam/proc/lock_eyes_to_cam()
	if(SStoolbox_events)
		for(var/t in SStoolbox_events.cached_events)
			var/datum/toolbox_event/E = SStoolbox_events.is_active(t)
			if(E && E.block_new_player_cam())
				return
	for(var/mob/dead/new_player/P in GLOB.player_list)
		if(!P.client)
			continue
		if(SSticker.current_state < GAME_STATE_PREGAME)
			continue
		if(thescreen && !(thescreen in P.client.screen))
			P.client.screen += thescreen
		if(toolboxlogo && !(toolboxlogo in P.client.screen))
			P.client.screen += toolboxlogo
		if(P.client.perspective != EYE_PERSPECTIVE)
			P.client.perspective = EYE_PERSPECTIVE
		if(P.client.eye != src)
			P.client.eye = src
		if(P.see_in_dark != world.view)
			P.see_in_dark = 7
		if(P.see_invisible != 15)
			P.see_invisible = 15
		if(!(P in viewers))
			viewers += P
		P.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)

/obj/new_player_cam/proc/unlock_eyes_from_cam()
	if(!viewers.len)
		return
	for(var/m in viewers)
		var/mob/dead/new_player/P = m
		if(!istype(P))
			viewers -= P
			continue
		if(!P.client)
			continue
		if(thescreen && (thescreen in P.client.screen))
			P.client.screen -= thescreen
		if(toolboxlogo && (toolboxlogo in P.client.screen))
			P.client.screen -= toolboxlogo
		if(P.client.eye != src)
			continue
		P.client.perspective = MOB_PERSPECTIVE
		P.client.eye = P.client.mob
		P.see_in_dark = initial(P.see_in_dark)
		P.see_invisible = initial(P.see_invisible)
		P.sight = initial(P.sight)

/obj/new_player_cam/New()
	thescreen = new()
	thescreen.icon = 'icons/effects/ss13_dark_alpha6.dmi'
	thescreen.icon_state = "0"
	thescreen.screen_loc = "SOUTH,WEST to NORTH,EAST"
	thescreen.mouse_opacity = 0
	thescreen.layer = 20
	thescreen.plane = 100
	thescreen.color = "black"
	toolboxlogo = new()
	spawn(0)
		while(1)
			if(SSticker.current_state != GAME_STATE_PREGAME)
				unlock_eyes_from_cam()
				loc = null
				sleep(5)
				continue
			if(!camturfs.len)
				if(SStoolbox_events)
					for(var/t in SStoolbox_events.cached_events)
						var/datum/toolbox_event/E = SStoolbox_events.is_active(t)
						if(E && E.active)
							var/list/event_cam_turfs = E.get_fal_cam_turfs()
							if(event_cam_turfs && event_cam_turfs.len)
								camturfs = event_cam_turfs
								break
				if(!camturfs || !camturfs.len)
					for(var/turf/open/floor/T in world)
						if(!is_station_level(T.z))
							continue
						camturfs += T
			var/list/destinations = list()
			var/turf/start = pick(camturfs)
			while(get_dist(start,previousstart) < 40)
				start = pick(camturfs)
			for(var/Dir in GLOB.alldirs)
				var/spacecrossed = 0
				var/turf/current = start
				for(var/i=tiles_moved_per_shot,i>0,i--)
					var/turf/thestep = get_step(current,Dir)
					if(thestep)
						destinations["[Dir]"] = get_dist(start,thestep)
						current = thestep
						if(istype(thestep,/turf/open/space) && !thestep.contents.len)
							spacecrossed++
							if(spacecrossed >= reset_shot_if_no_floors_in_this_range)
								break
			var/finaldir
			if(destinations.len)
				var/farthest = 0
				var/list/maxdirs = list()
				for(var/Dir in destinations)
					var/thedir = text2num(Dir)
					var/thedist = destinations[Dir]
					if(!finaldir||!farthest)
						farthest = thedist
						finaldir = thedir
					if(thedist > farthest)
						farthest = thedist
						maxdirs = list()
					if(thedist >= farthest)
						maxdirs += thedir
				if(maxdirs.len)
					finaldir = pick(maxdirs)
			else
				finaldir = pick(GLOB.alldirs)
			loc = start
			lock_eyes_to_cam()
			var/alphasync = 1
			spawn(0)
				for(var/i=0,i<=6,i++)
					if(!alphasync)
						break
					thescreen.icon_state = "[i]"
					sleep(1)
				thescreen.icon_state = "6"
			sleep(scroll_speed)
			for(var/i=tiles_moved_per_shot,i>0,i--)
				if(SSticker.current_state >= GAME_STATE_PLAYING)
					qdel(src)
					return
				var/turf/newturf = get_step(loc,finaldir)
				if(newturf)
					loc = newturf
					for(var/mob/dead/new_player/P in GLOB.player_list) // Parallax Update - Killing Torcher
						if (!P || !P.client || P.client.eye != src || !P.hud_used || P.client.byond_version < 511)
							continue
						P.hud_used.update_parallax()

					sleep(scroll_speed)
				else
					sleep(scroll_speed)
					break
			alphasync = 0
			for(var/i=6,i>0,i--)
				thescreen.icon_state = "[i]"
				sleep(1)
			thescreen.icon_state = "0"
			sleep(1)

/proc/message_falaskian(message)
	if(!message)
		return
	for(var/mob/M in world)
		if(M.ckey == "falaskian")
			to_chat(M, "[message]")
			return
