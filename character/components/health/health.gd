extends Sprite3D

@export var health: float = 100.00:
	set(value):
		health = value
		_update_health_visuals.call_deferred()

@onready var sub_viewport: SubViewport = $SubViewport
@onready var health_bar: ProgressBar = $SubViewport/HealthBar

signal health_depleted
signal health_reduced

func _ready() -> void:
	# Programmatically assign the viewport texture to the Sprite3D
	await get_tree().process_frame
	texture = sub_viewport.get_texture()
	
	_update_health_visuals()

func take_damage(damage: float) -> void:
	health = max(0.0, health - damage)

	if health <= 0:
		health_depleted.emit()
	else:
		health_reduced.emit()


func _update_health_visuals() -> void:
	if health_bar:
		health_bar.value = health
