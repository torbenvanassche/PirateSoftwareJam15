extends Node
class_name Manager

var player: Player;
var camera_controller: CameraController;

static var instance: Manager;

var scroll_in_use: bool = false;

func _init():
	Manager.instance = self;
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel") && !SceneManager.instance.ui_is_open():
		pause();
	
func pause(pause_game = !get_tree().paused):
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("paused", SceneConfig.new(false));
		
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		var btn = get_viewport().gui_get_focus_owner();
		if btn is Button:
			btn.pressed.emit();
