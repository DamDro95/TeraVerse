extends CharacterState
class_name CharacterStateJump


const ANIMATION_SPEED = 2

var jumped: bool = false


func default_lifecycle(input : InputPackage):
	if works_longer_than(DURATION):
		return "Jump_Idle"
	
	return "okay"


func update(_input : InputPackage, delta ):
	if works_longer_than(DURATION) and not jumped:
		jumped = true
	model.physics.apply_horizontal_resistance("air", delta)
	model.character.velocity.y -= model.physics.gravity * delta
	model.character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	model.character.velocity.y = model.physics.JUMP_VELOCITY
	model.character.rotate_mesh(model.character.get_direction(input))


func on_enter_state():
	jumped = false
	DURATION = model.states.data_repo.get_duration(backend_animation) / ANIMATION_SPEED
	model.animator.set_speed_scale(ANIMATION_SPEED)
	
func on_exit_state():
	model.animator.set_speed_scale(1)
