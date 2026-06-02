extends Node3D

var can_double_jump: bool = false
var body: CharacterBody3D

# This will act as our safety buffer
var frames_since_floor: int = 0

func _ready() -> void:
	body = get_parent() as CharacterBody3D
	if not body:
		push_error("DoubleJumpComponent must be a child of a CharacterBody3D!")

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if body.is_on_floor():
		# Reset our double jump ability when touching the ground
		can_double_jump = true
		frames_since_floor = 0
		
	frames_since_floor += 1
	# If we are in mid-air and hit the jump button
	if frames_since_floor > 3 and Input.is_action_just_pressed("ui_accept") and can_double_jump:
		execute_double_jump()

func execute_double_jump() -> void:
	body.animation_player.play("Player/Jump_Start")
	body.velocity.y += 6.0
	can_double_jump = false
	frames_since_floor = 0
