extends Node
class_name CharacterState


@export var animation : String
@export var state_name : String
@export var priority : int
@export var backend_animation : String
@export var tracking_angular_speed : float = 10
# I can tolerate up to two _costs, 
# the moment I need a third one, I'll create a small ResourceCost class to pay them.
@export var stamina_cost : float = 0

@onready var combos : Array[Combo] 

var model: CharacterModel

var enter_state_time : float
var initial_position : Vector3
var frame_length = 0.016

var has_queued_state : bool = false
var queued_state : String = "nonexistent queued state, drop error please"

var has_forced_state : bool = false
var forced_state : String = "nonexistent forced state, drop error please"

var DURATION : float


func check_relevance(input : InputPackage) -> String:
	if accepts_queueing():
		check_combos(input)
		
	if has_queued_state and transitions_to_queued():
		try_force_state(queued_state)
		has_queued_state = false
	
	if has_forced_state:
		has_forced_state = false
		return forced_state
		
	return default_lifecycle(input)


func check_combos(input : InputPackage):
	for combo : Combo in combos:
		if combo.is_triggered(input) and model.stats.can_be_paid(model.states.get_state_by_name(combo.triggered_state)):
			has_queued_state = true
			queued_state = combo.triggered_state


func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(model.states.states_priority_sort)
	for action in input.actions:
		if model.stats.can_be_paid(model.states.states[action]):
			if model.states.states[action] == self:
				return "okay"
			else:
				return action
	return "throwing because for some reason input.actions doesn't contain even idle"  


func _update(input : InputPackage, delta : float):
	if tracks_input_vector():
		process_input_vector(input, delta)
	update(input, delta)


func update(_input : InputPackage, _delta : float):
	pass


func process_input_vector(input : InputPackage, delta : float):
	model.character.rotate_mesh(model.character.get_direction(input))


func update_resources(delta : float):
	model.stats.update(delta)


func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()


func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time


func works_longer_than(time : float) -> bool:
	if get_progress() >= time:
		return true
	return false


func works_less_than(time : float) -> bool:
	if get_progress() < time: 
		return true
	return false


func works_between(start : float, finish : float) -> bool:
	var progress = get_progress()
	if progress >= start and progress <= finish:
		return true
	return false


func transitions_to_queued() -> bool:
	return model.states.data_repo.get_transitions_to_queued(backend_animation, get_progress())


func accepts_queueing() -> bool:
	return model.states.data_repo.get_accepts_queueing(backend_animation, get_progress())


func tracks_input_vector() -> bool:
	return model.states.data_repo.tracks_input_vector(backend_animation, get_progress())


func time_til_unlocking() -> float:
	if tracks_input_vector():
		return 0
	return model.states.data_repo.time_til_next_controllable_frame(backend_animation, get_progress())


func is_vulnerable() -> bool:
	return model.states.data_repo.get_vulnerable(backend_animation, get_progress())


func is_interruptable() -> bool:
	return model.states.data_repo.get_interruptable(backend_animation, get_progress())


func is_parryable() -> bool:
	return model.states.data_repo.get_parryable(backend_animation, get_progress())


func get_root_position_delta(delta_time : float) -> Vector3:
	return model.states.data_repo.get_root_delta_pos(backend_animation, get_progress(), delta_time)


func right_weapon_hurts() -> bool:
	return model.states.data_repo.get_right_weapon_hurts(backend_animation, get_progress())


# "default-default", works for animations that just linger
func default_lifecycle(input : InputPackage):
	if works_longer_than(DURATION):
		return best_input_that_can_be_paid(input)
	return "okay"


func _on_enter_state():
	initial_position = model.character.global_position
	model.stats.pay_resource_cost(self)
	mark_enter_state()
	on_enter_state()
	model.animator.update_body_animations()


func on_enter_state():
	pass


func _on_exit_state():
	on_exit_state()


func on_exit_state():
	pass


func assign_combos():
	for child in get_children():
		if child is Combo:
			combos.append(child)
			child.state = self


func form_hit_data(_weapon : Weapon) -> HitData:
	print("someone tries to get hit by default state")
	return HitData.blank()


func react_on_hit(hit : HitData):
	if not is_vulnerable():
		print("hit is here, but still the roll")
	if is_vulnerable():
		model.stats.lose_health(hit.damage)
	if is_interruptable():
		# TODO rewrite for better effects processing, this scales badly
		if hit.effects.has("Pushback") and hit.effects["Pushback"]:
			try_force_state("Pushback")
		else:
			try_force_state("staggered")


func react_on_parry(_hit : HitData):
	try_force_state("parried")


func try_force_state(new_forced_state : String):
	if not has_forced_state:
		has_forced_state = true
		forced_state = new_forced_state
	elif model.states.get_state_by_name(new_forced_state).priority >= model.states.get_state_by_name(forced_state).priority:
		forced_state = new_forced_state
		
