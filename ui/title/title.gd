extends CanvasLayer

var meshes = {
	"hat":[
		"res://assets/characters/barbarian/BearHat.res",
		"res://assets/characters/knight/Helmet.res",
		"res://assets/characters/mage/Hat.res",
	],
	"head":[
		"res://assets/characters/barbarian/Head.res",
		"res://assets/characters/knight/Head.res",
		"res://assets/characters/mage/Head.res",
		"res://assets/characters/ranger/Head.res",
		"res://assets/characters/rogue/Head.res",
	],
	"arm":[
		{
			"right": "res://assets/characters/barbarian/ArmRight.res",
			"left": "res://assets/characters/barbarian/ArmLeft.res",
		},
		{
			"right": "res://assets/characters/knight/ArmRight.res",
			"left": "res://assets/characters/knight/ArmLeft.res",
		},
		{
			"right": "res://assets/characters/mage/ArmRight.res",
			"left": "res://assets/characters/mage/ArmLeft.res",
		},
		{
			"right": "res://assets/characters/ranger/ArmRight.res",
			"left": "res://assets/characters/ranger/ArmLeft.res",
		},
		{
			"right": "res://assets/characters/rogue/ArmRight.res",
			"left": "res://assets/characters/rogue/ArmLeft.res",
		}
	],
	"body":[
		"res://assets/characters/barbarian/Body.res",
		"res://assets/characters/knight/Body.res",
		"res://assets/characters/mage/Body.res",
		"res://assets/characters/ranger/Body.res",
		"res://assets/characters/rogue/Body.res",
	],
	"leg":[
		{
			"right": "res://assets/characters/barbarian/LegRight.res",
			"left": "res://assets/characters/barbarian/LegLeft.res",
		},
		{
			"right": "res://assets/characters/knight/LegRight.res",
			"left": "res://assets/characters/knight/LegLeft.res",
		},
		{
			"right": "res://assets/characters/mage/LegRight.res",
			"left": "res://assets/characters/mage/LegLeft.res",
		},
		{
			"right": "res://assets/characters/ranger/LegRight.res",
			"left": "res://assets/characters/ranger/LegLeft.res",
		},
		{
			"right": "res://assets/characters/rogue/LegRight.res",
			"left": "res://assets/characters/rogue/LegLeft.res",
		}
	],
}

var selected_meshes: Dictionary[String, int] = {
	"hat": 0,
	"head": 0,
	"arm": 0,
	"body": 0,
	"leg": 0,
}

@onready var player: PlayerEntity = $"3D/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.set_display_mode(true)
	$Menu/CharacterCreate/PlayGameButton.pressed.connect(play_game)
	setup_buttons()
		
func setup_buttons() -> void:
	for button in get_tree().get_nodes_in_group("SetMeshButton"):
		if button is not Button:
			continue
		button = button as Button
		var target = button.get_meta("Target")
		button.pressed.connect(cycle_mesh.bind(target))


func cycle_mesh(target: String) -> void:
	selected_meshes[target] += 1
	if meshes[target].size() == selected_meshes[target]:
		selected_meshes[target] = 0
	
	var mesh = meshes[target][selected_meshes[target]]
	if not ["arm", "leg"].has(target):
		player.view.set_mesh(target, mesh)
	else:
		player.view.set_mesh_pair(target, mesh)
		
func play_game() -> void:
	player.set_display_mode(false)
	SceneLoader.set_transfer_nodes([player])
	SceneLoader.load_scene(SceneLoader.LEVEL_1_SCENE_UID)
	queue_free()
