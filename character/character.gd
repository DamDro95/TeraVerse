extends CharacterBody3D
class_name CharacterEntity

@onready var model: CharacterModel = $Model
@onready var view: CharacterView = $View
@onready var controller: CharacterController = $Controller

func _ready() -> void:
	view.set_meshes()

func rotate_mesh(direction: Vector3) -> void:
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		rotation.y = lerp_angle(rotation.y, target_angle, 0.2)

func get_direction(input: InputPackage) -> Vector3:
	var direction: Vector3 = model.character.velocity
	direction.y = 0.0
	
	return direction.normalized()
