extends Node
	
#camera sensitivity
var camera_rotation_sensitivity = 0.01;
var camera_zoom_sensitivity = 0.5;

#general settings
var camera_pixelation_ratio: int = 3;

#menu options
var close_context_on_mouse_exit: bool = true;

signal settings_changed();

#volume
var master_volume: float = 1;
signal volume_changed(new_value: float, bus_name: String);

func _ready():
	_deferred_ready.call_deferred();

func _deferred_ready():
	volume_changed.connect(_change_volume);
	
func _change_volume(value: float, bus_name: String):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value));
	master_volume = value;
