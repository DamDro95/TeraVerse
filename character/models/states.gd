extends Node
class_name CharacterStates


@export var model : CharacterModel
@export var state_data: PlayerMovesData

var moves : Dictionary # { string : Move }, where string is Move heirs name


func accept_moves():
	state_data.move_database = model.animator
	for move in get_children():
		if move is CharacterState:
			print(move.move_name)
			moves[move.move_name] = move
			move.model = model
			move.DURATION = state_data.get_duration(move.backend_animation)
			move.state_data = state_data

			move.assign_combos()


func moves_priority_sort(a : String, b : String):
	if moves[a].priority > moves[b].priority:
		return true
	else:
		return false


func get_move_by_name(move_name : String) -> CharacterState:
	return moves[move_name]
