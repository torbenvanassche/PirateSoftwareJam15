extends Node
class_name Manager

var player: Player;
var camera_controller: CameraController;
@export var world_space_drawer: WSD;
 
var campfire: Campfire;

static var instance: Manager;

var scroll_in_use: bool = false;

signal input_mode_changed(is_keyboard: bool);
var input_mode_is_keyboard: bool = true:
	set(value):
		input_mode_is_keyboard = value;
		input_mode_changed.emit(value)

func _init():
	Manager.instance = self;
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	input_mode_is_keyboard = event is InputEventKey || event is InputEventMouse;
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel") && SceneManager.instance.node_to_info(SceneManager.instance.active_scene).id == "main_game":
		get_viewport().set_input_as_handled()
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
