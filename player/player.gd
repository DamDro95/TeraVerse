extends CharacterController
class_name PlayerController

@export var player_input: PlayerInput

@onready var camera := $View/SpringArmPivot/Camera3D

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input = player_input.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
