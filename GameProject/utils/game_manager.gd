extends Node3D
class_name Manager

@export var scenes: Array[Node]
@export var player: CharacterController;
@export var camera: CameraController;

static var instance: Manager;

var scroll_in_use: bool = false;

func _init():
	Manager.instance = self;
	
func pause(pause_game = true):
	get_tree().paused = pause_game
