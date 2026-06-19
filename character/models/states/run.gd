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


func update(_input : InputPackage, _delta : float):
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
		var current_speed = horizontal_vel.length()
		current_speed = move_toward(current_speed, MAX_SPEED, ACCELERATION * delta)
		# Accelerate toward the target direction up to max speed
		horizontal_vel = direction * max(current_speed, ACCELERATION * delta)
		#horizontal_vel = horizontal_vel.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		# Apply ground friction to slide to a smooth stop
		horizontal_vel = horizontal_vel.move_toward(Vector3.ZERO, FRICTION * delta)

	model.character.velocity.x = horizontal_vel.x
	model.character.velocity.z = horizontal_vel.z
