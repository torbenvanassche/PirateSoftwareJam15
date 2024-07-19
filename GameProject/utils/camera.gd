class_name CameraController
extends Node3D

@export var target: Node3D

@export var distance: float = 7
@export var distance_interval: Vector2i = Vector2i(5, 10);
@export var follow_speed = 1;

var pitch_input: float = 0
var twist_input: float = 0
var mouse_position:Vector2;

func _init():
	Manager.instance.camera = self;

func _ready():
	%Camera3D.position.z = distance;
	
func _process(delta):
	$TwistPivot.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x((pitch_input))
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, -0.7, -0.15)
	
	position = position.lerp(target.position, delta * follow_speed);
	
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = - event.relative.x * Settings.camera_rotation_sensitivity;
		pitch_input = - event.relative.y * Settings.camera_rotation_sensitivity;
	
	if Input.is_action_just_pressed("enable_camera_rotate"):
		mouse_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("enable_camera_rotate"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_viewport().warp_mouse(mouse_position)
		
	var dist = %Camera3D.position.distance_to(Manager.instance.player.position)
	if Input.is_action_just_pressed("zoom_out") and dist < distance_interval.y:
		%Camera3D.position -= transform.basis.z * Settings.camera_zoom_sensitivity;

	elif Input.is_action_just_pressed("zoom_in") and dist > distance_interval.x:
		%Camera3D.position += transform.basis.z * Settings.camera_zoom_sensitivity;
	
	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_viewport().warp_mouse(mouse_position)
