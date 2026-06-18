extends Node
class_name LegsBehaviour


var model : CharacterModel
var states : CharacterStates
var legs_manager : Legs
var current_legs_state : CharacterState


func update(input : InputPackage, delta : float):
	transition_legs_state(input, delta)
	current_legs_state._update(input, delta)


func transition_legs_state(_input, _delta):
	pass


func change_state(next_state : String):
	print(next_state)
	current_legs_state = states.get_state_by_name(next_state)
	legs_manager.current_legs_state = current_legs_state
	model.animator.update_legs_animation()
