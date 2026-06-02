extends Node3D

@export var body: CharacterBody3D

@export var hitbox: Area3D

var is_attacking: bool = false

func _input(event: InputEvent) -> void:
	# Check if the event matches ANY action in our lookup keys
	if event.is_action_pressed("attack") and body.is_on_floor():
		hitbox.monitoring = true
		body.animation_player.play("Player/Melee_1H_Attack_Chop")
		
		call_deferred("attack")


func attack() -> void:
	await get_tree().create_timer(1).timeout
	hitbox.monitoring = false
