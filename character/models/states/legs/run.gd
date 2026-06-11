extends LegsBehaviour


func transition_legs_state(input, _delta):
	var target_move : String

	if input.input_direction:
		if input.actions.has("Running"):
			target_move = "Running"
	print(target_move + " - ")
	if target_move != current_legs_move.move_name:
		change_state(target_move)
