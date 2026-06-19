extends CharacterState


@export var dash_speed: float = 20.0

var dashed: bool = false


func default_lifecycle(input : InputPackage):
	var next_input = best_input_that_can_be_paid(input)
	if works_longer_than(DURATION) and dashed and next_input != "Dash":
		return next_input
	
	return "okay"


func update(_input : InputPackage, _delta ):
	if works_longer_than(DURATION) and not dashed:
		dashed = true
	model.character.velocity.y -= gravity * _delta
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var direction = (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	if direction == Vector3.ZERO:
		direction = -model.character.transform.basis.z

		# Adjust for camera position
	var cam_basis = model.character.camera.global_transform.basis
	var world_direction = cam_basis * direction
	world_direction.y = 0
	direction = world_direction.normalized()
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		model.skeleton.rotation.y = lerp_angle(model.skeleton.rotation.y, target_angle, 0.2)
	
	# Main dash
	model.character.velocity = direction * dash_speed


func on_exit_state():
	dashed = false
