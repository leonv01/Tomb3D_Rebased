extends Resource

class_name InventoryData

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)

@export var slot_datas: Array[SlotData]

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func grab_slot_data(index: int) -> SlotData:
	var slot_data: SlotData = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data: SlotData = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data
		
func drop_single_slot_data(grabbed_slot_data, index) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func picked_up_slot_data(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		var slot_at: SlotData = slot_datas[index]
		if slot_at and slot_at.can_fully_merge_with(slot_data):
			slot_at.fully_merge_with(slot_data)
			slot_datas[index] = slot_at
			inventory_updated.emit(self)
			return true
			
	for index in slot_datas.size():
		var slot_at: SlotData = slot_datas[index]
		
		if not slot_at:
			slot_at = slot_data
			slot_datas[index] = slot_at
			inventory_updated.emit(self)
			return true
			
	return false
