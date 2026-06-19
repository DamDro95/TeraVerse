extends Node


@export var animations : AnimationPlayer
@export var animation_data : AnimationPlayer
@export var model : CharacterModel

const ANIMATION_DIRECTORY_EXTRACTED = "res://assets/animations/rig_medium/extracted/"
const ANIMATION_DIRECTORY_TORSO = "res://assets/animations/rig_medium/torso/"
const ANIMATION_DIRECTORY_LEGS = "res://assets/animations/rig_medium/legs/"
const ANIMATION_DIRECTORY_DATA = "res://assets/animations/rig_medium/data/"
const ANIMATION_DIRECTORY_STATIC = "res://assets/animations/rig_medium/static/"
const ANIMATION_DIRECTORY_FORMATTED = "res://assets/animations/rig_medium/formatted/"

@onready var animation_names = {
	#"Sword_1h_Attack_Chop" : "Sword_1h_Attack_Chop",
	#"Sword_1h_Attack_Slice_Diagonal" : "Sword_1h_Attack_Slice_Diagonal",
	"Sword_1h_Attack_Stab" : "Sword_1h_Attack_Stab",
	#"Idle_B" : "Idle",
	#"Dodge_Forward" : "Dash",
	#"Jump_Idle" : "Jump_Idle",
	#"Jump_Land" : "Jump_Land",
	#"Jump_Start" : "Jump_Start",
	#"Running_B" : "Running",
	#"Sit_Floor_Down" : "Slide_Down",
	#"Sit_Floor_Idle" : "Slide_Idle",
	#"Sit_Floor_StandUp" : "Slide_End",
}

@onready var torso_bones_rename_map = {
	#"Rig_Medium/Skeleton3D:root" : "%Skeleton3D:root",
	"Rig_Medium/Skeleton3D:head" : "%Skeleton:head",
	"Rig_Medium/Skeleton3D:chest" : "%Skeleton:chest",
	"Rig_Medium/Skeleton3D:spine" : "%Skeleton:spine",
	"Rig_Medium/Skeleton3D:upperarm.r" : "%Skeleton:upperarm.r",
	"Rig_Medium/Skeleton3D:upperarm.l" : "%Skeleton:upperarm.l",
	"Rig_Medium/Skeleton3D:lowerarm.r" : "%Skeleton:lowerarm.r",
	"Rig_Medium/Skeleton3D:lowerarm.l" : "%Skeleton:lowerarm.l",
	"Rig_Medium/Skeleton3D:wrist.r" : "%Skeleton3D:wrist.r",
	"Rig_Medium/Skeleton3D:wrist.l" : "%Skeleton3D:wrist.l",
	"Rig_Medium/Skeleton3D:hand.r" : "%Skeleton:hand.r",
	"Rig_Medium/Skeleton3D:hand.l" : "%Skeleton:hand.l",
	"Rig_Medium/Skeleton3D:handslot.r" : "%Skeleton:handslot.r",
	"Rig_Medium/Skeleton3D:handslot.l" : "%Skeleton:handslot.l",
}

@onready var legs_bones_rename_map = {
	"Rig_Medium/Skeleton3D:hips" : "%Skeleton:hips",
	"Rig_Medium/Skeleton3D:upperleg.r" : "%Skeleton:upperleg.r",
	"Rig_Medium/Skeleton3D:upperleg.l" : "%Skeleton:upperleg.l",
	"Rig_Medium/Skeleton3D:lowerleg.r" : "%Skeleton:lowerleg.r",
	"Rig_Medium/Skeleton3D:lowerleg.l" : "%Skeleton:lowerleg.l",
	"Rig_Medium/Skeleton3D:foot.r" : "%Skeleton:foot.r",
	"Rig_Medium/Skeleton3D:foot.l" : "%Skeleton:foot.l",
	"Rig_Medium/Skeleton3D:toes.r" : "%Skeleton:toes.r",
	"Rig_Medium/Skeleton3D:toes.l" : "%Skeleton:toes.l",
}


func _ready():
	#format_dev_animations()
	#for animation_name in animation_names.keys():
		#setup_animation(animation_name)
	#setup_animation_root_data("Sword_1h_Attack_Chop", "Sword_1h_Attack_Chop", -0.062)
	print("DONE")
	

func format_dev_animations():
	var anim_list: PackedStringArray = animations.get_animation_list()
	
	for animation_name in anim_list:
		var animation = animations.get_animation(animation_name)
		var total_tracks: int = animation.get_track_count()
		for i in range(total_tracks - 1, -1, -1):
			var track_path: NodePath = animation.track_get_path(i)
			var track_path_string: String = str(track_path)
			#update the track name
			if torso_bones_rename_map.has(track_path_string):
				animation.track_set_path(i, torso_bones_rename_map[track_path_string])
			if legs_bones_rename_map.has(track_path_string):
				animation.track_set_path(i, legs_bones_rename_map[track_path_string])
			ResourceSaver.save(animation, ANIMATION_DIRECTORY_EXTRACTED + animation_name + ".res")


#DEVELOPMENT LEAYER FUNCTIONAL, IT DOES MODIFY ASSETS, UNCOMMENT IF YOU KNOW WHAT YOU ARE DOING
#AND DID BACKUPS
func setup_animation(animation_name : String):
	var animation = animations.get_animation(animation_name) as Animation
	var animation_torso = split_animations(animation, torso_bones_rename_map)
	var animation_legs = split_animations(animation, legs_bones_rename_map)
	var animation_data = create_animation_data(animation)
	
	ResourceSaver.save(animation_torso, ANIMATION_DIRECTORY_TORSO + animation_names[animation_name] + "_torso.res")
	ResourceSaver.save(animation_legs, ANIMATION_DIRECTORY_LEGS + animation_names[animation_name] + "_legs.res")
	ResourceSaver.save(animation_data, ANIMATION_DIRECTORY_DATA + animation_names[animation_name] + ".res")

func split_animations(animation : Animation, rename_map: Dictionary) -> Animation:
	var split_animation = animation.duplicate()
	var total_tracks: int = split_animation.get_track_count()
	for i in range(total_tracks - 1, -1, -1):
		var track_path: NodePath = split_animation.track_get_path(i)
		var track_path_string: String = str(track_path)
		if rename_map.values().has(track_path_string):
			#update the track name
			split_animation.track_set_path(i, track_path_string)
		else:
			split_animation.remove_track(i)
		
	return split_animation
	
func create_animation_data(animation: Animation) -> Animation:
	var animation_data = animation.duplicate()
	var total_tracks: int = animation_data.get_track_count()
	for i in range(total_tracks - 1, -1, -1):
		var track_path: NodePath = animation_data.track_get_path(i)
		var track_path_string: String = str(track_path)
		animation_data.remove_track(i)
	return animation_data

func setup_animation_root_data(animation_name : String, into_backend_animation : String, value : float) -> void:
	var animation = animations.get_animation(animation_name) as Animation
	var backend_animation = animation_data.get_animation(into_backend_animation) as Animation
	var backend_track = backend_animation.find_track("StateData:root_position", Animation.TYPE_VALUE)
	var hips_track = animation.find_track("%Skeleton:hips", Animation.TYPE_POSITION_3D)
	for i : int in animation.track_get_key_count(hips_track):
		var position = animation.track_get_key_value(hips_track, i)
		var time = animation.track_get_key_time(hips_track, i)
		backend_animation.track_insert_key(backend_track, time, position)
		var position_without_z = position
		position_without_z.z = value
		animation.track_set_key_value(hips_track, i, position_without_z)
	
	var animation_torso = split_animations(animation, torso_bones_rename_map)
	var animation_legs = split_animations(animation, legs_bones_rename_map)
	
	# create a animation file with z position adjusted
	ResourceSaver.save(animation_torso, ANIMATION_DIRECTORY_STATIC + "torso/" + animation_name + ".res")
	ResourceSaver.save(animation_legs, ANIMATION_DIRECTORY_STATIC + "legs/" + animation_name + ".res")
	# update the animation data root track
	ResourceSaver.save(backend_animation, ANIMATION_DIRECTORY_DATA + into_backend_animation + ".res")
