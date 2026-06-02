extends CharacterBody3D

@export var rotation_speed: float = 10.0
@export var health: Node3D
@export var damage: float = 10

@onready var animation_player = $AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var player_node: Node3D = null


func _ready() -> void:
	if health:
		health.health_depleted.connect(die)
	# Find the player in the scene tree using the group
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		player_node = players[0] # Grab the first player found


func die() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not player_node or not is_instance_valid(player_node):
		return # Safety check in case the player dies or hasn't spawned
		
	# 1. TRACK ROTATION (Look at the player)
	track_rotation(delta)
	
	# 2. TRACK MOVEMENT (Walk toward the player)
	track_movement(delta)
	
	animation_player.play("enemy_animation/Walking_A")

func track_rotation(delta: float) -> void:
	# Calculate the target position but keep the Y coordinate the same 
	# so the enemy doesn't tilt upward/downward weirdly if the player jumps.
	var target_pos = player_node.global_position
	target_pos.y = global_position.y
	
	# Create a transform that looks at the target position
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	
	# Smoothly interpolate (lerp) the rotation toward the player
	global_transform = global_transform.interpolate_with(target_transform, rotation_speed * delta)

func track_movement(delta: float) -> void:
	# Get the direction vector pointing from us to the player
	var direction = (player_node.global_position - global_position).normalized()
	
	# If we are doing a 2.5D Smash-style game, lock the Z axis!
	# direction.z = 0
	# direction = direction.normalized()
	
	# Apply movement velocity
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	# Handle standard 3D gravity if it's not a flying entity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0
		
	move_and_slide()
	
	# Loop through everything we ran into during this frame
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.has_method("is_in_group"):
			if collider.is_in_group('weapon'):
				print('hi')
				health.take_damage(50)
			else:
				print('aaa')
