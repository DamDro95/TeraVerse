extends CharacterController
class_name PlayerController

@export var player_input: PlayerInput

@onready var camera := $SpringArmPivot/Camera3D
@onready var mesh := $Rig_Medium

func _physics_process(delta):
	var input = player_input.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
