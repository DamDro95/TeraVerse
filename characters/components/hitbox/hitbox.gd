class_name HitboxComponent
extends Area3D

@export var damage: float = 15.0

func _ready() -> void:
	# Connect Godot's built-in area detection signal to our custom logic
	area_entered.connect(_on_area_entered)

func _on_area_entered(incoming_area: Area3D) -> void:
	# If what we hit is a Hurtbox, tell it to take our damage payload
	if incoming_area is HurtboxComponent:
		incoming_area.receive_hit(damage)
