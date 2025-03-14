// A special GetAllContents that doesn't search past things with rad insulation
// Components which return COMPONENT_BLOCK_RADIATION prevent further searching into that object's contents. The object itself will get returned still.
// The ignore list makes those objects never return at all
/proc/get_rad_contents(atom/location)
	var/static/list/ignored_things = typecacheof(list(
		/mob/dead,
		/mob/camera,
		/mob/living/simple_animal/revenant,
		/obj/effect,
		/obj/docking_port,
		/atom/movable/lighting_object,
		/obj/item/projectile,
		/obj/structure/chisel_message
		))
	var/list/processing_list = list(location)
	. = list()
	while(processing_list.len)
		var/atom/thing = processing_list[1]
		processing_list -= thing
		if(thing == null)
			continue
		if(ignored_things[thing.type])
			continue
		. += thing
		if((thing.rad_flags & RAD_PROTECT_CONTENTS) || (SEND_SIGNAL(thing, COMSIG_ATOM_RAD_PROBE) & COMPONENT_BLOCK_RADIATION))
			continue
		processing_list += thing.contents

/proc/radiation_pulse(atom/source, intensity, range_modifier, log=FALSE, can_contaminate=TRUE, _cosmic = 0, cancel_log = 0)
	if(!SSradiation.can_fire)
		return

	/*if(istype(get_turf(source), /turf/open/indestructible/sound/pool)) //Pools heavily block rads. Spent fuel pool!
		intensity *= 0.05*/

	if(!isnum(intensity))
		intensity = 0
	intensity = min(intensity,200000)

	var/atom/theloc = source.loc
	while(theloc)
		if(theloc.contents_radiation_multiplier >= 0)
			intensity *= theloc.contents_radiation_multiplier
		theloc = theloc.loc

	var/list/things = get_rad_contents(isturf(source) ? source : get_turf(source)) //copypasta because I don't want to put special code in waves to handle their origin
	for(var/k in 1 to things.len)
		var/atom/thing = things[k]
		if(!thing)
			continue
		thing.rad_act(intensity, _cosmic)

	if(intensity >= RAD_WAVE_MINIMUM) // Don't bother to spawn rad waves if they're just going to immediately go out
		new /datum/radiation_wave(source, intensity, range_modifier, can_contaminate, _cosmic)

		var/static/last_huge_pulse = 0
		if(intensity > 3000 && world.time > last_huge_pulse + 200)
			last_huge_pulse = world.time
			log = TRUE
		if(log && !cancel_log)
			var/turf/_source_T = isturf(source) ? source : get_turf(source)
			log_game("Radiation pulse with intensity: [intensity] and range modifier: [range_modifier] in [loc_name(_source_T)] ")

	return TRUE
