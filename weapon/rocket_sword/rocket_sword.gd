extends Weapon

func _ready():
	super()
	base_damage = 10
	basic_attacks = {
		"Attack" : "Attack"
	}


func get_hit_data():
	return holder.current_move.form_hit_data(self)
