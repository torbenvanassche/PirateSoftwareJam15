extends Area3D

@export var item_id: String;

@onready var timer: Timer = $Timer;
@onready var collision_shape: CollisionShape3D = $CollisionShape3D;
var mesh_instance: Node3D;
@onready var sprite: Node3D = $Sprite3D;

@export var cooldown_timer: float = 20;

# Called when the node enters the scene tree for the first time.
func _ready():
	var item_data = ItemManager.get_item(item_id);
	if item_data != {}:
		var packed_scene = ItemManager.get_scene(item_data);
		if packed_scene != null:
			mesh_instance = packed_scene.instantiate();
			add_child(mesh_instance);
	timer.wait_time = cooldown_timer;
	
func on_interact():
	Manager.instance.player.inventory.add_item_by_id(item_id, 1);
	collision_shape.disabled = true;
	mesh_instance.visible = false;
	timer.start();
	
func on_timer_end():
	collision_shape.disabled = false;
	mesh_instance.visible = true;

func on_area_enter():
	Manager.instance.world_space_drawer.show_rect(sprite);
	pass
	
func on_area_leave():
	Manager.instance.world_space_drawer.show_rect(null);
	pass
