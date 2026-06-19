extends CharacterBody3D

@export var rotation_speed: float = 10.0
@export var health: Node3D
@export var damage: float = 10
@export var hit_duration: float = 0.2
@export var knock_back_velocity = 20

@onready var animation_player = $AnimationPlayer

enum MoveState { WALKING, DAMAGED }
var current_move_state = MoveState.WALKING

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var player_node: Node3D = null


func _ready() -> void:	
	%Hurtbox.recieved_hit.connect(hit)
	%Health.health_depleted.connect(die)
	
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
		
	if current_move_state == MoveState.WALKING:
		# 1. TRACK ROTATION (Look at the player)
		track_rotation(delta)
		
		# 2. TRACK MOVEMENT (Walk toward the player)
		track_movement(delta)
	
		#animation_player.play("enemy_animation/Walking_A")


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


func hit() -> void:
	change_state(MoveState.DAMAGED)
	%AnimationPlayer.play("enemy_animation/Hit_B")
	velocity = Vector3(0,0, knock_back_velocity)
	await get_tree().create_timer(hit_duration).timeout
	
	change_state(MoveState.WALKING)


## Helper function for components to safely request a state change
func change_state(new_state: MoveState) -> void:
	# Prevent interrupting a dash unless you want them to cancel it
	current_move_state = new_state
