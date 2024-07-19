class_name  Inventory
extends Node

var data: Array[ItemSlot] = []
@export var unlocked_slots: int
@export var max_slots: int;

signal inventory_changed(data: Array[ItemSlot]);
signal on_item_add_failed();

func _init(slot_open: int = 1, slot_max: int = 1):
	max_slots = slot_max;
	unlocked_slots = slot_open;

func _ready():
	for i in range(data.size()):
		data[i].queue_free();
	data.clear();
		
	for i in range(max_slots):
		var slot = ItemSlot.new(i < unlocked_slots);
		data.append(slot)
		
func add_slot(exceed_max: bool = false):
	for slot in data:
		if !slot.is_available:
			slot.is_available = true;
			return;
	if exceed_max:
		max_slots += 1;
		data.append(ItemSlot.new(true))
	
func add_item(item: Dictionary, amount: int = 1, create_slot_if_full: bool = false, empty_only: bool = false):
	if item == {} || item == null:
		return amount;
	
	var require_update: bool = false;
	var remaining_amount: int = amount
	var slots: Array[ItemSlot] = try_get_slots(item);
	if empty_only:
		slots = slots.filter(func(slot: ItemSlot): return slot.is_empty())
	
	var local_item = {"name": item.name, "id": item.id, "stack_size": item.stack_size, "sprite": ItemManager.get_sprite(item), "description": item.description};
	
	while remaining_amount > 0:
		if slots.size() == 0:
			if create_slot_if_full:
				add_slot(create_slot_if_full)
				continue;
			break;
			
		remaining_amount = slots[0].add(local_item, remaining_amount);
		if not slots[0].has_space(local_item.id, remaining_amount):
			slots.remove_at(0);
		
		require_update = true;
			
	if require_update:
		inventory_changed.emit(data)
		
	if remaining_amount != 0:
		on_item_add_failed.emit()
	
	return remaining_amount;
	
func remove_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;		
	var remaining_amount: int = amount
	var slots: Array[ItemSlot] = try_get_slots(item, false);
	
	while remaining_amount > 0:
		if slots.size() == 0:
			break;
		
		slots[0].item.count -= 1;
		remaining_amount -= 1;
		require_update = true;
		if slots[0].item.count <= 0:
			data[slots[0].get_meta("slot_index")].item = {}
			slots.erase(slots[0])
			
	if require_update:
		inventory_changed.emit(data)
		
	return remaining_amount;
	
func refresh_ui():
	inventory_changed.emit(data)
		
func add_item_by_id(item: String, amount: int = 1, create_slot_if_full: bool = false):
	add_item(ItemManager.get_item(item), amount, create_slot_if_full)
	
func try_get_slots(dict: Dictionary, include_empty: bool = true) -> Array[ItemSlot]:
	var slots: Array[ItemSlot] = []
	for i in range(data.size()):
		if data[i].has_space(dict.id, 1, include_empty):
			data[i].set_meta("slot_index", i);
			slots.append(data[i]);
	return slots

func get_item_count(item_name: String = ""):
	var total_count = 0
	for i in data:
		if item_name == "" || item_name == i.item.name:
			total_count += i.item.count
	return total_count

func swap_slot_data(start_slot: ItemSlot, end_slot: ItemSlot):
	var old_value = start_slot.item;
	start_slot.item = end_slot.item;
	end_slot.item = old_value;
	inventory_changed.emit(data)

func contains(items: Array[ItemSlot]) -> bool:
	var match_counter: int = 0;
	for _other_slot in items:
		for _self_slot in data:
			if _other_slot.item.id == _self_slot.item.id && _other_slot.item.count > _self_slot.item.count:
				match_counter += 1;
	return match_counter == data.size() - 1;
	
func _to_string():
	var rv = "{";
	for slot in data:
		if slot.item != {}:
			rv += slot.item.name + ": " + str(slot.item.count)
	rv += "}"
	return rv;
	
func has_open_slot() -> bool:
	return data.any(func(slot): return slot.is_available && slot.is_empty())
