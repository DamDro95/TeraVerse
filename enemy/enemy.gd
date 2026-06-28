extends CharacterEntity
class_name EnemyEntity

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input = controller.gather_input() 
	model.update(input, delta)
	# Visuals -> follow parent transformations
