extends Node3D

@export var player: PlayerController

const FLY_SPEED = 8.0

func _input(event: InputEvent) -> void:
	if not player or not player.is_multiplayer_authority(): return

	if event.is_action_pressed("fly"):
		if player.current_state == player.MoveState.FLYING:
			player.change_state(player.MoveState.IDLE_WALK)
		else:
			player.change_state(player.MoveState.FLYING)

func _physics_process(delta: float) -> void:
	if not player or not player.is_multiplayer_authority(): return

	# Only run flying controls if the player is actually in the FLYING state
	if player.current_state == player.MoveState.FLYING:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		
		var vertical_input := 0.0
		if Input.is_action_pressed("jump"): vertical_input += 1.0
		if Input.is_action_pressed("descend"): vertical_input -= 1.0

		var direction := (player.transform.basis * Vector3(input_dir.x, vertical_input, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, player.camera.global_rotation.y)
		
		# Override the player's velocity directly
		player.velocity = direction * FLY_SPEED
