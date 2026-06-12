extends CharacterState

const FLY_SPEED = 8.0

func default_lifecycle(input : InputPackage):
	if input.actions.has("Fly") and works_longer_than(DURATION):
		return "Jump_Idle"
	
	return "okay"


func update(_input : InputPackage, _delta ):
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var vertical_input := 0.0
	if input.actions.has("Jump"): vertical_input += 1.0
	if input.actions.has("Descend"): vertical_input -= 1.0

	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, vertical_input, input.input_direction.y)).normalized()
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	# Override the player's velocity directly
	model.character.velocity = direction * FLY_SPEED
