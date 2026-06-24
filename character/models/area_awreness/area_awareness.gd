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

func get_nearest_character(group: String = "player") -> CharacterEntity:
	var characters = get_tree().get_nodes_in_group(group)
	if characters.is_empty():
		return null
		
	var nearest_character: Node3D = null
	# Start with infinity so the first checked distance will always be smaller
	var shortest_distance: float = INF 
	# Cache the player/origin position for performance
	var current_position = global_position
	
	for character in characters:
		# Safety check: ensure the node is actually a 3D spatial node
		if not character is CharacterEntity:
			continue
			
		# Using distance_squared_to() is faster than distance_to() 
		# because it avoids calculating a heavy square root operation.
		var distance_squared = current_position.distance_squared_to(character.global_position)
		
		if distance_squared < shortest_distance:
			shortest_distance = distance_squared
			nearest_character = character
		
	return nearest_character
