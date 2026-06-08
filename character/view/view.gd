extends Node3D
class_name CharacterView

@export var model: CharacterModel

@export var skeleton: Skeleton3D

#@onready var sword_visuals_1 = $SwordVisuals1
#@onready var stamina_label = $"Stamina _bar_"
#@onready var health_label = $"Health _bar_"


func _ready():
	skeleton = model.skeleton


#func _process(_delta):
	#update_resources_interface()
	#adjust_weapon_visuals()


#func adjust_weapon_visuals():
	#sword_visuals_1.global_transform = model.active_weapon.global_transform


#func update_resources_interface():
	#if not model.is_enemy:
		#stamina_label.text = "Stamina " + "%10.3f" % model.resources.stamina
		#health_label.text = "Health " + "%10.3f" % model.resources.health
