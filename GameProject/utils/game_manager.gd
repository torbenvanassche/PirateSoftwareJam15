extends Node
class_name Manager

@export var scenes: Array[Node]
var player: CharacterController;
var camera_controller: CameraController;

static var instance: Manager;

var scroll_in_use: bool = false;

func _init():
	Manager.instance = self;
	
func pause(pause_game = true):
	get_tree().paused = pause_game
