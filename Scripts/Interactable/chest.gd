extends StaticBody3D

## Signal to emit inventory toggle
## @param1: reference to external inventory owner
signal toggle_inventory(external_inventory_owner)

# Inventory Data of external inventory
@export var inventory_data: InventoryData

## Function called when player uses external inventory
func player_interact() -> void:
	toggle_inventory.emit(self)
