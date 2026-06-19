extends Combo


func is_triggered(input : InputPackage) -> bool:
	# if input.actions.has( current weapon light attack move code ) in future for scalability
	if input.actions.has("Attack"):
		return true
	return false
