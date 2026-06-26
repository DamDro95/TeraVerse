extends CharacterState

func default_lifecycle(input : InputPackage):
	print(forced_state)
	if works_longer_than(DURATION):
		return "Follow"
	return "okay"

func update(input : InputPackage, delta : float):
	model.character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	var direction: Vector3 = model.character.get_direction(input)
	var pushback = (-direction * 160)
	model.character.velocity.x = pushback.normalized().x
	model.character.velocity.z = pushback.normalized().z
