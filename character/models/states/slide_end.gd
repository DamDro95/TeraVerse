extends CharacterState


@export var jump_velocity: float = 5.0

var jumped: bool = false


func default_lifecycle(input : InputPackage):
	if works_longer_than(DURATION):
		return best_input_that_can_be_paid(input)
	
	return "okay"


func update(_input : InputPackage, delta ):
	model.physics.apply_horizontal_resistance("slide", delta)
	model.character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	var direction := (model.character.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, model.character.camera.global_rotation.y)
	
	model.character.rotate_mesh(direction)

func on_enter_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) / 4
	model.animator.set_speed_scale(4)
	
func on_exit_state():
	model.animator.set_speed_scale(1)
