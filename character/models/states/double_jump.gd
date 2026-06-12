extends CharacterStateJump


func default_lifecycle(input : InputPackage):
	if works_less_than(DURATION):
		return "okay"
	
	jumped = false
	return "Double_Jump_Idle"
