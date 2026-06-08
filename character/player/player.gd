extends Character
class_name CharacterPlayer

@export var controller: PlayerController


func _physics_process(delta):
	var input = controller.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
