extends CharacterMove


func default_lifecycle(input) -> String:
	if not model.character.is_on_floor():
		#return "midair"
		return "character/Jump_Idle"
	
	return best_input_that_can_be_paid(input)


func on_enter_state():
	model.character.velocity = Vector3.ZERO
