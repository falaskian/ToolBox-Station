/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "secure crate"
	icon_state = "secure_crate"
	secure = TRUE
	locked = TRUE
	max_integrity = 500
	armor = list("melee" = 30, "bullet" = 50, "laser" = 50, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	var/tamperproof = 0
	icon_door = "crate"
	icon_door_override = TRUE
	var/alternate_lock_icon = null

/obj/structure/closet/crate/secure/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < 25)
		return 0
	. = ..()

/obj/structure/closet/crate/secure/update_icon()
	..()
	var/lock_icon = icon
	if(alternate_lock_icon)
		lock_icon = alternate_lock_icon
	if(broken)
		add_overlay("securecrateemag", 0, lock_icon)
	else if(locked)
		add_overlay("securecrater", 0, lock_icon)
	else
		add_overlay("securecrateg", 0, lock_icon)

/obj/structure/closet/crate/secure/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(prob(tamperproof) && damage_amount >= DAMAGE_PRECISION)
		boom()
	else
		return ..()


/obj/structure/closet/crate/secure/proc/boom(mob/user)
	if(user)
		to_chat(user, "<span class='danger'>The crate's anti-tamper system activates!</span>")
		log_bomber(user, "has detonated a", src)
	for(var/atom/movable/AM in src)
		qdel(AM)
	explosion(get_turf(src), 0, 1, 5, 5)
	qdel(src)

/obj/structure/closet/crate/secure/weapon
	desc = "A secure weapons crate."
	name = "weapons crate"
	icon_state = "weapon_crate"
	icon_door = null
	icon_door_override = FALSE

/obj/structure/closet/crate/secure/plasma
	desc = "A secure plasma crate."
	name = "plasma crate"
	icon_state = "plasma_crate"
	icon_door = null
	icon_door_override = FALSE

/obj/structure/closet/crate/secure/gear
	desc = "A secure gear crate."
	name = "gear crate"
	icon_state = "secgear_crate"
	icon_door = null
	icon_door_override = FALSE

/obj/structure/closet/crate/secure/hydroponics
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	name = "secure hydroponics crate"
	icon_state = "hydro_secure_crate"
	icon_door = null
	icon_door_override = FALSE

/obj/structure/closet/crate/secure/engineering
	desc = "A crate with a lock on it, painted in the scheme of the station's engineers."
	name = "secure engineering crate"
	icon_state = "engi_secure_crate"
	icon_door = "engi_crate"

/obj/structure/closet/crate/secure/science
	name = "secure science crate"
	desc = "A crate with a lock on it, painted in the scheme of the station's scientists."
	icon_state = "sci_secure_crate"
	icon_door = "sci_crate"

/obj/structure/closet/crate/secure/owned
	name = "private crate"
	desc = "A crate cover designed to only open for who purchased its contents."
	icon_state = "private_crate"
	icon_door = null
	icon_door_override = FALSE
	var/datum/bank_account/buyer_account
	var/privacy_lock = TRUE

/obj/structure/closet/crate/secure/owned/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It's locked with a privacy lock, and can only be unlocked by the buyer's ID with required access.</span>"

/obj/structure/closet/crate/secure/owned/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account

/obj/structure/closet/crate/secure/owned/togglelock(mob/living/user, silent)
	if(privacy_lock)
		if(!broken)
			var/obj/item/card/id/id_card = user.get_idcard(TRUE)
			if(id_card)
				if(id_card.registered_account)
					if(id_card.registered_account == buyer_account)
						if(allowed(user))
							if(iscarbon(user))
								add_fingerprint(user)
							locked = !locked
							user.visible_message("<span class='notice'>[user] unlocks [src]'s privacy lock.</span>",
											"<span class='notice'>You unlock [src]'s privacy lock.</span>")
							privacy_lock = FALSE
							update_icon()
						else if(!silent)
							to_chat(user, "<span class='notice'>Access Denied, insufficient access on ID card.</span>")
					else if(!silent)
						to_chat(user, "<span class='notice'>Bank account does not match with buyer!</span>")
				else if(!silent)
					to_chat(user, "<span class='notice'>No linked bank account detected!</span>")
			else if(!silent)
				to_chat(user, "<span class='notice'>No ID detected!</span>")
		else if(!silent)
			to_chat(user, "<span class='warning'>[src] is broken!</span>")
	else ..()
