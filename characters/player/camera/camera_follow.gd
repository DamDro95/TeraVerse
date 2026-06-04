extends Camera3D

@onready var spring_arm := $"../SpringArm3D/SpringArmPosition"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#saif not multiplayer.is_server(): return
	position = lerp(position, spring_arm.position, delta*5.0)
