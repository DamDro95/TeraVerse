class_name HurtboxComponent
extends Area3D

# Reference your character's health controller node in the inspector
@export var health_node: Node3D 

func receive_hit(incoming_damage: float) -> void:
	if is_instance_valid(health_node) and health_node.has_method("take_damage"):
		# Apply armor, buffs, or passives here before damaging the health node
		var final_damage = incoming_damage 
		
		health_node.take_damage(final_damage)
