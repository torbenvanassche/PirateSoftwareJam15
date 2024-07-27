extends Node

@onready var added_slot: ItemSlotUI = $MarginContainer/HBoxContainer/Item;
@onready var add_item_button = $MarginContainer/HBoxContainer/Button;
var component_array: Array[Dictionary] = [];

func on_enable():
	pass;
	
func _ready():
	add_item_button.pressed.connect(on_item_added)

func on_item_added():
	component_array.append(added_slot.slot_data.item);
	added_slot.slot_data.remove_all();
	added_slot.redraw();
