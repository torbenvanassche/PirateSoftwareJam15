class_name HealthBar
extends Node

@export var max_health: int = 100;
@export var current_health: int = 100;
var health_ui: ProgressBar;

signal is_depleted()

func set_data(_progress_bar: ProgressBar, curr_health: int = max_health):
	health_ui = _progress_bar;
	current_health = curr_health
	
	if _progress_bar.has_theme_stylebox("background"):
		var value_padding_left = _progress_bar.get_theme_stylebox("background").get("border_width_left") * 2;
		var value_padding_right = _progress_bar.get_theme_stylebox("background").get("border_width_right") * 2;
		health_ui.max_value = max_health + value_padding_left + value_padding_right;
	
	health_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	health_ui.value = current_health;
	health_ui.visible = true;

func decrease_health(amount: int):
	current_health -= amount;
	health_ui.value = current_health;
	
	if current_health <= 0:
		is_depleted.emit()
		
func is_alive():
	return current_health > 0;
