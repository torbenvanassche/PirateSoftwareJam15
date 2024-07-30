class_name Mover extends Node

@export var target: Node3D;
@export var time_to_destination: float = 1;

@onready var original_position: Vector3 = self.position;

@onready var wisp: GPUParticles3D = $Wisp;
@onready var energy: GPUParticles3D = $Energy;

@export var gradient_white: GradientTexture1D;
@export var gradient_black: GradientTexture1D;

func _ready():
	create_tween().tween_property(self, "position", target.position, time_to_destination)
	
func set_color(gradient: GradientTexture1D):
	(wisp.process_material as ParticleProcessMaterial).color_ramp = gradient;
	
func on_interact():
	back_to_tree();

func back_to_tree():
	create_tween().tween_property(self, "position", original_position, time_to_destination)
	set_color(gradient_black)

func on_area_enter():
	Manager.instance.world_space_drawer.show_rect($Sprite3D);
	pass
	
func on_area_leave():
	Manager.instance.world_space_drawer.show_rect(null);
	pass
