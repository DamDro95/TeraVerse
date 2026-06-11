extends Node
class_name LegsBehaviour


var model : CharacterModel
var moves_container : CharacterStates
var legs_manager : Legs
var current_legs_move : CharacterState


func update(input : InputPackage, delta : float):
	transition_legs_state(input, delta)
	current_legs_move._update(input, delta)


func transition_legs_state(_input, _delta):
	pass


func change_state(next_state : String):
	current_legs_move = moves_container.get_move_by_name(next_state)
	legs_manager.current_legs_move = current_legs_move
	model.animator.update_legs_animation()
