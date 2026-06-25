extends Weapon
class_name Sword


func _ready():
	base_damage = 10
	basic_attacks = {
		"Attack" : "Attack"
	}


func get_hit_data():
	return holder.current_state.form_hit_data(self)
