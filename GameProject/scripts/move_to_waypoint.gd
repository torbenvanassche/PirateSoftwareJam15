class_name Mover extends Node

@export var target: Node3D;
@export var time_to_destination: float = 1;

@onready var wisp: GPUParticles3D = $Wisp;
@onready var energy: GPUParticles3D = $Energy;

@export var gradient_white: GradientTexture1D;
@export var gradient_black: GradientTexture1D;

func _ready():
	create_tween().tween_property(self, "position", target.position, time_to_destination)
	
	
func set_color(gradient: GradientTexture1D):
	(wisp.process_material as ParticleProcessMaterial).color_ramp = gradient;
