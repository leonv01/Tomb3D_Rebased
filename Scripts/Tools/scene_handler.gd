extends Node

var scene_cache: Dictionary = {}

func get_scene(scene_path: String) -> PackedScene:
	if not scene_cache.has(scene_path):
		var scene: PackedScene = load(scene_path)
		scene_cache[scene_path] = scene
	return scene_cache[scene_path]
	
func instantiate_scene(scene_path: String, position: Vector3) -> Node:
	var scene: PackedScene = get_scene(scene_path)
	var instance: Node = scene.instantiate()
	
	#instance.global_transform.origin = position
	#get_tree().root.add_child(instance)
	return instance
