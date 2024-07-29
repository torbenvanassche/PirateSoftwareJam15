extends Node

@onready var added_slot: ItemSlotUI = $MarginContainer/VBoxContainer/HBoxContainer/Item;
@onready var add_item_button = $MarginContainer/VBoxContainer/HBoxContainer/Button;
@onready var added_items: VBoxContainer = $MarginContainer/VBoxContainer/added_items;
var component_array: Array[Dictionary] = [];

@onready var add_item_visual = preload("res://scenes/brewing_component_ui.tscn");

func on_enable():
	pass;
	
func _ready():
	add_item_button.pressed.connect(on_item_added)
	added_slot.window_id = "brewing"

func on_item_added():
	var visual_element = add_item_visual.instantiate();
	visual_element.get_node("TextureRect").texture = ItemManager.get_sprite(added_slot.slot_data.item);
	visual_element.get_node("Label").text = added_slot.slot_data.item.name;
	added_items.add_child(visual_element);
	
	component_array.append(added_slot.slot_data.item);
	added_slot.slot_data.remove_all();
	added_slot.redraw();
