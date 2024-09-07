extends Control

@export var grabbed_image_offset: Vector2 = Vector2(5, 5)

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var external_inventory: PanelContainer = $ExternalInventory
@onready var equip_inventory: PanelContainer = $EquipInventory

## Signal to handle dropped data slot
## @param1: slot data to be dropped
signal drop_slot_data(slot_data: SlotData)

var external_inventory_data: InventoryData
var grabbed_slot_data: SlotData
var is_external_open: bool = false
var external_inventory_position: Vector3

func _physics_process(delta: float) -> void:
	# Add offset to texture of grabbed item
	grabbed_slot.global_position = get_global_mouse_position() + grabbed_image_offset

## Function to set player inventory data
## @param1: inventory data to be used
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	# Connect inventory data to signal
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

## Function to set external inventory data
## @param1: inventory data to be used
func set_external_inventory_data(inventory_data: InventoryData) -> void:
	# Set flag that external inventory is open
	is_external_open = true
	
	external_inventory_data = inventory_data
	
	# Connect inventory data to signal
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	
	# Show external inventory in inventory interface
	external_inventory.show()

## Function set equiped inventory data
## @param1: inventory data to be used
func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	# Connect inventory data to signal
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

## Function to clear external inventory data
## @param1: external inventory data to be cleared
func clear_external_inventory_data(external_inventory_data: InventoryData) -> void:
	# If external inventory data exists
	if external_inventory_data:
		# Set flag to false
		is_external_open = false
		external_inventory_position = Vector3.ZERO
		var inventory_data: InventoryData = external_inventory_data
		
		# Remove signal handler from inventory data
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		# Hide external inventory
		external_inventory.hide()
		external_inventory_data = null

## Function to handle player interaction
## @param1: inventory data to be used
## @param2: index of slot data
## @param3: mouse button index
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	# Compare both grabbed slot data and mouse button 
	match[grabbed_slot_data, button]:
		# Case: Grabbed item is not picked and left mouse button is pressed
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		# Case: Grabbed item is picked and left mouse button is pressed
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		# Case: Grabbed item is not picked and right mouse button is pressed
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		# Case: Grabbed item is picked and right mouse button is pressed
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)

	# Update grabbed item slot
	update_grabbed_slot()

## Function to update the grabbed item slot
func update_grabbed_slot() -> void:
	# If grabbed item slot exists -> display
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
	pass

## Callback function on user input
func _on_gui_input(event: InputEvent) -> void:
	# If input even is done by a mouse button, is pressed and grabbed slot data exists
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
		
		# Check which mouse button has been pressed
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				# Emit signal to drop whole grabbed slot data
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			
			MOUSE_BUTTON_RIGHT:
				# Emit signal to drop one grabbed slot data
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
		update_grabbed_slot()

## Callback function for visibility check
func _on_visibility_changed() -> void:
	# If interface is not visible and grabbed slot data exists
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null

## Function to check if external inventory is in range
## @range1: position of external inventory
## @range2: maximum range where interface is active
func check_external_inventory_in_range(_position: Vector3, max_range: int) -> void:
	if external_inventory_position.distance_to(_position) > max_range and is_external_open:
		external_inventory.hide()
