extends Node
class_name CharacterPhysics

@export var character: CharacterEntity

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var MAX_SPEED = 12.0
@onready var ACCELERATION = 40.0
@onready var SLIDE_ACCELERATION = 80.0
@onready var FRICTION = 10.0
@onready var SLIDE_FRICTION = 55.0
@onready var JUMP_VELOCITY = 8
@onready var AIR_CONTROL = 5.0

func apply_horizontal_resistance(type: String, delta : float):
	var friction = get_resistance(type)
	var velocity_h = Vector3(character.velocity.x, 0, character.velocity.z)
	velocity_h = velocity_h.move_toward(Vector3.ZERO, friction * delta)
	character.velocity.x = velocity_h.x
	character.velocity.z = velocity_h.z

func get_resistance(type: String) -> float:
	match type:
		"ground":
			return FRICTION
		"slide":
			return SLIDE_FRICTION
		"air":
			return AIR_CONTROL
	return FRICTION
