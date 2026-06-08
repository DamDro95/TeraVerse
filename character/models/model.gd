extends Node
class_name CharacterModel

@export var is_enemy : bool = false

@export var character: Character
@export var skeleton: Skeleton3D
@export var animator: PlayerAnimations
@export var combat: CharacterCombat
@export var stats:  CharacterStats
#@export var hurtbox: CharacterHurtbox
@export var area_awareness: AreaAwareness
@export var states: CharacterStates

@onready var current_state : CharacterState

#@onready var active_weapon : Weapon = $RightWrist/WeaponSocket/Sword as Sword
#@onready var weapons = {
	#"sword" = $....Sword,
	#"bow" = $....Bow,
	#"greatsword" = $....Greatsword,
	#....
#}


func _ready():
	#moves_container.player = character
	states.accept_moves()
	current_state = states.moves["character/Idle_B"]
	switch_to("character/Idle_B")


func update(input : InputPackage, delta : float):
	input = combat.contextualize(input)
	area_awareness.last_input_package = input
	var relevance = current_state.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	#print(animator.torso_animator.current_animation)
	current_state.update_resources(delta) # moved back here for now, because of TorsoMoves triggering _update from legs behaviour -> doubledipping
	current_state._update(input, delta)


func switch_to(state : String):
	print(current_state.move_name + " -> " + state)
	current_state._on_exit_state()
	current_state = states.moves[state]
	current_state._on_enter_state()
