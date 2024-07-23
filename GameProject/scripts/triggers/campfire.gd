extends Area3D

func on_area_enter():
	print("entered")
	
func on_area_leave():
	print("leave");
	
func on_interact():
	SceneManager.instance.set_active_scene("brewing", SceneConfig.new())
