extends Node3D
class_name CharacterView


@export var model: CharacterModel

@onready var skeleton: Skeleton3D
@onready var meshes = { 
	"hat": $Hat,
	"head": $Head,
	"arm_right": $ArmRight,
	"arm_left": $ArmLeft,
	"body": $Body,
	"leg_right": $LegRight,
	"leg_left": $LegLeft,
}
@onready var speed_value = $SpeedValueLabel


func _ready():
	skeleton = model.skeleton
	for mesh in meshes:
		meshes[mesh].skeleton = skeleton.get_path()


func set_mesh(target: String, mesh_path: String) -> void:
	meshes[target].mesh = load(mesh_path)

func set_mesh_pair(target: String, mesh_pair: Dictionary) -> void:
	print(mesh_pair)
	meshes[target + "_right"].mesh = load(mesh_pair["right"])
	meshes[target + "_left"].mesh = load(mesh_pair["left"])
