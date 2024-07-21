extends Node

@onready var new_game_button: Button = $Buttons/VBoxContainer/new_game;

func _ready():
	new_game_button.pressed.connect(SceneManager.instance.set_active_scene.bind("main_game", SceneConfig.new(false, true, true)))
