extends Node
class_name LegsState


@export var state_name: String

@onready var model : CharacterModel
@onready var legs_manager : LegsStates = get_parent()


func update(input : InputPackage, delta : float):
	transition_legs_state(input, delta)
	print('Update Legs: ' + legs_manager.current_state.state_name)
	legs_manager.current_state._update(input, delta)


func transition_legs_state(_input, _delta):
	pass


func change_state(next_state : String):
	legs_manager.current_state = model.states.get_state_by_name(next_state)
	model.animator.update_legs_animation()
