extends CharacterState


const LANDING_HEIGHT : float = 1.0


func default_lifecycle(input) -> String:
	if model.character.is_on_floor():
		if model.character.velocity.x == 0 and model.character.velocity.z == 0 and works_longer_than(DURATION):
			return "Idle"
		else:
			return best_input_that_can_be_paid(input)
	
	return "okay"
	
func update(_input : InputPackage, delta ):
	if not model.character.is_on_floor():
		model.character.velocity.y -= model.physics.gravity * delta
	model.physics.apply_horizontal_resistance("ground", delta)
	model.character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	model.character.rotate_mesh(model.character.get_direction(input))
