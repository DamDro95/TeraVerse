extends CharacterState

func update(_input : InputPackage, _delta : float):
	model.character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	var player = model.area_awareness.get_nearest_character("Player")
	if not player:
		return
		
	var target_pos = player.global_position
	target_pos.y = model.character.global_position.y
	
	# Create a transform that looks at the target position
	var target_transform = model.character.global_transform.looking_at(target_pos, Vector3.UP)
	
	# Smoothly interpolate (lerp) the rotation toward the player
	model.character.global_transform = model.character.global_transform.interpolate_with(target_transform, 10 * delta)
	
	var direction = (player.global_position - model.character.global_position).normalized()
	
	model.character.velocity.x = direction.x * 7
	model.character.velocity.z = direction.z * 7
	model.character.velocity.y = 0
	## Handle standard 3D gravity if it's not a flying entity
	#if not model.character.is_on_floor():
		#model.character.velocity.y += get_gravity().y * delta
	#else:
		#velocity.y = 0
