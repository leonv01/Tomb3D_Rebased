extends Resource

class_name InventoryData

## Signal to track when inventory has been interacted
## @param1: inventory data to check
## @param2: index of item grid
## @param3: index of mouse button pressed
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

## Signal to update inventory
## @param1: inventory data used to update
signal inventory_updated(inventory_data: InventoryData)

# Reference to slot data array
@export var slot_datas: Array[SlotData]

## Function to handle click event
## @param1: index of grid map
## @param2: index of mouse button
func on_slot_clicked(index: int, button: int) -> void:
	# Emit signal
	inventory_interact.emit(self, index, button)

## Function to handle grabbed slot data
## @param1: index of item in item grid
## @return: 
##			- slot data at index if item exists
##			- null if item doesn't exist
func grab_slot_data(index: int) -> SlotData:
	# Get slot data from slot array by index
	var slot_data: SlotData = slot_datas[index]
	# If slot exists
	if slot_data:
		# Remove item from array
		slot_datas[index] = null
		# Update inventory
		inventory_updated.emit(self)
		# Return slot data at index
		return slot_data
	else:
		# Return null
		return null

## Function to drop slot data in inventory
## @param1: grabbed slot data by player
## @param2: index where item has to placed
## @return:
##			- other slot data instance when it exists at index
##			- null if item at index doesn't exist
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Get slot data at index
	var slot_data: SlotData = slot_datas[index]
	
	# Instantiate a return instance (null)
	var return_slot_data: SlotData
	
	# If slot data at index exists and can full ymerge with data of same instance as grabbed slot data
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		# Merge data with slot data at index
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		# Switch grabbed item with existing item at index
		slot_datas[index] = grabbed_slot_data
		# Set return to switched slot data
		return_slot_data = slot_data
	
	# Emit signal to update inventory
	inventory_updated.emit(self)
	return return_slot_data

## Function to drop single slot data
## @param1: grabbed slot data by player
## @param2: index where item has to placed
## @return:
##			- grabbed slot data
##			- null if item at index doesn't exist
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Get slot data at index
	var slot_data = slot_datas[index]
	
	# If not slot data exists at index
	if not slot_data:
		# Drop single item of grabbed slot
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	# Else if item can be merged with item at index
	elif slot_data.can_merge_with(grabbed_slot_data):
		# Fully merge with item at index
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	# Emit signal to update inventory
	inventory_updated.emit(self)
	
	# If quantity of grabbed slot data is greater than 0
	if grabbed_slot_data.quantity > 0:
		# Return grabbed slot data
		return grabbed_slot_data
	else:
		# Else quantity of grabbed slot item is 0 -> non existing
		return null

## Function to handle picked up items to sort in the inventory
## @param1: slot data to be inserted
## @return: 
##			- true if item has been merged or item could be placed in inventory
##			- false if item could not be merged or placed in inventory
func picked_up_slot_data(slot_data: SlotData) -> bool:
	# For each item in inventory
	for index in slot_datas.size():
		# Get instance at index
		var slot_at: SlotData = slot_datas[index]
		
		# If slot at index exists and can be fully merged
		if slot_at and slot_at.can_fully_merge_with(slot_data):
			# Fully merge with item
			slot_at.fully_merge_with(slot_data)
			slot_datas[index] = slot_at
			# Emit signal to update inventory
			inventory_updated.emit(self)
			return true
	
	# For each item in inventory
	for index in slot_datas.size():
		# Get instance at index
		var slot_at: SlotData = slot_datas[index]
		
		# If slot at index doesn't exist
		if not slot_at:
			# Insert slot at position
			slot_at = slot_data
			slot_datas[index] = slot_at
			inventory_updated.emit(self)
			return true
			
	return false

## Function to use slot data
## @param1: index of slot data to be used
func use_slot_data(index: int) -> void:
	# Get slot data at index
	var slot_data: SlotData = slot_datas[index]
	
	# If slot data does not exist -> return
	if not slot_data:
		return
	
	# If item data of slot data is a consumable item
	if slot_data.item_data is ItemDataConsumable:
		# Reduce decrement quantity
		slot_data.quantity -= 1
		# If quantity is 0 -> set instance to null
		if slot_data.quantity < 1:
			slot_datas[index] = null
	
	# Handle usage of item via Singleton player manager
	PlayerManager.use_slot_data(slot_data)
	
	# Emit signal to update inventory
	inventory_updated.emit(self)
