#define KPA_TO_PSI(A) (A/6.895)
#define PSI_TO_KPA(A) (A*6.895)
#define KELVIN_TO_CELSIUS(A) (A-273.15)
#define CELSIUS_TO_KELVIN(A) (A+273.15)
#define MEGAWATTS /1e+6

//For my sanity :))

#define COOLANT_INPUT_GATE airs[1]
#define MODERATOR_INPUT_GATE airs[2]
#define COOLANT_OUTPUT_GATE airs[3]

#define RBMK_TEMPERATURE_OPERATING 640 //Celsius
#define RBMK_TEMPERATURE_CRITICAL 800 //At this point the entire ship is alerted to a meltdown. This may need altering
#define RBMK_TEMPERATURE_MELTDOWN 900

#define RBMK_NO_COOLANT_TOLERANCE 5 //How many process()ing ticks the reactor can sustain without coolant before slowly taking damage

#define RBMK_PRESSURE_OPERATING 1000 //PSI
#define RBMK_PRESSURE_CRITICAL 1469.59 //PSI

#define RBMK_MAX_CRITICALITY 3 //No more criticality than N for now.

#define RBMK_POWER_FLAVOURISER 8000 //To turn those KWs into something usable

#define NUCLEAR_REACTOR_RBMK		"rbmk_reactor"

//Reference: Heaters go up to 500K.
//Hot plasmaburn: 14164.95 C.

/**

What is this?

Moderators list (Not gonna keep this accurate forever):
Fuel Type:
Oxygen: Power production multiplier. Allows you to run a low plasma, high oxy mix, and still get a lot of power.
Plasma: Power production gas. More plasma -> more power, but it enriches your fuel and makes the reactor much, much harder to control.
Tritium: Extremely efficient power production gas. Will cause chernobyl if used improperly.

Moderation Type:
N2: Helps you regain control of the reaction by increasing control rod effectiveness, will massively boost the rad production of the reactor.
CO2: Super effective shutdown gas for runaway reactions. MASSIVE RADIATION PENALTY!
Pluoxium: Same as N2, but no cancer-rads!

Permeability Type:
BZ: Increases your reactor's ability to transfer its heat to the coolant, thus letting you cool it down faster (but your output will get hotter)
Water Vapour: More efficient permeability modifier
Hyper Noblium: Extremely efficient permeability increase. (10x as efficient as bz)

Depletion type:
Nitryl: When you need weapons grade plutonium yesterday. Causes your fuel to deplete much, much faster. Not a huge amount of use outside of sabotage.

Sabotage:

Meltdown:
Flood reactor moderator with plasma, they won't be able to mitigate the reaction with control rods.
Shut off coolant entirely. Raise control rods.
Swap all fuel out with spent fuel, as it's way stronger.

Blowout:
Shut off exit valve for quick overpressure.
Cause a pipefire in the coolant line (LETHAL).
Tack heater onto coolant line (can also cause straight meltdown)

Tips:
Be careful to not exhaust your plasma supply. I recommend you DON'T max out the moderator input when youre running plasma + o2, or you're at a tangible risk of running out of those gasses from atmos.
The reactor CHEWS through moderator. It does not do this slowly. Be very careful with that!

*/

//Remember kids. If the reactor itself is not physically powered by an APC, it cannot shove coolant in!

//Helper proc to set a new looping ambience, and play it to any mobs already inside of that area.

/client/var/last_ambience = null
/area/proc/set_looping_ambience(sound)
	if(ambient_buzz == sound)
		return FALSE
	ambient_buzz = sound
	var/list/affecting = list() //Which mobs are we about to transmit to?
	for(var/mob/M in GLOB.player_list)
		if(get_area(M) == get_area(src))
			affecting = M
	/*for(var/obj/structure/overmap/OM in GLOB.overmap_objects)
		if(OM.linked_areas?.len)
			if(src in OM.linked_areas)
				affecting = OM.mobs_in_ship
	if(!affecting.len) //OK, we can't get away with the cheaper check.
		for(var/mob/L in src) //This is really really expensive, please use this proc on non-overmap supported areas sparingly!
			if(!istype(L))
				continue
			affecting += L*/
	for(var/mob/L in affecting)
		if(L.client && L.client.prefs.toggles & SOUND_SHIP_AMBIENCE && L.client?.last_ambience != ambient_buzz)
			L.client.ambient_buzz_playing = ambient_buzz
			SEND_SOUND(L, sound(ambient_buzz, repeat = 1, wait = 0, volume = 100, channel = CHANNEL_AMBIENT_MUSIC))
			L.client.last_ambience = ambient_buzz
	return TRUE

/obj/item/book/manual/wiki/rbmk
	name = "\improper Haynes nuclear reactor owner's manual"
	icon_state ="bookEngineering2"
	author = "CogWerk Engineering Reactor Design Department"
	title = "Haynes nuclear reactor owner's manual"
	page_link = "Guide_to_the_Nuclear_Reactor"

/obj/item/book/manual/wiki/rbmk/get_wiki_url()
	return "https://nsv.beestation13.com/wiki"

/obj/machinery/atmospherics/components/trinary/nuclear_reactor
	name = "\improper Advanced Gas-Cooled Nuclear Reactor"
	desc = "A tried and tested design which can output stable power at an acceptably low risk. The moderator can be changed to provide different effects."
	icon = 'icons/oldschool/reactor/rbmk.dmi'
	icon_state = "reactor_map"
	pixel_x = -32
	pixel_y = -32
	density = FALSE //It burns you if you're stupid enough to walk over it.
	anchored = TRUE
	//processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	light_color = LIGHT_COLOR_CYAN
	dir = 8 //Less headache inducing :))
	var/id = null //Change me mappers
	//Variables essential to operation
	var/temperature = 0 //Lose control of this -> Meltdown
	var/vessel_integrity = 400 //How long can the reactor withstand overpressure / meltdown? This gives you a fair chance to react to even a massive pipe fire
	var/pressure = 0 //Lose control of this -> Blowout
	var/K = 0 //Rate of reaction.
	var/desired_k = 0
	var/control_rod_effectiveness = 0.65 //Starts off with a lot of control over K. If you flood this thing with plasma, you lose your ability to control K as easily.
	var/power = 0 //0-100%. A function of the maximum heat you can achieve within operating temperature
	var/power_modifier = 1 //Upgrade me with parts, science! Flat out increase to physical power output when loaded with plasma.
	var/list/fuel_rods = list()
	//Secondary variables.
	var/next_slowprocess = 0
	var/gas_absorption_effectiveness = 0.5
	var/gas_absorption_constant = 0.5 //We refer to this one as it's set on init, randomized.
	var/minimum_coolant_level = 5
	var/warning = FALSE //Have we begun warning the crew of their impending death?
	var/next_warning = 0 //To avoid spam.
	var/last_power_produced = 0 //For logging purposes
	var/next_flicker = 0 //Light flicker timer
	var/last_flicker_power_level = 0
	var/base_power_modifier = RBMK_POWER_FLAVOURISER
	var/slagged = FALSE //Is this reactor even usable any more?
	//Console statistics.
	var/last_coolant_temperature = 0
	var/last_output_temperature = 0
	var/last_heat_delta = 0 //For administrative cheating only. Knowing the delta lets you know EXACTLY what to set K at.
	var/no_coolant_ticks = 0	//How many times in succession did we not have enough coolant? Decays twice as fast as it accumulates.
	var/original_dir = 0
	var/last_admin_alert = 0
	var/last_alarm_sound = 0

//Use this in your maps if you want everything to be preset.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/preset
	id = "default_reactor_for_lazy_mappers"

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/destroyed
	icon_state = "reactor_slagged"
	slagged = TRUE
	vessel_integrity = 0

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/examine(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS, target=src))
			var/percent = vessel_integrity / initial(vessel_integrity) * 100
			var/msg = "<span class='warning'>The reactor looks operational.</span>"
			switch(percent)
				if(0 to 10)
					msg = "<span class='boldwarning'>[src]'s seals are dangerously warped and you can see cracks all over the reactor vessel! </span>"
				if(10 to 40)
					msg = "<span class='boldwarning'>[src]'s seals are heavily warped and cracked! </span>"
				if(40 to 60)
					msg = "<span class='warning'>[src]'s seals are holding, but barely. You can see some micro-fractures forming in the reactor vessel.</span>"
				if(60 to 80)
					msg = "<span class='warning'>[src]'s seals are in-tact, but slightly worn. There are no visible cracks in the reactor vessel.</span>"
				if(80 to 90)
					msg = "<span class='notice'>[src]'s seals are in good shape, and there are no visible cracks in the reactor vessel.</span>"
				if(95 to 100)
					msg = "<span class='notice'>[src]'s seals look factory new, and the reactor's in excellent shape.</span>"
			. += msg

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/attackby(obj/item/W, mob/user, params)
	if(default_change_direction_wrench(user, W))
		return
	if(istype(W, /obj/item/twohanded/required/fuel_rod))
		if(power >= 20)
			to_chat(user, "<span class='notice'>You cannot insert fuel into [src] when it has been raised above 20% power.</span>")
			return FALSE
		if(fuel_rods.len >= 5)
			to_chat(user, "<span class='warning'>[src] is already at maximum fuel load.</span>")
			return FALSE
		to_chat(user, "<span class='notice'>You start to insert [W] into [src]...</span>")
		radiation_pulse(src, temperature)
		if(do_after(user, 5 SECONDS, target=src))
			insert_fuel_rod(W,user)
		return TRUE
	if(!slagged && istype(W, /obj/item/reagent_containers/food/snacks/butter))
		var/obj/item/reagent_containers/food/snacks/butter/B = W
		if(!B.reagents || !B.reagents.has_reagent(/datum/reagent/consumable/nutriment, amount = 5))
			to_chat(user, "<span class='warning'>You need more butter.</span>")
			return FALSE
		if(power >= 20)
			to_chat(user, "<span class='notice'>You cannot repair [src] while it is running at above 20% power.</span>")
			return FALSE
		if(vessel_integrity >= 350)
			to_chat(user, "<span class='notice'>[src]'s seals are already in-tact, repairing them further would require more butter.</span>")
			return FALSE
		if(vessel_integrity <= 0.5 * initial(vessel_integrity)) //Heavily damaged.
			to_chat(user, "<span class='notice'>[src]'s reactor vessel is cracked and worn, you need to repair the cracks with a welder before butter will help.</span>")
			return FALSE
		if(do_after(user, 5 SECONDS, target=src))
			if(vessel_integrity >= 350)	//They might've stacked doafters
				to_chat(user, "<span class='notice'>[src]'s seals are already in-tact, repairing them further needs more butter.</span>")
				return FALSE
			playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
			user.visible_message("<span class='warning'>[user] starts rubbing butter to some of [src]'s worn out seals.</span>", "<span class='notice'>You start rubbing butter on some of [src]'s worn out seals.</span>")
			vessel_integrity += 10
			vessel_integrity = CLAMP(vessel_integrity, 0, initial(vessel_integrity))
			qdel(B)
		return TRUE
	return ..()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/welder_act(mob/living/user, obj/item/I)
	if(slagged)
		to_chat(user, "<span class='notice'>You can't repair [src], it's completely slagged!</span>")
		return FALSE
	if(power >= 20)
		to_chat(user, "<span class='notice'>You can't repair [src] while it is running at above 20% power.</span>")
		return FALSE
	if(vessel_integrity > 0.5 * initial(vessel_integrity))
		to_chat(user, "<span class='notice'>[src] is free from cracks. Something like butter might beable to carry out further repairs.</span>")
		return FALSE
	if(I.use_tool(src, user, 0, volume=40))
		if(vessel_integrity > 0.5 * initial(vessel_integrity))
			to_chat(user, "<span class='notice'>[src] is free from cracks. Something like butter might beable to carry out further repairs.</span>")
			return FALSE
		vessel_integrity += 20
		to_chat(user, "<span class='notice'>You weld together some of [src]'s cracks. This'll do for now.</span>")
	return TRUE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/insert_fuel_rod(obj/item/twohanded/required/fuel_rod/rod,mob/user)
	if(!istype(rod) || !rod.forceMove(src))
		return
	fuel_rods[rod] = world.time
	//logging whoever inserted this rod.
	var/logged_user = "no one"
	if(user)
		logged_user = "[user]([user.key])"
	investigate_log("[logged_user] inserted a [rod] into the [src] at [x] [y] [z] in [get_area(src)].", NUCLEAR_REACTOR_RBMK)
	if(length(fuel_rods) <= 1)
		start_up(user) //That was the first fuel rod. Let's heat it up.
	else
		playsound(src, pick('sound/toolbox/reactor/switch.ogg','sound/toolbox/reactor/switch2.ogg','sound/toolbox/reactor/switch3.ogg'), 100, FALSE)
	radiation_pulse(src, temperature) //Wear protective equipment when even breathing near a reactor!

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/remove_fuel_rod(obj/item/twohanded/required/fuel_rod/rod)
	if(!rod)
		for(var/obj/item/twohanded/required/fuel_rod/F in fuel_rods)
			rod = F
			break
	if(!rod || !(rod in fuel_rods)) // Was also !rod in fuel_rods, which doesnt add up.
		return
	playsound(src, 'sound/toolbox/reactor/crane_1.wav', 100, FALSE)
	var/turf/unloadturf = get_turf(src)
	for(var/obj/item/twohanded/required/fuel_rod/blockingrod in unloadturf)
		if(blockingrod == rod)
			continue
		var/list/otherturfs = list()
		for(var/turf/T in orange(1,unloadturf))
			var/foundrod = 0
			for(var/obj/item/twohanded/required/fuel_rod/anotherblockingrod in T)
				if(anotherblockingrod == rod)
					continue
				foundrod = 1
				break
			if(foundrod)
				continue
			otherturfs += T
		if(otherturfs.len)
			unloadturf = pick(otherturfs)
		break
	if(unloadturf)
		rod.forceMove(unloadturf)
		fuel_rods.Remove(rod)

//Admin procs to mess with the reaction environment.

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/lazy_startup()
	slagged = FALSE
	for(var/I=0;I<5;I++)
		insert_fuel_rod(new /obj/item/twohanded/required/fuel_rod())
	start_up("admin")

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/deplete()
	for(var/obj/item/twohanded/required/fuel_rod/FR in fuel_rods)
		FR.depletion = 100

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/Initialize()
	original_dir = dir
	. = ..()
	icon_state = "reactor_off"
	gas_absorption_effectiveness = rand(5, 6)/10 //All reactors are slightly different. This will result in you having to figure out what the balance is for K.
	gas_absorption_constant = gas_absorption_effectiveness //And set this up for the rest of the round.

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/on_entered(datum/source, atom/movable/AM, oldloc)
	SIGNAL_HANDLER

	if(isliving(AM) && temperature > 0)
		var/mob/living/L = AM
		L.adjust_bodytemperature(CLAMP(temperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)) //If you're on fire, you heat up!

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/process()
	if(dir != original_dir)
		reset_direction()
	update_parents() //Update the pipenet to register new gas mixes
	if(next_slowprocess < world.time)
		slowprocess()
		next_slowprocess = world.time + 1 SECONDS //Set to wait for another second before processing again, we don't need to process more than once a second

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/has_fuel()
	return length(fuel_rods)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/slowprocess()
	if(slagged)
		STOP_PROCESSING(SSmachines, src)
		return

	//Let's get our gasses sorted out.
	var/datum/gas_mixture/coolant_input = COOLANT_INPUT_GATE
	var/datum/gas_mixture/moderator_input = MODERATOR_INPUT_GATE
	var/datum/gas_mixture/coolant_output = COOLANT_OUTPUT_GATE

	//Firstly, heat up the reactor based off of K.
	var/input_moles = coolant_input.total_moles() //Firstly. Do we have enough moles of coolant?
	if(input_moles >= minimum_coolant_level)
		last_coolant_temperature = KELVIN_TO_CELSIUS(coolant_input.return_temperature())
		//Important thing to remember, once you slot in the fuel rods, this thing will not stop making heat, at least, not unless you can live to be thousands of years old which is when the spent fuel finally depletes fully.
		var/heat_delta = (KELVIN_TO_CELSIUS(coolant_input.return_temperature()) / 100) * gas_absorption_effectiveness //Take in the gas as a cooled input, cool the reactor a bit. The optimum, 100% balanced reaction sits at K=1, coolant input temp of 200K / -73 celsius.
		last_heat_delta = heat_delta
		temperature += heat_delta
		coolant_output.merge(coolant_input) //And now, shove the input into the output.
		coolant_input.clear() //Clear out anything left in the input gate.
		color = null
		no_coolant_ticks = max(0, no_coolant_ticks-2)	//Needs half as much time to recover the ticks than to acquire them
	else
		if(has_fuel())
			no_coolant_ticks++
			if(no_coolant_ticks > RBMK_NO_COOLANT_TOLERANCE)
				temperature += temperature / 500 //This isn't really harmful early game, but when your reactor is up to full power, this can get out of hand quite quickly.
				vessel_integrity -= temperature / 200 //Think fast loser.
				play_damage_alarm()
				take_damage(10) //Just for the sound effect, to let you know you've fucked up.
				color = "[COLOR_RED]"
				log_reactor("[src] is running with insufficient coolant and may melt down. Integrity at [(vessel_integrity/initial(vessel_integrity)*100)]% at [x] [y] [z] in [get_area(src)]",50)
	//Now, heat up the output and set our pressure.
	coolant_output.set_temperature(max(CELSIUS_TO_KELVIN(temperature),0)) //Heat the coolant output gas that we just had pass through us.
	last_output_temperature = KELVIN_TO_CELSIUS(coolant_output.return_temperature())
	pressure = KPA_TO_PSI(coolant_output.return_pressure())
	power = (temperature / RBMK_TEMPERATURE_CRITICAL) * 100
	var/radioactivity_spice_multiplier = 1 //Some gasses make the reactor a bit spicy.
	var/depletion_modifier = 0.035 //How rapidly do your rods decay
	gas_absorption_effectiveness = gas_absorption_constant
	//Next up, handle moderators!
	if(moderator_input.total_moles() >= minimum_coolant_level)
		var/total_fuel_moles = moderator_input.get_moles(/datum/gas/plasma) /*+ (moderator_input.get_moles(/datum/gas/plasma_constricted)*2)*/+ (moderator_input.get_moles(/datum/gas/tritium)*10) //Constricted plasma isnt real //Constricted plasma is 50% more efficient as fuel than plasma, but is harder to produce
		var/power_modifier = max((moderator_input.get_moles(/datum/gas/oxygen) / moderator_input.total_moles() * 10), 1) //You can never have negative IPM. For now.
		if(total_fuel_moles >= minimum_coolant_level) //You at least need SOME fuel.
			var/power_produced = max((total_fuel_moles / moderator_input.total_moles() * 10), 1)
			last_power_produced = max(0,((power_produced*power_modifier)*moderator_input.total_moles()))
			last_power_produced *= (max(0,power)/100) //Aaaand here comes the cap. Hotter reactor => more power.
			last_power_produced *= base_power_modifier //Finally, we turn it into actual usable numbers.
			radioactivity_spice_multiplier += moderator_input.get_moles(/datum/gas/tritium) / 5 //Chernobyl 2.
			var/turf/T = get_turf(src)
			if(power >= 20)
				coolant_output.adjust_moles(/datum/gas/nucleium, total_fuel_moles/20) //Shove out nucleium into the air when it's fuelled. You need to filter this off, or you're gonna have a bad time.
			var/obj/structure/cable/C = T.get_cable_node()
			if(!C?.powernet)
				return
			else
				C.powernet.newavail += last_power_produced
		var/total_control_moles = moderator_input.get_moles(/datum/gas/nitrogen) + (moderator_input.get_moles(/datum/gas/carbon_dioxide)*2) + (moderator_input.get_moles(/datum/gas/pluoxium)*3) //N2 helps you control the reaction at the cost of making it absolutely blast you with rads. Pluoxium has the same effect but without the rads!
		if(total_control_moles >= minimum_coolant_level)
			var/control_bonus = total_control_moles / 250 //1 mol of n2 -> 0.002 bonus control rod effectiveness, if you want a super controlled reaction, you'll have to sacrifice some power.
			control_rod_effectiveness = initial(control_rod_effectiveness) + control_bonus
			radioactivity_spice_multiplier += moderator_input.get_moles(/datum/gas/nitrogen) / 25 //An example setup of 50 moles of n2 (for dealing with spent fuel) leaves us with a radioactivity spice multiplier of 3.
			radioactivity_spice_multiplier += moderator_input.get_moles(/datum/gas/carbon_dioxide) / 12.5
		var/total_permeability_moles = moderator_input.get_moles(/datum/gas/bz) + (moderator_input.get_moles(/datum/gas/water_vapor)*2) + (moderator_input.get_moles(/datum/gas/hypernoblium)*10)
		if(total_permeability_moles >= minimum_coolant_level)
			var/permeability_bonus = total_permeability_moles / 500
			gas_absorption_effectiveness = gas_absorption_constant + permeability_bonus
		var/total_degradation_moles = moderator_input.get_moles(/datum/gas/nitryl) //Because it's quite hard to get.
		if(total_degradation_moles >= minimum_coolant_level*0.5) //I'll be nice.
			depletion_modifier += total_degradation_moles / 15 //Oops! All depletion. This causes your fuel rods to get SPICY.
			playsound(src, pick('sound/machines/sm/accent/normal/1.ogg','sound/machines/sm/accent/normal/2.ogg','sound/machines/sm/accent/normal/3.ogg','sound/machines/sm/accent/normal/4.ogg','sound/machines/sm/accent/normal/5.ogg'), 100, TRUE)
		//From this point onwards, we clear out the remaining gasses.
		moderator_input.clear() //Woosh. And the soul is gone.
		K += total_fuel_moles / 1000
	var/fuel_power = 0 //So that you can't magically generate K with your control rods.
	if(!has_fuel())  //Reactor must be fuelled and ready to go before we can heat it up boys.
		K = 0
	else
		for(var/obj/item/twohanded/required/fuel_rod/FR in fuel_rods)
			K += FR.fuel_power
			fuel_power += FR.fuel_power
			FR.deplete(depletion_modifier)
	//Firstly, find the difference between the two numbers.
	var/difference = abs(K - desired_k)
	//Then, hit as much of that goal with our cooling per tick as we possibly can.
	difference = CLAMP(difference, 0, control_rod_effectiveness) //And we can't instantly zap the K to what we want, so let's zap as much of it as we can manage....
	if(difference > fuel_power && desired_k > K)
		difference = fuel_power //Again, to stop you being able to run off of 1 fuel rod.
	if(K != desired_k)
		if(desired_k > K)
			K += difference
		else if(desired_k < K)
			K -= difference

	K = CLAMP(K, 0, RBMK_MAX_CRITICALITY)
	if(has_fuel())
		temperature += K
	else
		temperature -= 10 //Nothing to heat us up, so.
	handle_alerts() //Let's check if they're about to die, and let them know.
	update_icon()
	radiation_pulse(src, temperature*radioactivity_spice_multiplier)
	if(power >= 90)
		if(last_flicker_power_level <= 0)
			last_flicker_power_level = power
		if((power >= 100 || power > last_flicker_power_level + 1) && world.time >= next_flicker) //You're overloading the reactor. Give a more subtle warning that power is getting out of control.
			next_flicker = world.time + 1.5 MINUTES
			last_flicker_power_level = power
			for(var/obj/machinery/light/L in GLOB.machines)
				if(prob(25) && shares_overmap(src, L)) //If youre running the reactor cold though, no need to flicker the lights.
					L.flicker()
	for(var/atom/movable/I in get_turf(src))
		if(isliving(I))
			var/mob/living/L = I
			if(temperature > 0)
				L.adjust_bodytemperature(CLAMP(temperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)) //If you're on fire, you heat up!
		if(istype(I, /obj/item/reagent_containers/food) && !istype(I, /obj/item/reagent_containers/food/drinks))
			playsound(src, pick('sound/machines/fryer/deep_fryer_1.ogg', 'sound/machines/fryer/deep_fryer_2.ogg'), 100, TRUE)
			var/obj/item/reagent_containers/food/grilled_item = I
			if(prob(80))
				return //To give the illusion that it's actually cooking omegalul.
			switch(power)
				if(20 to 39)
					grilled_item.name = "grilled [initial(grilled_item.name)]"
					grilled_item.desc = "[initial(I.desc)] It's been grilled over a nuclear reactor."
					if(!(grilled_item.foodtype & FRIED))
						grilled_item.foodtype |= FRIED
				if(40 to 70)
					grilled_item.name = "heavily grilled [initial(grilled_item.name)]"
					grilled_item.desc = "[initial(I.desc)] It's been heavily grilled through the magic of nuclear fission."
					if(!(grilled_item.foodtype & FRIED))
						grilled_item.foodtype |= FRIED
				if(70 to 95)
					grilled_item.name = "Three-Mile Nuclear-Grilled [initial(grilled_item.name)]"
					grilled_item.desc = "A [initial(grilled_item.name)]. It's been put on top of a nuclear reactor running at extreme power by some badass engineer."
					if(!(grilled_item.foodtype & FRIED))
						grilled_item.foodtype |= FRIED
				if(95 to INFINITY)
					grilled_item.name = "Ultimate Meltdown Grilled [initial(grilled_item.name)]"
					grilled_item.desc = "A [initial(grilled_item.name)]. A grill this perfect is a rare technique only known by a few engineers who know how to perform a 'controlled' meltdown whilst also having the time to throw food on a reactor. I'll bet it tastes amazing."
					if(!(grilled_item.foodtype & FRIED))
						grilled_item.foodtype |= FRIED

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/reset_direction()
	SetInitDirections()
	for(var/i=1,i<=nodes.len,i++)
		var/obj/machinery/atmospherics/node = nodes[i]
		if(node)
			node.disconnect(src)
			nodes[i] = null
	for(var/parent in parents)
		nullifyPipenet(parent)
	atmosinit()
	for(var/i=1,i<=nodes.len,i++)
		var/obj/machinery/atmospherics/node = nodes[i]
		node.atmosinit()
		node.addMember(src)
	build_network()
	//SSair.add_to_rebuild_queue(src)
	original_dir = dir

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/default_change_direction_wrench(mob/user, obj/item/I)
	if(datum_flags & DF_ISPROCESSING)
		to_chat(user, "<span class='warning'>You cannot rotate the [src] while it is operating.</span>")
		return FALSE
	if(I.tool_behaviour == TOOL_WRENCH)
		I.play_tool_sound(src, 50)
		setDir(turn(dir,-90))
		reset_direction()
		to_chat(user, "<span class='notice'>You rotate the [src]'s piping 90 degrees.</span>")
		return TRUE
	return FALSE

//Method to handle sound effects, reactor warnings, all that jazz.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/handle_alerts()
	var/alert = FALSE //If we have an alert condition, we'd best let people know.
	if(K <= 0 && temperature <= 0)
		shut_down()
	//First alert condition: Overheat
	if(temperature >= RBMK_TEMPERATURE_CRITICAL)
		alert = TRUE
		if(temperature >= RBMK_TEMPERATURE_MELTDOWN)
			var/temp_damage = min(temperature/100, initial(vessel_integrity)/40)	//40 seconds to meltdown from full integrity, worst-case. Bit less than blowout since it's harder to spike heat that much.
			vessel_integrity -= temp_damage
			play_damage_alarm()
			log_reactor("[src] now at MELTDOWN temperature of [temperature]c. Integrity at [(vessel_integrity/initial(vessel_integrity)*100)]% at [x] [y] [z] in [get_area(src)]",50)
			if(vessel_integrity <= temp_damage) //It wouldn't be able to tank another hit.
				meltdown() //Oops! All meltdown
				return
		else
			log_reactor("[src] now at critical temperature of [temperature]c. Integrity at [(vessel_integrity/initial(vessel_integrity)*100)]% at [x] [y] [z] in [get_area(src)]",150)
	else
		alert = FALSE
	if(temperature < -200) //That's as cold as I'm letting you get it, engineering.
		color = COLOR_CYAN
		temperature = -200
	else
		color = null
	//Second alert condition: Overpressurized (the more lethal one)
	if(pressure >= RBMK_PRESSURE_CRITICAL)
		alert = TRUE
		shake_animation(0.5)
		playsound(loc, 'sound/machines/clockcult/steam_whoosh.ogg', 100, TRUE)
		var/turf/T = get_turf(src)
		T.atmos_spawn_air("water_vapor=[pressure/100];TEMP=[CELSIUS_TO_KELVIN(temperature)]")
		var/pressure_damage = min(pressure/100, initial(vessel_integrity)/45)	//You get 45 seconds (if you had full integrity), worst-case. But hey, at least it can't be instantly nuked with a pipe-fire.. though it's still very difficult to save.
		vessel_integrity -= pressure_damage
		play_damage_alarm()
		log_reactor("[src] now at overpressure of [pressure]. Integrity at [(vessel_integrity/initial(vessel_integrity)*100)]% at [x] [y] [z] in [get_area(src)]",50)
		if(vessel_integrity <= pressure_damage) //It wouldn't be able to tank another hit.
			blowout()
			return
	/*var/obj/structure/overmap/OM = get_overmap()
	if(!OM) //Can't be bothered to do this any other way ;)
		return*/
	if(warning)
		if(!alert) //Congrats! You stopped the meltdown / blowout.
			//OM.stop_relay(CHANNEL_REACTOR_ALERT)
			stop_relay(CHANNEL_REACTOR_ALERT)
			warning = FALSE
			set_light(0)
			light_color = LIGHT_COLOR_CYAN
			set_light(10)
	else
		if(!alert)
			return
		if(world.time < next_warning)
			return
		next_warning = world.time + 30 SECONDS //To avoid engis pissing people off when reaaaally trying to stop the meltdown or whatever.
		warning = TRUE //Start warning the crew of the imminent danger.
		//OM.relay('sound/toolbox/reactor/alarm.ogg', null, loop=TRUE, channel = CHANNEL_REACTOR_ALERT)
		relay('sound/toolbox/reactor/alarm.ogg', null, loop=TRUE, channel = CHANNEL_REACTOR_ALERT)
		set_light(0)
		light_color = LIGHT_COLOR_RED
		set_light(10)

//Failure condition 1: Meltdown. Achieved by having heat go over tolerances. This is less devastating because it's easier to achieve.
//Results: Engineering becomes unusable and your engine irreparable
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/meltdown()
	set waitfor = FALSE
	investigate_log("[src] has got into meltdown at [x] [y] [z] in [get_area(src)].", NUCLEAR_REACTOR_RBMK)
	SSair.atmos_machinery -= src //Annd we're now just a useless brick.
	color = null
	slagged = TRUE
	update_icon()
	STOP_PROCESSING(SSmachines, src)
	icon_state = "reactor_slagged"
	AddComponent(/datum/component/radioactive, 15000 , src, 0)
	//var/obj/structure/overmap/OM = get_overmap()
	//OM.relay('sound/toolbox/reactor/meltdown.ogg', "<span class='userdanger'>You hear a horrible metallic hissing.</span>")
	relay('sound/toolbox/reactor/meltdown.ogg', "<span class='userdanger'>You hear a horrible metallic hissing.</span>")
	stop_relay(CHANNEL_REACTOR_ALERT)
	var/obj/effect/landmark/nuclear_waste_spawner/NSW
	var/turf/srcturf = get_turf(src)
	if(isturf(srcturf))
		NSW = new /obj/effect/landmark/nuclear_waste_spawner/strong(get_turf(srcturf))
		var/list/sludge_landmarks = list(
			/obj/effect/landmark/nuclear_waste_spawner/strong = 2,
			/obj/effect/landmark/nuclear_waste_spawner/weak = 5,
			/obj/effect/landmark/nuclear_waste_spawner = 10)
		var/list/viable_turfs = list()
		var/thez = srcturf.z
		for(var/turf/open/floor/F in block(locate(1,1,thez),locate(world.maxx,world.maxy,thez)))
			if(F == srcturf)
				continue
			viable_turfs += F
		if(viable_turfs.len)
			for(var/i=25,i>0,i--)
				var/turf/T = pick(viable_turfs)
				var/chosen = pickweight(sludge_landmarks)
				new chosen(T)
				viable_turfs.Remove(T)
		viable_turfs.Cut()
	if(NSW)
		NSW.fire() //This will take out engineering for a decent amount of time as they have to clean up the sludge.
	for(var/obj/machinery/power/apc/A in GLOB.apcs_list)
		if(shares_overmap(src, A) && prob(70))
			A.overload_lighting()
	var/datum/gas_mixture/coolant_input = COOLANT_INPUT_GATE
	var/datum/gas_mixture/moderator_input = MODERATOR_INPUT_GATE
	var/datum/gas_mixture/coolant_output = COOLANT_OUTPUT_GATE
	var/turf/T = get_turf(src)
	coolant_input.set_temperature(CELSIUS_TO_KELVIN(temperature)*2)
	moderator_input.set_temperature(CELSIUS_TO_KELVIN(temperature)*2)
	coolant_output.set_temperature(CELSIUS_TO_KELVIN(temperature)*2)
	T.assume_air(coolant_input)
	T.assume_air(moderator_input)
	T.assume_air(coolant_output)
	explosion(get_turf(src), 0, 5, 10, 20, TRUE, TRUE)
	empulse(get_turf(src), 25, 15)
	fail_meltdown_objective()

//Failure condition 2: Blowout. Achieved by reactor going over-pressured. This is a round-ender because it requires more fuckery to achieve.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/blowout()
	investigate_log("[src] has exploded in full at [x] [y] [z] in [get_area(src)].", NUCLEAR_REACTOR_RBMK)
	explosion(get_turf(src), GLOB.MAX_EX_DEVESTATION_RANGE, GLOB.MAX_EX_HEAVY_RANGE, GLOB.MAX_EX_LIGHT_RANGE, GLOB.MAX_EX_FLASH_RANGE)
	meltdown() //Double kill.
	//var/obj/structure/overmap/OM = get_overmap()
	//OM.relay('sound/toolbox/reactor/explode.ogg')
	relay('sound/toolbox/reactor/explode.ogg')
	//if(OM?.role == MAIN_OVERMAP) //Irradiate the shit out of the player ship
	if(is_station_level(z))
		SSweather.run_weather("nuclear fallout")
	for(var/X in GLOB.landmarks_list)
		if(istype(X, /obj/effect/landmark/nuclear_waste_spawner))
			var/obj/effect/landmark/nuclear_waste_spawner/WS = X
			if(shares_overmap(src, WS)) //Begin the SLUDGING
				WS.fire()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/repair()
	if(!slagged)
		return
	vessel_integrity = initial(vessel_integrity)
	slagged = FALSE
	power = 0
	temperature = 0
	var/datum/component/R = GetComponent(/datum/component/radioactive)
	if(istype(R))
		R.RemoveComponent()
	SSair.atmos_machinery += src
	shut_down()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/fail_meltdown_objective()
	for(var/client/C in GLOB.clients)
		if(CONFIG_GET(flag/allow_crew_objectives))
			var/mob/M = C.mob
			if(M?.mind?.current && LAZYLEN(M.mind.crew_objectives) && (M.job == "Station Engineer" || M.job == "Chief Engineer" || M.job == "Atmospheric Technician"))
				for(var/datum/objective/crew/meltdown/MO in M.mind.crew_objectives)
					MO.meltdown = TRUE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/update_icon()
	icon_state = "reactor_off"
	switch(temperature)
		if(0 to 200)
			icon_state = "reactor_on"
		if(200 to RBMK_TEMPERATURE_OPERATING)
			icon_state = "reactor_hot"
		if(RBMK_TEMPERATURE_OPERATING to 750)
			icon_state = "reactor_veryhot"
		if(750 to RBMK_TEMPERATURE_CRITICAL) //Point of no return.
			icon_state = "reactor_overheat"
		if(RBMK_TEMPERATURE_CRITICAL to INFINITY)
			icon_state = "reactor_meltdown"
	if(!has_fuel())
		icon_state = "reactor_off"
	if(slagged)
		icon_state = "reactor_slagged"

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/log_reactor(message,nospam)
	if(nospam > 0 && last_admin_alert && last_admin_alert+nospam > world.time)
		return
	last_admin_alert = world.time
	investigate_log("[message]", NUCLEAR_REACTOR_RBMK)

//Startup, shutdown

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/start_up(mob/user)
	if(slagged)
		return // No :)
	START_PROCESSING(SSmachines, src)
	desired_k = 1
	set_light(10)
	var/area/AR = get_area(src)
	AR.set_looping_ambience('sound/toolbox/reactor/reactor_hum.ogg')
	var/startup_sound = pick('sound/toolbox/reactor/startup.ogg', 'sound/toolbox/reactor/startup2.ogg')
	playsound(loc, startup_sound, 100)
	var/logged_user = "noone"
	if(istype(user))
		logged_user = "[user]([user.key])"
	else if(istext(user))
		logged_user = "[user]"
	investigate_log("[logged_user] has started up the [src] at  [x] [y] [z] in [get_area(src)].", NUCLEAR_REACTOR_RBMK)

//Shuts off the fuel rods, ambience, etc. Keep in mind that your temperature may still go up!
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/shut_down()
	investigate_log("[src] has gone into shutdown at [x] [y] [z] in [get_area(src)].", NUCLEAR_REACTOR_RBMK)
	STOP_PROCESSING(SSmachines, src)
	set_light(0)
	var/area/AR = get_area(src)
	AR.set_looping_ambience('sound/ambience/shipambience.ogg')
	K = 0
	desired_k = 0
	temperature = 0
	update_icon()

//We didnt have this proc. It existed on the source we stole the rbmk from so i had to make it here to make porting this easier because im lazy. We may need to fix this if we port more shit. -Falaskian
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/shares_overmap(A,B)
	if(istype(A,/atom) && istype(B,/atom))
		var/atom/Aatom = A
		var/atom/Batom = B
		if(Aatom.z && Batom.z && Aatom.z == Batom.z)
			return TRUE
	return FALSE

//controlling sounds. This code was adapted from some unnecessary bullshit i saw in another source. -falaskian
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/relay(S, var/message=null, loop = FALSE, channel = null) //Sends a sound + text message to the crew of a ship
	var/list/mobs_in_ship = list()
	for(var/mob/M in GLOB.player_list)
		var/turf/T = get_turf(M)
		if(istype(T) && T.z == z)
			mobs_in_ship += M
	for(var/mob/M as() in mobs_in_ship)
		if(M.can_hear())
			if(channel) //Doing this forbids overlapping of sounds
				SEND_SOUND(M, sound(S, repeat = loop, wait = 0, volume = 100, channel = channel))
			else
				SEND_SOUND(M, sound(S, repeat = loop, wait = 0, volume = 100))
		if(message)
			to_chat(M, message)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/stop_relay(channel) //Stops all playing sounds for crewmen on N channel.
	var/list/mobs_in_ship = list()
	for(var/mob/M in GLOB.player_list)
		var/turf/T = get_turf(M)
		if(istype(T) && T.z == z)
			mobs_in_ship += M
	for(var/mob/M as() in mobs_in_ship)
		M.stop_sound_channel(channel)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/shake_animation(var/intensity = 8) //Makes the object visibly shake
	var/initial_transform = new/matrix(transform)
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/rotation = 2+soft_cap(intensity, 1, 1, 0.94)
	var/offset = 1+soft_cap(intensity*0.3, 1, 1, 0.8)
	var/time = 2+soft_cap(intensity*0.3, 2, 1, 0.92)
	animate(src, transform=turn(transform, rotation*shake_dir), pixel_x=init_px + offset*shake_dir, time=1)
	animate(transform=initial_transform, pixel_x=init_px, time=time, easing=ELASTIC_EASING)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/play_damage_alarm(timedelay = 150)
	if(last_alarm_sound+timedelay > world.time)
		return
	last_alarm_sound = world.time
	playsound(src, 'sound/machines/engine_alert2.ogg', 100)

/proc/soft_cap(var/input, var/cap = 0, var/groupsize = 1, var/groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output

//rods
/*/obj/item/twohanded/required/fuel_rod/Initialize()
	. = ..()
	//AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	AddComponent(/datum/component/radioactive, 350 , src)*/

//Controlling the reactor.

/obj/machinery/computer/reactor
	name = "reactor control console"
	desc = "Scream"
	light_color = "#55BA55"
	light_power = 1
	light_range = 3
	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = null
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor = null
	var/id = "default_reactor_for_lazy_mappers"

/obj/machinery/computer/reactor/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	addtimer(CALLBACK(src, .proc/link_to_reactor), 10 SECONDS)

/obj/machinery/computer/reactor/proc/link_to_reactor()
	for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/asdf in GLOB.machines)
		if(asdf.id && asdf.id == id)
			reactor = asdf
			return TRUE
	return FALSE

#define FREQ_RBMK_CONTROL 1439.69

/obj/machinery/computer/reactor/control_rods
	name = "control rod management computer"
	desc = "A computer which can remotely raise / lower the control rods of a reactor."
	icon_screen = "rbmk_rods"

/obj/machinery/computer/reactor/control_rods/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/machinery/computer/reactor/control_rods/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RbmkControlRods")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/computer/reactor/control_rods/ui_act(action, params)
	if(..())
		return
	if(!reactor)
		return
	if(action == "input")
		var/input = text2num(params["target"])
		reactor.desired_k = CLAMP(input, 0, 3)
		investigate_log("[usr]([usr.key]) has attempted to change the rbmk reactors K to [reactor.desired_k].", NUCLEAR_REACTOR_RBMK)

/obj/machinery/computer/reactor/control_rods/ui_data(mob/user)
	var/list/data = list()
	data["control_rods"] = 0
	data["k"] = 0
	data["desiredK"] = 0
	if(reactor)
		data["k"] = reactor.K
		data["desiredK"] = reactor.desired_k
		data["control_rods"] = 100 - (reactor.desired_k / 3 * 100) //Rod insertion is extrapolated as a function of the percentage of K
	return data

/obj/machinery/computer/reactor/stats
	name = "reactor statistics console"
	desc = "A console for monitoring the statistics of a nuclear reactor."
	icon_screen = "rbmk_stats"
	var/next_stat_interval = 0
	var/list/psiData = list()
	var/list/powerData = list()
	var/list/tempInputData = list()
	var/list/tempOutputdata = list()

/obj/machinery/computer/reactor/stats/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/machinery/computer/reactor/stats/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RbmkStats")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/computer/reactor/stats/process()
	if(world.time >= next_stat_interval)
		next_stat_interval = world.time + 1 SECONDS //You only get a slow tick.
		psiData += (reactor) ? reactor.pressure : 0
		if(psiData.len > 100) //Only lets you track over a certain timeframe.
			psiData.Cut(1, 2)
		powerData += (reactor) ? reactor.power*10 : 0 //We scale up the figure for a consistent:tm: scale
		if(powerData.len > 100) //Only lets you track over a certain timeframe.
			powerData.Cut(1, 2)
		tempInputData += (reactor) ? reactor.last_coolant_temperature : 0 //We scale up the figure for a consistent:tm: scale
		if(tempInputData.len > 100) //Only lets you track over a certain timeframe.
			tempInputData.Cut(1, 2)
		tempOutputdata += (reactor) ? reactor.last_output_temperature : 0 //We scale up the figure for a consistent:tm: scale
		if(tempOutputdata.len > 100) //Only lets you track over a certain timeframe.
			tempOutputdata.Cut(1, 2)

/obj/machinery/computer/reactor/stats/ui_data(mob/user)
	var/list/data = list()
	data["powerData"] = powerData
	data["psiData"] = psiData
	data["tempInputData"] = tempInputData
	data["tempOutputdata"] = tempOutputdata
	data["coolantInput"] = reactor ? reactor.last_coolant_temperature : 0
	data["coolantOutput"] = reactor ? reactor.last_output_temperature : 0
	data["power"] = reactor ? reactor.power : 0
	data ["psi"] = reactor ? reactor.pressure : 0
	return data

/obj/machinery/computer/reactor/fuel_rods
	name = "Reactor Fuel Management Console"
	desc = "A console which can remotely raise fuel rods out of nuclear reactors."
	icon_screen = "rbmk_fuel"

/obj/machinery/computer/reactor/fuel_rods/ui_interact(user)
	if(!reactor)
		to_chat(user, "<span class='warning'>No reactor found.</span>")
		return FALSE
	var/datum/browser/popup = new(user, "fuelrodsmenu", "[name]", 380, 400)
	var/dat = "<B>Reactor Fuel Rods:</B><BR><BR>"
	var/poweredup = 0
	if(reactor.power > 20)
		poweredup = 1
		dat += "<B>Notice:</B> You cannot remove fuel from [reactor] while it is running above 20% power.<br><br>"
	if(reactor.fuel_rods.len)
		var/number = 0
		for(var/obj/item/twohanded/required/fuel_rod/F in reactor.fuel_rods)
			number++
			var/rodtime
			if(reactor.fuel_rods[F])
				var/rodinserted = reactor.fuel_rods[F]
				rodtime = world.time-rodinserted
				var/hours = 0
				while(rodtime > 36000)
					hours++
					rodtime -= 36000
				var/minutes = 0
				if(rodtime > 600)
					minutes++
					rodtime -= 600
				rodtime = "<B>Duration Inserted:</B> "
				if(hours > 0)
					rodtime = "[hours]h"
				rodtime += "[minutes]m"
			var/removebuttontext = "<A href='?src=\ref[src];fuelrod=\ref[F]'>Remove</A>"
			if(poweredup)
				removebuttontext = "<B>Locked</B>"
			dat += "<B>Fuel Rod #[number]: </B><br>[rodtime]<br>[removebuttontext]<br><br>"
	else
		dat += "No fuel rods detected."
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/reactor/fuel_rods/Topic(href, list/href_list)
	. = ..()
	if(href_list["fuelrod"])
		if(!reactor)
			return
		if(reactor.power > 20)
			to_chat(usr, "<span class='warning'>You cannot remove fuel from [reactor] while it is running above 20% power.</span>")
			return
		var/obj/item/twohanded/required/fuel_rod/rod = locate(href_list["fuelrod"])
		if(istype(rod) && (rod in reactor.fuel_rods))
			to_chat(usr, "<span class='notice'>You remove [rod.name] from the [reactor].</span>")
			reactor.remove_fuel_rod(rod)
			playsound(src, pick('sound/toolbox/reactor/switch.ogg','sound/toolbox/reactor/switch2.ogg','sound/toolbox/reactor/switch3.ogg'), 100, FALSE)
			ui_interact(usr)

//debug href console for reactor
/obj/machinery/computer/reactor/debug
	name = "reactor debug console"
	desc = "A debug console for the reactor."
	icon_screen = "rbmk_stats"

/obj/machinery/computer/reactor/debug/ui_interact(user)
	var/dat = ""
	if(!reactor)
		dat += "No reactor found"
	else
		var/list/data = list(
		"coolantInput" = reactor.last_coolant_temperature,
		"coolantOutput" = reactor.last_output_temperature,
		"power" = reactor.power,
		"psi" = reactor.pressure
		)
		dat += "<B>Reactor Legend:</B><BR>"
		dat += "Reactor Power (%) [data["power"]]<br>"
		dat += "Reactor Pressure (PSI) [data["psi"]]<br>"
		dat += "Coolant input (C) [data["coolantInput"]]<br>"
		dat += "Coolant output (C) [data["coolantOutput"]]<br>"
		var/currentk = 100 - (reactor.K / 3 * 100)
		var/desiredk = 100 - (reactor.desired_k / 3 * 100)
		dat += "<br><B>Control Rods: Inserted [round(currentk)]%</B><br>"
		if(currentk != desiredk)
			dat += "Attempting to move them to [round(desiredk)]%<br>"
		dat += "<a href='?src=\ref[src];controlrodsup=1'>Raise</a> | <a href='?src=\ref[src];controlrodsdown=1'>Lower</a>"
	var/datum/browser/popup = new(user, "reactor", "Reactor Debug", 400, 700)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/reactor/debug/Topic(href, href_list)
	. = ..()
	if(reactor)
		if(href_list["controlrodsdown"])
			reactor.desired_k = max(reactor.desired_k-1,0)
		if(href_list["controlrodsup"])
			reactor.desired_k = min(reactor.desired_k+1,3)
		ui_interact(usr)

//Preset pumps for mappers. You can also set the id tags yourself.
/obj/machinery/atmospherics/components/binary/pump/rbmk_input
	id = "rbmk_input"
	frequency = FREQ_RBMK_CONTROL

/obj/machinery/atmospherics/components/binary/pump/rbmk_output
	id = "rbmk_output"
	frequency = FREQ_RBMK_CONTROL

/obj/machinery/atmospherics/components/binary/pump/rbmk_moderator
	id = "rbmk_moderator"
	frequency = FREQ_RBMK_CONTROL

/obj/machinery/computer/reactor/pump
	name = "reactor inlet valve computer"
	desc = "A computer which controls valve settings on an advanced gas cooled reactor. Alt click it to remotely set pump pressure."
	icon_state = "reactorswitch_off"
	//icon_screen = "reactorswitch_off"
	id = "rbmk_input"
	icon = 'icons/oldschool/reactor/switches.dmi'
	var/datum/radio_frequency/radio_connection
	var/on = FALSE

/obj/machinery/computer/reactor/pump/Initialize()
	. = ..()
	update_icon()

/obj/machinery/computer/reactor/pump/update_icon()
	overlays.Cut()
	icon_state = "reactorswitch_[on ? "on" : "off"]"
	if(!(stat & (NOPOWER|BROKEN)))
		var/icon/I = icon(icon,"[icon_state]light")
		overlays += I

/obj/machinery/computer/reactor/pump/AltClick(mob/user)
	. = ..()
	var/newPressure = input(user, "Set new output pressure (kPa)", "Remote pump control", null) as num
	if(!newPressure)
		return
	newPressure = clamp(newPressure, 0, MAX_OUTPUT_PRESSURE) //Number sanitization is not handled in the pumps themselves, only during their ui_act which this doesn't use.
	signal(on, newPressure)
	update_icon()

/obj/machinery/computer/reactor/attack_robot(mob/user)
	. = ..()
	attack_hand(user)

/obj/machinery/computer/reactor/attack_ai(mob/user)
	. = ..()
	attack_hand(user)

/obj/machinery/computer/reactor/pump/attack_hand(mob/living/user)
	. = ..()
	if(!is_operational())
		return FALSE
	playsound(loc, pick('sound/toolbox/reactor/switch.ogg','sound/toolbox/reactor/switch2.ogg','sound/toolbox/reactor/switch3.ogg'), 100, FALSE)
	visible_message("<span class='notice'>[src]'s switch flips [on ? "off" : "on"].</span>")
	on = !on
	signal(on)
	update_icon()

/obj/machinery/computer/reactor/pump/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	radio_connection = SSradio.add_object(src, FREQ_RBMK_CONTROL,filter=RADIO_ATMOSIA)

/obj/machinery/computer/reactor/pump/proc/signal(power, set_output_pressure=null)
	var/datum/signal/signal
	if(!set_output_pressure) //Yes this is stupid, but technically if you pass through "set_output_pressure" onto the signal, it'll always try and set its output pressure and yeahhh...
		signal = new(list(
			"tag" = id,
			"frequency" = FREQ_RBMK_CONTROL,
			"timestamp" = world.time,
			"power" = power,
			"sigtype" = "command"
		))
	else
		signal = new(list(
			"tag" = id,
			"frequency" = FREQ_RBMK_CONTROL,
			"timestamp" = world.time,
			"power" = power,
			"set_output_pressure" = set_output_pressure,
			"sigtype" = "command"
		))
	radio_connection.post_signal(src, signal, filter=RADIO_ATMOSIA)

//Preset subtypes for mappers
/obj/machinery/computer/reactor/pump/rbmk_input
	name = "Reactor inlet valve computer"
	icon_screen = "rbmk_input"
	id = "rbmk_input"

/obj/machinery/computer/reactor/pump/rbmk_output
	name = "Reactor output valve computer"
	icon_screen = "rbmk_output"
	id = "rbmk_output"

/obj/machinery/computer/reactor/pump/rbmk_moderator
	name = "Reactor moderator valve computer"
	icon_screen = "rbmk_moderator"
	id = "rbmk_moderator"

//SPENT FUEL POOL
//FINALLY WE CAN RECREATE THE ROBLOX NUCLEAR DISASTER - 18/08/2020

/turf/open/indestructible/sound/pool/spentfuel
	name = "Spent fuel pool"
	desc = "A dumping ground for spent nuclear fuel, can you touch the bottom?"
	icon = 'icons/obj/pool.dmi'
	icon_state = "spentfuelpool"

/turf/open/indestructible/sound/pool/spentfuel/wall
	icon_state = "spentfuelpoolwall"

//Monitoring program.
/datum/computer_file/program/nuclear_monitor
	filename = "rbmkmonitor"
	filedesc = "Nuclear Reactor Monitoring"
	ui_header = "smmon_0.gif"
	program_icon_state = "smmon_0"
	extended_desc = "This program connects to specially calibrated sensors to provide information on the status of nuclear reactors."
	requires_ntnet = TRUE
	transfer_access = ACCESS_CONSTRUCTION
	network_destination = "rbmk monitoring system"
	size = 2
	tgui_id = "NtosRbmkStats"
	var/active = TRUE //Easy process throttle
	var/next_stat_interval = 0
	var/list/psiData = list()
	var/list/powerData = list()
	var/list/tempInputData = list()
	var/list/tempOutputdata = list()
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor //Our reactor.

/datum/computer_file/program/nuclear_monitor/process_tick()
	..()
	if(!reactor || !active)
		return FALSE
	var/stage = 0
	//This is dirty but i'm lazy wahoo!
	if(reactor.power > 0)
		stage = 1
	if(reactor.power >= 40)
		stage = 2
	if(reactor.temperature >= RBMK_TEMPERATURE_OPERATING)
		stage = 3
	if(reactor.temperature >= RBMK_TEMPERATURE_CRITICAL)
		stage = 4
	if(reactor.temperature >= RBMK_TEMPERATURE_MELTDOWN)
		stage = 5
		if(reactor.vessel_integrity <= 100) //Bye bye! GET OUT!
			stage = 6
	ui_header = "smmon_[stage].gif"
	program_icon_state = "smmon_[stage]"
	if(istype(computer))
		computer.update_icon()
	if(world.time >= next_stat_interval)
		next_stat_interval = world.time + 1 SECONDS //You only get a slow tick.
		psiData += (reactor) ? reactor.pressure : 0
		if(psiData.len > 100) //Only lets you track over a certain timeframe.
			psiData.Cut(1, 2)
		powerData += (reactor) ? reactor.power*10 : 0 //We scale up the figure for a consistent:tm: scale
		if(powerData.len > 100) //Only lets you track over a certain timeframe.
			powerData.Cut(1, 2)
		tempInputData += (reactor) ? reactor.last_coolant_temperature : 0 //We scale up the figure for a consistent:tm: scale
		if(tempInputData.len > 100) //Only lets you track over a certain timeframe.
			tempInputData.Cut(1, 2)
		tempOutputdata += (reactor) ? reactor.last_output_temperature : 0 //We scale up the figure for a consistent:tm: scale
		if(tempOutputdata.len > 100) //Only lets you track over a certain timeframe.
			tempOutputdata.Cut(1, 2)

/datum/computer_file/program/nuclear_monitor/run_program(mob/living/user)
	. = ..(user)
	//No reactor? Go find one then.
	if(!reactor)
		for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/R in GLOB.machines)
			if(R.shares_overmap(user, R))
				reactor = R
				break
	active = TRUE

/datum/computer_file/program/nuclear_monitor/kill_program(forced = FALSE)
	active = FALSE
	..()

/datum/computer_file/program/nuclear_monitor/ui_data()
	var/list/data = get_header_data()
	data["powerData"] = powerData
	data["psiData"] = psiData
	data["tempInputData"] = tempInputData
	data["tempOutputdata"] = tempOutputdata
	data["coolantInput"] = reactor ? reactor.last_coolant_temperature : 0
	data["coolantOutput"] = reactor ? reactor.last_output_temperature : 0
	data["power"] = reactor ? reactor.power : 0
	data ["psi"] = reactor ? reactor.pressure : 0
	return data

/datum/computer_file/program/nuclear_monitor/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("swap_reactor")
			var/list/choices = list()
			for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/R in GLOB.machines)
				if(!R.shares_overmap(usr, R))
					continue
				choices += R
			reactor = input(usr, "What reactor do you wish to monitor?", "[src]", null) as null|anything in choices
			powerData = list()
			psiData = list()
			tempInputData = list()
			tempOutputdata = list()
			return TRUE

//areas
/area/engine/engineering/reactor_core
	name = "Nuclear Reactor Core"

/area/engine/engineering/reactor_control
	name = "Reactor Control Room"

/*				ENGINEERING OBJECTIVES				*/

/datum/objective/crew/integrity //ported from old Hippie
	explanation_text = "Ensure the station's integrity rating is at least (Something broke, yell on GitHub)% when the shift ends."
	jobs = "chiefengineer,stationengineer"

/datum/objective/crew/integrity/New()
	. = ..()
	target_amount = rand(60,95)
	update_explanation_text()

/datum/objective/crew/integrity/update_explanation_text()
	. = ..()
	explanation_text = "Ensure the station's integrity rating is at least [target_amount]% when the shift ends."

/datum/objective/crew/integrity/check_completion()
	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()
	var/station_integrity = min(PERCENT(GLOB.start_state.score(end_state)), 100)
	if(!SSticker.mode.station_was_nuked && station_integrity >= target_amount)
		return TRUE
	else
		return FALSE

/datum/objective/crew/poly
	explanation_text = "Make sure Poly keeps his headset, and stays alive until the end of the shift."
	jobs = "chiefengineer"

/datum/objective/crew/poly/check_completion()
	for(var/mob/living/simple_animal/parrot/Poly/dumbbird in GLOB.mob_list)
		if(!(dumbbird.stat == DEAD) && dumbbird.ears)
			if(istype(dumbbird.ears, /obj/item/radio/headset))
				return TRUE
	return FALSE

/datum/objective/crew/meltdown
	explanation_text = "Make sure that the engine does not meltdown while you are on the job."
	jobs = "chiefengineer,stationengineer,atmospherictechnician"
	var/meltdown = FALSE

/datum/objective/crew/meltdown/check_completion()
	if(meltdown)
		return FALSE
	return TRUE

/datum/objective/crew/power_generation
	explanation_text = "Maintain production of x MW in the engine until the end of the shift."
	jobs = "chiefengineer,stationengineer,atmospherictechnician"
	//var/obj/machinery/atmospherics/components/binary/stormdrive_reactor/SD
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/RBMK

/datum/objective/crew/power_generation/New()
	. = ..()
	//SD = locate() in GLOB.machines
	RBMK = locate() in GLOB.machines
	var/base_target_power
	/*if(SD)
		base_target_power = 13000000*/
	if(RBMK)
		base_target_power = 10000000
	else
		base_target_power = 5000000
	var/target_percent = rand(60,90)
	target_amount = base_target_power * target_percent
	update_explanation_text()

/datum/objective/crew/power_generation/update_explanation_text()
	. = ..()
	explanation_text = "Maintain production of [target_amount] Watts in an engine until the end of the shift."

/datum/objective/crew/power_generation/check_completion()
	/*if(SD.last_power_produced >= target_amount)
		return TRUE*/
	if(RBMK.last_power_produced >= target_amount)
		return TRUE
	return FALSE

//traitor fuel rods
/datum/uplink_item/device_tools/tc_rod
	name = "Telecrystal Fuel Rod"
	desc = "This special fuel rod has eight material slots that can be inserted with telecrystals, \
			once the rod has been fully depleted, you will be able to harvest the extra telecrystals. \
			Please note: This Rod fissiles much faster than it's nanotrasen counterpart, it doesn't take \
			much to overload the reactor with these..."
	item = /obj/item/twohanded/required/fuel_rod/material/telecrystal
	cost = 7

//engineering export
/datum/export/plutonium_rod
	cost = 9000
	unit_name = "Plutonium Rod"
	export_types = list(/obj/item/twohanded/required/fuel_rod/plutonium)

#undef KPA_TO_PSI
#undef PSI_TO_KPA
#undef KELVIN_TO_CELSIUS
#undef CELSIUS_TO_KELVIN
#undef MEGAWATTS

//Plutonium sludge

#define PLUTONIUM_SLUDGE_RANGE 5
#define PLUTONIUM_SLUDGE_RANGE_STRONG 10
#define PLUTONIUM_SLUDGE_RANGE_WEAK 3

#define PLUTONIUM_SLUDGE_CHANCE 35


/obj/effect/landmark/nuclear_waste_spawner //Clean way of spawning nuclear gunk after a reactor core meltdown.
	name = "nuclear waste spawner"
	var/range = PLUTONIUM_SLUDGE_RANGE //tile radius to spawn goop
	var/center_sludge = TRUE // Whether or not the center turf should spawn sludge or not.
	var/static/list/avoid_objs = typecacheof(list( // List of objs that the waste does not spawn on
		/obj/structure/stairs, // Sludge is hidden below stairs
		/obj/structure/ladder, // Going down the ladder directly on sludge bad
		/obj/effect/decal/nuclear_waste, // No stacked sludge
		/obj/structure/girder,
		/obj/structure/grille,
		/obj/structure/window/fulltile,
		/obj/structure/window/plasma/fulltile,
		/obj/structure/window/plasma/reinforced/fulltile,
		/obj/structure/window/plastitanium,
		/obj/structure/window/reinforced/fulltile,
		/obj/structure/window/reinforced/clockwork/fulltile,
		///obj/structure/window/reinforced/ship,
		/obj/structure/window/reinforced/tinted/fulltile,
		///obj/structure/window/ship,
		/obj/structure/window/shuttle,
		/obj/machinery/gateway,
		/obj/machinery/gravity_generator,
		))

/obj/effect/landmark/nuclear_waste_spawner/proc/fire()
	playsound(loc, 'sound/effects/gib_step.ogg', 100)

	if(center_sludge)
		place_sludge(get_turf(src), TRUE)

	for(var/turf/open/floor in orange(range, get_turf(src)))
		place_sludge(floor, FALSE)

	qdel(src)

/// Tries to place plutonium sludge on 'floor'. Returns TRUE if the turf has been successfully processed, FALSE otherwise.
/obj/effect/landmark/nuclear_waste_spawner/proc/place_sludge(turf/open/floor, epicenter = FALSE)
	if(!floor)
		return FALSE

	if(epicenter)
		for(var/obj/effect/decal/nuclear_waste/waste in floor) //Replace nuclear waste with the stronger version
			qdel(waste)
		new /obj/effect/decal/nuclear_waste/epicenter (floor)
		return TRUE

	if(!prob(PLUTONIUM_SLUDGE_CHANCE)) //Scatter the sludge, don't smear it everywhere
		return TRUE

	for(var/obj/O in floor)
		if(avoid_objs[O.type])
			return TRUE

	new /obj/effect/decal/nuclear_waste (floor)
	return TRUE

/obj/effect/landmark/nuclear_waste_spawner/strong
	range = PLUTONIUM_SLUDGE_RANGE_STRONG

/obj/effect/landmark/nuclear_waste_spawner/weak
	range = PLUTONIUM_SLUDGE_RANGE_WEAK
	center_sludge = FALSE

#undef PLUTONIUM_SLUDGE_RANGE
#undef PLUTONIUM_SLUDGE_RANGE_STRONG
#undef PLUTONIUM_SLUDGE_RANGE_WEAK
#undef PLUTONIUM_SLUDGE_CHANCE

//nuclear waste decal
/obj/effect/decal/nuclear_waste
	name = "plutonium sludge"
	desc = "A writhing pool of heavily irradiated, spent reactor fuel. You probably shouldn't step through this..."
	icon = 'icons/oldschool/reactor/reactor_parts.dmi'
	icon_state = "nuclearwaste"
	alpha = 150
	light_color = LIGHT_COLOR_CYAN
	color = "#ff9eff"

/obj/effect/decal/nuclear_waste/Initialize()
	. = ..()
	set_light(3)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/decal/nuclear_waste/ex_act(severity, target)
	if(severity != EXPLODE_DEVASTATE)
		return
	qdel(src)

/obj/effect/decal/nuclear_waste/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(isliving(AM))
		var/mob/living/L = AM
		playsound(loc, 'sound/effects/gib_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 20 : 50, 1)
	radiation_pulse(src, 500, 5) //MORE RADS

/obj/effect/decal/nuclear_waste/attackby(obj/item/tool, mob/user)
	if(tool.tool_behaviour == TOOL_SHOVEL)
		radiation_pulse(src, 1000, 5) //MORE RADS
		to_chat(user, "<span class='notice'>You start to clear [src]...</span>")
		if(tool.use_tool(src, user, 50, volume=100))
			to_chat(user, "<span class='notice'>You clear [src]. </span>")
			qdel(src)
			return
	. = ..()

/obj/effect/decal/nuclear_waste/epicenter //The one that actually does the irradiating. This is to avoid every bit of sludge PROCESSING
	name = "dense nuclear sludge"


/obj/effect/decal/nuclear_waste/epicenter/Initialize()
	. = ..()
	AddComponent(/datum/component/radioactive, 1500, src, 0)

/// This element hooks a signal onto the loc the current object is on.
/// When the object moves, it will unhook the signal and rehook it to the new object.
/datum/element/connect_loc
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// An assoc list of signal -> procpath to register to the loc this object is on.
	var/list/connections

/datum/element/connect_loc/Attach(atom/movable/listener, list/connections)
	. = ..()
	if (!istype(listener))
		return ELEMENT_INCOMPATIBLE

	src.connections = connections

	RegisterSignal(listener, COMSIG_MOVABLE_MOVED, .proc/on_moved, override = TRUE)
	update_signals(listener)

/datum/element/connect_loc/Detach(atom/movable/listener)
	. = ..()
	unregister_signals(listener, listener.loc)
	UnregisterSignal(listener, COMSIG_MOVABLE_MOVED)

/datum/element/connect_loc/proc/update_signals(atom/movable/listener)
	var/atom/listener_loc = listener.loc
	if(isnull(listener_loc))
		return

	for (var/signal in connections)
		//override=TRUE because more than one connect_loc element instance tracked object can be on the same loc
		listener.RegisterSignal(listener_loc, signal, connections[signal], override=TRUE)

/datum/element/connect_loc/proc/unregister_signals(datum/listener, atom/old_loc)
	if(isnull(old_loc))
		return

	for (var/signal in connections)
		listener.UnregisterSignal(old_loc, signal)

/datum/element/connect_loc/proc/on_moved(atom/movable/listener, atom/old_loc)
	SIGNAL_HANDLER
	unregister_signals(listener, old_loc)
	update_signals(listener)

//nuclear fall out weather
/datum/weather/nuclear_fallout
	name = "nuclear fallout"
	desc = "Irradiated dust falls down everywhere."
	telegraph_duration = 50
	telegraph_message = "<span class='boldwarning'>The air suddenly becomes dusty..</span>"
	weather_message = "<span class='userdanger'><i>You feel a wave of hot ash fall down on you.</i></span>"
	weather_overlay = "light_ash"
	telegraph_overlay = "light_snow"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_color = "green"
	telegraph_sound = null
	weather_sound = 'sound/toolbox/reactor/falloutwind.ogg'
	end_duration = 100
	area_type = /area
	protected_areas = list(/area/maintenance, /area/ai_monitored/turret_protected/ai_upload, /area/ai_monitored/turret_protected/ai_upload_foyer,
	/area/ai_monitored/turret_protected/ai, /area/storage/emergency/starboard, /area/storage/emergency/port, /area/shuttle)
	target_trait = ZTRAIT_STATION
	end_message = "<span class='notice'>The ash stops falling.</span>"
	immunity_type = "rad"

/datum/weather/nuclear_fallout/weather_act(mob/living/L)
	L.rad_act(100)

/datum/weather/nuclear_fallout/telegraph()
	..()
	status_alarm(TRUE)

/datum/weather/nuclear_fallout/proc/status_alarm(active)	//Makes the status displays show the radiation warning for those who missed the announcement.
	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)
	if(!frequency)
		return

	var/datum/signal/signal = new
	if (active)
		signal.data["command"] = "alert"
		signal.data["picture_state"] = "radiation"
	else
		signal.data["command"] = "shuttle"

	var/atom/movable/virtualspeaker/virt = new(null)
	frequency.post_signal(virt, signal)

/datum/weather/nuclear_fallout/end()
	if(..())
		return
	status_alarm(FALSE)

//Advanced turbine
/obj/machinery/power/turbine/advanced
	name = "advanced gas turbine generator"
	icon = 'icons/oldschool/advancedturbine.dmi'
	//icon_state = "turbine"
	circuit = /obj/item/circuitboard/machine/power_turbine/advanced
	base_productivity = 2

/obj/machinery/power/compressor/advanced
	name = "advanced compressor"
	icon = 'icons/oldschool/advancedturbine.dmi'
	//icon_state = "compressor"
	circuit = /obj/item/circuitboard/machine/power_compressor/advanced
	base_efficiency = 2
	minimum_temperature = 373.15 //100 degrees celsius needed minimum to function.

/obj/item/circuitboard/machine/power_compressor/advanced
	name = "advanced power compressor (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/compressor/advanced
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stock_parts/manipulator = 12)

/obj/item/circuitboard/machine/power_turbine/advanced
	name = "advanced power turbine (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/turbine/advanced
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stock_parts/capacitor = 12)

//turbine room turfs
#define OPENTURF_REACTOR_TURBINE "o2=132;n2=492;TEMP=293.15"
/turf/open/floor/engine/reactor_turbine
	initial_gas_mix = OPENTURF_REACTOR_TURBINE
