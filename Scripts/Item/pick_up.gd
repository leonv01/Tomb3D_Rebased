extends RigidBody3D

@export var slot_data: SlotData

@export_category("Potion Attributes")
@export var potion_value: int

@export_category("Item Move Properties")
@export var rotation_speed: float = 90.0
@export var move_amplitude: float = 0.2
@export var move_speed: float = 2.0

var start_position: Vector3
var time_passed: float = 0

func _ready() -> void:
	# Set start position
	start_position = global_transform.origin

func _process(delta: float) -> void:
	# Add delta time to time passed
	time_passed += delta
	
	# Rotate on Y-axis
	rotate_y(deg_to_rad(rotation_speed * delta))
	
	# Set new y position
	var new_y: float = start_position.y + sin(time_passed * move_speed) * move_amplitude
	
	# Set position with new y position
	global_transform = Transform3D(global_transform.basis, Vector3(start_position.x, new_y, start_position.z))

## Function to handle pick up
## @param1: player inventory data to be appended
func picked_up(player_inventory_data: InventoryData) -> void:
	# If item has been picked up
	if player_inventory_data.picked_up_slot_data(slot_data):
		# Remove instance
		queue_free()
