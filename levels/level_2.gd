# Attach this script on the root node of each level
class_name Level extends Node3D

const LEVEL_SAVES_FOLDER: String = "user://level_saves/"

# List of all levels and assign a unique int for each key (eg. Forest_1 = 1, Snow_1 = 5...)
enum LevelIDs {
	
}

# Assign the coresponding level id to the level with this script
@export var level_id: LevelIDs

# How to get the game to autosave
#
# make a static var to define the current level of type Level (class_name):
# 		static var current_level: Level
# then in the ready function in any level, set the current_level var to itself
# 		current_level = self
# then at a specific instance (eg. completing a challenge) call the save function from anywhere
# 		Level.current_level.save_level_data()


func _ready() -> void:
	DirAccess.make_dir_absolute(LEVEL_SAVES_FOLDER)
	
	load_level_data()
	save_level_data()

func get_level_save_file_path() -> String:
	# '.tres' is for debugging purposes - BE SURE TO SWITCH TO '.res' for a more secure version
	return LEVEL_SAVES_FOLDER +str("level_save_", level_id) + ".tres"

func save_level_data() -> void:
	var new_save = LevelSaveData.new()
	
	for saver: SaverNode in get_tree().get_nodes_in_group(SaverNode.SAVER_NODE_GROUP):
		var node_path = get_path_to(saver)
		new_save.data[node_path] = saver.get_save_dict()
		
	ResourceSaver.save(new_save, get_level_save_file_path())
	print ("Saved level data to ", get_level_save_file_path())

func load_level_data() -> void:
	if not FileAccess.file_exists(get_level_save_file_path()):
		return
	
	print ("Saved level data to ", get_level_save_file_path())
	var loaded_save = ResourceLoader.load(get_level_save_file_path()) as LevelSaveData
	
	for path in loaded_save.data:
		var saver_node = get_node_or_null(path)
		if saver_node:
			saver_node.apply_save_dict(loaded_save.save[path])
