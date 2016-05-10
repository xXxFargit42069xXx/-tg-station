/obj/effect/proc_holder/changeling/headcrab
	name = "Last Resort"
	desc = "We sacrifice our current body in a moment of need, stunning and damaging everyone nearby. If a dead body is nearby we infect it to raise again."
	chemical_cost = 20
	dna_cost = 1
	req_stat = UNCONSCIOUS
	req_human = 1

/obj/effect/proc_holder/changeling/headcrab/sting_action(var/mob/user)
	var/datum/mind/M = user.mind
	var/list/organs = user.get_internal_organs("head")
	var/list/organitems

	var/datum/organ/brain = user.get_organ("brain")
	var/obj/item/organ/internal/brain/B
	if(brain)
		B = brain.organitem
	for(var/datum/organ/internal/I in organs)
		if(I)
			organitems += I.organitem
			I.dismember(ORGAN_DESTROYED)

	explosion(get_turf(user),0,0,2,0,silent=1)
	var/turf = get_turf(user)
	spawn(5) // So it's not killed in explosion
		var/mob/living/simple_animal/hostile/headcrab/crab = new(turf)
		for(var/obj/item/organ/internal/I in organitems)
			I.loc = crab
		crab.origin = M
		if(M)
			M.transfer_to(crab)
			crab << "<span class='warning'>You burst out of the remains of your former body in a shower of gore!</span>"
		if(B)
			qdel(B)
	user.gib()
	feedback_add_details("changeling_powers","LR")
	return 1