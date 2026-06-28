@tool
class_name SaverNode extends Node

const SAVER_NODE_GROUP: String = "saver_node"

@export var properties_to_save: Array[String] = []

var suggested_properties: Array[String] = []

func _update_property_list() -> void:
	var parent = get_parent()
	if not parent:
		return
	
	suggested_properties.clear()
	#this grabs ALL properties, suggested that we filter the ones we care about
	var all_props = parent.get_property_list()
	
	#this for loop will be set up to help discard unwanted properties
	for p in all_props:
		var pname = p.name
		suggested_properties.append(pname)
	
	notify_property_list_changed()

func _validate_property(property: Dictionary) -> void:
	if property.name == "properties_to_save":
		var options = "," .join(suggested_properties)
		property.hint = PROPERTY_HINT_TYPE_STRING
		property.hint_string = "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, options]

func _ready() -> void:
	add_to_group(SAVER_NODE_GROUP)
	if Engine.is_editor_hint():
		_update_property_list()

func get_save_dict() -> Dictionary:
	var parent = get_parent()
	var node_data = {}
	for prop in properties_to_save:
		print("Saving property: ", prop)
		if prop in parent:
			node_data[prop] = parent.get(prop)
	return node_data

func apply_save_dict(node_data: Dictionary) -> void:
	var parent = get_parent()
	for prop in node_data:
		if prop in parent:
			parent.set(prop, node_data[prop])
