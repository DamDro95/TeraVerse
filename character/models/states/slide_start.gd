extends CharacterState


@export var slide_velocity: float = 5.0


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	return "Slide_Idle"


func update(_input : InputPackage, _delta ):
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		model.character.mesh.rotation.y = lerp_angle(model.character.mesh.rotation.y, target_angle, 0.2)
	if direction:
		model.character.velocity.x = direction.x * slide_velocity
		model.character.velocity.z = direction.z * slide_velocity
	else:
		model.character.velocity.x = move_toward(model.character.velocity.x, 0, slide_velocity)
		model.character.velocity.z = move_toward(model.character.velocity.z, 0, slide_velocity)
