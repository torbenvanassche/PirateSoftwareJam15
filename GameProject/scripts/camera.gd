class_name CameraController
extends Node3D

@export var target: Node3D

@export var distance: float = 7
@export var distance_interval: Vector2i = Vector2i(5, 20);
@export var follow_speed = 1;

@export var can_rotate: bool = true;
@export var can_zoom: bool = true;

@onready var camera: Camera3D = %Camera3D;

var pitch_input: float = 0
var twist_input: float = 0
var mouse_position:Vector2;

const DEADZONE_THRESHOLD = 0.1;

func _init():
	Manager.instance.camera_controller = self;

func _ready():
	camera.position.z = distance

func _process(delta):
	var joy_twist_input = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)  # 0 is the device index, change if necessary
	var joy_pitch_input = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(joy_twist_input) > DEADZONE_THRESHOLD:
		twist_input = -joy_twist_input

	if abs(joy_pitch_input) > DEADZONE_THRESHOLD:
		pitch_input = -joy_pitch_input
	
	$TwistPivot.rotate_y(twist_input * Settings.camera_rotation_sensitivity)
	$TwistPivot/PitchPivot.rotate_x(pitch_input * Settings.camera_rotation_sensitivity)
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, -0.7, -0.15)

	position = position.lerp(target.position, delta * follow_speed)
	
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event):
	if !Manager.instance.player.do_processing:
		return;
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and can_rotate:
		twist_input = -event.relative.x
		pitch_input = -event.relative.y

	if Input.is_action_just_pressed("enable_camera_rotate"):
		mouse_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("enable_camera_rotate"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_viewport().warp_mouse(mouse_position)

	if can_zoom and target:
		var dist = camera.global_position.distance_to(target.global_position)
		if Input.is_action_just_pressed("zoom_in") and dist < distance_interval.y:
			camera.position += transform.basis.z * Settings.camera_zoom_sensitivity
		if Input.is_action_just_pressed("zoom_out") and dist > distance_interval.x:
			camera.position -= transform.basis.z * Settings.camera_zoom_sensitivity

	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_viewport().warp_mouse(mouse_position)
