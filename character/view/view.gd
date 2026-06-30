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


func _ready():
	skeleton = model.skeleton


func set_meshes() -> void:
	print(skeleton.get_path())
	for mesh in meshes:
		print(skeleton.get_path())
		meshes[mesh].skeleton = skeleton.get_path()


func set_mesh(target: String, mesh_path: String) -> void:
	meshes[target].mesh = load(mesh_path)

func set_mesh_pair(target: String, mesh_pair: Dictionary) -> void:
	meshes[target + "_right"].mesh = load(mesh_pair["right"])
	meshes[target + "_left"].mesh = load(mesh_pair["left"])
