extends CharacterView
class_name PlayerView

@onready var speed_value = $SpeedValueLabel

func _physics_process(delta: float) -> void:
	speed_value.text = str(model.character.velocity.length())
