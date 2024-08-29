extends CharacterBody3D


@export_category("controls")
@export var speed: float = 5.0
@export var run_speed: float = 10.0
@export var jump_velocity: float = 4.5
@export var sensivity: float = 0.001
@export var max_look_down_angle: int = -90
@export var max_look_up_angle: int = 90
@export var movement_ease: float = 5.0
@export var jump_movement_ease: float = 2.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var hud: Control = $HUD
@onready var info_label: Label = $HUD/InfoLabel
@onready var interact_cast: RayCast3D = $Head/Camera/InteractCast

enum PLAYER_STATES { WALKING, RUNNING }
var player_state: PLAYER_STATES = PLAYER_STATES.WALKING

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
	
	var target_speed: float = run_speed if player_state == PLAYER_STATES.RUNNING else speed

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
		print("Open inventory")
	
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
		print("Colliding with ", interact_cast.get_collider())
