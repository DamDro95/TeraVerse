extends CharacterState


const FLY_SPEED = 8.0


func default_lifecycle(input : InputPackage):
	if input.actions.has("Fly_Start"):
		return "Jump_Idle"
	
	return "okay" 


func update(_input : InputPackage, _delta ):
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var vertical_input := 0.0
	if input.actions.has("Jump"): vertical_input += 1.0
	if input.actions.has("Slide"): vertical_input -= 1.0

	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, vertical_input, input.input_direction.y)).normalized()
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		model.skeleton.rotation.y = lerp_angle(model.skeleton.rotation.y, target_angle, 0.2)
	
	# Override the player's velocity directly
	model.character.velocity = direction * FLY_SPEED
