extends CharacterBody3D
class_name CharacterEntity

@onready var model: CharacterModel = $Model
@onready var view: CharacterView = $View

func rotate_mesh(direction: Vector3) -> void:
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		model.skeleton.rotation.y = lerp_angle(model.skeleton.rotation.y, target_angle, 0.2)
