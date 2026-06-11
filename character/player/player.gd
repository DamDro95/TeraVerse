extends CharacterController
class_name PlayerController

@export var player_input: PlayerInput

func _physics_process(delta):
	var input = player_input.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
