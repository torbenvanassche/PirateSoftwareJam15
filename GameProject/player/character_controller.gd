class_name CharacterController
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var current_rotation_y: float = 0;
@export var rotation_speed: float = 3.0;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var inventory: Inventory;

func _init():
	Manager.instance.player = self;

func _physics_process(delta):
	if not Manager.instance.camera_controller:
		return;
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("open_inventory"):
		SceneManager.instance.set_active_scene("inventory", SceneConfig.new())

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "back", "forward").normalized()
	var direction = (Manager.instance.camera_controller.camera.global_basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target_rotation_y = atan2(input_dir.x, input_dir.y)
		current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)
		rotation.y = current_rotation_y
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
