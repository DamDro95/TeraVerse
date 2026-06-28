extends Node
class_name CharacterController

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.actions.append("Idle")

	return new_input
