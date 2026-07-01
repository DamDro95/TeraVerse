extends Node3D
class_name CharacterModel


@export var is_enemy : bool = false

@onready var character: CharacterEntity = get_parent()
@onready var hitbox: CharacterHitbox = %Hitbox
@onready var skeleton: Skeleton3D = $Skeleton
@onready var physics: CharacterPhysics = $Physics
@onready var animator: SplitBodyAnimator = $SplitBodyAnimator
@onready var stats: CharacterStats = $Stats
@onready var combat: CharacterCombat = $Combat
@onready var area_awareness: AreaAwareness = $AreaAwareness
@onready var states: CharacterStates = $States
@onready var legs: LegsStates = $LegsStates
@onready var current_state : CharacterState

#@onready var weapons = {
	#"sword" = $....Sword,
	#"bow" = $....Bow,
	#"greatsword" = $....Greatsword,
	#....
#}


func _ready():
	#moves_container.player = character
	states.load_states()
	current_state = states.get_state_by_name("Idle")
	switch_to("Idle")
	legs.current_state = states.get_state_by_name("Idle")
	legs.load_states()


func update(input : InputPackage, delta : float):
	input = combat.contextualize(input)
	area_awareness.last_input_package = input
	var relevance = current_state.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	current_state.update_resources(delta) # moved back here for now, because of TorsoMoves triggering _update from legs behaviour -> doubledipping
	current_state._update(input, delta)


func switch_to(state : String):
	current_state._on_exit_state()
	current_state = states.get_state_by_name(state)
	current_state._on_enter_state()
