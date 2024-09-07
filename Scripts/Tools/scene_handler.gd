extends Node

var scene_cache: Dictionary = {}

## Function to get scene according to path and caches in memory
## @param1: scene path to the packed scene to be loaded
func get_scene(scene_path: String) -> PackedScene:
	if not scene_cache.has(scene_path):
		var scene: PackedScene = load(scene_path)
		scene_cache[scene_path] = scene
	return scene_cache[scene_path]
	
## Function to get the instaniated scene by path
## @param1: scene path to be found in cache
## @param2: position to be instantiated
func instantiate_scene(scene_path: String, position: Vector3) -> Node:
	var scene: PackedScene = get_scene(scene_path)
	var instance: Node = scene.instantiate()
	
	return instance
