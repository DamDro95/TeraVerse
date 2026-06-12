extends CharacterState


@export var jump_velocity: float = 5.0

var jumped: bool = false


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	
	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, _delta ):
	model.character.move_and_slide()


#func process_input_vector(input : InputPackage, delta : float):
	#pass
#
#
#func on_enter_state():
	#model.character.velocity.y = jump_velocity
