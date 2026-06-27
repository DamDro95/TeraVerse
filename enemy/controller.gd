extends CharacterController
class_name EnemyController


func gather_input(disabled: bool = false) -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.actions.append("Follow")

	return new_input
