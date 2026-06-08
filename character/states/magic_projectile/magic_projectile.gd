extends MeshInstance3D

class_name MagicProjectile

@export var speed: float = 15.0

var target_position: Vector3 = Vector3.ZERO
var creator_node: Node3D


func setup(start_pos: Vector3, end_pos: Vector3, creator: Node3D) -> void:
	global_position = start_pos
	target_position = end_pos
	creator_node = creator
	
	# Look toward the target
	look_at(target_position)


func _physics_process(delta: float) -> void:
	# Move towards the destination
	global_position = global_position.move_toward(target_position, speed * delta)
	
	# Check if we arrived at the targeting spot
	if global_position.distance_to(target_position) < 0.2:
		explode()


func explode() -> void:
	# Enable the hitbox explosion collision
	if %Hitbox:
		%Hitbox.monitoring = true
	
	# Optional: Spawn particle effects or play audio here
	
	# Wait one frame for the physics server to register the explosion overlaps
	await get_tree().physics_frame
	queue_free()
