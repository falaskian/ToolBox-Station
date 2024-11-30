#define PWHITELIST_FILE "data/other_saves/pwhitelist.sav"
var/global/list/perseus_managers = list()

/datum/toolbox_feature/perseus_initializations

/datum/toolbox_feature/perseus_initializations/run_feature()
	save_perseus_manager_whitelist()
	create_perseus_access_list()
	GLOB.security_positions += "Perseus Security Enforcer"
	GLOB.security_positions += "Perseus Security Commander"

/proc/save_perseus_manager_whitelist()
	var/thefile = CONFIG_GET(string/pmgrs)
	if(findtext(thefile,".txt") && fexists(thefile))
		var/list/ckeys = tdmtext2list(file2text(file(thefile)),"\n")
		if(istype(ckeys) && ckeys.len)
			perseus_managers = ckeys
			return 1
	return 0

/proc/is_pmanager(ckey)
	if(!ckey || !istext(ckey))
		return 0
	if(istype(perseus_managers) && perseus_managers.len)
		if(ckey in perseus_managers)
			return 1
	return 0

/proc/get_pwhitelist()
	var/list/whitelist = list()
	if(PWHITELIST_FILE && findtext(PWHITELIST_FILE,".sav") && fexists(PWHITELIST_FILE))
		var/savefile/S = new/savefile(PWHITELIST_FILE)
		if(S)
			S["whitelist"] >> whitelist
	if(!istype(whitelist))
		whitelist = list()
	return whitelist

/proc/is_pwhitelisted(ckey,list/pwhitelist)
	. = 0
	if(!perseus_managers || !perseus_managers.len)
		return
	if(!pwhitelist)
		pwhitelist = get_pwhitelist()
	if(ckey && (ckey in pwhitelist))
		var/list/paramslist = params2list(pwhitelist[ckey])
		if(paramslist)
			if(paramslist["rank"] in perseusranks)
				var/ranknumber = 0
				switch(paramslist["rank"])
					if("Enforcer")
						ranknumber = 1
					if("Commander")
						ranknumber = 2
				if(paramslist["number"])
					ranknumber = "[ranknumber] [paramslist["number"]]"
				return "[ranknumber]"

/proc/save_pwhitelist(list/new_whitelist)
	if(istype(new_whitelist))
		var/savefile/S = new/savefile(PWHITELIST_FILE)
		if(S)
			S["whitelist"] << new_whitelist

/client/add_admin_verbs()
	. = ..()
	if(holder)
		if(holder.rank.rights & R_ADMIN)
			add_verb(list(/datum/admins/proc/manage_perseus))

var/global/list/perseusranks = list("Enforcer","Commander")
/datum/admins/proc/manage_perseus()
	set name = "Manage Perseus Whitelist"
	set category = "Server"
	if(!usr.ckey || !is_pmanager(usr.ckey))
		to_chat(usr, "Authorization check fail")
		return
	var/procname = "Manage Perseus Whitelist"
	var/list/menu = list(
		"View Whitelist" = 1,
		"Modify Player Entry" = 2,
		"Delete Player Entry" = 3,
		"Add Player Entry" = 4)
	var/selected = input(usr,"Choose an option",procname,null) as null|anything in menu
	if(!(selected in menu) || !is_pmanager(usr.ckey))
		return
	var/list/pwhitelist = get_pwhitelist()
	if(!istype(pwhitelist))
		return
	switch(menu[selected])
		if(1)
			var/dat = "<B>Perseus Whitelist</B><BR><BR>"
			for(var/text in pwhitelist)
				dat += "<B>Player:</B> [text]"
				var/list/paramslist = params2list(pwhitelist[text])
				if(paramslist)
					dat += ", <B>Rank:</B> [paramslist["rank"]], <B>Number:</B> [paramslist["number"]]"
				dat += "<BR>"
			usr << browse(dat,"window=perseuswhitelist;size=600x500")
		if(2)
			var/player = input(usr,"Choose a player to modify",procname,null) as null|anything in pwhitelist
			if(!player || !(player in pwhitelist))
				return
			var/theckey = player
			var/list/paramslist = params2list(pwhitelist[player])
			if(paramslist)
				var/therank = paramslist["rank"]
				var/thenumber = paramslist["number"]
				var/oldckey = theckey
				theckey = input(usr,"Enter new player ckey",procname,theckey) as text
				if(!theckey)
					return
				if(theckey != oldckey)
					var/savedparams = pwhitelist[player]
					pwhitelist.Remove(oldckey)
					pwhitelist[theckey] = savedparams
				therank = input(usr,"Choose a rank",procname,therank) as null|anything in perseusranks
				if(!(therank in perseusranks))
					return
				var/numberislegit = 0
				while(!numberislegit)
					thenumber = input(usr,"Enter new number designation",procname,thenumber) as text
					var/oldnumber = thenumber
					if(!thenumber)
						break
					var/fail = 0
					if(length(thenumber) == 3)
						for(var/i=1,i<=length(thenumber),i++)
							var/digit = copytext(thenumber,i,i+1)
							if(!isnum(text2num(digit)))
								fail = 1
								break
						if(!fail)
							numberislegit = 1
					else
						fail = 1
					if(fail)
						thenumber = oldnumber
						to_chat(usr, "The number designation must be 3 one digit numbers. (example: 075)")
				if(theckey && therank && thenumber)
					pwhitelist[theckey] = "rank=[therank];number=[thenumber]"
					save_pwhitelist(pwhitelist)
		if(3)
			var/player = input(usr,"Choose a player to delete",procname,null) as null|anything in pwhitelist
			if(!player || !(player in pwhitelist))
				return
			var/confirmdelete = alert(usr,"Confirm deletion of [player] from the perseus whitelist?",procname,"Confirm","Cancel")
			if(confirmdelete != "Confirm")
				return
			pwhitelist.Remove(player)
			save_pwhitelist(pwhitelist)
		if(4)
			var/player = input(usr,"Enter a player ckey to add to the perseus whitelist.",procname,null) as text
			if(!player)
				return
			if(player in pwhitelist)
				to_chat(usr,"Player \"[player]\" is already in the perseus whitelist.")
				return
			var/therank = input(usr,"Choose a rank",procname,null) as null|anything in perseusranks
			if(!(therank in perseusranks))
				return
			var/thenumber
			var/numberislegit = 0
			while(!numberislegit)
				thenumber = input(usr,"Enter new number designation",procname,null) as text
				var/oldnumber = thenumber
				if(!thenumber)
					break
				var/fail = 0
				if(length(thenumber) == 3)
					for(var/i=1,i<=length(thenumber),i++)
						var/digit = copytext(thenumber,i,i+1)
						if(!isnum(text2num(digit)))
							fail = 1
							break
					if(!fail)
						numberislegit = 1
				else
					fail = 1
				if(fail)
					thenumber = oldnumber
					to_chat(usr, "The number designation must be 3 one digit numbers. (example: 075)")
			if(player && therank && thenumber)
				pwhitelist[player] = "rank=[therank];number=[thenumber]"
				save_pwhitelist(pwhitelist)

//deathsquad war module
/datum/deathsquadwar_observer/perseus
	var/list/thepwhitelist
	var/list/perseus = list()

/datum/deathsquadwar_observer/perseus/New()
	thepwhitelist = get_pwhitelist()
	. = ..()

/datum/deathsquadwar_observer/perseus/is_special(client/C)
	var/perccheck = is_pwhitelisted(C.ckey,thepwhitelist)
	if(perccheck)
		perseus[C] = perccheck
		return TRUE
	return FALSE

/datum/deathsquadwar_observer/perseus/spawn_deathsquad(client/C)
	if(!(C in perseus))
		return
	var/mob/living/carbon/human/H = new()
	C.prefs.copy_to(H)
	H.dna.update_dna_identity()
	H.sync_mind()
	var/outfitdatum = /datum/outfit/perseus/fullkit
	if(copytext(perseus[C],1,2) == "2")
		outfitdatum = /datum/outfit/perseus/commander/fullkit
	var/datum/outfit/perseus/P = new outfitdatum()
	H.equipOutfit(P)
	return H

