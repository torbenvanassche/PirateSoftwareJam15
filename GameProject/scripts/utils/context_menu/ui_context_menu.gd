class_name ContextMenu
extends PopupMenu

var menu_items: Array[ContextMenuItem];

func _ready():
	close_requested.connect(_on_close)

func _init(data: Array[ContextMenuItem]):
	for index in range(data.size()):
		var context_item := data[index];
		add_item(context_item.id, index)
		set_item_disabled(index, context_item.disabled)
		context_item.idx = index;

	menu_items = data
	size.y = 0
	
	index_pressed.connect(_on_idx)
	if Settings.close_context_on_mouse_exit:
		mouse_exited.connect(_on_close)
	
func _on_idx(index):
	var found_item = menu_items.filter(func(x: ContextMenuItem): return x.idx == index);
	for item in found_item:
		item.function.call()
	close_requested.emit();

func _on_close():
	queue_free()

func open(rect: Rect2):
	position = rect.position;
	size = rect.size;
	show()
