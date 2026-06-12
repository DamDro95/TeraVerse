extends Node
class_name CharacterStates


var states : Dictionary

@onready var model : CharacterModel = get_parent()
@onready var data_repo: StateDataRepo = $StateDataRepo


func accept_states():
	for state in get_children():
		if not state is CharacterState:
			continue
			
		states[state.state_name] = state
		state.model = model
		state.DURATION = data_repo.get_duration(state.backend_animation)
		state.assign_combos()


func states_priority_sort(a : String, b : String):
	if states[a].priority > states[b].priority:
		return true
	else:
		return false


func get_state_by_name(state_name : String) -> CharacterState:
	return states[state_name]
