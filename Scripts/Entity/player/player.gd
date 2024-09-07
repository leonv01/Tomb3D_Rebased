extends Entity


@export_category("controls")
@export var jump_velocity: float = 4.5
@export var sensivity: float = 0.001
@export var max_look_down_angle: int = -90
@export var max_look_up_angle: int = 90
@export var movement_ease: float = 5.0
@export var jump_movement_ease: float = 2.0

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@export var max_range_external_inventory: int = 5
@onready var hotbar_inventory: PanelContainer = $UI/HotbarInventory

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var interact_cast: RayCast3D = $Head/Camera/InteractCast
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var interact_label: Label = $UI/Crosshair/InteractLabel
@onready var health_label: Label = $UI/Properties/HealthLabel

enum PLAYER_STATES { WALKING, RUNNING }
var player_state: PLAYER_STATES = PLAYER_STATES.WALKING

func _ready() -> void:
	# Add player reference to manager
	PlayerManager.player = self
	# Lock courser to game
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Add inventory to interface
	inventory_interface.set_player_inventory_data(inventory_data)
	inventory_interface.set_equip_inventory_data(equip_inventory_data)
	hotbar_inventory.set_inventory_data(inventory_data)

func _process(delta: float) -> void:
	# Check if raycast hits object
	if interact_cast.is_colliding():
		# Display pick up text
		interact_label.show()
	else:
		interact_label.hide()
	
	# Display health
	health_label.text = "Health: %d" % health
	
	inventory_interface.check_external_inventory_in_range(global_position, max_range_external_inventory)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_speed: float = run_speed if player_state == PLAYER_STATES.RUNNING else walk_speed

	if is_on_floor():
		if direction:
			velocity.x = direction.x * target_speed
			velocity.z = direction.z * target_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * target_speed, delta * movement_ease)
			velocity.z = lerp(velocity.z, direction.z * target_speed, delta * movement_ease)
	else:
		velocity.x = lerp(velocity.x, direction.x * target_speed, delta * jump_movement_ease)
		velocity.z = lerp(velocity.z, direction.z * target_speed, delta * jump_movement_ease)

	move_and_slide()

## Function to handle user input
func _unhandled_input(event: InputEvent) -> void:
	# If event is triggered by mouse motion and mouse mode is captured
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate view according to look-at position of camera and head
		head.rotate_y(-event.relative.x * sensivity)
		camera.rotate_x(-event.relative.y * sensivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(max_look_down_angle), deg_to_rad(max_look_up_angle))
	
	# Toggle inventory
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
	
	# Trigger interact
	if Input.is_action_just_pressed("interact"):
		if inventory_interface.visible:
			pass
		else:
			interact()
	
	# Run action
	if Input.is_action_just_pressed("run"):
		player_state = PLAYER_STATES.RUNNING
	elif Input.is_action_just_released("run"):
		player_state = PLAYER_STATES.WALKING

	# Attack action
	if Input.is_action_just_pressed("attack"):
		print("Attack")
	elif Input.is_action_just_pressed("secondary"):
		print("Secondary")

## Function to handle interaction with raycast
func interact() -> void:
	# If object is hit by raycast
	if interact_cast.is_colliding():
		# Get object by collision
		var collided_object: Node = interact_cast.get_collider()
		
		# Check group of object
		if collided_object.is_in_group("external_inventory"):
			toggle_inventory(collided_object.inventory_data, collided_object.global_position)
			
		if collided_object.is_in_group("pick_up"):
			collided_object.picked_up(inventory_data)
		
## Function to toggle inventory
## @param1: external inventory data to be used (set to null by default if no data is passed)
func toggle_inventory(external_inventory_data: InventoryData = null, external_inventory_position: Vector3 = Vector3()) -> void:	
	# Toggle visbility of interface
	inventory_interface.visible = not inventory_interface.visible
	
	# If external interface data is existing and if flag is set for external inventory is open
	if external_inventory_data and not inventory_interface.is_external_open:
		# Set external inventory data
		inventory_interface.set_external_inventory_data(external_inventory_data, external_inventory_position)
	else:
		# Clear external inventory data
		inventory_interface.clear_external_inventory_data(external_inventory_data)
	
	# If inventory interface is visible
	if inventory_interface.visible:
		# Hide hotbar
		hotbar_inventory.hide()
		# Unlock mouse cursor
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		# Show hotbar
		hotbar_inventory.show()
		# Lock mouse cursor
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

## Function to get drop position based on look direction of player
func get_drop_position() -> Vector3:
	var direction: Vector3 = -camera.global_transform.basis.z
	return camera.global_position + direction
