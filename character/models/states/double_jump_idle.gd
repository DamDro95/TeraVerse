extends CharacterStateJumpIdle


func default_lifecycle(input : InputPackage):
	var floor_distance = model.area_awareness.get_floor_distance()
	if floor_distance < LANDING_HEIGHT:
		return "Jump_Land"
		
	return "okay"
