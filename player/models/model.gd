extends CharacterModel
class_name PlayerModel

@onready var active_weapon : Weapon = $RightHand/RocketSword as Weapon

func _ready():
	super();
	for state in active_weapon.states:
		states.load_state(state)
