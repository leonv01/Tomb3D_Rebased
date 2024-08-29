extends CharacterBody3D

class_name Entity

@export var health: int = 100
@export var armor: int = 100
@export var walk_speed: float
@export var run_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
