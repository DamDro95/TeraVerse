extends LegsState


func _init() -> void:
	state_name = "Move"


func transition_legs_state(input, _delta):
	var target_move : String = "Idle"

	if input.input_direction:
		if input.actions.has("Move"):
			target_move = "Move"
		
	if target_move != legs_manager.current_state.state_name:
		change_state(target_move)
