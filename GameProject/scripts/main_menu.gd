extends Node

@onready var new_game_button: Button = $Buttons/VBoxContainer/new_game;
@onready var settings_button: Button = $Buttons/VBoxContainer/settings;
@onready var credits_button: Button = $Buttons/VBoxContainer/credits;
@onready var quit_button: Button = $Buttons/VBoxContainer/quit;


func _ready():
	new_game_button.pressed.connect(_play_game)
	new_game_button.grab_focus();
	
	settings_button.pressed.connect(_to_settings)
	
	if OS.get_name() == "Web":
		quit_button.visible = false;
	
func _play_game():
	SceneManager.instance.set_active_scene("main_game", SceneConfig.new(false, true, true))

func _to_settings():
	SceneManager.instance.set_active_scene("settings", SceneConfig.new())
