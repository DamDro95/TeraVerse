extends Node3D
class_name CharacterView


@export var model: CharacterModel

@onready var meshes: Dictionary[String, MeshInstance3D] = { 
	"hat": $Hat,
	"head": $Head,
	"arm_right": $ArmRight,
	"arm_left": $ArmLeft,
	"body": $Body,
	"leg_right": $LegRight,
	"leg_left": $LegLeft,
}


func set_meshes() -> void:
	var skeleton_path = model.skeleton.get_path()
	for mesh in meshes:
		meshes[mesh].skeleton = skeleton_path


func set_mesh(target: String, mesh_path: String) -> void:
	meshes[target].mesh = load(mesh_path)


func set_mesh_pair(target: String, mesh_pair: Dictionary) -> void:
	var target_mesh = target + "_right"
	meshes[target_mesh].mesh = load(mesh_pair["right"])
	
	target_mesh = target + "_left"
	meshes[target_mesh].mesh = load(mesh_pair["left"])
