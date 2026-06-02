extends Node3D

@onready var spring_arm := $SpringArm3D

var capture = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * 0.005
		# Snap camera
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * 0.005
		rotation.x = clamp(rotation.x, -PI/2, PI/4)

	if event.is_action_pressed("wheel_up"):
		spring_arm.spring_length -= 1
	if event.is_action_pressed("wheel_down"):
		spring_arm.spring_length += 1
		
	if event.is_action_pressed("toggle_mouse_capture"):
		capture = true
		
	if event.is_action_released("toggle_mouse_capture"):
		capture = false

func _physics_process(delta: float) -> void:

	if capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
