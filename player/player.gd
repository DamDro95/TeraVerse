extends CharacterEntity
class_name PlayerEntity

@onready var camera := $View/SpringArmPivot/Camera3D

func _init() -> void:
	model = model as PlayerModel

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input = controller.gather_input() 
	model.update(input, delta)
	# Visuals -> follow parent transformations

func get_direction(input: InputPackage) -> Vector3:
	var raw_input = Vector3(input.input_direction.x, 0, input.input_direction.y)
	var direction := raw_input.rotated(Vector3.UP, camera.global_rotation.y)
	return direction.normalized()
