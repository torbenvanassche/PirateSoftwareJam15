extends Node

@onready var pixelation_slider: HSlider = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/HSlider;

func _ready():
	pixelation_slider.drag_ended.connect(set_pixelation)
	
func on_enter():
	pixelation_slider.value = Settings.camera_pixelation_ratio;

func set_pixelation(_b: bool):
	print(pixelation_slider.value)
	Settings.camera_pixelation_ratio = pixelation_slider.value
