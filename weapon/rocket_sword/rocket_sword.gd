extends Weapon

func _ready():
	super()
	base_damage = 10
	basic_attacks = {
		"Attack" : "Attack"
	}
	is_attacking = true


func get_hit_data():
	return holder.current_state.form_hit_data(self)
