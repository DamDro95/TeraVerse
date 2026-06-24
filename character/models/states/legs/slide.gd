extends LegsState


func _init() -> void:
	state_name = "Slide"


func transition_legs_state(input, _delta):
	var target_move : String = "Idle"

	if input.input_direction:
		if input.actions.has("Slide"):
			target_move = "Slide_Idle"
	
	if target_move != legs_manager.current_state.state_name:
		change_state(target_move)
