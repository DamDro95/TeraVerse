extends Node3D

@export var player: PlayerController


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	# Check if the event matches ANY action in our lookup keys
	if event.is_action_pressed("jump") and player.current_state == player.MoveState.JUMPING:
		double_jump()


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if player.current_state == player.MoveState.DOUBLE_JUMPING and player.is_on_floor():
		player.change_state(player.MoveState.IDLE_WALK)


func double_jump() -> void:
	player.change_state(player.MoveState.DOUBLE_JUMPING)
	player.animation_player.play("Player/Jump_Start")
	player.velocity.y += 6.0
