extends Label

var print_tween: Tween
var _is_printing = false

@export var print_delay: float = 0.5
@export var print_delay_speed_up: float = 0.05
	
func _print(txt: String):
	_is_printing = true
	self.text = txt;
	self.visible_characters = 0
	
	print_tween = create_tween()
	print_tween.tween_property(self, "visible_characters", txt.length(), print_delay * txt.length())
	print_tween.finished.connect(_on_tween_complete)
	
func _input(event):
	if Input.is_action_just_pressed("mouse_left") and _is_printing:
		print_tween.set_speed_scale(print_delay_speed_up)

func _on_tween_complete():
	_is_printing = false
