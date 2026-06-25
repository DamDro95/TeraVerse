extends CharacterState
class_name CharacterStateJumpIdle


const LANDING_HEIGHT : float = 1.1


func default_lifecycle(input : InputPackage):
	var floor_distance = model.area_awareness.get_floor_distance()
	if floor_distance < LANDING_HEIGHT:
		return "Jump_Land"
		
	return "okay"


func update(_input : InputPackage, delta ):
	model.character.velocity.y -= model.physics.gravity * delta
	model.physics.apply_horizontal_resistance("air", delta)
	model.character.move_and_slide()


func process_input_vector(input: InputPackage, delta : float):
	model.character.rotate_mesh(model.character.get_direction(input))
