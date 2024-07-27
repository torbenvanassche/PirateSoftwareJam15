class_name DragData
extends Node

var item: Dictionary;
var item_slot: ItemSlotUI;
var origin_window: String;

func _init(it: Dictionary, window: String, slot: ItemSlotUI):
	item = it;
	item_slot = slot;
	origin_window = window;
