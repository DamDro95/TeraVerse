extends Node3D

var is_jumping = false

@export var player: PlayerController
@export var jump_velocity: float = 5.0

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	# Check if the event matches ANY action in our lookup keys
	if event.is_action_pressed("jump") and player.is_on_floor():
		jump()
		
func jump() -> void:
	player.velocity.y = jump_velocity
	player.change_state(player.MoveState.JUMPING)
	player.animation_player.play("Player/Jump_Start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if player.current_state == player.MoveState.JUMPING and player.is_on_floor():
		player.change_state(player.MoveState.IDLE_WALK)
