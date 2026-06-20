extends CharacterState


@export var slide_velocity: float = 5.0

@onready var jumped: bool = false

#@onready var MAX_SLIDE_SPEED = (model.physics.MAX_SPEED + 5)
#@onready var SLIDE_ACCELERATION = (model.physics.ACCELERATION * (1/3))

func default_lifecycle(input : InputPackage):
	
	if input.actions.has("Slide") and model.character.velocity.length() > 0:
		return "okay"
	
	return "Slide_End"


func update(input : InputPackage, delta ):
	model.physics.apply_horizontal_resistance("slide", delta)
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	model.character.rotate_mesh(direction)
