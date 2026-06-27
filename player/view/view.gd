extends CharacterView
class_name PlayerView


func _physics_process(delta: float) -> void:
	speed_value.text = str(model.character.velocity.length())
