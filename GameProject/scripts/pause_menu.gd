extends Node

@onready var resume_button: Button = $resume;
@onready var settings_button: Button = $settings;
@onready var quit_button: Button = $quit;

var window_controller: DraggableControl;

func _ready():	
	resume_button.pressed.connect(resume)
	print("ready!")
	settings_button.pressed.connect(func(): print("Not implemented yet."))
	
	quit_button.pressed.connect(func(): window_controller.close_requested.emit())
	quit_button.pressed.connect(SceneManager.instance.reset_to_scene.bind("main_menu"))

func on_disable():
	Manager.instance.pause(false)
	
func on_enable():
	resume_button.grab_focus();
	
func resume():
	print("resuming")
	window_controller.close_requested.emit()
