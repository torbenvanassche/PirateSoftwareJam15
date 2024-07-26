extends Node3D

@export var item_id: String;

# Called when the node enters the scene tree for the first time.
func _ready():
	var item_data = ItemManager.get_item(item_id);
	var mesh = ItemManager.get_scene(item_data).instantiate();
	add_child(mesh);
