extends Combo


func is_triggered(input : InputPackage) -> bool:
	if input.actions.has("Jump"):
		return true
	return false
