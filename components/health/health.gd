extends Sprite3D

@export var health: float = 100.00

@onready var sub_viewport: SubViewport = $SubViewport
@onready var health_bar: ProgressBar = $SubViewport/HealthBar

signal health_depleted

func _ready() -> void:
	# Programmatically assign the viewport texture to the Sprite3D
	texture = sub_viewport.get_texture()
	
	health_bar.value = health

func take_damage(damage: float) -> void:
	health -= damage
	
	if health <= 0:
		health_depleted.emit()
	
	health_bar.value = health
