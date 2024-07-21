extends SubViewportContainer

func _ready():
	Settings.settings_changed.connect(_on_settings_changed)
	_on_settings_changed()
	
func _on_settings_changed():
	stretch_shrink = Settings.camera_pixelation_ratio;
