extends TorsoPartialState


@export var RELEASES_PRIORITY : float

const ANIMATION_SPEED = 1.5

@onready var hit_damage = 10 # will be a function of player stats in the future


# this strange construction is here because our animation asset has a long tail transitioning to idle,
# think of it as of "custom perfect blending" to idle
# so after a certain point we want to release priority, but to anything except idle
func default_lifecycle(input : InputPackage) -> String:
	#if works_less_than(RELEASES_PRIORITY):
	if works_less_than(DURATION):
		return "okay"
	
	return best_input_that_can_be_paid(input)


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = is_parryable()
	hit.weapon = model.character.model.active_weapon
	return hit


func on_enter_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) / ANIMATION_SPEED
	model.animator.set_speed_scale(ANIMATION_SPEED, "torso")


func on_exit_state():
	DURATION = model.states.data_repo.get_duration(backend_animation) * ANIMATION_SPEED
	model.animator.set_speed_scale(1, "toso")
	model.character.model.active_weapon.hitbox_ignore_list.clear()
	model.character.model.active_weapon.is_attacking = false
