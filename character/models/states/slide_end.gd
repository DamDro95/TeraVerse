extends CharacterState


@export var jump_velocity: float = 5.0

var jumped: bool = false


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	
	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, _delta ):
	model.character.move_and_slide()


func on_enter_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) / 4
	model.animator.set_speed_scale(4)
	
func on_exit_state():
	model.animator.set_speed_scale(1)
