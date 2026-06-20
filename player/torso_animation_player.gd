extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_blend_time("Sword_1h_Attack_Chop_torso", "Sword_1h_Attack_Slice_Diagonal_torso", 0.25)
	set_blend_time("Sword_1h_Attack_Slice_Diagonal_torso", "Sword_1h_Attack_Stab_torso", 0.25)
	set_blend_time("Sword_1h_Attack_Stab_torso", "Sword_1h_Attack_Chop_torso", 0.25)
