extends CharacterState
class_name CharacterStateJumpIdle


const LANDING_HEIGHT : float = 1.1


func default_lifecycle(input : InputPackage):
	var floor_distance = model.area_awareness.get_floor_distance()
	if floor_distance < LANDING_HEIGHT:
		return "Jump_Land"
		
	return "okay"


func update(_input : InputPackage, delta ):
	model.character.velocity.y -= model.physics.gravity * delta
	model.physics.apply_horizontal_resistance("air", delta)
	model.character.move_and_slide()


func process_input_vector(input: InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	# Move in the directin relative to the camera
	if model.character.is_in_group("player"):
		direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		model.skeleton.rotation.y = lerp_angle(model.skeleton.rotation.y, target_angle, 0.2)
