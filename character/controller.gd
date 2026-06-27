extends Node
class_name CharacterController

func gather_input(disabled: bool = false) -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.actions.append("Idle")

	return new_input
