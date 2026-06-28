extends Node
class_name LegsStates


# The more suited approach will be inherit Move once more to define LegsMove 
# then those heirs will register themselves here on_enter state.
# This way we could escape the need to manually call update() here.
# But I wanted a fast makeshift patch to work
@export var model : CharacterModel
#@export var legs_states : Array[Move]
var current_state : CharacterState
var states: Dictionary[String, LegsState]


func load_states():
	for child in get_children():
		if child is LegsState:
			states[child.state_name] = child
			child.model = model
