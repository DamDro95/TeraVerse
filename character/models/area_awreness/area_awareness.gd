extends RayCast3D
class_name AreaAwareness


@export var anchor: BoneAttachment3D

var last_pushback_vector : Vector3
var last_input_package : InputPackage


func _process(_delta):
	##print(root_attachment.global_position)
	global_position = anchor.global_position
	#anchor.global_position = get_collision_point()


func get_floor_distance() -> float:
	if is_colliding():
		return global_position.distance_to(get_collision_point())
	return 999999
