extends CharacterEntity
class_name PlayerEntity

@onready var camera := $View/SpringArmPivot/Camera3D

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input = controller.gather_input() 
	model.update(input, delta)
	# Visuals -> follow parent transformations
