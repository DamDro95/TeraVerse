extends Node3D

var body: CharacterBody3D
var is_jumping = false

func _ready() -> void:
	body = get_parent() as CharacterBody3D
	if not body:
		push_error("JumpComponent must be a child of a CharacterBody3D!")

func _unhandled_input(event: InputEvent) -> void:
	# Check if the event matches ANY action in our lookup keys
	if event.is_action_pressed("attack") and body.is_on_floor():
		handle_attack_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func handle_attack_input() -> void:
	body.animation_player.play("Player/Melee_1H_Attack_Chop")
