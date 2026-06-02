extends Marker3D

@export var spawn_time: float = 2.00
@export var entity_scene: PackedScene

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkController.server_started.connect(start_timer)
	timer.timeout.connect(spawn)
	
	timer.wait_time = spawn_time


func start_timer() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn() -> void:
	var entity = entity_scene.instantiate()
	get_parent().add_child(entity)
