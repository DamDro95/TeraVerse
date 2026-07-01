extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in SceneLoader.transfer_nodes:
		add_child(node)
		if node is PlayerEntity:
			var player = node as PlayerEntity
			player.global_position = Vector3(0,0,0)
			player.view.set_meshes()
