extends CharacterState

@export var SPEED = 5.0
@export var TURN_SPEED = 2
 

func default_lifecycle(input : InputPackage):
	if not model.character.is_on_floor():
		return "Jump_Idle" 

	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, _delta : float):
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
		model.character.velocity.x = direction.x * SPEED
		model.character.velocity.z = direction.z * SPEED
	else:
		model.character.velocity.x = move_toward(model.character.velocity.x, 0, SPEED)
		model.character.velocity.z = move_toward(model.character.velocity.z, 0, SPEED)


func on_exit_state():
	model.animator.set_speed_scale(1)
