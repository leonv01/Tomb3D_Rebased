extends InventoryData
 
class_name InventoryDataEquip

## Function to drop slot data in inventory
## @param1: grabbed slot data by player
## @param2: index where item has to placed
## @return:
##			- other slot data instance when it exists at index
##			- null if item at index doesn't exist
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	return super.drop_slot_data(grabbed_slot_data, index)
	
## Function to drop single slot data
## @param1: grabbed slot data by player
## @param2: index where item has to placed
## @return:
##			- grabbed slot data
##			- null if item at index doesn't exist
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	return super.drop_single_slot_data(grabbed_slot_data, index)
