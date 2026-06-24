extends Node
class_name PlayerController

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.actions.append("Idle")
	
	new_input.input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("Move")
		
	#if Input.is_action_pressed("dash"):
		#new_input.actions.append("Dash")
	#
	#if Input.is_action_pressed("fly"):
		#new_input.actions.append("Fly_Start")
	
	if Input.is_action_pressed("slide"):
		new_input.actions.append("Slide")
	
	if Input.is_action_pressed("jump"):
		new_input.actions.append("Jump")
		#if new_input.actions.has("sprint"):
			#new_input.actions.append("jump_sprint")
		#else:
			#new_input.actions.append("jump_run")
	
	if Input.is_action_pressed("attack"):
		new_input.combat_actions.append("Attack")
	#if Input.is_action_just_pressed("heavy_attack"):
		#new_input.combat_actions.append("heavy_attack_pressed")
	
	#print(new_input.input_direction)
	return new_input
