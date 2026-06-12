extends CharacterState
class_name CharacterStateJump


@export var jump_velocity: float = 5.0

var jumped: bool = false


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	
	jumped = false
	return "Jump_Idle"


func update(_input : InputPackage, _delta ):
	if works_longer_than(DURATION) and not jumped:
		model.character.velocity.y += 1
		jumped = true
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	pass


func on_enter_state():
	model.character.velocity.y = jump_velocity
