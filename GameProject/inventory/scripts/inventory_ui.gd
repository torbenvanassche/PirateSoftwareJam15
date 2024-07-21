class_name InventoryUI
extends GridContainer

var controller: Inventory;

var item_ui_packed: PackedScene = preload("res://inventory/scenes/slot_ui.tscn");              
var elements: Array[ItemSlotUI] = []

var selected_slot: ItemSlotUI;
var btn_grp: ButtonGroup = ButtonGroup.new()

@export var slot_size_constraints: Vector2i = Vector2i(25, 50);
@export var show_locked: bool = false;

func _ready():
	on_enable.call_deferred()
	
func _control_size():
	var size_constraint = min((size.x / columns) - get_theme_constant("h_separation"), (size.y / (controller.data.size() / columns)) - get_theme_constant("v_separation"));
	var container_size = clamp((size.x / columns) - get_theme_constant("h_separation"), slot_size_constraints.x, slot_size_constraints.y);
	print(container_size, size)
	
	for e: Control in get_children():
		e.custom_minimum_size.x = container_size;
		e.custom_minimum_size.y = container_size;

func on_enable(_options: Dictionary = {}):
	if !item_ui_packed:
		printerr("the item's UI is undefined")
		return;
	controller = Manager.instance.player.inventory;
	set_controller(controller);
	resized.connect(_control_size)
	btn_grp.allow_unpress = true;

func set_controller(con: Inventory):
	if con != controller:
		if controller: 
			controller.inventory_changed.disconnect(_update)
		controller = con;
	if !controller.inventory_changed.is_connected(_update):
		controller.inventory_changed.connect(_update);
	create_ui(controller.data)
	controller.refresh_ui();
	
func create_ui(data: Array[ItemSlot]):
	for d in data:
		add(d)

func add(dict: ItemSlot) -> ItemSlotUI:
	var item_ui: ItemSlotUI = item_ui_packed.instantiate() as ItemSlotUI;
	add_child(item_ui);
	elements.append(item_ui);
	item_ui.show_amount = true;
	
	item_ui.button_up.connect(_set_selected.bind(item_ui))
	item_ui.on_drag_end.connect(func(_drag_end_slot): selected_slot = null);
	item_ui.button_group = btn_grp;
	
	if show_locked:
		item_ui.disabled = !dict.is_available;
	else:
		item_ui.visible = dict.is_available;
	item_ui.set_reference(dict);
	return item_ui
	
func _set_selected(slot: ItemSlotUI):
	if selected_slot != slot && selected_slot:
		selected_slot.button_pressed = false;
		selected_slot = null;
	
	var redraw = selected_slot == slot;
	if redraw || (slot && slot.slot_data.item == {}):
		slot.button_pressed = false;
		selected_slot = null;
		if !redraw:
			#set_info_content()
			pass
	else:
		selected_slot = slot;

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func _update(data: Array[ItemSlot]):
	_clear();
	for index in range(data.size()):
		add(data[index])
