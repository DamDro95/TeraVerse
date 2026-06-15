extends CharacterStateJump

const JUMP_FORWARD = 10.0


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	
	jumped = false
	return "Jump_Idle"

func process_input_vector(input : InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	if direction == Vector3.ZERO:
		direction = -model.character.transform.basis.z

		# Adjust for camera position
	var cam_basis = model.character.camera.global_transform.basis
	var world_direction = cam_basis * direction
	world_direction.y = 0
	direction = world_direction.normalized()
	
	model.character.velocity = direction * JUMP_FORWARD
	model.character.velocity += Vector3(0, (JUMP_VELOCITY + 5), 0)
