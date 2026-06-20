extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_blend_time("Running_legs", "Slide_Down_legs", 0.25)
	set_blend_time("Slide_Idle_legs", "Jump_Start_legs", 0.25)
	#set_blend_time("run", "idle", 0.2)
