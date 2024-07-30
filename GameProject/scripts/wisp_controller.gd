extends Node3D

@export var wisps: Array[Mover] = []

func transition_color(color: Color):
	for wisp in wisps:
		if color == Color.BLACK:
			wisp.set_color(wisp.gradient_black);
		elif color == Color.WHITE:
			wisp.set_color(wisp.gradient_white);
		else:
			print("Color provided was not valid")
