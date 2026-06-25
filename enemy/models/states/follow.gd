extends CharacterState

func default_lifecycle(input : InputPackage):
	return best_input_that_can_be_paid(input)

func update(_input : InputPackage, _delta : float):
	model.character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	var player = model.area_awareness.get_nearest_character("Player")
	if not player:
		return
		
	# Move towards the closest player
	var target_direction = (player.global_position - model.character.global_position).normalized()
	model.character.rotate_mesh(target_direction)

	model.character.velocity.x = target_direction.x * 7
	model.character.velocity.z = target_direction.z * 7
	model.character.velocity.y = 0
