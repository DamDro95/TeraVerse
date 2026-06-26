extends CharacterState

func default_lifecycle(input : InputPackage):
	return "okay"
	
func update(_input : InputPackage, _delta : float):
	await get_tree().create_timer(3.0).timeout
	model.character.queue_free()
