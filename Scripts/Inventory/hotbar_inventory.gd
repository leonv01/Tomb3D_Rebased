extends PanelContainer

# Reference to HBox
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

# Reference to Slot instance
const Slot = preload("res://Ressource/Inventory/Slot.tscn")

## Signal when using hotbar
## @param1: index of pressed hotkey
signal hot_bar_used(index: int)

## Function to handle user input
func _unhandled_input(event: InputEvent) -> void:
	# When hotbar is not visible or no event is pressed or the event is a mouse input from the player: return from function
	if not visible or not event.is_pressed() or event is InputEventMouseButton:
		return
	
	# If key input from 1 - 7 has been pressed: Emit signal that item should be used at pressed location
	if range(KEY_1, KEY_7).has(event.keycode):
		hot_bar_used.emit(event.keycode - KEY_1)

## Function to set inventory data
## @param1: inventory data to be set
func set_inventory_data(inventory_data: InventoryData) -> void:
	# Emit signal that inventory has been updated
	inventory_data.inventory_updated.connect(populate_hot_bar)
	# Fill hotbar with items
	populate_hot_bar(inventory_data)
	# Connect signal to allow using items via numeric keys
	hot_bar_used.connect(inventory_data.use_slot_data)

## Function to fill hotbar with items from inventory data
## @param1: inventory data used to fill hotbar
func populate_hot_bar(inventory_data: InventoryData) -> void:
	# For each existing item in hotbar
	for child in h_box_container.get_children():
		# Remove from hotbar
		child.queue_free()
	
	# For each data slot from inventory data
	for slot_data in inventory_data.slot_datas.slice(0, 6):
		# Create an instance
		var slot = Slot.instantiate()
		# Add to HBox
		h_box_container.add_child(slot)
		
		# If item is existing
		if slot_data:
			# Set the slot data
			slot.set_slot_data(slot_data)
