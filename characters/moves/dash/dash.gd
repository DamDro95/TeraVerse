extends Node3D

# Use an Enum to cleanly define your input states
enum DashDirection { NONE, LEFT, RIGHT, FORWARD, BACK }

@export var player: PlayerController
@export var double_tap_timeout: float = 0.50

@export_group("Dash Physics")
@export var dash_speed: float = 50.0
@export var dash_duration: float = 0.2

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector3 = Vector3.ZERO

# A clean, static lookup table. No loops required to fetch data!
const DIRECTION_MAP = {
	"move_left": DashDirection.LEFT,
	"move_right": DashDirection.RIGHT,
	"move_forward": DashDirection.FORWARD,
	"move_back": DashDirection.BACK
}

const VECTOR_MAP = {
	DashDirection.LEFT: Vector3.LEFT,
	DashDirection.RIGHT: Vector3.RIGHT,
	DashDirection.FORWARD: Vector3.FORWARD,
	DashDirection.BACK: Vector3.BACK,
}

# Track timers for each enum type
var last_press_time = 0.0
var last_keycode = 0

func _input(event: InputEvent) -> void:
	if not player or not player.is_multiplayer_authority(): return
	
	for action in DIRECTION_MAP.keys():
		if event.is_action_pressed(action):
			var pressed_dir = DIRECTION_MAP[action]
			if last_press_time > 0 and last_keycode == event.keycode:
				dash(VECTOR_MAP[pressed_dir])
			else:
				last_press_time = double_tap_timeout
				last_keycode = event.keycode
			break

func _physics_process(delta: float) -> void:
	if not player or not player.is_multiplayer_authority(): return
	
	if player.current_state == player.MoveState.DASHING:
		return
		
	last_press_time -= delta
	
	if Input.is_action_just_pressed("dash"):
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		dash(direction)


func dash(direction: Vector3) -> void:
	player.change_state(player.MoveState.DASHING)
	
	if direction == Vector3.ZERO:
		direction = -player.transform.basis.z # Forward
	
	# Adjust for camera position
	var cam_basis = player.camera.global_transform.basis
	var world_direction = cam_basis * direction
	world_direction.y = 0
	direction = world_direction.normalized()
	
	# Main dash
	player.velocity = direction * dash_speed
	
	await player.get_tree().create_timer(dash_duration).timeout
	
	if player.current_state == player.MoveState.DASHING:
		player.change_state(player.MoveState.IDLE_WALK)
