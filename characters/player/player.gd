extends CharacterBody3D
class_name PlayerController

@export var health: Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DAMAGE_BUFFER = 1.5

enum MoveState { IDLE_WALK, JUMPING, DOUBLE_JUMPING, FLYING, DASHING }
var current_state: MoveState = MoveState.IDLE_WALK

@onready var camera := $SpringArmPivot/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var mesh := $Barbarian


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	if health:
		health.health_depleted.connect(die)
	# Check if this specific player instance is controlled by THIS machine
	if is_multiplayer_authority():
		camera.make_current()
	else:
		# Optional: Turn off the camera entirely for other players 
		# so it doesn't waste processing power
		camera.clear_current() 
		camera.queue_free() # Or just delete it to keep the scene clean


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and is_on_floor():
		animation_player.play("Player/Melee_1H_Attack_Chop")


func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Move in the directin relative to the camera
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	# Rotate mesh
	var target_angle = atan2(direction.x, direction.z)
	if not target_angle == 0.0:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, target_angle, 0.2)
	
	match current_state:
		MoveState.IDLE_WALK, MoveState.JUMPING, MoveState.DOUBLE_JUMPING:
			# Apply normal gravity when on the ground or jumping
			if not is_on_floor():
				velocity += get_gravity() * delta
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		MoveState.FLYING:
				# Zero gravity handled here or inside the Fly Component
				pass
			
		MoveState.DASHING:
			# Freeze gravity entirely during a dash
			velocity.y = 0
			
	# --- ANIMATION LOGIC ---
	# Check if we are on the floor and moving horizontally
	if is_on_floor():
		if velocity.length() > 0.2 and velocity.y == 0:
			animation_player.play("Player/Running_B")
		elif velocity.length() == 0 and animation_player.current_animation != "Player/Melee_1H_Attack_Chop":
			animation_player.play("Player/Idle_B")
	
	if current_state == MoveState.JUMPING and velocity.y > 0 and animation_player.current_animation != "Player/Jump_Start":
		animation_player.play("Player/Jump_Idle")
	
	if current_state == MoveState.JUMPING and is_on_floor():
		animation_player.play("Player/Jump_Land")
		change_state(MoveState.IDLE_WALK)
			
	move_and_slide()


func die() -> void:
	queue_free()
	
## Helper function for components to safely request a state change
func change_state(new_state: MoveState) -> void:
	# Prevent interrupting a dash unless you want them to cancel it
	if current_state == MoveState.DASHING and new_state != MoveState.IDLE_WALK:
		return
		
	current_state = new_state
	print("Player State Changed to: ", MoveState.keys()[new_state])
