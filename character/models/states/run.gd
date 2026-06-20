extends CharacterState

@export var SPEED = 7.0
@export var TURN_SPEED = 2
 

func default_lifecycle(input : InputPackage):
	if not model.character.is_on_floor():
		return "Jump_Idle" 
	
	var next_state = best_input_that_can_be_paid(input)
	
	#If Idle, keep the running state until friction reduces speed to 0
	if next_state == "Idle" and (model.character.velocity.x != 0 or model.character.velocity.z != 0):
		return "okay"

	return next_state


func update(_input : InputPackage, delta : float):
	model.physics.apply_horizontal_resistance("ground", delta)
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	model.character.rotate_mesh(direction)
		
	if direction == Vector3.ZERO:
		return
		
	var velocity_h = Vector3(model.character.velocity.x, 0, model.character.velocity.z)
	var current_speed = velocity_h.length()
	current_speed = move_toward(current_speed, model.physics.MAX_SPEED, model.physics.ACCELERATION * delta)
	
	# Keep velocity even when changing direction
	velocity_h = direction * max(current_speed, model.physics.ACCELERATION * delta)

	model.character.velocity.x = velocity_h.x
	model.character.velocity.z = velocity_h.z
