extends Entity


@export_category("controls")
@export var jump_velocity: float = 4.5
@export var sensivity: float = 0.001
@export var max_look_down_angle: int = -90
@export var max_look_up_angle: int = 90
@export var movement_ease: float = 5.0
@export var jump_movement_ease: float = 2.0

@export var inventory_data: InventoryData

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var interact_cast: RayCast3D = $Head/Camera/InteractCast
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var interact_label: Label = $UI/Crosshair/InteractLabel

enum PLAYER_STATES { WALKING, RUNNING }
var player_state: PLAYER_STATES = PLAYER_STATES.WALKING

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory_interface.set_player_inventory_data(inventory_data)
	
func _process(delta: float) -> void:
	if interact_cast.is_colliding():
		interact_label.show()
	else:
		interact_label.hide()
		

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * sensivity)
		camera.rotate_x(-event.relative.y * sensivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(max_look_down_angle), deg_to_rad(max_look_up_angle))
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_just_pressed("run"):
		player_state = PLAYER_STATES.RUNNING
	elif Input.is_action_just_released("run"):
		player_state = PLAYER_STATES.WALKING

	if Input.is_action_just_pressed("attack"):
		print("Attack")
	elif Input.is_action_just_pressed("secondary"):
		print("Secondary")

func interact() -> void:
	if interact_cast.is_colliding():
		var collided_object: Node = interact_cast.get_collider()
		
		if collided_object.is_in_group("external_inventory"):
			toggle_inventory(collided_object.inventory_data)
			
		if collided_object.is_in_group("pick_up"):
			collided_object.picked_up(inventory_data)
		

func toggle_inventory(external_inventory_data: InventoryData = null) -> void:	
	inventory_interface.visible = not inventory_interface.visible
	
	if external_inventory_data and not inventory_interface.is_external_open:
		inventory_interface.set_external_inventory_data(external_inventory_data)
	else:
		inventory_interface.clear_external_inventory_data()
		
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
