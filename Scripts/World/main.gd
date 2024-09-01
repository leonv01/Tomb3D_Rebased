extends Node

@onready var player: CharacterBody3D = $Player
const PickUp: PackedScene = preload("res://Mesh/Items/Cigs/Cigs.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.inventory_interface.drop_slot_data.connect(_on_inventory_interface_drop_slot_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(player.toggle_inventory)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up: Node = SceneHandler.instantiate_scene(slot_data.item_data.scene_path, player.get_drop_position())
	pick_up.transform.origin = player.get_drop_position()
	add_child(pick_up)
	#reparent(pick_up)
