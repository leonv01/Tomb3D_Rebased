extends RigidBody3D

class_name Potion

@export_category("Potion Attributes")
@export var potion_value: int

@export_category("Item Move Properties")
@export var rotation_speed: float = 90.0
@export var move_amplitude: float = 0.5
@export var move_speed: float = 2.0

var start_position: Vector3
var time_passed: float = 0

func _ready() -> void:
	start_position = global_transform.origin

func _process(delta: float) -> void:
	time_passed += delta
	
	rotate_y(deg_to_rad(rotation_speed * delta))
	
	var new_y: float = start_position.y + sin(time_passed * move_speed) * move_amplitude
	
	global_transform = Transform3D(global_transform.basis, Vector3(start_position.x, new_y, start_position.z))
