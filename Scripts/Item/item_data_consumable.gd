extends ItemData

class_name ItemDataConsumable

@export var heal_value: int

## Function to handle use
## @param1: target to be healed
func use(target) -> void:
	if heal_value != 0:
		target.heal(heal_value)
	pass
