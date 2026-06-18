extends CharacterState


@export var slide_velocity: float = 5.0


@warning_ignore("unused_parameter")
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
		model.skeleton.rotation.y = lerp_angle(model.skeleton.rotation.y, target_angle, 0.2)

	var horizontal_vel = Vector3(model.character.velocity.x, 0, model.character.velocity.z)
	if direction != Vector3.ZERO:
		# Accelerate toward the target direction up to max speed
		horizontal_vel = horizontal_vel.move_toward(direction * (MAX_SPEED + 4), ACCELERATION * delta)

	model.character.velocity.x = horizontal_vel.x
	model.character.velocity.z = horizontal_vel.z


func on_enter_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) / 3
	model.animator.set_speed_scale(3)
	
func on_exit_state():
	model.animator.set_speed_scale(1)
