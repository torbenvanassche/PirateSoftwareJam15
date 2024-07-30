extends Node

var data_file_path: String = "res://inventory/item_data/item_database.json"
var _items: Dictionary = FileUtils.load_items(data_file_path);
	
func get_item(id: String, as_copy: bool = false) -> Dictionary:
	if _items.keys().find(id) != -1:
		var rv: Dictionary = _items[id];
		rv.id = id;
		
		if as_copy:
			return rv.duplicate();
		else:
			return rv;
		
	printerr(id + " not found in the item database.")
	return {};
	
func get_items() -> Dictionary:
	return _items;
	
func get_by_property_value(prop: String, value: Variant = null, dict: Dictionary = _items) -> Dictionary:
	var a_items: Dictionary = {};
	for entry in dict.keys():
		if dict[entry].has(prop) && dict[entry][prop] == value:
			a_items[entry] = dict[entry];
			a_items[entry].id = entry;
	return a_items;
	
func get_by_property(prop: String, dict: Dictionary = _items) -> Dictionary:
	var a_items: Dictionary = {};
	for entry in dict.keys():
		if dict[entry].has(prop):
			a_items[entry] = dict[entry];
			a_items[entry].id = entry;
	return a_items;

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://inventory/item_data/scenes/" + item.asset_path + ".glb"
	if ResourceLoader.exists(path):
		return load(path)
	else:
		printerr("Could not find mesh for " + item.name)
	return null
	
func get_sprite(item: Dictionary) -> Texture:
	if item.has("sprite"):
		return item.sprite;
	else:
		var path = "res://inventory/item_data/sprites/" + item.asset_path + ".png"
		if ResourceLoader.exists(path):
			item.sprite = load(path);
			return item.sprite;
		else:
			printerr("Could not find sprite for " + item.name)
		return null
	
func get_colors(item: Dictionary) -> Array[Color]:
	var colors: Array = item.colors;
	var output: Array[Color] = []
	for c in colors:
		output.append(Color(c));
	return output;
	
func get_components(item: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for component in item.components:
		result.append(get_item(component))
	return result
	
func is_craftable(item: Dictionary):
	var items_with_components = get_by_property("components")
	return items_with_components.has(item.id) && items_with_components[item.id].components != []
	
func _match_components(components: Array, item: Dictionary):
	if item.components.size() != components.size(): 
		return false
	for entry in item.components:
		if !components.has(entry): 
			return false
	return true
	
func find_item_with_components(components: Array) -> Dictionary:
	for item in _items:
		var item_data = _items[item]
		if item_data.has("components") && item_data.components.size() != 0:
			if _match_components(components, item_data):
				return item_data;
	return {};
