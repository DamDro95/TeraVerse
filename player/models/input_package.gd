extends Resource
class_name InputPackage

var actions : Array[String]
var combat_actions : Array[String]

var input_direction : Vector2 

func get_actions_filtered() -> Array[String]:
	return actions.filter(func(action): return action not in combat_actions)
