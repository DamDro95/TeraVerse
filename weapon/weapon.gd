extends MeshInstance3D
class_name Weapon

var hitbox_ignore_list : Array[Area3D]
var is_attacking : bool = false
var states: Array[CharacterState]

@export var holder : CharacterModel

@export var base_damage : float = 10

var basic_attacks : Dictionary


func _ready() -> void:
	for child in get_children():
		if child is not CharacterState:
			continue
		states.append(child)


func get_hit_data() -> HitData:
	print("someone tries to get hit by default Weapon")
	return HitData.blank()
