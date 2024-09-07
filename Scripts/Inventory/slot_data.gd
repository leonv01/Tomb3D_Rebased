extends Resource

class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1 : set = set_quantity

## Function to set quantity of slot data
## @param1: value to be set
func set_quantity(value: int) -> void:
	quantity = value
	# If item is greater than one and not stackable
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		# Push error in console
		push_warning("%s is not stackable, setting quantity to 1" % item_data.name)

## Function to check if item can be merged with same item type
## @param1: other slot data to be checked
## @return: 
##			- true if item data and other item data is equal and stackable and quantity is less than MAX_STACK_SIZE
##			- false if not mergeable
func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
		and item_data.stackable \
		and quantity < MAX_STACK_SIZE

## Function to check if item can be fully merged with same item type
## @param1: other slot data to be checked
## @return:
##			- true if item data and other item data is equal and stackable and quantity is less than MAX_STACK_SIZE
##			- false if not mergeable
func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
		and item_data.stackable \
		and quantity + other_slot_data.quantity < MAX_STACK_SIZE

## Function to fully merge with other slot data
## @param1: other slot data to be merged with
func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

## Function to create a single instance of an item stack
func create_single_slot_data() -> SlotData:
	var new_slot_data: SlotData = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data
