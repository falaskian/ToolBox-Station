//extra roles. This is to have a datum attached to a mind that affects the user in various ways -falaskian
/datum/mind
	var/list/extra_roles = list()

/datum/extra_role
	var/datum/mind/affecting = null
	var/access = list()

/datum/extra_role/proc/activate(mob/M)
	if(M.mind)
		if(!islist(M.mind.extra_roles))
			M.mind.extra_roles = list()
		M.mind.extra_roles += src
		affecting = M.mind
		on_gain(M)
		return 1
	return 0

/datum/extra_role/proc/remove()
	if(affecting)
		var/mob/living/L = affecting.current
		if(istype(affecting.extra_roles))
			affecting.extra_roles -= src
		if(L)
			on_remove(L)
		affecting = null
		return 1
	return 0

/datum/extra_role/Destroy()
	remove()
	return ..()

/datum/extra_role/proc/on_gain(mob/user)

/datum/extra_role/proc/on_remove(mob/user)

/datum/extra_role/process()

/datum/extra_role/proc/GetAccess()
	return access

/datum/extra_role/proc/get_who_list_info()
	return ""

/datum/extra_role/proc/on_click(atom/A,params)

/datum/extra_role/proc/get_sec_hud()

/datum/extra_role/proc/on_death(gibbed)

/mob/living/carbon/AltClickOn(atom/A)
	. = ..()
	if(stat != DEAD && !restrained() && mind && istype(mind.extra_roles,/list))
		for(var/datum/extra_role/extra_role in mind.extra_roles)
			extra_role.on_click(A)

/mob/living/proc/handle_extra_roles()
	if(mind && mind.extra_roles && mind.extra_roles.len)
		for(var/datum/extra_role/E in mind.extra_roles)
			if(E.affecting == mind)
				E.process()

/mob/living/carbon/proc/give_extra_role(path)
	if(!mind || !mind.extra_roles || !ispath(path))
		return 0
	var/datum/extra_role/E = new path()
	E.activate(src)
	return E

/mob/living/carbon/proc/has_extra_role(path)
	if(!mind || !mind.extra_roles || !ispath(path))
		return 0
	for(var/datum/extra_role/R in mind.extra_roles)
		if(istype(R,path))
			return R
	return 0

/mob/living/death(gibbed)
	. = ..()
	if(mind && istype(mind.extra_roles,/list))
		for(var/datum/extra_role/extra_role in mind.extra_roles)
			extra_role.on_death(gibbed)

