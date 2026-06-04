extends Node3D

var body: CharacterBody3D
var is_jumping = false

func _ready() -> void:
	body = get_parent() as CharacterBody3D
	if not body:
		push_error("JumpComponent must be a child of a CharacterBody3D!")

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	# Check if the event matches ANY action in our lookup keys
	if event.is_action_pressed("ui_accept") and body.is_on_floor():
		handle_jump_input()
		
func handle_jump_input() -> void:
	body.velocity.y = 5.0
	is_jumping = true
	body.animation_player.play("Player/Jump_Start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if is_jumping and body.velocity.y > 0 and body.animation_player.current_animation != "Player/Jump_Start":
		body.animation_player.play("Player/Jump_Idle")
	
	if is_jumping and body.is_on_floor():
		body.animation_player.play("Player/Jump_Land")
		is_jumping = false
