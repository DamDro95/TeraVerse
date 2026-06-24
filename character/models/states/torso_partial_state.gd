extends CharacterState
class_name TorsoPartialState


@export var valid_legs_states: Array[String]

# Dangerous stuff, but we are overriding an internal method of base Move class.
# Unthoughtful changes can ruin base Move processing around this class.
# Here I only add new lines and I call the base implementation onwards
func _update(input : InputPackage, delta : float):
	# Check to see if the is a valid leg state to enter
	var do_intersect: bool = input.actions.any(func(item): return item in valid_legs_states)
	if do_intersect:
		var input_no_combat = InputPackage.new()
		input_no_combat.actions = input.get_actions_filtered()
		input_no_combat.input_direction = input.input_direction
		
		var next_legs_state = model.legs.current_state.check_relevance(input_no_combat)
		if next_legs_state != "okay":
			model.legs.states[next_legs_state].update(input, delta)
		else:
			model.legs.current_state._update(input, delta)
	
	process_input_vector(input, delta)
	update(input, delta)
