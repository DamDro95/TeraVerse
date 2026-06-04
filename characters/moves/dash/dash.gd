extends Node3D

var body: CharacterBody3D

# Use an Enum to cleanly define your input states
enum DashDirection { NONE, LEFT, RIGHT, FORWARD, BACK }

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

func _ready() -> void:
	body = get_parent() as CharacterBody3D
	if not body:
		push_error("DoubleJumpComponent must be a child of a CharacterBody3D!")

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	# Check if the event matches ANY action in our lookup keys
	for action in DIRECTION_MAP.keys():
		if event.is_action_pressed(action):
			var pressed_dir = DIRECTION_MAP[action]
			if event.is_action_pressed("dash") or (last_press_time > 0 and last_keycode == event.keycode):
				start_dash(VECTOR_MAP[pressed_dir])
			else:
				last_press_time = double_tap_timeout
				last_keycode = event.keycode
			break
			
func _process(delta: float) -> void:
	last_press_time -= delta

# --- The start_dash function called by your input handler ---
func start_dash(relative_vector: Vector3) -> void:
	is_dashing = true
	dash_timer = dash_duration
	
	# 1. Grab the camera's orientation matrix (basis)
	var cam_basis = body.camera.global_transform.basis
	
	# 2. Multiply the camera view by our intent vector (e.g., Vector3.LEFT)
	var world_direction = cam_basis * relative_vector
	
	# 3. CRITICAL: Flatten the Y axis. If the camera is tilted down, 
	# this stops the forward dash from driving the player down into the floor.
	world_direction.y = 0
	
	# 4. Normalize it so diagonal calculations don't accidentally make you move faster
	dash_direction = world_direction.normalized()

# --- Hook this into your physics loop to execute the high-speed movement ---
func _physics_process(delta: float) -> void:
	
	if is_dashing:
		process_dash(delta)
		return # BYPASS standard WASD walking and gravity during a dash!

	# ... Your normal walking movement and gravity logic live down here ...
	# var input_dir = Input.get_vector(...)
	# move_and_slide()

func process_dash(delta: float) -> void:
	dash_timer -= delta
	
	# Inject the camera-relative dash vector directly into horizontal velocity
	body.velocity.x = dash_direction.x * dash_speed
	body.velocity.z = dash_direction.z * dash_speed
	#body.velocity.y = 0 # Lock gravity to 0 for a crisp, airborne air-dash effect
	
	# Clean exit when the dash duration ends
	if dash_timer <= 0:
		is_dashing = false
		# Kill horizontal momentum instantly so you don't wildly slide forever
		body.velocity.x = 0
		body.velocity.z = 0
