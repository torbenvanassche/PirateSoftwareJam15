class_name Campfire extends Area3D

@onready var camera_brewing: Camera3D = $Camera3D;
@export var sprite_position: Node3D;

@onready var liquid_material: StandardMaterial3D = preload("res://models/materials/mat_cauldronfluid.tres")
@export var bubble_particle: GPUParticles3D;
@export var sparkles_particle: GPUParticles3D;

var player_in_area: bool = true;
var old_color: Color;

func _ready():
	Manager.instance.campfire = self;

func reset_color():
		recolor_fluid(old_color)
	
func recolor_fluid(color: Color):
	old_color = liquid_material.albedo_color;
	create_tween().tween_property(liquid_material, "albedo_color", color, 0.5)
	(bubble_particle.process_material as ParticleProcessMaterial).color = color;
	(sparkles_particle.process_material as ParticleProcessMaterial).color = color;
	
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
