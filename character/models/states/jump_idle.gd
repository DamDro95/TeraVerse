extends CharacterState
class_name CharacterStateJumpIdle


const LANDING_HEIGHT : float = 1.1
const JUMP_IDLE_MOVE_SPEED : float = 5.0


func default_lifecycle(input : InputPackage):
	var floor_distance = model.area_awareness.get_floor_distance()
	if floor_distance < LANDING_HEIGHT:
		return "Jump_Land"
		
	return "okay"


func update(_input : InputPackage, delta ):
	model.character.velocity.y -= gravity * delta
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
		model.character.velocity.x = direction.x * JUMP_IDLE_MOVE_SPEED
		model.character.velocity.z = direction.z * JUMP_IDLE_MOVE_SPEED
	else:
		model.character.velocity.x = move_toward(model.character.velocity.x, 0, JUMP_IDLE_MOVE_SPEED)
		model.character.velocity.z = move_toward(model.character.velocity.z, 0, JUMP_IDLE_MOVE_SPEED)
