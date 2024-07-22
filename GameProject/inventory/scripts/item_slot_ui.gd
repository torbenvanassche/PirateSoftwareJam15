class_name ItemSlotUI
extends Button

@onready var textureRect: TextureRect = $MarginContainer/ItemSprite;
@onready var counter: Label = $Count;
var slot_data: ItemSlot;

@export var default_color = Color(Color.WHITE)
@export var dragging_color = Color(Color.WHITE, 0.3);

@export var show_amount: bool = true:
	set(value):
		counter.visible = value;
		show_amount = value;
	
func as_blank():
	textureRect.modulate = dragging_color;
	counter.visible = false;
	
func redraw():
	var sprite = null;
	textureRect.modulate = default_color
	counter.visible = false;
	
	if slot_data.item.has("id"):
		sprite = ItemManager.get_sprite(slot_data.item);
		if !slot_data.item.has("count"):
			slot_data.item.count = 1;
		counter.set_text(str(slot_data.item.count));
		counter.visible = show_amount && slot_data.item.count > 0;
	textureRect.set_texture(sprite);
	
func set_reference(data: ItemSlot):
	if slot_data:
		slot_data.has_changed.disconnect(redraw);
	slot_data = data;
	slot_data.has_changed.connect(redraw);
	slot_data.has_changed.emit()
	
signal on_drag_end(b: ItemSlotUI);

func _get_drag_data(_at_position):
	if slot_data.item != {}:
		as_blank();
		return DragData.new(slot_data.item, "inventory", [], [self]);
	return null;
	
func _can_drop_data(_at_position, data):
	var data_is_valid = data is DragData && self is ItemSlotUI && slot_data.is_available;
	var can_place_item = slot_data.has_space(data.item.id, data.item.count);
	return data_is_valid && can_place_item;
	
func _drop_data(_at_position, data):
	var count_removed = data.item.count;
	data.item_slots[0].slot_data.remove(data.item.count);
	slot_data.add(data.item, count_removed);
	on_drag_end.emit(self)
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
