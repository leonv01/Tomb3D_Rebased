extends PanelContainer

# Reference to Slot instance
const Slot = preload("res://Ressource/Inventory/Slot.tscn")

# Reference to GridContainer
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

## Function to set inventory data of player
## @param1: inventory data to be set
func set_inventory_data(inventory_data: InventoryData) -> void:
	# Connect signal when inventory data changes to fill inventory data
	inventory_data.inventory_updated.connect(populate_item_grid)
	# Fill inventory data with existing inventory data
	populate_item_grid(inventory_data)

## Function to clear inventory data
## @param1: inventory data to be cleared
func clear_inventory_data(inventory_data: InventoryData) -> void:
	# Remove signal
	inventory_data.inventory_updated.disconnect(populate_item_grid)

## Function to fill inventory data with existing data
## @param1: inventory data used to fill inventory data
func populate_item_grid(inventory_data: InventoryData) -> void:
	# For each existing item in hotbar
	for child in item_grid.get_children():
		# Remove from hotbar
		child.queue_free()
		
	# For each data slot from inventory data
	for slot_data in inventory_data.slot_datas:
		# Create an instance
		var slot = Slot.instantiate()
		# Add instance to item grid
		item_grid.add_child(slot)
		
		# Add event listener when item is clicked
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		# If slot data exists
		if slot_data:
			# Set slot data
			slot.set_slot_data(slot_data)
