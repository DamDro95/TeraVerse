extends CharacterState

@export var SPEED = 3.0
@export var TURN_SPEED = 2
 

func default_lifecycle(input : InputPackage):
	if not model.character.is_on_floor():
		return "midair" 
	
	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, _delta : float):
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (model.character.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = model.character.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	if abs(angle) >= tracking_angular_speed * delta:
		model.character.velocity = face_direction.rotated(Vector3.UP, sign(angle) * tracking_angular_speed * delta) * TURN_SPEED
		model.character.rotate_y(sign(angle) * tracking_angular_speed * delta)
	else:
		model.character.velocity = face_direction.rotated(Vector3.UP, angle) * SPEED
		model.character.rotate_y(angle)
	model.animator.set_speed_scale(model.character.velocity.length() / SPEED)


func on_exit_state():
	model.animator.set_speed_scale(1)
