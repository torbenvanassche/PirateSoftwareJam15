extends Node

@export var target: Node3D;
@export var time_to_destination: float = 1;

func _ready():
	create_tween().tween_property(self, "position", target.position, time_to_destination)
