extends CharacterState


@export var slide_velocity: float = 5.0

const slide_boost = 12


@warning_ignore("unused_parameter")
func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return best_input_that_can_be_paid(input)
		
	if works_longer_than(DURATION):
		return "Slide_Idle"
		
	return "okay"


func update(_input : InputPackage, delta ):
	model.physics.apply_horizontal_resistance("slide", delta)
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var direction = model.character.get_direction(input) 
	#:= (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	#
	## Move in the directin relative to the camera
	#direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	# Rotate mesh
	model.character.rotate_mesh(direction)

	if direction == Vector3.ZERO:
		return
		
	var velocity_h = Vector3(model.character.velocity.x, 0, model.character.velocity.z)
	var to = model.character.velocity.length() + 10
	velocity_h = velocity_h.move_toward(direction * to, model.physics.SLIDE_ACCELERATION * delta)
		
	model.character.velocity.x = velocity_h.x
	model.character.velocity.z = velocity_h.z


func on_enter_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) / 3
	model.animator.set_speed_scale(3)
	
func on_exit_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) * 3
	model.animator.set_speed_scale(1)
