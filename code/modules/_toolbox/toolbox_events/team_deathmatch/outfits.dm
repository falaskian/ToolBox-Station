/********************** TDM OUTFITS **************************/


		//OUTFITS


/*
	//OUTFIT TEMPLATE

/datum/outfit/template
	name = "template"
	uniform = null
	suit = null
	back = null
	belt = null
	gloves = null
	shoes = null
	head = null
	mask = null
	neck = null
	ears = null
	glasses = null
	id = null
	l_pocket = null
	r_pocket = null
	suit_store = null
	r_hand = null
	l_hand = null
	toggle_helmet = TRUE
	internals_slot = null
	list/backpack_contents = null
	list/implants = null
	accessory = null
*/


	//Lobby

/datum/outfit/TDM_lobby
    name = "TDM Lobby"
    uniform = /obj/item/clothing/under/color/grey
    shoes = /obj/item/clothing/shoes/sneakers/black

	//Red Team

/datum/outfit/TDM/red
	name = "TDM Red Team T1"
	uniform = /obj/item/clothing/under/color/red/TDM
	belt = /obj/item/storage/belt/fannypack/red
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/TDM/red
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/red/t3
	name = "TDM Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/red/t4
	name = "TDM Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt


	//Blue Team

/datum/outfit/TDM/blue
	name = "TDM Blue Team T1"
	uniform = /obj/item/clothing/under/color/blue/TDM
	belt = /obj/item/storage/belt/fannypack/blue
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/TDM/blue
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/blue/t3
	name = "TDM Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/blue/t4
	name = "TDM Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



		//TDM Clowns

	//TDM Clown Red

/datum/outfit/TDM/clown/red
	name = "TDM Clown Red Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown
	belt = /obj/item/storage/belt/fannypack/red
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/red/t3
	name = "TDM Clown Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/red/t4
	name = "TDM Clown Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



	//TDM Clown Blue

/datum/outfit/TDM/clown/blue
	name = "TDM Clown Blue Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown/blue
	belt = /obj/item/storage/belt/fannypack/blue
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/sexyclown
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/blue/t3
	name = "TDM Clown Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/blue/t4
	name = "TDM Clown Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



		//TDM Mime

/datum/outfit/TDM/mime
	name = "TDM Mime"
	uniform = /obj/item/clothing/under/rank/civilian/mime/TDM
	belt = /obj/item/storage/belt/fannypack/red
	suit = /obj/item/clothing/suit/suspenders/TDM
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/sneakers/black
	head = /obj/item/clothing/head/frenchberet
	mask = /obj/item/clothing/mask/gas/mime/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two

/datum/outfit/TDM/mime/t3
	name = "TDM Mime T3"
	suit = /obj/item/clothing/suit/armor/vest/alt

/datum/outfit/TDM/mime/t4
	name = "TDM Mime T3"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



		//DeathRun Outfits

	//Death Outfit

/datum/outfit/TDM/Death
	name = "TDM Death"
	uniform = /obj/item/clothing/under/color/black/TDM
	suit = /obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM
	neck = /obj/item/clothing/neck/cloak/chap/bishop/black/TDM
	belt = /obj/item/storage/belt/fannypack/black
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/bishopmitre/black/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	r_hand = /obj/item/nullrod/scythe


	//Runner Outfit

/datum/outfit/TDM/Runner
	name = "TDM Runner"
	uniform = /obj/item/clothing/under/color/grey/TDM
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two



		//TDM Space Outfits

	//Red Team Space Suit

/datum/outfit/TDM/red_space
	name = "TDM Red Team Space"
	uniform = /obj/item/clothing/under/color/red/TDM
	belt = /obj/item/storage/belt/fannypack/red
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/old
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	suit = /obj/item/clothing/suit/space/syndicate/black/red/TDM
	back = /obj/item/tank/jetpack/oxygen/security/TDM_Red
	head = /obj/item/clothing/head/helmet/space/syndicate/black/red/TDM


	//Blue Team Space Suit

/datum/outfit/TDM/blue_space
	name = "TDM Blue Team Space"
	uniform = /obj/item/clothing/under/color/blue/TDM
	belt = /obj/item/storage/belt/fannypack/blue
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/old
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	suit = /obj/item/clothing/suit/space/syndicate/black/blue/TDM
	back = /obj/item/tank/jetpack/oxygen/TDM_Blue
	head = /obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM



		//TDM Assistants

	//TDM Assistant Red

/datum/outfit/TDM/assistant_red
	name = "TDM Assistant Red"
	uniform = /obj/item/clothing/under/color/grey/TDM
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	accessory = /obj/item/clothing/accessory/armband/TDM


	//TDM Assistant Blue

/datum/outfit/TDM/assistant_blue
	name = "TDM Assistant Blue"
	uniform = /obj/item/clothing/under/color/grey/TDM
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/reagent_containers/pill/patch/styptic
	r_pocket = /obj/item/stack/medical/gauze/two
	accessory = /obj/item/clothing/accessory/armband/blue/TDM



		//Hide&Seek


	//Hunter Clown

/datum/outfit/hunter_clown
	name = "TDM_HUNTER_CLOWN"
	uniform = /obj/item/clothing/under/rank/civilian/clown
	back = /obj/item/storage/backpack/clown
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/clown_shoes/TDM/slow
	mask = /obj/item/clothing/mask/gas/clown_hat


	//Hider Mime

/datum/outfit/hider_mime
	name = "TDM_HIDER_MIME"
	uniform = /obj/item/clothing/under/rank/civilian/mime
	suit = /obj/item/clothing/suit/suspenders
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/sneakers/black
	head = /obj/item/clothing/head/frenchberet
	mask = /obj/item/clothing/mask/gas/mime

/datum/outfit/hider_mime/chameleon
	name = "TDM_HIDER_MIME"
	uniform = /obj/item/clothing/under/rank/civilian/mime
	suit = /obj/item/clothing/suit/suspenders
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/sneakers/black
	head = /obj/item/clothing/head/frenchberet
	mask = /obj/item/clothing/mask/gas/mime
	l_pocket = /obj/item/chameleon






/********************** TDM CLOTHES **************************/

	//Berets

/obj/item/clothing/head/beret/TDM
	name = "beret"
	desc = "A beret. Very stylish but offers no protection."
	icon_state = "beret_ce" //White



/obj/item/clothing/head/beret/TDM/red
	name = "red beret"
	desc = "A red beret. Very stylish but offers no protection."
	icon_state = "beret_badge"


/obj/item/clothing/head/beret/TDM/blue
	name = "blue beret"
	desc = "A blue beret. Very stylish but offers no protection."
	icon_state = "beret_captain"

/obj/item/clothing/head/beret/TDM/green
	name = "green beret"
	color = "#00B200" //Green



		//Jumpsuits

	//Red TDM Jumpsuit

/obj/item/clothing/under/color/red/TDM
	can_adjust = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/under/color/red/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Jumpsuit

/obj/item/clothing/under/color/blue/TDM
	can_adjust = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/under/color/blue/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Black TDM Jumpsuit

/obj/item/clothing/under/color/black/TDM
	can_adjust = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/under/color/black/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Grey TDM Jumpsuit

/obj/item/clothing/under/color/grey/TDM
	can_adjust = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/under/color/grey/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Armbands

	//Red Armband

/obj/item/clothing/accessory/armband/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/accessory/armband/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue Armband

/obj/item/clothing/accessory/armband/blue/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/accessory/armband/blue/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


		//Death Clothes

	//Death Robe

/obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM
	name = "death robe"
	desc = "Very ominous robe."

/obj/item/clothing/suit/chaplainsuit/bishoprobe/black/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Death Hat

/obj/item/clothing/head/bishopmitre/black/TDM
	name = "death hat"
	desc = "Very ominous hat."

/obj/item/clothing/head/bishopmitre/black/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Death Cloak

/obj/item/clothing/neck/cloak/chap/bishop/black/TDM
	name = "death cloak"
	desc = "Very ominous cloak."

/obj/item/clothing/neck/cloak/chap/bishop/black/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Space Suits

	//Red TDM Space Suit

/obj/item/clothing/suit/space/syndicate/black/red/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Space Suit

/obj/item/clothing/suit/space/syndicate/black/blue/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/suit/space/syndicate/black/blue/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//Space Helmets

	//Red TDM Space Helmet

/obj/item/clothing/head/helmet/space/syndicate/black/red/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/head/helmet/space/syndicate/black/red/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//Blue TDM Space Helmet

/obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/head/helmet/space/syndicate/black/blue/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)



		//JetPacks

	//Harness Jetpack TDM

/obj/item/tank/jetpack/oxygen/harness/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

	//Red TDM JetPack

/obj/item/tank/jetpack/oxygen/security/TDM_Red
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE


	//Blue TDM JetPack

/obj/item/tank/jetpack/oxygen/TDM_Blue
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE



		//Mimes

	//TDM Mime Mask

/obj/item/clothing/mask/gas/mime/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//TDM Mime Jumpsuit

/obj/item/clothing/under/rank/civilian/mime/TDM
	can_adjust = 0
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/under/rank/civilian/mime/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


	//TDM Mime Suspenders

/obj/item/clothing/suit/suspenders/TDM
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE

/obj/item/clothing/suit/space/syndicate/black/red/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/********************** CLOWNS **************************/


		//CLOWN WEAPONS

	//Banana -

/obj/item/reagent_containers/food/snacks/grown/banana/TDM
	name = "deadly banana"
	desc = "It's an excellent weapon for a clown. Very nutritious! It seems like you could eat it in three bites. Damage: 35 Damage Thrown: 20"
	force = 35
	throwforce = 20
	bitesize = 3
	trash = /obj/item/grown/bananapeel/TDM
	list_reagents = list(/datum/reagent/medicine/bicaridine = 30, /datum/reagent/consumable/nutriment = 3)

	//Banana Peel

/obj/item/grown/bananapeel/TDM
	name = "deadly banana peel"
	desc = "A peel from a banana. You just want to throw it. Damage Thrown: 35"
	throwforce = 35




		//CLOWN CLOTHES

/obj/item/clothing/under/rank/civilian/clown/TDM
	can_adjust = 0

/obj/item/clothing/under/rank/civilian/clown/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/mask/gas/clown_hat/TDM

/obj/item/clothing/mask/gas/clown_hat/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/under/rank/civilian/clown/blue/TDM
	can_adjust = 0

/obj/item/clothing/under/rank/civilian/clown/blue/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/shoes/clown_shoes/TDM

/obj/item/clothing/shoes/clown_shoes/TDM/slow
	slowdown = 0.2

/obj/item/clothing/shoes/clown_shoes/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


/obj/item/clothing/mask/gas/sexyclown/TDM

/obj/item/clothing/mask/gas/sexyclown/TDM/Initialize()
	.=..()
	//ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)




		//TDM CLOWN OUTFITS


	//OUTFIT TDM CLOWN RED

/datum/outfit/TDM/clown/red
	name = "TDM Clown Red Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown
	belt = /obj/item/storage/belt/fannypack/red
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/food/snacks/grown/banana/TDM
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/red/t3
	name = "TDM Clown Red Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/red/t4
	name = "TDM Clown Red Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt



	//OUTFIT TDM CLOWN BLUE

/datum/outfit/TDM/clown/blue
	name = "TDM Clown Blue Team"
	uniform = /obj/item/clothing/under/rank/civilian/clown/blue
	belt = /obj/item/storage/belt/fannypack/blue
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/sexyclown
	toggle_helmet = TRUE
	l_pocket = /obj/item/reagent_containers/food/snacks/grown/banana/TDM
	r_pocket = /obj/item/stack/medical/gauze/two


/datum/outfit/TDM/clown/blue/t3
	name = "TDM Clown Blue Team T3"
	suit = /obj/item/clothing/suit/armor/vest/alt


/datum/outfit/TDM/clown/blue/t4
	name = "TDM Clown Blue Team T4"
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt