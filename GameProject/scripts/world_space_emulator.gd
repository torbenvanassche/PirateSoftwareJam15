class_name WSD extends Control

@export var element: TextureRect;

@export var rect_controller: Rect2 = Rect2(80, 144, 16, 16);
@export var rect_keyboard: Rect2 = Rect2(305 ,33, 13, 14);

var _target: Node3D;

func _process(_delta: float):
	if _target:
		element.global_position = Manager.instance.camera_controller.camera.unproject_position(_target.global_position) * Settings.camera_pixelation_ratio - element.size / 2;
		element.visible = !Manager.instance.camera_controller.camera.is_position_behind(_target.global_position)
	else:
		element.visible = false;

func show_rect(target: Node3D):
	_target = target;
	element.visible = true;

func handle_rect(_b: bool):
	(element.texture as AtlasTexture).region = rect_keyboard if Manager.instance.input_mode_is_keyboard else rect_controller;

func _ready():
	Manager.instance.input_mode_changed.connect(handle_rect);
