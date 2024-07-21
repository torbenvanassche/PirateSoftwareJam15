class_name SceneConfig
extends Resource

@export var hide_current: bool = false;
@export var disable_processing: bool = false;
@export var free_current: bool = false;
@export var custom_parameters: Dictionary = {};
@export var remove_all_other_scenes: bool = false;

func _init(hide: bool = false, disable_process: bool = false, free: bool = false, remove_other: bool = false, custom_params: Dictionary = {}):
	remove_all_other_scenes = remove_other;
	disable_processing = disable_process;
	custom_parameters = custom_params;
	hide_current = hide;
	free_current = free;
