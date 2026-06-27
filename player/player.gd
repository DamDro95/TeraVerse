extends CharacterEntity
class_name PlayerEntity


@export var disable_controller: bool = false

@onready var camera := $View/SpringArmPivot/Camera3D


func _ready() -> void:
	model = model as PlayerModel
	if disable_controller:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$View/SpringArmPivot.process_mode = Node.PROCESS_MODE_DISABLED
		$View/Crosshair.visible = false

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input = controller.gather_input(disable_controller) 
	print(input.actions)
	model.update(input, delta)
	# Visuals -> follow parent transformations

func get_direction(input: InputPackage) -> Vector3:
	var raw_input = Vector3(input.input_direction.x, 0, input.input_direction.y)
	var direction := raw_input.rotated(Vector3.UP, camera.global_rotation.y)
	return direction.normalized()
