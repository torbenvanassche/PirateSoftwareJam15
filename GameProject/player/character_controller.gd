class_name Player
extends CharacterBody3D

#movement
@export var speed = 5.0

#rotation
var current_rotation_y: float = 0;
@export var rotation_speed: float = 3.0;

#jump
@export var jump_height: float = 10;
@export var jump_time_to_peak: float = 0.5;
@export var jump_time_to_descent: float = 0.4;
@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak;
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak);
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent);

#mechanics
@export var inventory: Inventory;
@export var interaction_range: Area3D;

func _init():
	Manager.instance.player = self;
	
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta):
	if not Manager.instance.camera_controller:
		return;
		
	velocity.y += get_gravity() * delta;

	if is_on_floor():
		velocity.y = 0;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity;
		
	if Input.is_action_just_pressed("open_inventory"):
		SceneManager.instance.set_active_scene("inventory", SceneConfig.new())

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "back", "forward").normalized()
	var direction = (Manager.instance.camera_controller.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		var target_rotation_y = atan2(-input_dir.x, input_dir.y)
		current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)
		rotation.y = current_rotation_y
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
