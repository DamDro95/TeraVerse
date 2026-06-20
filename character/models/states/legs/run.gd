extends LegsBehaviour


func transition_legs_state(input, _delta):
	var target_move : String = "Idle"

	if input.input_direction:
		if input.actions.has("Running"):
			target_move = "Running"
		
		if input.actions.has("Slide"):
			target_move = "Slide_Idle"

	if target_move != current_legs_state.state_name:
		change_state(target_move)
