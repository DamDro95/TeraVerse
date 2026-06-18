extends CharacterState


@export var slide_velocity: float = 5.0

var jumped: bool = false

@onready var MAX_SLIDE_SPEED = (MAX_SPEED + 5)
@onready var SLIDE_ACCELERATION = (ACCELERATION * (1/3))

func default_lifecycle(input : InputPackage):
	
	if input.actions.has("Slide"):
		return "okay"
	
	return "Slide_End"


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
		horizontal_vel = horizontal_vel.move_toward(direction * MAX_SLIDE_SPEED, SLIDE_ACCELERATION * delta)
	else:
		# Apply ground friction to slide to a smooth stop
		horizontal_vel = horizontal_vel.move_toward(Vector3.ZERO, FRICTION * delta)
		
	model.character.velocity.x = horizontal_vel.x
	model.character.velocity.z = horizontal_vel.z
