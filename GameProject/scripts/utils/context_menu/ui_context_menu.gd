class_name ContextMenu
extends PopupMenu

var function_mappings: Array
static var instance

func _init(options: Dictionary):
	var btn_shorthand: int = 0
	if options.idx < 9 and options.idx > 0:
		btn_shorthand += 48
	else:
		btn_shorthand = KEY_NONE	
	self.add_item(options.id, options.idx, btn_shorthand)
	function_mappings.append(options)

	self.index_pressed.connect(_on_popup_index_pressed)
	
static func show_menu(options: Dictionary, rect: Rect2i, parent: Node) -> ContextMenu:
	instance = ContextMenu.new(options)
	parent.add_child(instance)
	instance.popup(rect)
	return instance
	
static func format_options(display_name: String, idx: int, function: Callable) -> Dictionary:
	return {"id": display_name, "idx": idx, "function": function}
	
func _on_popup_index_pressed(idx):
	function_mappings[idx].function.call()
