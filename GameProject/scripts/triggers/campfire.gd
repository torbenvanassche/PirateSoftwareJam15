extends Area3D

@onready var camera_brewing: Camera3D = $Camera3D;
@export var sprite_position: Node3D;

var player_in_area: bool = true;
	
func on_interact():
	SceneManager.instance.set_active_scene("brewing", SceneConfig.new())
	Manager.instance.world_space_drawer.show_rect();
	Manager.instance.player.can_transform = false;
	camera_brewing.make_current();

func on_area_enter():
	Manager.instance.world_space_drawer.show_rect(sprite_position);
	player_in_area = true;
	
func _process(delta):
	if Input.is_action_just_pressed("cancel") && player_in_area:
		on_area_leave()
	
func on_area_leave():
	SceneManager.instance.remove_ui()
	Manager.instance.world_space_drawer.show_rect();
	Manager.instance.camera_controller.camera.make_current();
	Manager.instance.player.can_transform = true;
	SceneManager.instance.set_active_scene("main_game", SceneConfig.new())
	player_in_area = false;
