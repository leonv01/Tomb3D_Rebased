extends PanelContainer

@onready var quantity_label: Label = $QuantityLabel
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

## Signal to handle clicked slot
## @param1: index of slot item
## @param2: index of mouse button 
signal slot_clicked(index: int, button: int)

## Function to set slot data
## @param1: slot data to be used
func set_slot_data(slot_data: SlotData) -> void:
	# Get item data of slot data
	var item_data = slot_data.item_data
	# Set texture of own texture from the slot data
	texture_rect.texture = item_data.texture
	# Set hover text
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	# If quantity is greater than 1
	if slot_data.quantity > 1:
		# Display numeric count of stack
		quantity_label.text = "x%s" % slot_data.quantity
		# Show text
		quantity_label.show()
	else:
		# Hide text
		quantity_label.hide()

## Callback to handle user input
func _on_gui_input(event: InputEvent) -> void:
	# If even is mouse button pressed and left or right mouse button
	if event is InputEventMouseButton \
			and	(event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		# Emit signal
		slot_clicked.emit(get_index(), event.button_index)
