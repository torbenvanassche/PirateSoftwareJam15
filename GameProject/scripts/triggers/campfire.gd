extends Area3D

@onready var camera_brewing: Camera3D = $Camera3D;

func on_area_enter():
	pass
	
func on_area_leave():
	Manager.instance.camera_controller.camera.make_current();
	Manager.instance.player.do_processing = true;
	
func on_interact():
	SceneManager.instance.set_active_scene("brewing", SceneConfig.new())
	Manager.instance.player.do_processing = false;
	camera_brewing.make_current();
