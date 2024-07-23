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

var current_triggers: Array[Area3D];
var do_processing: bool = true;

func _init():
	Manager.instance.player = self;
	
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta):
	if Input.is_action_just_pressed("open_inventory"):
		SceneManager.instance.set_active_scene("inventory", SceneConfig.new())
		
	if Input.is_action_just_pressed(("interact")):
		interact();
	
	if not Manager.instance.camera_controller || !do_processing:
		return;
		
	velocity.y += get_gravity() * delta;

	if is_on_floor():
		velocity.y = 0;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "back", "forward").normalized()
	var direction = (Manager.instance.camera_controller.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		var target_rotation_y = atan2(-direction.x, -direction.z)
		current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)
		rotation.y = current_rotation_y
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _ready():
	interaction_range.area_entered.connect(_on_enter);
	interaction_range.area_exited.connect(_on_leave);
	var s = ItemManager.get_components(ItemManager.get_item("potion_shadow_control"))
	
func interact():
	if current_triggers.size() != 0:
		if current_triggers[0].has_method("on_interact"):
			current_triggers[0].on_interact();
		
	
func sort_areas_by_distance():
	current_triggers.sort_custom(func(a, b): return position.distance_squared_to(a) > position.distance_squared_to(b));

func _on_enter(body: Area3D):
	if !current_triggers.has(body):
		current_triggers.push_back(body);
		sort_areas_by_distance();
		if body.has_method("on_area_enter"):
			body.on_area_enter();
	
func _on_leave(body: Area3D):
	current_triggers.erase(body);
	if body.has_method("on_area_leave"):
		body.on_area_leave();
