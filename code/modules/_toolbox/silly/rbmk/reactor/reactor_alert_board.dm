#define ALERT_BOARD_TEMP "temp"
#define ALERT_BOARD_HEALTH "health"
#define ALERT_BOARD_NOPRESSURE "nopressure"
#define ALERT_BOARD_OVERPRESSURE "overpressure"
#define ALERT_BOARD_STABLE "stable"
#define ALERT_BOARD_INPUTCOOLANT "inputcoolant"

/obj/machinery/rbmkalertconsole
	name = "Reactor Alarm Monitor"
	desc = "Displays alarms associated with the reactor."
	icon = 'icons/oldschool/reactor/panel_64x32.dmi'
	icon_state = "reactoralerts"
	anchored = 1
	density = 0
	use_power = IDLE_POWER_USE
	idle_power_usage = 300
	active_power_usage = 300
	max_integrity = 200
	integrity_failure = 50
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 100, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 20)
	var/id = null
	var/previous_temp = 0
	var/list/alarms = list() //alarms triggered by circumstance
	var/list/forced_alarms = list() //alarms triggered by force ie hacking and suck
	var/list/muted_alarms = list() //alarms sounds muted by interface
	var/list/active_alarms = list() //actual running alarms
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor
	var/list/play_once_sounds = list('sound/toolbox/reactor/alarms/alarm1_once.ogg','sound/toolbox/reactor/alarms/alarm2_once.ogg','sound/toolbox/reactor/alarms/alarm3_once.ogg')
	var/list/looping_sounds_list = list('sound/toolbox/reactor/alarms/alarm1_loop.ogg' = 26,'sound/toolbox/reactor/alarms/alarm2_loop.ogg' = 80,'sound/toolbox/reactor/alarms/alarm3_loop.ogg' = 22,'sound/toolbox/reactor/alarms/alarm4_loop.ogg' = 31)
	var/list/currently_playing_alarms = list()
	var/list/alarm_list = list(
			ALERT_BOARD_TEMP = list(null,'sound/toolbox/reactor/alarms/alarm1_once.ogg','sound/toolbox/reactor/alarms/alarm4_loop.ogg'),
			ALERT_BOARD_HEALTH = list(null,'sound/toolbox/reactor/alarms/alarm2_once.ogg','sound/toolbox/reactor/alarms/alarm2_loop.ogg'),
			ALERT_BOARD_NOPRESSURE = list(null,null,'sound/toolbox/reactor/alarms/alarm4_loop.ogg'),
			ALERT_BOARD_OVERPRESSURE = list(null,'sound/toolbox/reactor/alarms/alarm1_once.ogg','sound/toolbox/reactor/alarms/alarm1_loop.ogg'),
			ALERT_BOARD_STABLE = list(null,null,null),
			ALERT_BOARD_INPUTCOOLANT = list(null,'sound/toolbox/reactor/alarms/alarm3_once.ogg','sound/toolbox/reactor/alarms/alarm3_loop.ogg'))
	var/wire_panel_open = 0
	var/require_access = 1

/obj/machinery/rbmkalertconsole/Initialize()
	. = ..()
	wires = new /datum/wires/rbmkalertconsole(src)
	for(var/f in looping_sounds_list)
		var/datum/looping_sound/custom/loop = new()
		loop.output_atoms = list(src)
		loop.mid_sounds = f
		loop.mid_length = looping_sounds_list[f]
		loop.volume = 100
		looping_sounds_list[f] = loop
	if(!reactor && istext(id))
		for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/R in world)
			if(R.id == id)
				reactor = R

/obj/machinery/rbmkalertconsole/Destroy()
	forced_alarms.Cut()
	muted_alarms.Cut()
	clear_alarms()
	reactor = null
	. = ..()

/obj/machinery/rbmkalertconsole/examine()
	. = ..()

/obj/machinery/rbmkalertconsole/ui_interact(mob/user)
	var/datum/browser/popup = new(user, "rbmkalertconsole", "[name]", 350, 300)
	var/dat = "<p><B>Active Reactor Alarms:</B></p>"
	if(active_alarms && active_alarms.len)
		var/alarm_names = list(
		ALERT_BOARD_TEMP = "temperature",
		ALERT_BOARD_HEALTH = "Vessel integrity",
		ALERT_BOARD_NOPRESSURE = "exposed fuel",
		ALERT_BOARD_OVERPRESSURE = "vessel overpressure",
		ALERT_BOARD_STABLE = "stability",
		ALERT_BOARD_INPUTCOOLANT = "coolant temperature")
		var/list/alarm_texts = list()
		for(var/alarm in active_alarms)
			if(alarm in alarm_names)
				var/alarmnumber = active_alarms[alarm]
				if(isnum(alarmnumber) && alarmnumber > 0)
					var/alarmstatus = "<font color='#00ff37'>good</font>"
					switch(alarmnumber)
						if(2)
							alarmstatus = "<font color='#fbff00'><b>caution</b></font>"
						if(3)
							alarmstatus = "<font color='#eb0000'><b>Danger!</b></font>"
					var/alarmdat = "[uppertext(alarm_names[alarm])] : [alarmstatus]"
					var/alarmfile
					if(alarm_list[alarm] && islist(alarm_list[alarm]))
						alarmfile = alarm_list[alarm][alarmnumber]
					if(isfile(alarmfile) && (alarmfile in looping_sounds_list))
						alarmdat += " <A href='?src=\ref[src];silence=[alarm];number=[alarmnumber]'>Silence Alarm</A>"
					alarmdat += "<br>"
					alarm_texts += alarmdat
		if(alarm_texts.len)
			for(var/t in alarm_texts)
				dat += "[t]"
		else
			dat += "No active alarms."
	popup.set_content(dat)
	popup.open()

/obj/machinery/rbmkalertconsole/Topic(href, href_list)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	if(href_list["silence"])
		var/alarm = href_list["silence"]
		var/alarmnumber = text2num(href_list["number"])
		if(alarm_list[alarm] && isnum(alarmnumber) && alarmnumber > 0)
			mute_alarm(alarm,alarmnumber)

/obj/machinery/rbmkalertconsole/power_change()
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		set_light(0, 0)
	update_icon()
	return

/obj/machinery/rbmkalertconsole/attackby(obj/item/I, mob/user, params)
	if(wire_panel_open && is_wire_tool(I))
		wires.interact(user)
		return
	. = ..()

/obj/machinery/rbmkalertconsole/screwdriver_act(mob/living/user, obj/item/W)
	. = ..()
	if(.)
		return
	. = TRUE
	wire_panel_open = !wire_panel_open
	to_chat(user, "The wires have been [wire_panel_open ? "exposed" : "unexposed"].")
	W.play_tool_sound(src)
	update_icon()

/obj/machinery/rbmkalertconsole/process()
	if(reactor && reactor.has_fuel() && !reactor.slagged && !(stat & (NOPOWER|BROKEN)))
		var/yellowtemp = RBMK_TEMPERATURE_CRITICAL-100
		var/dangertemp = RBMK_TEMPERATURE_CRITICAL-15
		//Handle temperature
		if(reactor.temperature >= yellowtemp)
			if(reactor.temperature <= dangertemp)
				trigger_alarm(ALERT_BOARD_TEMP,2)
			else
				trigger_alarm(ALERT_BOARD_TEMP,3)
		else
			trigger_alarm(ALERT_BOARD_TEMP,0)
		//Handle Integrity
		if(reactor.temperature >= RBMK_TEMPERATURE_MELTDOWN || reactor.no_coolant_ticks > RBMK_NO_COOLANT_TOLERANCE || reactor.pressure >= RBMK_PRESSURE_CRITICAL)
			trigger_alarm(ALERT_BOARD_HEALTH,3)
		else
			var/vessel_percent = round((reactor.vessel_integrity/initial(reactor.vessel_integrity))*100)
			if(vessel_percent >= 50)
				trigger_alarm(ALERT_BOARD_HEALTH,0)
			else
				trigger_alarm(ALERT_BOARD_HEALTH,2)
		//Handle Uncovered Fuel
		var/datum/gas_mixture/coolant_input = reactor.COOLANT_INPUT_GATE
		if(coolant_input)
			var/input_moles = coolant_input.total_moles()
			if(!(input_moles >= reactor.minimum_coolant_level) && reactor.no_coolant_ticks > RBMK_NO_COOLANT_TOLERANCE)
				trigger_alarm(ALERT_BOARD_NOPRESSURE,3)
			else
				trigger_alarm(ALERT_BOARD_NOPRESSURE,0)
		else
			trigger_alarm(ALERT_BOARD_NOPRESSURE,3)
		//Handle pressure
		if(reactor.pressure <= RBMK_PRESSURE_OPERATING)
			trigger_alarm(ALERT_BOARD_OVERPRESSURE,0)
		else if(reactor.pressure <=  RBMK_PRESSURE_CRITICAL)
			trigger_alarm(ALERT_BOARD_OVERPRESSURE,2)
		else
			trigger_alarm(ALERT_BOARD_OVERPRESSURE,3)
		//Handle stability
		if(!previous_temp)
			previous_temp = reactor.temperature
		var/temp_diff = previous_temp-reactor.temperature
		previous_temp = reactor.temperature
		if(temp_diff >= 0.04 || temp_diff <= -0.015)
			trigger_alarm(ALERT_BOARD_STABLE,0)
		else
			trigger_alarm(ALERT_BOARD_STABLE,1)
		//Handle Coolant Input Temperature
		var/warmcoolant = round(RBMK_TEMPERATURE_CRITICAL/4)
		var/hotcoolant = round(RBMK_TEMPERATURE_CRITICAL/2)
		if(reactor.last_coolant_temperature <= warmcoolant)
			trigger_alarm(ALERT_BOARD_INPUTCOOLANT,0)
		else if(reactor.last_coolant_temperature <= hotcoolant)
			trigger_alarm(ALERT_BOARD_INPUTCOOLANT,2)
		else
			trigger_alarm(ALERT_BOARD_INPUTCOOLANT,3)
		update_alarms()
	else if(alarms.len)
		clear_alarms()

/obj/machinery/rbmkalertconsole/proc/trigger_alarm(alarm,level = 0,forced)
	if(!(alarm in alarm_list) || !isnum(level))
		return
	if(forced)
		forced_alarms[alarm] = level
		return
	if(alarm in alarms && alarms[alarm] == level)
		return
	if(level == 0)
		alarms.Remove(alarm)
	else
		alarms[alarm] = level

/obj/machinery/rbmkalertconsole/proc/update_alarms(silent = 0)
	if(reactor)
		var/list/old_alarms = active_alarms.Copy()
		active_alarms.Cut()
		var/meltdown = 0
		if(reactor.slagged)
			meltdown = 3
		for(var/t in alarm_list)
			var/alarmnumber = 0
			var/oldnumber = 0
			if(old_alarms[t])
				oldnumber = old_alarms[t]
			if((t in forced_alarms) && forced_alarms[t] >= 0)
				alarmnumber = forced_alarms[t]
			else if((t in alarms) && alarms[t] > 0)
				alarmnumber = alarms[t]
			alarmnumber = max(alarmnumber,meltdown)
			if(alarmnumber > 0)
				active_alarms[t] = alarmnumber
			if(oldnumber != alarmnumber)
				cancel_looping_sound(t,oldnumber)
				muted_alarms.Remove(t)
				if(!meltdown && !silent)
					play_alarm_sound(t,alarmnumber)
		update_icon()

/obj/machinery/rbmkalertconsole/proc/play_alarm_sound(alarm,number)
	if(!(alarm in alarm_list) || !isnum(number) || number <= 0 || (alarm in muted_alarms))
		return
	var/alarmfile
	if(alarm_list[alarm] && islist(alarm_list[alarm]))
		var/list/sounds_list = alarm_list[alarm]
		if(number > 0 && number <= sounds_list.len)
			alarmfile = alarm_list[alarm][number]
	if(isfile(alarmfile))
		if(alarmfile in looping_sounds_list)
			var/datum/looping_sound/loop = looping_sounds_list[alarmfile]
			if(loop && !(loop in currently_playing_alarms))
				currently_playing_alarms += loop
				loop.start()
		else
			playsound(loc, alarmfile, 100, 0)

/obj/machinery/rbmkalertconsole/proc/cancel_looping_sound(alarm,number)
	if(!(alarm in alarm_list) || !isnum(number) || number <= 0)
		return
	var/alarmfile
	if(alarm_list[alarm] && islist(alarm_list[alarm]) && number <= 3)
		alarmfile = alarm_list[alarm][number]
	if(isfile(alarmfile) && (alarmfile in looping_sounds_list))
		var/datum/looping_sound/loop = looping_sounds_list[alarmfile]
		if(loop && (loop in currently_playing_alarms))
			currently_playing_alarms -= loop
			loop.stop()

/obj/machinery/rbmkalertconsole/proc/mute_alarm(alarm,number)
	cancel_looping_sound(alarm,number)
	if(!(alarm in muted_alarms))
		muted_alarms += alarm

/obj/machinery/rbmkalertconsole/update_icon()
	overlays.Cut()
	if(stat)
		if(stat & BROKEN)
			icon_state = "[initial(icon_state)]_nopower" // needs broken sprite
		else if(stat & NOPOWER)
			icon_state = "[initial(icon_state)]_nopower"
	else
		icon_state = "[initial(icon_state)]"
		for(var/alarm in active_alarms)
			var/alarmnumber = active_alarms[alarm]
			if(alarmnumber < 1)
				continue
			var/image/alarmlight = new()
			alarmlight.icon = icon
			alarmlight.icon_state = "[initial(icon_state)]alarm_[alarm]_[alarmnumber]"
			alarmlight.layer = layer+0.1
			overlays += alarmlight
	if(wire_panel_open) //with overlays cut we have to check this every time.
		var/image/panel = new()
		panel.icon = icon
		panel.icon_state = "[initial(icon_state)]_panel"
		panel.layer = layer+0.2
		overlays += panel

/obj/machinery/rbmkalertconsole/proc/clear_alarms(all = 0)
	alarms.Cut()
	if(all)
		forced_alarms.Cut()
	update_alarms()

/obj/machinery/rbmkalertconsole/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(stat & BROKEN)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
			else
				playsound(src.loc, 'sound/effects/glasshit.ogg', 75, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)

//wires
/datum/wires/rbmkalertconsole
	holder_type = /obj/machinery/rbmkalertconsole
	proper_name = "Reactor Alarm Monitor"
	var/list/alarm_list = list(
			ALERT_BOARD_TEMP = "Red",
			ALERT_BOARD_HEALTH = "Orange",
			ALERT_BOARD_NOPRESSURE = "Black",
			ALERT_BOARD_OVERPRESSURE = "White",
			ALERT_BOARD_STABLE = "Brown",
			ALERT_BOARD_INPUTCOOLANT = "Blue")

/datum/wires/rbmkalertconsole/New(atom/holder)
	for(var/t in alarm_list)
		wires += t
	wires += WIRE_IDSCAN
	add_duds(2)
	..()

/datum/wires/rbmkalertconsole/interactable(mob/user)
	var/obj/machinery/rbmkalertconsole/A = holder
	if(!istype(A))
		return
	if(A.wire_panel_open)
		return TRUE

/datum/wires/rbmkalertconsole/on_pulse(wire)
	var/obj/machinery/rbmkalertconsole/A = holder
	if(!istype(A))
		return
	if(wire in A.alarm_list)
		var/alarmnumber = 0
		if(wire in A.forced_alarms)
			alarmnumber = A.forced_alarms[wire]
		alarmnumber++
		if(alarmnumber > 3)
			A.forced_alarms.Remove(wire)
		else
			A.trigger_alarm(wire,alarmnumber,forced = 1)
	else if(wire == WIRE_IDSCAN)
		A.require_access = !A.require_access
	A.update_alarms(1)

/datum/wires/rbmkalertconsole/on_cut(index, mend)
	var/obj/machinery/rbmkalertconsole/A = holder
	if(!istype(A))
		return
	if(index in A.alarm_list)
		if(!mend)
			A.trigger_alarm(index,0,forced = 1)
		else
			A.forced_alarms.Remove(index)
	else if(index == WIRE_IDSCAN && mend)
		A.require_access = initial(A.require_access)
	A.update_alarms(1)

/datum/wires/rbmkalertconsole/get_status()
	var/obj/machinery/rbmkalertconsole/A = holder
	if(!istype(A))
		return
	var/list/status = list()
	for(var/wire in A.alarm_list)
		var/lightcolor = "Yellow"
		if(wire in src.alarm_list)
			lightcolor = src.alarm_list[wire]
		var/lightstatus = "off"
		if((wire in A.forced_alarms) && A.forced_alarms[wire])
			switch(A.forced_alarms[wire])
				if(1)
					lightstatus = "on"
				if(2)
					lightstatus = "blinking slowly"
				if(3)
					lightstatus = "blinking fast"
		status += "The [lightcolor] light is [lightstatus]."
	status += "The Green light is [A.require_access ? "on" : "off"]."
	return status

//customizable looping sound that doesnt call a proc crash if you spawn it with no mid_sounds
/datum/looping_sound/custom
	mid_sounds = 1
/*
needs wires to toggle and block alarms

we need new switch console icons
we need a scram button
change it so all alarms flash at different rates
make big circle control rod panel
*/
