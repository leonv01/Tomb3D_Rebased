extends CharacterBody3D

class_name Entity

@export var health: int = 100
@export var max_health: int = 100

@export var armor: int = 100
@export var max_armor: int = 100

@export var walk_speed: float
@export var run_speed: float


func heal(heal_value: int) -> void:
	health += heal_value
	print(health)
	if health > max_health:
		health = max_health
